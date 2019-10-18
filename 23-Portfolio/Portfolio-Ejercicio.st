!classDefinition: #PortfolioTest category: #'Portfolio-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!PortfolioTest methodsFor: 'tests' stamp: 'jy 10/17/2019 18:58:22'!
test01PortfolioHasZeroAsBalanceWhenCreated 

	| portfolio |
	
	portfolio := Portfolio new.

	self assert: 0 equals: portfolio balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'jy 10/17/2019 19:00:10'!
test02PortfolioHasNoTransactionWhenCreated 

	| portfolio |
	
	portfolio := Portfolio new.

	self assert: portfolio transactions isEmpty.! !

!PortfolioTest methodsFor: 'tests' stamp: 'jy 10/17/2019 20:17:17'!
test03AnAddedAccountIsOnPortfolio

	| portfolio account|
	
	portfolio := Portfolio new.
	account := ReceptiveAccount new.
	
	portfolio addFinancialRecord: account.

	self assert: (portfolio hasAccount: account).! !

!PortfolioTest methodsFor: 'tests' stamp: 'jy 10/17/2019 20:17:17'!
test04notAddedAccountIsNotOnPortfolio

	| portfolio addedAccount notAddedAccount|
	
	portfolio := Portfolio new.
	addedAccount := ReceptiveAccount new.
	notAddedAccount := ReceptiveAccount new.	
	
	portfolio addFinancialRecord: addedAccount.

	self deny: (portfolio hasAccount: notAddedAccount).! !

!PortfolioTest methodsFor: 'tests' stamp: 'jy 10/17/2019 20:17:17'!
test05PortfolioBalanceReflectsAddedAccountInitialBalance

	| portfolio account|
	
	portfolio := Portfolio new.
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	
	portfolio addFinancialRecord: account.

	self assert: portfolio balance equals: 100.! !

!PortfolioTest methodsFor: 'tests' stamp: 'jy 10/17/2019 20:17:17'!
test06PortfolioBalanceReflectsAddedAccountUpdatedBalance

	| portfolio account|
	
	portfolio := Portfolio new.
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	
	portfolio addFinancialRecord: account.
	
	Deposit register: 100 on: account.
	
	self assert: portfolio balance equals: 200.! !

!PortfolioTest methodsFor: 'tests' stamp: 'jy 10/17/2019 20:17:17'!
test07portfolioKnowsTransactionsOfAddedAccounts

	| portfolio account deposit|
	
	portfolio := Portfolio new.
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	
	portfolio addFinancialRecord: account.
		
	self assert: portfolio transactions includes: deposit.
	self assert: portfolio transactions size equals: 1.! !

!PortfolioTest methodsFor: 'tests' stamp: 'jy 10/17/2019 20:17:17'!
test08transactionsNotInPortfolioAccountsAreNotRegistered

	| portfolio addedAccount notAddedAccount noRegisteredDeposit |
	
	portfolio := Portfolio new.
	
	addedAccount := ReceptiveAccount new.
	Deposit register: 100 on: addedAccount.
	
	notAddedAccount := ReceptiveAccount new.
	noRegisteredDeposit := Deposit register: 50 on: notAddedAccount.
	
	portfolio addFinancialRecord: addedAccount.
	
	self deny: (portfolio hasRegistered: noRegisteredDeposit).! !

!PortfolioTest methodsFor: 'tests' stamp: 'jy 10/17/2019 20:17:17'!
test09transactionsInPortfolioAccountsAreRegistered

	| portfolio addedAccount notAddedAccount noRegisteredDeposit |
	
	portfolio := Portfolio new.
	
	addedAccount := ReceptiveAccount new.
	Deposit register: 100 on: addedAccount.
	
	notAddedAccount := ReceptiveAccount new.
	noRegisteredDeposit := Deposit register: 50 on: notAddedAccount.
	
	portfolio addFinancialRecord: addedAccount.
	
	self deny: (portfolio hasRegistered: noRegisteredDeposit).! !

!PortfolioTest methodsFor: 'tests' stamp: 'jy 10/17/2019 20:17:17'!
test10transactionsInPortfolioAccountsAreRegistered

	| portfolio account deposit |
	
	portfolio := Portfolio new.
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	
	portfolio addFinancialRecord: account.
	
	self assert: (portfolio hasRegistered: deposit).! !

!PortfolioTest methodsFor: 'tests' stamp: 'jy 10/17/2019 20:17:17'!
test11CannotAddDuplicateAccountsInPortfolio

	| portfolio account |
	
	portfolio := Portfolio new.
	
	account := ReceptiveAccount new.
	
	portfolio addFinancialRecord: account.
	
	self should: [portfolio addFinancialRecord: account] 
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: Portfolio accountAlreadyAddedErrorMessage.
				self assert: (portfolio hasAccount: account)]! !

!PortfolioTest methodsFor: 'tests' stamp: 'jy 10/17/2019 20:17:32'!
test12CanAddAPortfolio

	| rootPortfolio addedPortfolio account |
	
	rootPortfolio := Portfolio new.
	addedPortfolio := Portfolio new.
	
	account := ReceptiveAccount new.
	
	addedPortfolio addFinancialRecord: account.
	
	rootPortfolio addFinancialRecord: addedPortfolio.
	self assert: (rootPortfolio hasAccount: account).! !

!PortfolioTest methodsFor: 'tests' stamp: 'jy 10/17/2019 20:23:55'!
test13PortfolioBalanceReflectsAddedPortfolios

	| rootPortfolio addedPortfolio account |
	
	rootPortfolio := Portfolio new.
	addedPortfolio := Portfolio new.
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account. 
	
	addedPortfolio addFinancialRecord: account.
	
	rootPortfolio addFinancialRecord: addedPortfolio.
	self assert: rootPortfolio balance equals: 100.! !

!PortfolioTest methodsFor: 'tests' stamp: 'jy 10/17/2019 20:26:18'!
test14CannotAddAPortfolioWithAccountsAlreadyRegisteredInThisPortfolio

	| rootPortfolio addedPortfolio account |
	
	rootPortfolio := Portfolio new.
	addedPortfolio  := Portfolio new.
	
	account := ReceptiveAccount new.
	
	rootPortfolio addFinancialRecord: account.
	addedPortfolio addFinancialRecord: account.
	
	self should: [rootPortfolio addFinancialRecord: addedPortfolio] 
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: Portfolio accountAlreadyAddedErrorMessage.
				self assert: (rootPortfolio hasAccount: account)]! !

!PortfolioTest methodsFor: 'tests' stamp: 'jy 10/17/2019 20:36:20'!
test15CannotAddAnEmptyPortfolioIfItsAlreadyInThisPortfolio

	| rootPortfolio addedPortfolio |
	
	rootPortfolio := Portfolio new.
	addedPortfolio  := Portfolio new.
	rootPortfolio addFinancialRecord: addedPortfolio.
	
	self should: [rootPortfolio addFinancialRecord: addedPortfolio] 
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: Portfolio portfolioAlreadyAddedErrorMessage.]! !

!PortfolioTest methodsFor: 'tests' stamp: 'jy 10/17/2019 20:44:34'!
test16PortfolioCannotAddItself

	| rootPortfolio  |
	
	rootPortfolio := Portfolio new.
	
	self should: [rootPortfolio addFinancialRecord: rootPortfolio ] 
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: Portfolio portfolioAlreadyAddedErrorMessage.]! !


!classDefinition: #ReceptiveAccountTest category: #'Portfolio-Ejercicio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:48'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:54'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:02'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:32'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:46'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:54'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:21:24'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 100 on: account1.
		
	self assert: 1 equals: account1 transactions size .
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #AccountTransaction category: #'Portfolio-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: #'Portfolio-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/17/2019 03:22:00'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: #'Portfolio-Ejercicio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'as yet unclassified' stamp: 'jy 10/17/2019 18:48:40'!
updateBalance: aBalance
	^ aBalance + value
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: #'Portfolio-Ejercicio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Withdraw category: #'Portfolio-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'jy 10/17/2019 18:39:45'!
value

	^ value! !


!Withdraw methodsFor: 'as yet unclassified' stamp: 'jy 10/17/2019 18:49:00'!
updateBalance: aBalance
	^aBalance - value
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: #'Portfolio-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #FinancialRecord category: #'Portfolio-Ejercicio'!
Object subclass: #FinancialRecord
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!FinancialRecord methodsFor: 'as yet unclassified' stamp: 'jy 10/17/2019 20:19:08'!
accounts
	^self subclassResponsibility.! !

!FinancialRecord methodsFor: 'as yet unclassified' stamp: 'jy 10/17/2019 20:19:33'!
balance
	^self subclassResponsibility.! !

!FinancialRecord methodsFor: 'as yet unclassified' stamp: 'jy 10/17/2019 20:19:53'!
hasRegistered: aTransaction
	^self subclassResponsibility.! !

!FinancialRecord methodsFor: 'as yet unclassified' stamp: 'jy 10/17/2019 20:19:59'!
transactions
	^self subclassResponsibility.! !


!classDefinition: #Portfolio category: #'Portfolio-Ejercicio'!
FinancialRecord subclass: #Portfolio
	instanceVariableNames: 'holdees'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'as yet unclassified' stamp: 'jy 10/17/2019 20:11:37'!
accounts
	^holdees inject: Set new into: [:theAccounts :aHoldee | theAccounts addAll: aHoldee accounts]. ! !

!Portfolio methodsFor: 'as yet unclassified' stamp: 'jy 10/17/2019 20:47:54'!
addFinancialRecord: aFinancialRecord 
	(aFinancialRecord isKindOf: Portfolio) ifTrue:[
		(self financialRecords includes: aFinancialRecord ) ifTrue: [self error: self class portfolioAlreadyAddedErrorMessage].
	].
	
	(aFinancialRecord accounts anySatisfy: [:anAccount | self hasAccount: anAccount]) ifTrue:[self error: self class accountAlreadyAddedErrorMessage].
	
	holdees add: aFinancialRecord .! !

!Portfolio methodsFor: 'as yet unclassified' stamp: 'jy 10/17/2019 20:09:45'!
balance
	^holdees sum: [:anAccount | anAccount balance] ifEmpty: [0].
	! !

!Portfolio methodsFor: 'as yet unclassified' stamp: 'jy 10/17/2019 20:39:35'!
financialRecords
	^ holdees copy add: self;yourself.! !

!Portfolio methodsFor: 'as yet unclassified' stamp: 'jy 10/17/2019 20:13:00'!
hasAccount: aReceptiveAccount 
	^self accounts includes: aReceptiveAccount ! !

!Portfolio methodsFor: 'as yet unclassified' stamp: 'jy 10/17/2019 19:36:07'!
hasRegistered: aTransaction
	^ self transactions includes: aTransaction ! !

!Portfolio methodsFor: 'as yet unclassified' stamp: 'jy 10/17/2019 20:09:45'!
initialize
	holdees := Set new.! !

!Portfolio methodsFor: 'as yet unclassified' stamp: 'jy 10/17/2019 20:09:45'!
transactions
	|transactions|
	transactions := Set new.
	holdees do: [:anAccount | transactions addAll: anAccount transactions].
	
	^transactions! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: #'Portfolio-Ejercicio'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'error message' stamp: 'jy 10/17/2019 19:47:41'!
accountAlreadyAddedErrorMessage
	^'la cuenta ya fue agregada'! !

!Portfolio class methodsFor: 'error message' stamp: 'jy 10/17/2019 20:40:02'!
portfolioAlreadyAddedErrorMessage
	^'no se pueden tener portfolios repetidos'! !


!classDefinition: #ReceptiveAccount category: #'Portfolio-Ejercicio'!
FinancialRecord subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'NR 10/17/2019 15:06:56'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'jy 10/17/2019 19:39:31'!
balance
	^transactions inject: 0 into: [:aBalance :aTransaction| aTransaction updateBalance: aBalance].
! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'jy 10/17/2019 20:11:57'!
accounts
	^Set with: self.! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/17/2019 03:28:43'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !
