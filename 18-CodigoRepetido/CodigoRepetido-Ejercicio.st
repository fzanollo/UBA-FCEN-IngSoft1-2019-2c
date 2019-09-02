!classDefinition: #CantSuspend category: #'CodigoRepetido-Ejercicio'!
Error subclass: #CantSuspend
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #NotFound category: #'CodigoRepetido-Ejercicio'!
Error subclass: #NotFound
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #CustomerBookTest category: #'CodigoRepetido-Ejercicio'!
TestCase subclass: #CustomerBookTest
	instanceVariableNames: 'anEmptyCustomerBook aClient notAClient aCustomerBookWithOneClient'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBookTest methodsFor: 'testing' stamp: 'fz 9/2/2019 20:29:00'!
test01AddingCustomerShouldNotTakeMoreThan50Milliseconds

	self assertDurationOf: [anEmptyCustomerBook addCustomerNamed: aClient.] isLessThan: 50*millisecond.
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'fz 9/2/2019 20:14:31'!
test02RemovingCustomerShouldNotTakeMoreThan100Milliseconds

	self assertDurationOf: [aCustomerBookWithOneClient removeCustomerNamed: aClient.] isLessThan: 100*millisecond.
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'fz 9/2/2019 20:13:02'!
test03CanNotAddACustomerWithEmptyName 

	| customerBook |
	customerBook := anEmptyCustomerBook.

	self expectedToFailDoing: [ customerBook addCustomerNamed: ''.] 
		withError: Error 
		do: [ :anError | 
			self assert: anError messageText = CustomerBook customerCanNotBeEmptyErrorMessage.
			self assert: customerBook isEmpty ].! !

!CustomerBookTest methodsFor: 'testing' stamp: 'fz 9/2/2019 20:19:47'!
test04CanNotRemoveAnInvalidCustomer
	
	self expectedToFailDoing: [aCustomerBookWithOneClient removeCustomerNamed: notAClient.] 
		withError: NotFound 
		do: [ :anError | 
			self assert: aCustomerBookWithOneClient numberOfCustomers = 1.
			self assert: (aCustomerBookWithOneClient includesCustomerNamed: aClient) ]
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'fz 9/2/2019 20:22:24'!
test05SuspendingACustomerShouldNotRemoveItFromCustomerBook

	| customerBook |
	
	customerBook := aCustomerBookWithOneClient.
	customerBook suspendCustomerNamed: aClient.
	
	self assertNumberOfActiveCustomers: 0 suspended: 1 total: 1 of: customerBook. 
	self assert: (customerBook includesCustomerNamed: aClient).
	

	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'fz 9/2/2019 20:23:01'!
test06RemovingASuspendedCustomerShouldRemoveItFromCustomerBook

	| customerBook |
	
	customerBook := aCustomerBookWithOneClient.
	
	customerBook suspendCustomerNamed: aClient.
	customerBook removeCustomerNamed: aClient.
	
	self assertNumberOfActiveCustomers: 0 suspended: 0 total: 0 of: customerBook. 
	self deny: (customerBook includesCustomerNamed: aClient).


	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'fz 9/2/2019 20:26:28'!
test07CanNotSuspendAnInvalidCustomer
	
	self expectedToFailDoing: [aCustomerBookWithOneClient suspendCustomerNamed: notAClient.] 
		withError: CantSuspend 
		do: [ :anError | 
			self assert: aCustomerBookWithOneClient numberOfCustomers = 1.
			self assert: (aCustomerBookWithOneClient includesCustomerNamed: aClient) ].! !

!CustomerBookTest methodsFor: 'testing' stamp: 'fz 9/2/2019 20:28:30'!
test08CanNotSuspendAnAlreadySuspendedCustomer
	
	| customerBook |
			
	customerBook := aCustomerBookWithOneClient. 
	customerBook suspendCustomerNamed: aClient.
	
	self expectedToFailDoing: [customerBook suspendCustomerNamed: aClient.] 
		withError: CantSuspend 
		do: [ :anError | 
			self assert: customerBook numberOfCustomers = 1.
			self assert: (customerBook includesCustomerNamed: aClient) ]
! !


!CustomerBookTest methodsFor: 'testsAbstractions' stamp: 'fz 9/2/2019 20:33:10'!
assertDurationOf: colaborations isLessThan: amountOfTime

	self assert: (self measureTimeOf: colaborations) < amountOfTime
! !

!CustomerBookTest methodsFor: 'testsAbstractions' stamp: 'fz 9/2/2019 19:21:43'!
assertNumberOfActiveCustomers: active suspended: suspended total: total of: customerBook

	self assert: active equals: customerBook numberOfActiveCustomers.
	self assert: suspended equals: customerBook numberOfSuspendedCustomers.
	self assert: total equals: customerBook numberOfCustomers.! !

!CustomerBookTest methodsFor: 'testsAbstractions' stamp: 'fz 9/2/2019 20:35:46'!
expectedToFailDoing: aClosureToFail withError: errorType do: assertions
	"aunque no saque muchas lineas expresa mejor la intencion de que deberia fallar, ocultando el como (self fail)"
	[ aClosureToFail value.
	self fail ]
		on: errorType 
		do: assertions.! !

!CustomerBookTest methodsFor: 'testsAbstractions' stamp: 'fz 9/2/2019 20:33:10'!
measureTimeOf: colaborations 
| millisecondsBeforeRunning millisecondsAfterRunning |
	
	millisecondsBeforeRunning := Time millisecondClockValue * millisecond.
	colaborations value.
	millisecondsAfterRunning := Time millisecondClockValue * millisecond.
	
	^millisecondsAfterRunning - millisecondsBeforeRunning.! !


!CustomerBookTest methodsFor: 'initialization' stamp: 'fz 9/2/2019 20:12:22'!
setUp
	anEmptyCustomerBook := CustomerBook new.
	
	aClient := 'Paul McCartney'.
	
	notAClient := 'John Lennon'.
	
	aCustomerBookWithOneClient := CustomerBook new.
	aCustomerBookWithOneClient addCustomerNamed: aClient.! !


!classDefinition: #CustomerBook category: #'CodigoRepetido-Ejercicio'!
Object subclass: #CustomerBook
	instanceVariableNames: 'suspended active'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
includesCustomerNamed: aName

	^(active includes: aName) or: [ suspended includes: aName ]! !

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
isEmpty
	
	^active isEmpty and: [ suspended isEmpty ]! !


!CustomerBook methodsFor: 'initialization' stamp: 'NR 4/3/2019 10:14:26'!
initialize

	super initialize.
	active := OrderedCollection new.
	suspended:= OrderedCollection new.! !


!CustomerBook methodsFor: 'customer management' stamp: 'fz 9/2/2019 18:58:12'!
addCustomerNamed: aName

	aName isEmpty ifTrue: [ self signalCustomerNameCannotBeEmpty ].
	(self includesCustomerNamed: aName) ifTrue: [ self signalCustomerAlreadyExists ].
	
	active add: aName ! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
numberOfActiveCustomers
	
	^active size! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
numberOfCustomers
	
	^active size + suspended size! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 9/19/2018 17:36:09'!
numberOfSuspendedCustomers
	
	^suspended size! !

!CustomerBook methodsFor: 'customer management' stamp: 'fz 9/2/2019 19:03:30'!
removeCustomerNamed: aName 
 
	active remove: aName ifAbsent: [
		suspended remove: aName  ifAbsent: [^ NotFound signal.]
	]. ! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:52'!
signalCustomerAlreadyExists 

	self error: self class customerAlreadyExistsErrorMessage! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:51'!
signalCustomerNameCannotBeEmpty 

	self error: self class customerCanNotBeEmptyErrorMessage ! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
suspendCustomerNamed: aName 
	
	(active includes: aName) ifFalse: [^CantSuspend signal].
	
	active remove: aName.
	
	suspended add: aName
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerBook class' category: #'CodigoRepetido-Ejercicio'!
CustomerBook class
	instanceVariableNames: ''!

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 9/2/2019 14:41:10'!
customerAlreadyExistsErrorMessage

	^'Customer Already Exists.'! !

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 9/2/2019 14:41:16'!
customerCanNotBeEmptyErrorMessage

	^'Customer Name Cannot Be Empty.'! !
