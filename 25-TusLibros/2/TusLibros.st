!classDefinition: #CartTest category: #TusLibros stamp: 'fz_md 11/4/2019 20:53:23'!
TestCase subclass: #CartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:08'!
test01NewCartsAreCreatedEmpty

	self assert: self createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:45'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := self createCart.
	
	self 
		should: [ cart add: self itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := self createCart.
	
	self 
		should: [cart add: 0 of: self itemSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:45'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := self createCart.
	
	self 
		should: [cart add: 2 of: self itemNotSellByTheStore  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test06CartRemembersAddedItems

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	self assert: (cart includes: self itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := self createCart.
	
	self deny: (cart includes: self itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:45'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := self createCart.
	
	cart add: 2 of: self itemSellByTheStore.
	self assert: (cart occurrencesOf: self itemSellByTheStore) = 2! !


!CartTest methodsFor: 'support' stamp: 'fz_md 11/4/2019 19:43:58'!
createCart
	
	^TusLibrosTestObjectFactory createCart ! !

!CartTest methodsFor: 'support' stamp: 'fz_md 11/4/2019 19:43:52'!
defaultCatalog
	
	^ TusLibrosTestObjectFactory defaultCatalog ! !

!CartTest methodsFor: 'support' stamp: 'fz_md 11/4/2019 19:43:46'!
itemNotSellByTheStore
	
	^TusLibrosTestObjectFactory itemNotSellByTheStore ! !

!CartTest methodsFor: 'support' stamp: 'fz_md 11/4/2019 19:42:09'!
itemSellByTheStore
	^TusLibrosTestObjectFactory itemSellByTheStore! !


!classDefinition: #CashierTest category: #TusLibros stamp: 'fz_md 11/4/2019 20:53:23'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'emptyCart emptySalesBook expiredCreditCard validCreditCard testingDate item cartWithItems cardWithInvalidOwnerName cardWithInvalidNumber'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'fz_md 11/4/2019 19:57:12'!
test01canNotCheckoutEmptyCart
	
	self should: [Cashier toCheckout: emptyCart registerOn: emptySalesBook withCreditCard: validCreditCard onDay: testingDate]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError| self assert: anError messageText = Cashier canNotCheckoutEmptyCart.
								self assert: emptySalesBook isEmpty]! !

!CashierTest methodsFor: 'tests' stamp: 'fz_md 11/4/2019 20:00:58'!
test02TotalCheckoutAmmountIsCorrectAndIsRegistered
	| cashier|
	
	cashier :=  Cashier toCheckout: cartWithItems registerOn: emptySalesBook withCreditCard: validCreditCard onDay: testingDate.
	
	self assert: (cashier checkout) equals: TusLibrosTestObjectFactory itemPrice.
	self assert: (emptySalesBook first) equals: TusLibrosTestObjectFactory itemPrice.! !

!CashierTest methodsFor: 'tests' stamp: 'fz_md 11/4/2019 19:57:02'!
test03cannotCheckoutWithExpiredCreditCard
	| cashier|
	
	cashier :=  Cashier toCheckout: cartWithItems registerOn: emptySalesBook withCreditCard: expiredCreditCard onDay: testingDate.
	
	self should: [cashier checkout ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError| self assert: anError messageText = Cashier canNotCheckoutWIthExpiredCreditCard.
								self assert: emptySalesBook isEmpty]! !

!CashierTest methodsFor: 'tests' stamp: 'fz_md 11/4/2019 20:52:25'!
test04canNotCheckoutCreditCardWithInvalidOwner
	| cashier |
	
	cashier :=  Cashier toCheckout: cartWithItems registerOn: emptySalesBook withCreditCard: cardWithInvalidOwnerName onDay: testingDate.
	
	self should: [cashier checkout ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError| self assert: anError messageText = Cashier canNotCheckoutCardWithInvalidOwner.
								self assert: emptySalesBook isEmpty]! !


!CashierTest methodsFor: 'setUp' stamp: 'fz_md 11/4/2019 20:45:18'!
setUp
	|validCardDate|
	item := TusLibrosTestObjectFactory itemSellByTheStore.
	
	emptyCart := TusLibrosTestObjectFactory createCart.
	
	cartWithItems := TusLibrosTestObjectFactory createCart.
	cartWithItems add: item.
	
	emptySalesBook := OrderedCollection new.
	testingDate := FixedGregorianDate yearNumber: 2019 monthNumber: 12 dayNumber: 31.
	
	expiredCreditCard := CreditCard expiresOn: (GregorianMonthOfYear yearNumber: 2000 monthNumber:1) ownedBy: 'owner' withNumber: 1.
	
	validCardDate := (GregorianMonthOfYear yearNumber: 2200 monthNumber:1).
	
	validCreditCard := CreditCard expiresOn: validCardDate ownedBy: 'owner' withNumber: 1.
	cardWithInvalidOwnerName := CreditCard expiresOn: validCardDate ownedBy: 'tooLongOfAString_lol_aaaaaaaaaaaaaaaaaa' withNumber: 1.
	cardWithInvalidNumber := CreditCard expiresOn: validCardDate ownedBy: 'Juan Perez' withNumber: -1.! !


!classDefinition: #Cart category: #TusLibros stamp: 'fz_md 11/4/2019 20:53:23'!
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


!Cart methodsFor: 'assertions' stamp: 'fz_md 11/4/2019 19:52:09'!
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

!Cart methodsFor: 'queries' stamp: 'fz_md 11/4/2019 19:48:39'!
totalPrice
	^items inject: 0 into: [:totalValue :item | totalValue + catalog at:item].! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:44'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:51'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	1 to: aQuantity do: [ :aNumber | items add: anItem ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: #TusLibros stamp: 'fz_md 11/4/2019 20:53:23'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #Cashier category: #TusLibros stamp: 'fz_md 11/4/2019 20:53:23'!
Object subclass: #Cashier
	instanceVariableNames: 'cart salesBook creditCard date'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'initialization' stamp: 'fz_md 11/4/2019 19:57:55'!
initializeToCheckout: aCart registerOn: aSalesBook withCreditCard: aCreditCard onDay: aDay    
	cart := aCart.
	salesBook := aSalesBook.
	creditCard := aCreditCard.
	date := aDay.! !


!Cashier methodsFor: 'as yet unclassified' stamp: 'fz_md 11/4/2019 20:51:51'!
checkout
	|totalCheckout|
	
	creditCard owner size > 30 ifTrue: [self error: self class canNotCheckoutCardWithInvalidOwner].
	date > creditCard expirationDate ifTrue: [self error: self class canNotCheckoutWIthExpiredCreditCard ].
	
	totalCheckout := cart totalPrice.
	
	salesBook add: totalCheckout.
	
	^totalCheckout! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: #TusLibros stamp: 'fz_md 11/4/2019 20:53:23'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'instance creation' stamp: 'fz_md 11/4/2019 19:58:06'!
toCheckout: aCart registerOn: aSalesBook withCreditCard: aCreditCard onDay: aDay    
	
	aCart isEmpty ifTrue:[self error: self canNotCheckoutEmptyCart].
	
	^self new initializeToCheckout: aCart registerOn: aSalesBook withCreditCard: aCreditCard onDay: aDay    ! !


!Cashier class methodsFor: 'error messages' stamp: 'fz_md 11/4/2019 20:52:47'!
canNotCheckoutCardWithInvalidOwner
	^'can not checkout card with invalid owner'! !

!Cashier class methodsFor: 'error messages' stamp: 'fz_md 11/4/2019 18:01:13'!
canNotCheckoutEmptyCart
	^'can not checkout an empty cart'! !

!Cashier class methodsFor: 'error messages' stamp: 'fz_md 11/4/2019 19:24:50'!
canNotCheckoutWIthExpiredCreditCard
	^'the credit card is no longer valid'! !


!classDefinition: #CreditCard category: #TusLibros stamp: 'fz_md 11/4/2019 20:53:23'!
Object subclass: #CreditCard
	instanceVariableNames: 'expirationDate owner number'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'initialization' stamp: 'fz_md 11/4/2019 20:37:22'!
initializeExpiresOn: anExpirationDate ownedBy: anOwner withNumber: aNumber   
	expirationDate := anExpirationDate.
	owner := anOwner.
	number := aNumber.! !


!CreditCard methodsFor: 'testing' stamp: 'fz_md 11/4/2019 19:22:00'!
expirationDate

	^ expirationDate.! !


!CreditCard methodsFor: 'as yet unclassified' stamp: 'fz_md 11/4/2019 20:52:03'!
owner
	^owner! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: #TusLibros stamp: 'fz_md 11/4/2019 20:53:23'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'fz_md 11/4/2019 20:36:50'!
expiresOn: expirationDate ownedBy: anOwner withNumber: aNumber   
	^self new initializeExpiresOn: expirationDate ownedBy: anOwner withNumber: aNumber   ! !


!classDefinition: #MerchantProcessor category: #TusLibros stamp: 'fz_md 11/4/2019 20:53:23'!
Object subclass: #MerchantProcessor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!


!classDefinition: #TusLibrosTestObjectFactory category: #TusLibros stamp: 'fz_md 11/4/2019 20:53:23'!
Object subclass: #TusLibrosTestObjectFactory
	instanceVariableNames: 'expirationDate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TusLibrosTestObjectFactory class' category: #TusLibros stamp: 'fz_md 11/4/2019 20:53:23'!
TusLibrosTestObjectFactory class
	instanceVariableNames: ''!

!TusLibrosTestObjectFactory class methodsFor: 'as yet unclassified' stamp: 'fz_md 11/4/2019 19:42:38'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!TusLibrosTestObjectFactory class methodsFor: 'as yet unclassified' stamp: 'fz_md 11/4/2019 19:53:49'!
defaultCatalog
	|catalog|
	
	catalog := Dictionary new.
	catalog at: self itemSellByTheStore put: self itemPrice.
	^ catalog ! !

!TusLibrosTestObjectFactory class methodsFor: 'as yet unclassified' stamp: 'fz_md 11/4/2019 19:42:50'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!TusLibrosTestObjectFactory class methodsFor: 'as yet unclassified' stamp: 'fz_md 11/4/2019 19:49:57'!
itemPrice
	^10.! !

!TusLibrosTestObjectFactory class methodsFor: 'as yet unclassified' stamp: 'fz_md 11/4/2019 19:43:07'!
itemSellByTheStore

	^'validBook'! !
