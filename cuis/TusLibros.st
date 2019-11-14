!classDefinition: #CartTest category: #TusLibros stamp: 'fz 11/14/2019 20:16:08'!
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

!CartTest methodsFor: 'tests' stamp: 'fz 11/14/2019 19:09:40'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: 2 of: testObjectsFactory itemSoldByTheStore.
	self assert: (cart occurrencesOf: testObjectsFactory itemSoldByTheStore) = 2! !


!CartTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 18:09'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.! !


!classDefinition: #CashierTest category: #TusLibros stamp: 'fz 11/14/2019 20:16:08'!
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


!classDefinition: #UserAPITest category: #TusLibros stamp: 'fz 11/14/2019 20:16:08'!
TestCase subclass: #UserAPITest
	instanceVariableNames: 'testObjectsFactory debitBehavior usersLog validUser validUserPassword validUserButWrongPassword invalidUser invalidUserPassword time anotherValidUser anotherValidUserPassword emptySalesBook userAPI'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:15:59'!
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
	
	emptySalesBook := OrderedCollection new.
	
	userAPI := UserAPI withUserManager: self clock: self catalog: testObjectsFactory defaultCatalog salesBook: emptySalesBook merchantProcessor: self.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:16:00'!
test01CreateCartFailsWithUnknownUser

	self should: [userAPI createCartOf: invalidUser withPassword: invalidUserPassword.]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI invalidCredentialsErrorMessage].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:15:59'!
test02CartIsCreatedForValidUserAndIsEmpty
	| cartID |

	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	
	self assert: (userAPI isValidCartID: cartID).! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:15:59'!
test03CreateCartFailsWithWrongPassword

	self should: [userAPI createCartOf: validUser withPassword: validUserButWrongPassword.]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI invalidCredentialsErrorMessage].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:16:00'!
test04CreatedCartCanAddItems
	| cartID |
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	
	userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	
	self assert: (userAPI itemsOf: testObjectsFactory itemSoldByTheStore inCartID: cartID) equals: 1.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:15:59'!
test05CanNotAddItemsToInvalidCartID
	| cartID invalidCartID|
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	invalidCartID := cartID +1. "asumimos que los IDs son incrementales"
	
	self should: [userAPI addToCart: invalidCartID book: testObjectsFactory itemSoldByTheStore quantity: 1.]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI invalidCartIDErrorMessage].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:15:59'!
test06AddingItemsWithMultipleCartsBehavesCorrectly
	| cart1ID cart2ID|
	
	cart1ID := userAPI createCartOf: validUser withPassword: validUserPassword.
	cart2ID := userAPI createCartOf: validUser withPassword: validUserPassword.	
	
	userAPI addToCart: cart2ID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	userAPI addToCart: cart2ID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	
	self assert: (userAPI itemsOf: testObjectsFactory itemSoldByTheStore inCartID: cart2ID) equals: 2.
	self assert: (userAPI itemsOf: testObjectsFactory itemSoldByTheStore inCartID: cart1ID) equals: 0.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:15:59'!
test07ListCartOfNewCartIsEmpty
	|cartID|
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	
	self assert: (userAPI listCart: cartID) isEmpty.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:15:59'!
test08ListCartReflectsAddedItems
	|cartID itemsList |
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	
	userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	userAPI addToCart: cartID book: testObjectsFactory anotherItemSoldByTheStore quantity: 1.
	
	itemsList := userAPI listCart: cartID.
	self assert: (itemsList occurrencesOf: testObjectsFactory itemSoldByTheStore) equals: 2.
	self assert: (itemsList occurrencesOf: testObjectsFactory anotherItemSoldByTheStore) equals: 1.
	self assert: itemsList size equals: 3.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:15:59'!
test09newCartHasLastAccesedTimeRightNow
	|cartID|
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	
	self assert: (userAPI lastUsedTime: cartID) equals: self currentTime.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:15:59'!
test10canNotAddItemsToCartAfter30Mins
	| cartID|
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	time := time next: (TimeUnits minute with: 31).
	
	self should: [userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI expiredCartErrorMessage].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:15:59'!
test11canAddItemsToCartIfItWasCreated30MinsAgoButWasUsedInBetween
	|cartID itemsList |
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	time := time next: (TimeUnits minute with: 20).
	userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	time := time next: (TimeUnits minute with: 20).
	
	userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	
	itemsList := userAPI listCart: cartID.
	self assert: (itemsList occurrencesOf: testObjectsFactory itemSoldByTheStore) equals: 2.
	self assert: itemsList size equals: 2.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:16:00'!
test12canNotListCartAfter30Mins
	|cartID|
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	time := time next: (TimeUnits minute with: 31).
	
	self should: [userAPI listCart: cartID]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI expiredCartErrorMessage].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:15:59'!
test13CanNotLIstInvalidCartID
	|cartID invalidCartID|
	
	userAPI := UserAPI withUserManager: self clock: self catalog: testObjectsFactory defaultCatalog salesBook: emptySalesBook merchantProcessor: self.
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	invalidCartID := cartID +1. "asumimos que los IDs son incrementales"
	
	self should: [userAPI listCart: invalidCartID ]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI invalidCartIDErrorMessage].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:15:59'!
test14cartCheckoutRegistersSales
	|cartID total|
 
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	
	total := userAPI checkoutCart: cartID withCreditCard: testObjectsFactory notExpiredCreditCard.
			
	self assert: emptySalesBook size = 1.
	self assert: emptySalesBook first total = total.
	
	"acá podrían venir muchos tests medio redudantes de la lógica de cashier, no sería TDD sino testing, decidimos no agregarlos ya que nos parece que no es lo importante del ejercicio"
! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:15:59'!
test15afterCheckOutCartIDIsInvalid
	|cartID|
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	
	userAPI checkoutCart: cartID withCreditCard: testObjectsFactory notExpiredCreditCard.
			
	self should: [userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI invalidCartIDErrorMessage].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:15:59'!
test16cannotCheckoutAfter30Minutes
	|cartID|
	
	cartID := userAPI createCartOf: validUser withPassword: validUserPassword.
	userAPI addToCart: cartID book: testObjectsFactory itemSoldByTheStore quantity: 1.
	time := time next: (TimeUnits minute with: 31).
			
	self should: [userAPI checkoutCart: cartID withCreditCard: testObjectsFactory notExpiredCreditCard.]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI expiredCartErrorMessage ].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:15:59'!
test17ListPurchasesFailsWithInvalidCredentials
	
	self should: [userAPI listPurchasesOf: invalidUser withPassword: invalidUserPassword.]
	 raise: Error - MessageNotUnderstood 
	 withExceptionDo: [ :anError | 
			self assert: anError messageText = UserAPI invalidCredentialsErrorMessage].! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:15:59'!
test18ListPurchasesOfAValidClientWithOnlyOneSaleIsCorrect
	|total purchases |
 
	total := self makePurchaseForUser: validUser withPassword: validUserPassword andBuy: 1 of: testObjectsFactory itemSoldByTheStore .
	
	purchases := userAPI listPurchasesOf: validUser withPassword: validUserPassword.
	
	self assert: purchases itemsPurchased = 1.
	self assert: (purchases occurrencesOf: testObjectsFactory itemSoldByTheStore) equals: 1.
	self assert: purchases total = total.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:15:59'!
test19ListPurchasesOnlyListSalesOfQueringClient
	|total purchases |
	
	self makePurchaseForUser: anotherValidUser withPassword: anotherValidUserPassword andBuy: 2 of: testObjectsFactory itemSoldByTheStore .
	
	total := self makePurchaseForUser: validUser withPassword: validUserPassword andBuy: 1 of: testObjectsFactory itemSoldByTheStore .
	
	purchases := userAPI listPurchasesOf: validUser withPassword: validUserPassword.
	
	self assert: purchases itemsPurchased = 1.
	self assert: (purchases occurrencesOf: testObjectsFactory itemSoldByTheStore) equals: 1.
	self assert: purchases total = total.! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:15:49'!
test20cartCheckoutTicketHasDetailedPricesOfBooks
	|total|
 
	total := self makePurchaseForUser: validUser withPassword: validUserPassword andBuy: 1 of: testObjectsFactory itemSoldByTheStore .
			
	self assert: emptySalesBook size = 1.
	self assert: emptySalesBook first total = total.
	self assert: (emptySalesBook first priceOf: testObjectsFactory itemSoldByTheStore) = total.
	
	"este test en cierta manera deberia haber estado en checkout, como no se sabia el formato del ticket que debia devolver lo testeamos aca"! !

!UserAPITest methodsFor: 'tests' stamp: 'fz 11/14/2019 20:15:59'!
test21ListPurchasesOfAValidClientWithMultipleSalesIsCorrect
	|total purchases |
 
	total := self makePurchaseForUser: validUser withPassword: validUserPassword andBuy: 1 of: testObjectsFactory itemSoldByTheStore .
	total := total + (self makePurchaseForUser: validUser withPassword: validUserPassword andBuy: 1 of: testObjectsFactory itemSoldByTheStore ).
	
	purchases := userAPI listPurchasesOf: validUser withPassword: validUserPassword.
	
	self assert: purchases itemsPurchased = 2.
	self assert: (purchases occurrencesOf: testObjectsFactory itemSoldByTheStore) equals: 2.
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


!UserAPITest methodsFor: 'private' stamp: 'fz 11/14/2019 20:15:59'!
makePurchaseForUser: aUser withPassword: aPassword andBuy: aQuantity of: anItem  
	|cartID |
	cartID := userAPI createCartOf: aUser withPassword: aPassword.
	userAPI addToCart: cartID book: anItem quantity: aQuantity.
	^ userAPI checkoutCart: cartID withCreditCard: testObjectsFactory notExpiredCreditCard.
	! !


!classDefinition: #Cart category: #TusLibros stamp: 'fz 11/14/2019 20:16:08'!
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

!Cart methodsFor: 'queries' stamp: 'fz 11/14/2019 19:41:06'!
listItemsWithPrices
	^items inject: Dictionary new into: [:itemsWithPrice :item | itemsWithPrice at: item put: (catalog at: item). itemsWithPrice]! !

!Cart methodsFor: 'queries' stamp: 'fz 11/14/2019 19:09:40'!
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

!classDefinition: 'Cart class' category: #TusLibros stamp: 'fz 11/14/2019 20:16:08'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #Cashier category: #TusLibros stamp: 'fz 11/14/2019 20:16:08'!
Object subclass: #Cashier
	instanceVariableNames: 'cart salesBook merchantProcessor creditCard total client'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:08'!
calculateTotal

	total := cart total.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'fz 11/14/2019 19:45:49'!
createTicket

	^ Ticket of: total itemsQuantity: cart listItems itemsPrices: cart listItemsWithPrices forClient: client ! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
debitTotal

	merchantProcessor debit: total from: creditCard.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'fz 11/14/2019 18:02:25'!
registerSale

	salesBook add: self createTicket! !


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

!classDefinition: 'Cashier class' category: #TusLibros stamp: 'fz 11/14/2019 20:16:08'!
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


!classDefinition: #CreditCard category: #TusLibros stamp: 'fz 11/14/2019 20:16:08'!
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

!classDefinition: 'CreditCard class' category: #TusLibros stamp: 'fz 11/14/2019 20:16:08'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:38'!
expiringOn: aMonth 
	
	^self new initializeExpiringOn: aMonth! !


!classDefinition: #PurchaseSummary category: #TusLibros stamp: 'fz 11/14/2019 20:16:08'!
Object subclass: #PurchaseSummary
	instanceVariableNames: 'client sales'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!PurchaseSummary methodsFor: 'initialization' stamp: 'fz 11/14/2019 17:45:32'!
initializeOfClient: aClient withSales: salesOfClient
	client := aClient.
	sales := salesOfClient.! !


!PurchaseSummary methodsFor: 'testing' stamp: 'fz 11/14/2019 17:58:48'!
itemsPurchased
	^sales inject: 0 into: [:total :sale | total + sale size]! !

!PurchaseSummary methodsFor: 'testing' stamp: 'fz 11/14/2019 18:22:01'!
namesOfBooks
	^sales inject: Set new into: [:total :sale | total addAll: sale items]! !

!PurchaseSummary methodsFor: 'testing' stamp: 'fz 11/14/2019 19:09:40'!
occurrencesOf: anItem
	^sales inject: 0 into: [:total :sale | total + (sale occurrencesOf: anItem)]! !

!PurchaseSummary methodsFor: 'testing' stamp: 'fz 11/14/2019 18:00:28'!
total
	^sales inject: 0 into: [:total :sale | total + sale total]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PurchaseSummary class' category: #TusLibros stamp: 'fz 11/14/2019 20:16:08'!
PurchaseSummary class
	instanceVariableNames: ''!

!PurchaseSummary class methodsFor: 'instance creation' stamp: 'fz 11/14/2019 17:45:48'!
ofClient: aClient withSales: salesOfClient 
	^self new initializeOfClient: aClient withSales: salesOfClient ! !


!classDefinition: #Session category: #TusLibros stamp: 'fz 11/14/2019 20:16:08'!
Object subclass: #Session
	instanceVariableNames: 'user cart lastUsedTime'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Session methodsFor: 'initialization' stamp: 'fz 11/14/2019 18:39:22'!
initializeOfUser: aUser withCart: aCart lastUsedTime: theLastUsedTime 
	user := aUser.
	cart := aCart.
	lastUsedTime := theLastUsedTime.! !


!Session methodsFor: 'using cart' stamp: 'fz 11/14/2019 18:51:08'!
add: aQuantity of: aBookISBN on: aTime
	cart add: aQuantity of: aBookISBN.
	lastUsedTime := aTime.! !

!Session methodsFor: 'using cart' stamp: 'fz 11/14/2019 18:52:40'!
listItems
	^cart listItems ! !

!Session methodsFor: 'using cart' stamp: 'fz 11/14/2019 19:11:28'!
quantityOf: anItem
	^cart occurrencesOf: anItem! !


!Session methodsFor: 'testing' stamp: 'fz 11/14/2019 18:59:13'!
lastUsedTime
	^lastUsedTime! !


!Session methodsFor: 'checkout' stamp: 'fz 11/14/2019 18:50:11'!
checkoutCharging: aCreditCard throught: aMerchantProcessor on: aTime registeringOn: aSalesBook
	|cashier|
	
	cashier:= Cashier 
			toCheckout: cart
			ofClient: user
			charging: aCreditCard
			throught: aMerchantProcessor
			on: aTime
			registeringOn: aSalesBook.
		
	^cashier checkOut.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Session class' category: #TusLibros stamp: 'fz 11/14/2019 20:16:08'!
Session class
	instanceVariableNames: ''!

!Session class methodsFor: 'instance creation' stamp: 'fz 11/14/2019 18:38:45'!
ofUser: aUser withCart: aCart lastUsedTime: theLastUsedTime 
	^self new initializeOfUser: aUser withCart: aCart lastUsedTime: theLastUsedTime ! !


!classDefinition: #StoreTestObjectsFactory category: #TusLibros stamp: 'fz 11/14/2019 20:16:08'!
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


!classDefinition: #Ticket category: #TusLibros stamp: 'fz 11/14/2019 20:16:08'!
Object subclass: #Ticket
	instanceVariableNames: 'total itemsPrice client itemsQuantity'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Ticket methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 18:48'!
total
	
	^ total! !


!Ticket methodsFor: 'initialization' stamp: 'fz 11/14/2019 19:46:54'!
initializeTotal: aTotal itemsQuantity: theItemsQuantity itemsPrices: theItemsAndPrices forClient: aClient    

	total := aTotal.
	itemsQuantity := theItemsQuantity.
	itemsPrice := theItemsAndPrices.
	client := aClient.! !


!Ticket methodsFor: 'testing' stamp: 'fz 11/14/2019 18:04:33'!
isOfClient: aClient
	^client = aClient ! !

!Ticket methodsFor: 'testing' stamp: 'fz 11/14/2019 19:47:07'!
occurrencesOf: anItem
	^itemsQuantity occurrencesOf: anItem! !

!Ticket methodsFor: 'testing' stamp: 'fz 11/14/2019 19:46:42'!
priceOf: anItem
	^itemsPrice at: anItem
	! !

!Ticket methodsFor: 'testing' stamp: 'fz 11/14/2019 19:47:16'!
size
	^itemsQuantity size.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Ticket class' category: #TusLibros stamp: 'fz 11/14/2019 20:16:08'!
Ticket class
	instanceVariableNames: ''!

!Ticket class methodsFor: 'instance creation' stamp: 'fz 11/14/2019 19:46:30'!
of: aTotal itemsQuantity: theItemsQuantity itemsPrices: theItemsAndPrices forClient: aClient    

	"should assert total is not negative or 0!!"
	^self new initializeTotal: aTotal itemsQuantity: theItemsQuantity itemsPrices: theItemsAndPrices forClient: aClient ! !


!classDefinition: #UserAPI category: #TusLibros stamp: 'fz 11/14/2019 20:16:08'!
Object subclass: #UserAPI
	instanceVariableNames: 'userManager catalog currentID clock salesBook merchantProcessor sessions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!UserAPI methodsFor: 'API' stamp: 'fz 11/14/2019 18:46:03'!
addToCart: aCartID book: aBookISBN quantity: aQuantity 

	self assertValidCart: aCartID.
	
	(sessions at: aCartID) add: aQuantity of: aBookISBN on: clock currentTime.! !

!UserAPI methodsFor: 'API' stamp: 'fz 11/14/2019 18:50:30'!
checkoutCart: aCartID withCreditCard: aCreditCard
	|total|
	self assertValidCart: aCartID.
	
	total := (sessions at: aCartID) checkoutCharging: aCreditCard
		throught: merchantProcessor
		on: clock today
		registeringOn: salesBook.
		
	sessions removeKey: aCartID.
	
	^total.! !

!UserAPI methodsFor: 'API' stamp: 'fz 11/14/2019 18:51:55'!
createCartOf: aUser withPassword: aPassword 
	|cartID cart |
	self assertCredentialsOfUser: aUser withPassword: aPassword.
	
	cartID := currentID.
	currentID  := currentID +1.
	
	cart := Cart acceptingItemsOf: catalog.
	sessions at: cartID put: (Session ofUser: aUser withCart: cart lastUsedTime: clock currentTime).
	
	^cartID.! !

!UserAPI methodsFor: 'API' stamp: 'fz 11/14/2019 18:52:28'!
listCart: aCartID
	self assertValidCart: aCartID.
	^ (sessions at: aCartID) listItems.! !

!UserAPI methodsFor: 'API' stamp: 'fz 11/14/2019 18:10:16'!
listPurchasesOf: aUser withPassword: aPassword
	self assertCredentialsOfUser: aUser withPassword: aPassword.
	
	^PurchaseSummary ofClient: aUser withSales: (salesBook select:[:aSale | aSale isOfClient: aUser]).! !


!UserAPI methodsFor: 'initialization' stamp: 'fz 11/14/2019 18:59:40'!
initializeWithUserManager: aUserManager clock: aClock catalog: aCatalog salesBook: aSalesBook merchantProcessor: aMerchantProcessor    
	userManager := aUserManager.
	catalog := aCatalog.
	clock := aClock.
	salesBook := aSalesBook.
	merchantProcessor := aMerchantProcessor.
	
	currentID := 1.
	
	sessions := Dictionary new.! !


!UserAPI methodsFor: 'testing' stamp: 'fz 11/14/2019 18:59:26'!
isExpiredCart: aCartID 
	^clock currentTime > ((self lastUsedTime: aCartID) next: (TimeUnits minute with: 30))! !

!UserAPI methodsFor: 'testing' stamp: 'fz 11/14/2019 18:58:09'!
isValidCartID: aCartID 
	^sessions includesKey: aCartID ! !

!UserAPI methodsFor: 'testing' stamp: 'fz 11/14/2019 19:11:05'!
itemsOf: anItem inCartID: aCartID
	^(sessions at: aCartID) quantityOf: anItem.! !

!UserAPI methodsFor: 'testing' stamp: 'fz 11/14/2019 18:59:25'!
lastUsedTime: aCartID 
	^ (sessions at: aCartID) lastUsedTime.! !


!UserAPI methodsFor: 'assert' stamp: 'fz 11/14/2019 18:09:43'!
assertCredentialsOfUser: aUser withPassword: aPassword
	(userManager isValidUser: aUser withPassword: aPassword) ifFalse: [self error: self class invalidCredentialsErrorMessage].! !

!UserAPI methodsFor: 'assert' stamp: 'fz 11/11/2019 18:39:33'!
assertValidCart: aCartID.
	(self isValidCartID: aCartID) ifFalse: [self error: self class invalidCartIDErrorMessage].
	(self isExpiredCart: aCartID) ifTrue: [self error: self class expiredCartErrorMessage]. ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'UserAPI class' category: #TusLibros stamp: 'fz 11/14/2019 20:16:08'!
UserAPI class
	instanceVariableNames: ''!

!UserAPI class methodsFor: 'error messages' stamp: 'fz 11/11/2019 18:27:54'!
expiredCartErrorMessage
	^'cart is expired'! !

!UserAPI class methodsFor: 'error messages' stamp: 'fz 11/7/2019 20:38:06'!
invalidCartIDErrorMessage
	^'invalid cart ID'! !

!UserAPI class methodsFor: 'error messages' stamp: 'fz 11/14/2019 18:08:26'!
invalidCredentialsErrorMessage
	^ 'usuario o contraseña invalida'! !


!UserAPI class methodsFor: 'instance creation' stamp: 'fz 11/11/2019 19:25:25'!
withUserManager: aUserManager clock: aClock catalog: aCatalog salesBook: aSalesBook merchantProcessor: aMerchantProcessor    
	^self new initializeWithUserManager: aUserManager clock: aClock catalog: aCatalog salesBook: aSalesBook merchantProcessor: aMerchantProcessor . ! !
