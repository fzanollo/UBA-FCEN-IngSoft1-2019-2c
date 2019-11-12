!classDefinition: #CartTest category: #TusLibros stamp: 'fz 11/11/2019 21:27:14'!
TestCase subclass: #CartTest
	instanceVariableNames: 'testObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test01NewCartsAreCreatedEmpty

	self assert: testObjectsFactory createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'fz 11/11/2019 19:12:06'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [ cart add: testObjectsFactory itemNotSoldByTheStore ]
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

!CartTest methodsFor: 'tests' stamp: 'fz 11/11/2019 19:12:06'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 2 of: testObjectsFactory itemNotSoldByTheStore  ]
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


!classDefinition: #CashierTest category: #TusLibros stamp: 'fz 11/11/2019 21:27:14'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'testObjectsFactory debitBehavior'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'fz 11/11/2019 21:13:30'!
test01CanNotCheckoutAnEmptyCart

	| salesBook |
	
	salesBook := OrderedCollection new.
	self 
		should: [ Cashier 
			toCheckout: testObjectsFactory createCart 
			ofClient: testObjectsFactory validClient charging: testObjectsFactory notExpiredCreditCard 
			throught: self
			on: testObjectsFactory today
			registeringOn:  salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier cartCanNotBeEmptyErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'fz 11/11/2019 21:13:30'!
test02CalculatedTotalIsCorrect

	| cart cashier |
	
	cart := testObjectsFactory createCart.
	cart add: 2 of: testObjectsFactory itemSoldByTheStore.
	
	cashier :=  Cashier
		toCheckout: cart 
		ofClient: testObjectsFactory validClient charging: testObjectsFactory notExpiredCreditCard 
		throught: self
		on: testObjectsFactory today 
		registeringOn: OrderedCollection new.
		
	self assert: cashier checkOut = (testObjectsFactory itemSoldByTheStorePrice * 2)! !

!CashierTest methodsFor: 'tests' stamp: 'fz 11/11/2019 21:13:30'!
test03CanNotCheckoutWithAnExpiredCreditCart

	| cart salesBook |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSoldByTheStore.
	salesBook := OrderedCollection new.
	
	self
		should: [ Cashier 
				toCheckout: cart 
				ofClient: testObjectsFactory validClient charging: testObjectsFactory expiredCreditCard 
				throught: self
				on: testObjectsFactory today
				registeringOn: salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = Cashier canNotChargeAnExpiredCreditCardErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'fz 11/11/2019 21:13:30'!
test04CheckoutRegistersASale

	| cart cashier salesBook total |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSoldByTheStore.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		ofClient: testObjectsFactory validClient charging: testObjectsFactory notExpiredCreditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	total := cashier checkOut.
					
	self assert: salesBook size = 1.
	self assert: salesBook first total = total.! !

!CashierTest methodsFor: 'tests' stamp: 'fz 11/11/2019 21:13:30'!
test05CashierChargesCreditCardUsingMerchantProcessor

	| cart cashier salesBook total creditCard debitedAmout debitedCreditCard  |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSoldByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		ofClient: testObjectsFactory validClient charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	debitBehavior := [ :anAmount :aCreditCard | 
		debitedAmout := anAmount.
		debitedCreditCard := aCreditCard ].
	total := cashier checkOut.
					
	self assert: debitedCreditCard = creditCard.
	self assert: debitedAmout = total.! !

!CashierTest methodsFor: 'tests' stamp: 'fz 11/11/2019 21:13:30'!
test06CashierDoesNotSaleWhenTheCreditCardHasNoCredit

	| cart cashier salesBook creditCard |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSoldByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 	debitBehavior := [ :anAmount :aCreditCard | self error: Cashier creditCardHasNoCreditErrorMessage].
	
	cashier:= Cashier 
		toCheckout: cart 
		ofClient: testObjectsFactory validClient charging: creditCard
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


!classDefinition: #UserAPITest category: #TusLibros stamp: 'fz 11/11/2019 21:27:14'!
TestCase subclass: #UserAPITest
	instanceVariableNames: 'testObjectsFactory debitBehavior usersLog validUser validUserPassword validUserButWrongPassword invalidUser invalidUserPassword time anotherValidUser anotherValidUserPassword emptySalesBook'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/11/2019 20:36:42'!
setUp
	validUser := 'validUser'.
	validUserPassword := 'validUserPassword'.
	validUserButWrongPassword := 'wrongPassword'.	
	
	anotherValidUser := 'anotherValidUser'.
	anotherValidUserPassword := 'anotherValidUserPassword'.
	
	invalidUser := 'invalidUser'.
	invalidUserPassword := 'invalidUserPassword'.
	
	usersLog := Dictionary new.
	usersLog at: validUser put: validUserPassword.
	usersLog at: anotherValidUser put: anotherValidUserPassword.	
	
	testObjectsFactory := StoreTestObjectsFactory new.
	
	time := GregorianDateTime now.
	
	emptySalesBook := OrderedCollection new.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/11/2019 20:35:04'!
test01CreateCartFailsWithUnknownUser
	|userAPI|
	
	userAPI := UserAPI withUserManager: self clock: self catalog: Dictionary new salesBook: emptySalesBook merchantProcessor: self.
	
	self should: [userAPI createCartOf: invalidUser withPassword: invalidUserPassword.]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI canNotCreateCartWithInvalidCredentialsErrorMessage].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/11/2019 20:34:56'!
test02CartIsCreatedForValidUserAndIsEmpty
	|userAPI cartID |
	
	userAPI := UserAPI withUserManager: self clock: self catalog: Dictionary new salesBook: emptySalesBook merchantProcessor: self.
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	
	self assert: (userAPI isValidCartID: cartID).! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/11/2019 20:34:51'!
test03CreateCartFailsWithWrongPassword
	|userAPI|
	
	userAPI := UserAPI withUserManager: self clock: self catalog: Dictionary new salesBook: emptySalesBook merchantProcessor: self.
	
	self should: [userAPI createCartOf: validUser withPassword: validUserButWrongPassword.]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI canNotCreateCartWithInvalidCredentialsErrorMessage].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/11/2019 20:34:43'!
test04CreatedCartCanAddItems
	|userAPI cartID |
	
	userAPI := UserAPI withUserManager: self clock: self catalog: testObjectsFactory defaultCatalog salesBook: emptySalesBook merchantProcessor: self.
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	
	userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	
	self assert: ((userAPI cartOfID: cartID) occurrencesOf: testObjectsFactory itemSoldByTheStore) equals: 1.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/11/2019 20:34:37'!
test05CanNotAddItemsToInvalidCartID
	|userAPI cartID invalidCartID|
	
	userAPI := UserAPI withUserManager: self clock: self catalog: testObjectsFactory defaultCatalog salesBook: emptySalesBook merchantProcessor: self.
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	invalidCartID := cartID +1. "asumimos que los IDs son incrementales"
	
	self should: [userAPI addToCart: invalidCartID book: testObjectsFactory itemSoldByTheStore quantity: 1.]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI invalidCartIDErrorMessage].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/11/2019 20:34:32'!
test06AddingItemsWithMultipleCartsBehavesCorrectly
	|userAPI cart1ID cart2ID|
	
	userAPI := UserAPI withUserManager: self clock: self catalog: testObjectsFactory defaultCatalog salesBook: emptySalesBook merchantProcessor: self.
	
	cart1ID := userAPI createCartOf: validUser withPassword: validUserPassword.
	cart2ID := userAPI createCartOf: validUser withPassword: validUserPassword.	
	
	userAPI addToCart: cart2ID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	userAPI addToCart: cart2ID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	
	self assert: ((userAPI cartOfID: cart2ID) occurrencesOf: testObjectsFactory itemSoldByTheStore) equals: 2.
	self assert: ((userAPI cartOfID: cart1ID) occurrencesOf: testObjectsFactory itemSoldByTheStore) equals: 0.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/11/2019 20:34:26'!
test07ListCartOfNewCartIsEmpty
	|userAPI cartID|
	
	userAPI := UserAPI withUserManager: self clock: self catalog: testObjectsFactory defaultCatalog salesBook: emptySalesBook merchantProcessor: self.
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	
	self assert: (userAPI listCart: cartID) isEmpty.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/11/2019 20:34:21'!
test08ListCartReflectsAddedItems
	|userAPI cartID itemsList |
	
	userAPI := UserAPI withUserManager: self clock: self catalog: testObjectsFactory defaultCatalog salesBook: emptySalesBook merchantProcessor: self.
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	
	userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	userAPI addToCart: cartID book: testObjectsFactory anotherItemSoldByTheStore quantity: 1.
	
	itemsList := userAPI listCart: cartID.
	self assert: (itemsList occurrencesOf: testObjectsFactory itemSoldByTheStore) equals: 2.
	self assert: (itemsList occurrencesOf: testObjectsFactory anotherItemSoldByTheStore) equals: 1.
	self assert: itemsList size equals: 3.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/11/2019 20:34:08'!
test09newCartHasLastAccesedTimeRightNow
	|userAPI cartID|
	
	userAPI := UserAPI withUserManager: self clock: self catalog: Dictionary new salesBook: emptySalesBook merchantProcessor: self.
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	
	self assert: (userAPI lastAccesedTime: cartID) equals: self currentTime.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/11/2019 20:34:01'!
test10canNotAddItemsToCartAfter30Mins
	|userAPI cartID|
	
	userAPI := UserAPI withUserManager: self clock: self catalog: testObjectsFactory defaultCatalog salesBook: emptySalesBook merchantProcessor: self.
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	time := time next: (TimeUnits minute with: 31).
	
	self should: [userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI expiredCartErrorMessage].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/11/2019 20:33:56'!
test11canAddItemsToCartIfItWasCreated30MinsAgoButWasUsedInBetween
	|userAPI cartID itemsList |
	
	userAPI := UserAPI withUserManager: self clock: self catalog: testObjectsFactory defaultCatalog salesBook: emptySalesBook merchantProcessor: self.
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	time := time next: (TimeUnits minute with: 20).
	userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	time := time next: (TimeUnits minute with: 20).
	
	userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	
	itemsList := userAPI listCart: cartID.
	self assert: (itemsList occurrencesOf: testObjectsFactory itemSoldByTheStore) equals: 2.
	self assert: itemsList size equals: 2.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/11/2019 20:33:50'!
test12canNotListCartAfter30Mins
	|userAPI cartID|
	
	userAPI := UserAPI withUserManager: self clock: self catalog: testObjectsFactory defaultCatalog salesBook: emptySalesBook merchantProcessor: self.
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	time := time next: (TimeUnits minute with: 31).
	
	self should: [userAPI listCart: cartID]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI expiredCartErrorMessage].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/11/2019 20:33:26'!
test13CanNotLIstInvalidCartID
	|userAPI cartID invalidCartID|
	
	userAPI := UserAPI withUserManager: self clock: self catalog: testObjectsFactory defaultCatalog salesBook: emptySalesBook merchantProcessor: self.
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	invalidCartID := cartID +1. "asumimos que los IDs son incrementales"
	
	self should: [userAPI listCart: invalidCartID ]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI invalidCartIDErrorMessage].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/11/2019 20:33:40'!
test14cartCheckoutRegistersSales
	|userAPI cartID total|
 
	userAPI := UserAPI withUserManager: self clock: self catalog: testObjectsFactory defaultCatalog salesBook: emptySalesBook merchantProcessor: self.
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	
	total := userAPI checkoutCart: cartID withCreditCard: testObjectsFactory notExpiredCreditCard.
			
	self assert: emptySalesBook size = 1.
	self assert: emptySalesBook first total = total.
	
	"acá podrían venir muchos tests medio redudantes de la lógica de cashier, no sería TDD sino testing, decidimos no agregarlos ya que nos parece que no es lo importante del ejercicio"
! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/11/2019 20:32:45'!
test15afterCheckOutCartIDIsInvalid
	|userAPI cartID|
	
	userAPI := UserAPI withUserManager: self clock: self catalog: testObjectsFactory defaultCatalog salesBook: emptySalesBook merchantProcessor: self.
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	
	userAPI checkoutCart: cartID withCreditCard: testObjectsFactory notExpiredCreditCard.
			
	self should: [userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI invalidCartIDErrorMessage].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/11/2019 20:32:54'!
test16cannotCheckoutAfter30Minutes
	|userAPI cartID|
	
	userAPI := UserAPI withUserManager: self clock: self catalog: testObjectsFactory defaultCatalog salesBook: emptySalesBook merchantProcessor: self.
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	time := time next: (TimeUnits minute with: 31).
			
	self should: [userAPI checkoutCart: cartID withCreditCard: testObjectsFactory notExpiredCreditCard.]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI expiredCartErrorMessage ].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/11/2019 20:33:17'!
test17ListPurchasesFailsWithInvalidCredentials
	|userAPI|
	
	userAPI := UserAPI withUserManager: self clock: self catalog: Dictionary new salesBook: emptySalesBook merchantProcessor: self.
	
	self should: [userAPI listPurchasesOf: invalidUser withPassword: invalidUserPassword.]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI canNotListPurchasesWithInvalidCredentialsErrorMessage].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/11/2019 20:32:17'!
test18ListPurchasesOfAValidClientWithOnlyOneSaleIsCorrect
	|userAPI cartID total purchases |
 
	userAPI := UserAPI withUserManager: self clock: self catalog: testObjectsFactory defaultCatalog salesBook: emptySalesBook merchantProcessor: self.
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	
	total := userAPI checkoutCart: cartID withCreditCard: testObjectsFactory notExpiredCreditCard.
	
	purchases := userAPI listPurchasesOf: validUser withPassword: validUserPassword.
	
	self assert: purchases size = 1.
	self assert: (purchases occurrencesOf: testObjectsFactory itemSoldByTheStore) equals: 1.
	self assert: purchases total = total.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/11/2019 20:36:09'!
test19ListPurchasesOnlyListSalesOfQueringClient
	|userAPI queringClientCartID anotherClientCartID total purchases |
 
	userAPI := UserAPI withUserManager: self clock: self catalog: testObjectsFactory defaultCatalog salesBook: emptySalesBook merchantProcessor: self.
	
	anotherClientCartID := userAPI createCartOf: anotherValidUser withPassword: anotherValidUserPassword.
	userAPI addToCart: anotherClientCartID book: testObjectsFactory itemSoldByTheStore quantity: 2.
	userAPI checkoutCart: anotherClientCartID withCreditCard: testObjectsFactory notExpiredCreditCard.
	
	queringClientCartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	userAPI addToCart: queringClientCartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	total := userAPI checkoutCart: queringClientCartID withCreditCard: testObjectsFactory notExpiredCreditCard.
	
	purchases := userAPI listPurchasesOf: validUser withPassword: validUserPassword.
	
	self assert: purchases size = 1.
	self assert: (purchases occurrencesOf: testObjectsFactory itemSoldByTheStore) equals: 1.
	self assert: purchases total = total.! !


!UserAPITest methodsFor: 'user manager' stamp: 'fz 11/7/2019 19:54:55'!
isValidUser: aUser withPassword: aPassword 
	^(usersLog at: aUser ifAbsent: [^false]) = aPassword.! !


!UserAPITest methodsFor: 'clock' stamp: 'fz 11/11/2019 18:09:53'!
currentTime
	^ time! !

!UserAPITest methodsFor: 'clock' stamp: 'fz 11/11/2019 19:21:56'!
today
	^testObjectsFactory today.! !


!UserAPITest methodsFor: 'merchant processor protocol' stamp: 'fz 11/11/2019 19:28:07'!
debit: anAmount from: aCreditCard ! !


!classDefinition: #Cart category: #TusLibros stamp: 'fz 11/11/2019 21:27:14'!
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


!Cart methodsFor: 'queries' stamp: 'fz 11/11/2019 17:55:47'!
listItems
	^items copy! !

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

!classDefinition: 'Cart class' category: #TusLibros stamp: 'fz 11/11/2019 21:27:14'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #Cashier category: #TusLibros stamp: 'fz 11/11/2019 21:27:14'!
Object subclass: #Cashier
	instanceVariableNames: 'cart salesBook merchantProcessor creditCard total client'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:08'!
calculateTotal

	total := cart total.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'fz 11/11/2019 21:15:50'!
createSale

	^ Sale of: total listOfItems: cart listItems forClient: client
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


!Cashier methodsFor: 'initialization' stamp: 'fz 11/11/2019 21:14:35'!
initializeToCheckout: aCart ofClient: aClient charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook
	
	cart := aCart.
	creditCard := aCreditCard.
	merchantProcessor := aMerchantProcessor.
	salesBook := aSalesBook.
	client := aClient.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: #TusLibros stamp: 'fz 11/11/2019 21:27:14'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:22'!
assertIsNotEmpty: aCart 
	
	aCart isEmpty ifTrue: [self error: self cartCanNotBeEmptyErrorMessage ]! !

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:23'!
assertIsNotExpired: aCreditCard on: aDate
	
	(aCreditCard isExpiredOn: aDate) ifTrue: [ self error: self canNotChargeAnExpiredCreditCardErrorMessage ]! !


!Cashier class methodsFor: 'instance creation' stamp: 'fz 11/11/2019 21:14:00'!
toCheckout: aCart ofClient: aClient charging: aCreditCard throught: aMerchantProcessor on: aDate registeringOn: aSalesBook
	
	self assertIsNotEmpty: aCart.
	self assertIsNotExpired: aCreditCard on: aDate.
	
	^self new initializeToCheckout: aCart ofClient: aClient charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook! !


!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 18:21'!
canNotChargeAnExpiredCreditCardErrorMessage
	
	^'Can not charge an expired credit card'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:56'!
cartCanNotBeEmptyErrorMessage
	
	^'Can not check out an empty cart'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 19:02'!
creditCardHasNoCreditErrorMessage
	
	^'Credit card has no credit'! !


!classDefinition: #CreditCard category: #TusLibros stamp: 'fz 11/11/2019 21:27:14'!
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

!classDefinition: 'CreditCard class' category: #TusLibros stamp: 'fz 11/11/2019 21:27:14'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:38'!
expiringOn: aMonth 
	
	^self new initializeExpiringOn: aMonth! !


!classDefinition: #Sale category: #TusLibros stamp: 'fz 11/11/2019 21:27:14'!
Object subclass: #Sale
	instanceVariableNames: 'total listOfItems client'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Sale methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 18:48'!
total
	
	^ total! !


!Sale methodsFor: 'initialization' stamp: 'fz 11/11/2019 21:16:21'!
initializeTotal: aTotal listOfItems: aListOfItems forClient: aClient  

	total := aTotal.
	listOfItems := aListOfItems.
	client := aClient.! !


!Sale methodsFor: 'testing' stamp: 'fz 11/11/2019 21:16:50'!
client
	^client! !

!Sale methodsFor: 'testing' stamp: 'fz 11/11/2019 20:24:25'!
occurrencesOf: anItem
	^listOfItems occurrencesOf: anItem
	! !

!Sale methodsFor: 'testing' stamp: 'fz 11/11/2019 20:22:06'!
size
	^listOfItems size.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sale class' category: #TusLibros stamp: 'fz 11/11/2019 21:27:14'!
Sale class
	instanceVariableNames: ''!

!Sale class methodsFor: 'instance creation' stamp: 'fz 11/11/2019 21:16:13'!
of: aTotal listOfItems: aListOfItems forClient: aClient  

	"should assert total is not negative or 0!!"
	^self new initializeTotal: aTotal listOfItems: aListOfItems forClient: aClient ! !


!classDefinition: #StoreTestObjectsFactory category: #TusLibros stamp: 'fz 11/11/2019 21:27:14'!
Object subclass: #StoreTestObjectsFactory
	instanceVariableNames: 'today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'fz 11/7/2019 21:00:02'!
anotherItemSoldByTheStore

	^ 'anotherValidBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'fz 11/11/2019 19:11:44'!
anotherItemSoldByTheStorePrice
	
	^25! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'fz 11/11/2019 19:12:06'!
itemNotSoldByTheStore
	
	^'invalidBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'fz 11/7/2019 20:12:52'!
itemSoldByTheStore
	
	^ 'validBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'fz 11/11/2019 19:11:32'!
itemSoldByTheStorePrice
	
	^10! !


!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2013 18:08'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'fz 11/11/2019 19:11:44'!
defaultCatalog
	
	^ Dictionary new
		at: self itemSoldByTheStore put: self itemSoldByTheStorePrice;
		at: self anotherItemSoldByTheStore put: self anotherItemSoldByTheStorePrice;
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


!StoreTestObjectsFactory methodsFor: 'clients' stamp: 'fz 11/11/2019 21:14:13'!
validClient
	^'validClient'! !


!classDefinition: #UserAPI category: #TusLibros stamp: 'fz 11/11/2019 21:27:14'!
Object subclass: #UserAPI
	instanceVariableNames: 'userManager cartsRegister catalog currentID clock cartTimeRegister salesBook merchantProcessor cartClientRegister'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!UserAPI methodsFor: 'API' stamp: 'fz 11/11/2019 18:39:03'!
addToCart: aCartID book: aBookISBN quantity: aQuantity 

	self assertValidCart: aCartID.
	
	cartTimeRegister at: aCartID put: clock currentTime.

	^ (self cartOfID: aCartID) add: aQuantity of: aBookISBN.! !

!UserAPI methodsFor: 'API' stamp: 'fz 11/11/2019 21:22:33'!
createCartOf: aUser withPassword: aPassword 
	|cartID|
	(userManager isValidUser: aUser withPassword: aPassword) ifFalse: [self error: self class canNotCreateCartWithInvalidCredentialsErrorMessage].
	
	cartID := currentID.
	currentID  := currentID +1.
	
	cartsRegister at: cartID put: (Cart acceptingItemsOf: catalog).
	cartTimeRegister at: cartID put: clock currentTime.
	cartClientRegister at: cartID put: aUser.
	
	^cartID.! !

!UserAPI methodsFor: 'API' stamp: 'fz 11/11/2019 18:39:18'!
listCart: aCartID
	self assertValidCart: aCartID.
	^ (self cartOfID: aCartID) listItems.! !


!UserAPI methodsFor: 'initialization' stamp: 'fz 11/11/2019 21:22:07'!
initializeWithUserManager: aUserManager clock: aClock catalog: aCatalog salesBook: aSalesBook merchantProcessor: aMerchantProcessor    
	userManager := aUserManager.
	catalog := aCatalog.
	cartsRegister := Dictionary new.
	currentID := 1.
	clock := aClock.
	cartTimeRegister := Dictionary new.
	cartClientRegister := Dictionary new.
	salesBook := aSalesBook.
	merchantProcessor := aMerchantProcessor.! !


!UserAPI methodsFor: 'testing' stamp: 'fz 11/11/2019 18:32:58'!
cartOfID: aCartID
	^cartsRegister at: aCartID.! !

!UserAPI methodsFor: 'testing' stamp: 'fz 11/11/2019 18:35:28'!
isExpiredCart: aCartID 
	^clock currentTime > ((self lastAccesedTime: aCartID) next: (TimeUnits minute with: 30))! !

!UserAPI methodsFor: 'testing' stamp: 'fz 11/7/2019 20:29:55'!
isValidCartID: aCartID 
	^cartsRegister includesKey: aCartID ! !

!UserAPI methodsFor: 'testing' stamp: 'fz 11/11/2019 18:33:09'!
lastAccesedTime: aCartID 
	^ cartTimeRegister at: aCartID.! !


!UserAPI methodsFor: 'assert' stamp: 'fz 11/11/2019 18:39:33'!
assertValidCart: aCartID.
	(self isValidCartID: aCartID) ifFalse: [self error: self class invalidCartIDErrorMessage].
	(self isExpiredCart: aCartID) ifTrue: [self error: self class expiredCartErrorMessage]. ! !


!UserAPI methodsFor: 'as yet unclassified' stamp: 'fz 11/11/2019 21:21:38'!
checkoutCart: aCartID withCreditCard: aCreditCard
	|cashier total|
	self assertValidCart: aCartID.
	
	cashier:= Cashier 
		toCheckout: (self cartOfID: aCartID)
		ofClient: (self clientOfID: aCartID) 
		charging: aCreditCard
		throught: merchantProcessor
		on: clock today
		registeringOn: salesBook.
		
	total := cashier checkOut.
	cartsRegister removeKey: aCartID.
	cartTimeRegister removeKey: aCartID.
	cartClientRegister removeKey: aCartID.
	
	^total.! !

!UserAPI methodsFor: 'as yet unclassified' stamp: 'fz 11/11/2019 21:23:03'!
clientOfID: aCartID
	^cartClientRegister at: aCartID ! !

!UserAPI methodsFor: 'as yet unclassified' stamp: 'fz 11/11/2019 21:26:20'!
listPurchasesOf: aUser withPassword: aPassword
	| clientSales |
	(userManager isValidUser: aUser withPassword: aPassword) ifFalse: [self error: self class canNotListPurchasesWithInvalidCredentialsErrorMessage].
	
	clientSales := OrderedCollection new.
	salesBook do:[:aSale | aSale client = aUser ifTrue: [clientSales add: aSale]].
	^clientSales ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'UserAPI class' category: #TusLibros stamp: 'fz 11/11/2019 21:27:14'!
UserAPI class
	instanceVariableNames: ''!

!UserAPI class methodsFor: 'error messages' stamp: 'fz 11/7/2019 19:57:45'!
canNotCreateCartWithInvalidCredentialsErrorMessage
	^ 'usuario o contraseña invalida'! !

!UserAPI class methodsFor: 'error messages' stamp: 'fz 11/11/2019 19:56:13'!
canNotListPurchasesWithInvalidCredentialsErrorMessage
	^'invalid credentials'! !

!UserAPI class methodsFor: 'error messages' stamp: 'fz 11/11/2019 18:27:54'!
expiredCartErrorMessage
	^'cart is expired'! !

!UserAPI class methodsFor: 'error messages' stamp: 'fz 11/7/2019 20:38:06'!
invalidCartIDErrorMessage
	^'invalid cart ID'! !


!UserAPI class methodsFor: 'instance creation' stamp: 'fz 11/11/2019 19:25:25'!
withUserManager: aUserManager clock: aClock catalog: aCatalog salesBook: aSalesBook merchantProcessor: aMerchantProcessor    
	^self new initializeWithUserManager: aUserManager clock: aClock catalog: aCatalog salesBook: aSalesBook merchantProcessor: aMerchantProcessor . ! !
