!classDefinition: #CartTest category: #TusLibros stamp: 'fz 11/7/2019 21:10:49'!
TestCase subclass: #CartTest
	instanceVariableNames: 'testObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test01NewCartsAreCreatedEmpty

	self assert: testObjectsFactory createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [ cart add: testObjectsFactory itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'fz 11/7/2019 20:12:52'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSoldByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'fz 11/7/2019 20:12:52'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 0 of: testObjectsFactory itemSoldByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 2 of: testObjectsFactory itemNotSellByTheStore  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'fz 11/7/2019 20:12:52'!
test06CartRemembersAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSoldByTheStore.
	self assert: (cart includes: testObjectsFactory itemSoldByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'fz 11/7/2019 20:12:52'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self deny: (cart includes: testObjectsFactory itemSoldByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'fz 11/7/2019 20:12:52'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: 2 of: testObjectsFactory itemSoldByTheStore.
	self assert: (cart occurrencesOf: testObjectsFactory itemSoldByTheStore) = 2! !


!CartTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 18:09'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.! !


!classDefinition: #CashierTest category: #TusLibros stamp: 'fz 11/7/2019 21:10:49'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'testObjectsFactory debitBehavior'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:50'!
test01CanNotCheckoutAnEmptyCart

	| salesBook |
	
	salesBook := OrderedCollection new.
	self 
		should: [ Cashier 
			toCheckout: testObjectsFactory createCart 
			charging: testObjectsFactory notExpiredCreditCard 
			throught: self
			on: testObjectsFactory today
			registeringOn:  salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier cartCanNotBeEmptyErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'fz 11/7/2019 20:12:52'!
test02CalculatedTotalIsCorrect

	| cart cashier |
	
	cart := testObjectsFactory createCart.
	cart add: 2 of: testObjectsFactory itemSoldByTheStore.
	
	cashier :=  Cashier
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard 
		throught: self
		on: testObjectsFactory today 
		registeringOn: OrderedCollection new.
		
	self assert: cashier checkOut = (testObjectsFactory itemSellByTheStorePrice * 2)! !

!CashierTest methodsFor: 'tests' stamp: 'fz 11/7/2019 20:12:52'!
test03CanNotCheckoutWithAnExpiredCreditCart

	| cart salesBook |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSoldByTheStore.
	salesBook := OrderedCollection new.
	
	self
		should: [ Cashier 
				toCheckout: cart 
				charging: testObjectsFactory expiredCreditCard 
				throught: self
				on: testObjectsFactory today
				registeringOn: salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = Cashier canNotChargeAnExpiredCreditCardErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'fz 11/7/2019 20:12:52'!
test04CheckoutRegistersASale

	| cart cashier salesBook total |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSoldByTheStore.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	total := cashier checkOut.
					
	self assert: salesBook size = 1.
	self assert: salesBook first total = total.! !

!CashierTest methodsFor: 'tests' stamp: 'fz 11/7/2019 20:12:52'!
test05CashierChargesCreditCardUsingMerchantProcessor

	| cart cashier salesBook total creditCard debitedAmout debitedCreditCard  |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSoldByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	debitBehavior := [ :anAmount :aCreditCard | 
		debitedAmout := anAmount.
		debitedCreditCard := aCreditCard ].
	total := cashier checkOut.
					
	self assert: debitedCreditCard = creditCard.
	self assert: debitedAmout = total.! !

!CashierTest methodsFor: 'tests' stamp: 'fz 11/7/2019 20:12:52'!
test06CashierDoesNotSaleWhenTheCreditCardHasNoCredit

	| cart cashier salesBook creditCard |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSoldByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 	debitBehavior := [ :anAmount :aCreditCard | self error: Cashier creditCardHasNoCreditErrorMessage].
	
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	self 
		should: [cashier checkOut ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier creditCardHasNoCreditErrorMessage.
			self assert: salesBook isEmpty ]! !


!CashierTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 19:03'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
	debitBehavior := [ :anAmount :aCreditCard | ]! !


!CashierTest methodsFor: 'merchant processor protocol' stamp: 'HernanWilkinson 6/17/2013 19:02'!
debit: anAmount from: aCreditCard 

	^debitBehavior value: anAmount value: aCreditCard ! !


!classDefinition: #UserAPITest category: #TusLibros stamp: 'fz 11/7/2019 21:10:49'!
TestCase subclass: #UserAPITest
	instanceVariableNames: 'testObjectsFactory debitBehavior usersLog validUser validUserPassword validUserButWrongPassword invalidUser invalidUserPassword'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/7/2019 20:10:13'!
setUp
	validUser := 'validUser'.
	validUserPassword := 'validUserPassword'.
	
	validUserButWrongPassword := 'wrongPassword'.	
	
	invalidUser := 'invalidUser'.
	invalidUserPassword := 'invalidUserPassword'.
	
	usersLog := Dictionary new.
	usersLog at: validUser put: validUserPassword .
	
	testObjectsFactory := StoreTestObjectsFactory new.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/7/2019 20:25:46'!
test01CreateCartFailsWithUnknownUser
	|userAPI|
	
	userAPI := UserAPI withUserManager: self catalog: Dictionary new.
	
	self should: [userAPI createCartOf: invalidUser withPassword: invalidUserPassword.]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI canNotCreateCartWithInvalidCredentialsErrorMessage].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/7/2019 20:25:46'!
test02CartIsCreatedForValidUserAndIsEmpty
	|userAPI cartID |
	
	userAPI := UserAPI withUserManager: self catalog: Dictionary new.
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	
	self assert: (userAPI isValidCartID: cartID).! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/7/2019 20:25:46'!
test03CreateCartFailsWithWrongPassword
	|userAPI|
	
	userAPI := UserAPI withUserManager: self catalog: Dictionary new.
	
	self should: [userAPI createCartOf: validUser withPassword: validUserButWrongPassword.]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI canNotCreateCartWithInvalidCredentialsErrorMessage].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/7/2019 20:28:13'!
test04CreatedCartCanAddItems
	|userAPI cartID |
	
	userAPI := UserAPI withUserManager: self catalog: testObjectsFactory defaultCatalog.
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	
	userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	
	self assert: ((userAPI cartOfID: cartID) occurrencesOf: testObjectsFactory itemSoldByTheStore) equals: 1.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/7/2019 20:37:12'!
test05CanNotAddItemsToInvalidCartID
	|userAPI cartID invalidCartID|
	
	userAPI := UserAPI withUserManager: self catalog: testObjectsFactory defaultCatalog.
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	invalidCartID := cartID +1. "asumimos que los IDs son incrementales"
	
	self should: [userAPI addToCart: invalidCartID book: testObjectsFactory itemSoldByTheStore quantity: 1.]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI invalidCartIDErrorMessage].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/7/2019 20:44:21'!
test06AddingItemsWithMultipleCartsBehavesCorrectly
	|userAPI cart1ID cart2ID|
	
	userAPI := UserAPI withUserManager: self catalog: testObjectsFactory defaultCatalog.
	
	cart1ID := userAPI createCartOf: validUser withPassword: validUserPassword.
	cart2ID := userAPI createCartOf: validUser withPassword: validUserPassword.	
	
	userAPI addToCart: cart2ID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	userAPI addToCart: cart2ID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	
	self assert: ((userAPI cartOfID: cart2ID) occurrencesOf: testObjectsFactory itemSoldByTheStore) equals: 2.
	self assert: ((userAPI cartOfID: cart1ID) occurrencesOf: testObjectsFactory itemSoldByTheStore) equals: 0.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/7/2019 20:58:39'!
test07ListCartOfNewCartIsEmpty
	|userAPI cartID|
	
	userAPI := UserAPI withUserManager: self catalog: testObjectsFactory defaultCatalog.
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	
	self assert: (userAPI listCart: cartID) isEmpty.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/7/2019 21:09:20'!
test08ListCartReflectsAddedItems
	|userAPI cartID correctList |
	
	userAPI := UserAPI withUserManager: self catalog: testObjectsFactory defaultCatalog.
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	
	userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	userAPI addToCart: cartID book: testObjectsFactory anotherItemSoldByTheStore quantity: 1.
	
	correctList := Dictionary new; at: testObjectsFactory itemSoldByTheStore put: 2; at: testObjectsFactory anotherItemSoldByTheStore put: 1.
	
	self assert: (userAPI listCart: cartID) equals: correctList .! !


!UserAPITest methodsFor: 'user manager' stamp: 'fz 11/7/2019 19:54:55'!
isValidUser: aUser withPassword: aPassword 
	^(usersLog at: aUser ifAbsent: [^false]) = aPassword.! !


!classDefinition: #Cart category: #TusLibros stamp: 'fz 11/7/2019 21:10:49'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidQuantityErrorMessage
	
	^'Invalid number of items'! !


!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:06'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 17:48'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := OrderedCollection new.! !


!Cart methodsFor: 'queries' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 19:09'!
total

	^ items sum: [ :anItem | catalog at: anItem ]! !


!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:44'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:51'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	1 to: aQuantity do: [ :aNumber | items add: anItem ]! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: #TusLibros stamp: 'fz 11/7/2019 21:10:49'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #Cashier category: #TusLibros stamp: 'fz 11/7/2019 21:10:49'!
Object subclass: #Cashier
	instanceVariableNames: 'cart salesBook merchantProcessor creditCard total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:08'!
calculateTotal

	total := cart total.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:07'!
createSale

	^ Sale of: total
! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
debitTotal

	merchantProcessor debit: total from: creditCard.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
registerSale

	salesBook add: self createSale! !


!Cashier methodsFor: 'checkout' stamp: 'HernanWilkinson 6/17/2013 19:06'!
checkOut

	self calculateTotal.
	self debitTotal.
	self registerSale.

	^ total! !


!Cashier methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:53'!
initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook
	
	cart := aCart.
	creditCard := aCreditCard.
	merchantProcessor := aMerchantProcessor.
	salesBook := aSalesBook! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: #TusLibros stamp: 'fz 11/7/2019 21:10:49'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:22'!
assertIsNotEmpty: aCart 
	
	aCart isEmpty ifTrue: [self error: self cartCanNotBeEmptyErrorMessage ]! !

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:23'!
assertIsNotExpired: aCreditCard on: aDate
	
	(aCreditCard isExpiredOn: aDate) ifTrue: [ self error: self canNotChargeAnExpiredCreditCardErrorMessage ]! !


!Cashier class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:51'!
toCheckout: aCart charging: aCreditCard throught: aMerchantProcessor on: aDate registeringOn: aSalesBook
	
	self assertIsNotEmpty: aCart.
	self assertIsNotExpired: aCreditCard on: aDate.
	
	^self new initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook! !


!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 18:21'!
canNotChargeAnExpiredCreditCardErrorMessage
	
	^'Can not charge an expired credit card'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:56'!
cartCanNotBeEmptyErrorMessage
	
	^'Can not check out an empty cart'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 19:02'!
creditCardHasNoCreditErrorMessage
	
	^'Credit card has no credit'! !


!classDefinition: #CreditCard category: #TusLibros stamp: 'fz 11/7/2019 21:10:49'!
Object subclass: #CreditCard
	instanceVariableNames: 'expiration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 18:39'!
isExpiredOn: aDate 
	
	^expiration start < (Month month: aDate monthIndex year: aDate yearNumber) start ! !


!CreditCard methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:38'!
initializeExpiringOn: aMonth 
	
	expiration := aMonth ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: #TusLibros stamp: 'fz 11/7/2019 21:10:49'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:38'!
expiringOn: aMonth 
	
	^self new initializeExpiringOn: aMonth! !


!classDefinition: #Sale category: #TusLibros stamp: 'fz 11/7/2019 21:10:49'!
Object subclass: #Sale
	instanceVariableNames: 'total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Sale methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 18:48'!
total
	
	^ total! !


!Sale methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:47'!
initializeTotal: aTotal

	total := aTotal ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sale class' category: #TusLibros stamp: 'fz 11/7/2019 21:10:49'!
Sale class
	instanceVariableNames: ''!

!Sale class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:47'!
of: aTotal

	"should assert total is not negative or 0!!"
	^self new initializeTotal: aTotal ! !


!classDefinition: #StoreTestObjectsFactory category: #TusLibros stamp: 'fz 11/7/2019 21:10:49'!
Object subclass: #StoreTestObjectsFactory
	instanceVariableNames: 'today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'fz 11/7/2019 21:00:24'!
anotherItemSellByTheStorePrice
	
	^25! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'fz 11/7/2019 21:00:02'!
anotherItemSoldByTheStore

	^ 'anotherValidBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemSellByTheStorePrice
	
	^10! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'fz 11/7/2019 20:12:52'!
itemSoldByTheStore
	
	^ 'validBook'! !


!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2013 18:08'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'fz 11/7/2019 21:00:58'!
defaultCatalog
	
	^ Dictionary new
		at: self itemSoldByTheStore put: self itemSellByTheStorePrice;
		at: self anotherItemSoldByTheStore put: self anotherItemSellByTheStorePrice;
		yourself ! !


!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:37'!
expiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber - 1)! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:36'!
notExpiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber + 1)! !


!StoreTestObjectsFactory methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:37'!
initialize

	today := DateAndTime now! !


!StoreTestObjectsFactory methodsFor: 'date' stamp: 'HernanWilkinson 6/17/2013 18:37'!
today
	
	^ today! !


!classDefinition: #UserAPI category: #TusLibros stamp: 'fz 11/7/2019 21:10:49'!
Object subclass: #UserAPI
	instanceVariableNames: 'uM cartsRegister catalog currentID'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!UserAPI methodsFor: 'API' stamp: 'fz 11/7/2019 20:45:50'!
createCartOf: aUser withPassword: aPassword 
	|cartID|
	(uM isValidUser: aUser withPassword: aPassword) ifFalse: [self error: self class canNotCreateCartWithInvalidCredentialsErrorMessage].
	
	cartID := currentID.
	currentID  := currentID +1.
	
	cartsRegister at: cartID put: (Cart acceptingItemsOf: catalog).
	
	^cartID.! !

!UserAPI methodsFor: 'API' stamp: 'fz 11/7/2019 20:58:18'!
listCart: aCartID

	^ Set new.! !


!UserAPI methodsFor: 'initialization' stamp: 'fz 11/7/2019 20:44:49'!
initializeWithUserManager: aUM catalog: aCatalog  
	uM := aUM.
	catalog := aCatalog.
	cartsRegister := Dictionary new.
	currentID := 1.! !


!UserAPI methodsFor: 'for testing only' stamp: 'fz 11/7/2019 20:39:00'!
cartOfID: aCartID
	^cartsRegister at: aCartID ifAbsent: [self error: self class invalidCartIDErrorMessage]! !

!UserAPI methodsFor: 'for testing only' stamp: 'fz 11/7/2019 20:29:55'!
isValidCartID: aCartID 
	^cartsRegister includesKey: aCartID ! !


!UserAPI methodsFor: 'as yet unclassified' stamp: 'fz 11/7/2019 20:22:35'!
addToCart: aCartID book: aBookISBN quantity: aQuantity 
	^ (self cartOfID: aCartID) add: aQuantity of: aBookISBN.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'UserAPI class' category: #TusLibros stamp: 'fz 11/7/2019 21:10:49'!
UserAPI class
	instanceVariableNames: ''!

!UserAPI class methodsFor: 'error messages' stamp: 'fz 11/7/2019 19:57:45'!
canNotCreateCartWithInvalidCredentialsErrorMessage
	^ 'usuario o contraseña invalida'! !

!UserAPI class methodsFor: 'error messages' stamp: 'fz 11/7/2019 20:38:06'!
invalidCartIDErrorMessage
	^'invalid cart ID'! !


!UserAPI class methodsFor: 'instance creation' stamp: 'fz 11/7/2019 20:26:00'!
withUserManager: aUM catalog: aCatalog  
	^self new initializeWithUserManager: aUM catalog: aCatalog . ! !
