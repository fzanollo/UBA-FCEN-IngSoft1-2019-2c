!classDefinition: #TusLibrosServerController category: #'TusLibros-Server' stamp: 'fz 11/21/2019 21:00:46'!
Object subclass: #TusLibrosServerController
	instanceVariableNames: 'webServer port tusLibrosAPI'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Server'!

!TusLibrosServerController methodsFor: 'enabling services' stamp: 'fz 11/21/2019 19:17:36'!
destroy
	
	webServer ifNotNil:[webServer destroy].! !

!TusLibrosServerController methodsFor: 'enabling services' stamp: 'fz 11/21/2019 19:17:36'!
startListening
	
	webServer startListener.

	^ 'Listening on port: ', self port asString.
	! !

!TusLibrosServerController methodsFor: 'enabling services' stamp: 'fz 11/21/2019 19:17:36'!
stopListening
	
	webServer stopListener.
	
	^'Stopped listening from port: ', self port asString! !


!TusLibrosServerController methodsFor: 'initialization' stamp: 'fz 11/21/2019 20:52:30'!
initializeWith: aPortNumber withAPI: aTusLibrosAPI 

	tusLibrosAPI := aTusLibrosAPI.
	port:= aPortNumber.
	
	webServer := WebServer new listenOn: aPortNumber.
	
	webServer addService: '/createCart' action:[:request | |user password cartID|
		[user := (request fields at:'user').
		password := (request fields at:'password').
		
		cartID := tusLibrosAPI createCartFor: user authenticatedWith: password.
		
		request send200Response: (cartID asString asUtf8) 
				 contentType: 'application/json; charset=utf-8' do: [:resp | 
					resp headerAt: 'Access-Control-Allow-Origin' put: '*'.]
		 ] 
		on: Error 
		do: [ :anError |
			request send404Response: (anError messageText) ]
		].
	
	webServer addService: '/catalog' action:[:request | |catalog|
		
		[catalog := tusLibrosAPI catalog.
		request send200Response: (catalog asString asUtf8) 
				 contentType: 'application/json; charset=utf-8' do: [:resp | 
					resp headerAt: 'Access-Control-Allow-Origin' put: '*'.]
		 ] 
		on: Error 
		do: [ :anError |
			request send404Response: (anError messageText) ]].
	
	webServer addService: '/listCart' action:[:request | |cartID|
		
		[cartID := (request fields at:'cartID') asNumber.
		
		request send200Response: ((tusLibrosAPI listCartIdentifiedAs: cartID) asString asUtf8) 
				 contentType: 'application/json; charset=utf-8' do: [:resp | 
					resp headerAt: 'Access-Control-Allow-Origin' put: '*'.]
		 ] 
		on: Error 
		do: [ :anError |
			request send404Response: (anError messageText) ]].
	
	webServer addService: '/addToCart' action:[:request | |cartID book quantity|
		
		[cartID := (request fields at:'cartID') asNumber.
		 book := (request fields at:'book').
		quantity := (request fields at:'quantity') asNumber.
		
		tusLibrosAPI add: quantity of: book toCartIdentifiedAs: cartID.	
		
		request send200Response: ((tusLibrosAPI listCartIdentifiedAs: cartID) asString asUtf8) 
				 contentType: 'application/json; charset=utf-8' do: [:resp | 
					resp headerAt: 'Access-Control-Allow-Origin' put: '*'.]
		 ] 
		on: Error 
		do: [ :anError |
			request send404Response: (anError messageText) ]].
	
	webServer addService: '/removeFromCart' action:[:request | |cartID book quantity|
		
		[cartID := (request fields at:'cartID') asNumber.
		 book := (request fields at:'book').
		quantity := (request fields at:'quantity') asNumber.
		
		tusLibrosAPI remove: quantity of: book toCartIdentifiedAs: cartID.	
		
		request send200Response: ((tusLibrosAPI listCartIdentifiedAs: cartID) asString asUtf8) 
				 contentType: 'application/json; charset=utf-8' do: [:resp | 
					resp headerAt: 'Access-Control-Allow-Origin' put: '*'.]
		 ] 
		on: Error 
		do: [ :anError |
			request send404Response: (anError messageText) ]].
	! !

!TusLibrosServerController methodsFor: 'initialization' stamp: 'fz 11/21/2019 19:17:36'!
port
	"Use a random port to minimise chances of concurrently running test suites clashing."
	"^ port
		ifNil: [port := (10000 to: 50000) atRandom]"
	
	^port ifNil: [port:=8080].
	
	! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TusLibrosServerController class' category: #'TusLibros-Server' stamp: 'fz 11/21/2019 21:00:46'!
TusLibrosServerController class
	instanceVariableNames: ''!

!TusLibrosServerController class methodsFor: 'as yet unclassified' stamp: 'fz 11/21/2019 19:22:39'!
listeningOn: aPortNumber withAPI: aTusLibrosAPI 

	^self new initializeWith: aPortNumber withAPI: aTusLibrosAPI.! !


!classDefinition: #TusLibrosServerControllerXXX category: #'TusLibros-Server' stamp: 'fz 11/21/2019 21:00:46'!
Object subclass: #TusLibrosServerControllerXXX
	instanceVariableNames: 'testObjectsFactory clock systemFacade salesBook server'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Server'!

!TusLibrosServerControllerXXX methodsFor: 'mensajes seh' stamp: 'fz 11/21/2019 20:01:16'!
debit: anAmount from: aCreditCard! !

!TusLibrosServerControllerXXX methodsFor: 'mensajes seh' stamp: 'fz 11/21/2019 20:02:18'!
defaultCatalog

	^ Dictionary new
		at: 'harry popoter' put: 23445;
		at: 'sarlanga' put: 1123;
		yourself ! !

!TusLibrosServerControllerXXX methodsFor: 'mensajes seh' stamp: 'fz 11/21/2019 19:59:04'!
validUsersAndPasswords
	^Dictionary new
		at: 'pepe' put: '1234';
		yourself! !


!TusLibrosServerControllerXXX methodsFor: 'initialize' stamp: 'fz 11/21/2019 20:13:39'!
initialize
	salesBook := OrderedCollection new.

	testObjectsFactory := StoreTestObjectsFactory new.
	clock := ManualClock now: testObjectsFactory today.
	
	systemFacade := TusLibrosSystemFacade
		authenticatingWith: self validUsersAndPasswords
		acceptingItemsOf: self defaultCatalog
		registeringOn: salesBook
		debitingThrought: self 
		measuringTimeWith: clock.! !

!TusLibrosServerControllerXXX methodsFor: 'initialize' stamp: 'fz 11/21/2019 20:30:39'!
restartAPI
	systemFacade := TusLibrosSystemFacade
		authenticatingWith: self validUsersAndPasswords
		acceptingItemsOf: self defaultCatalog
		registeringOn: salesBook
		debitingThrought: self 
		measuringTimeWith: clock.! !


!TusLibrosServerControllerXXX methodsFor: 'server' stamp: 'fz 11/21/2019 20:14:28'!
newServerListeningOn: aPortNumber
	server := TusLibrosServerController listeningOn: 8080 withAPI: systemFacade.
	
	server startListening.
	! !

!TusLibrosServerControllerXXX methodsFor: 'server' stamp: 'fz 11/21/2019 20:31:42'!
startServer
	self restartAPI.
	server := TusLibrosServerController listeningOn: 8080 withAPI: systemFacade.
	
	server startListening.! !

!TusLibrosServerControllerXXX methodsFor: 'server' stamp: 'fz 11/21/2019 20:06:00'!
stopServer
	server stopListening.
	server destroy.
	! !
