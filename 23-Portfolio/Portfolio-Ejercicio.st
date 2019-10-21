!classDefinition: #PortfolioTest category: #'Portfolio-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: 'aPortfolio aManagedSubPortfolio anAccountManagedBySubPortfolio anEmptyPortfolio notManagedAccount aManagedAccount'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!PortfolioTest methodsFor: 'tests' stamp: 'fz 10/20/2019 19:23:15'!
test01PortfolioHasZeroAsBalanceWhenCreated 

	self assert: 0 equals: anEmptyPortfolio balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'fz 10/20/2019 19:23:28'!
test02PortfolioHasNoTransactionWhenCreated 

	self assert: anEmptyPortfolio transactions isEmpty.! !

!PortfolioTest methodsFor: 'tests' stamp: 'fz 10/20/2019 19:32:54'!
test03AnAddedAccountIsManagedByThePortfolio

	self assert: (aPortfolio manages: aManagedAccount ).! !

!PortfolioTest methodsFor: 'tests' stamp: 'fz 10/20/2019 19:25:12'!
test04notAddedAccountIsNotOnPortfolio

	self deny: (aPortfolio manages: notManagedAccount).! !

!PortfolioTest methodsFor: 'tests' stamp: 'fz 10/20/2019 19:54:16'!
test05PortfolioBalanceReflectsAccountTransactionsFromBefore

	| portfolio account|
	
	portfolio := Portfolio new.
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	
	portfolio manage: account.

	self assert: portfolio balance equals: 100.! !

!PortfolioTest methodsFor: 'tests' stamp: 'fz 10/20/2019 19:54:16'!
test06PortfolioBalanceReflectsAddedAccountUpdatedBalance

	| portfolio account|
	
	portfolio := Portfolio new.
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	
	portfolio manage: account.
	
	Deposit register: 100 on: account.
	
	self assert: portfolio balance equals: 200.! !

!PortfolioTest methodsFor: 'tests' stamp: 'fz 10/20/2019 21:24:46'!
test07portfolioKnowsTransactionsOfAddedAccounts

	|portfolio account deposit|
	portfolio := Portfolio new.	
	account := ReceptiveAccount new.
	
	portfolio manage: account.
	deposit := Deposit register: 100 on: account .
	
	self assert: portfolio transactions includes: deposit.
	self assert: portfolio transactions size equals: 1.! !

!PortfolioTest methodsFor: 'tests' stamp: 'fz 10/20/2019 19:35:29'!
test08transactionsNotInPortfolioAccountsAreNotRegistered

	| noRegisteredDeposit |
	
	noRegisteredDeposit := Deposit register: 50 on: notManagedAccount.
	
	self deny: (aPortfolio registers: noRegisteredDeposit).! !

!PortfolioTest methodsFor: 'tests' stamp: 'fz 10/20/2019 19:36:11'!
test09transactionsInPortfolioAccountsAreRegistered

	| deposit |
	
	deposit := Deposit register: 100 on: aManagedAccount.
	
	self assert: (aPortfolio registers: deposit).! !

!PortfolioTest methodsFor: 'tests' stamp: 'fz 10/20/2019 21:16:05'!
test10CannotAddDuplicateAccountsInPortfolio

	self should: [aPortfolio manage: aManagedAccount] 
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: Portfolio financialRecordAlreadyAddedErrorMessage.
				self assert: (aPortfolio manages: aManagedAccount)]! !

!PortfolioTest methodsFor: 'tests' stamp: 'fz 10/20/2019 19:54:16'!
test11CanAddAPortfolio

	| subPortfolio accountOfSubPortfolio |
	
	subPortfolio := Portfolio new.
	accountOfSubPortfolio := ReceptiveAccount new.
	
	subPortfolio manage: accountOfSubPortfolio.
	
	aPortfolio manage: subPortfolio.
	self assert: (aPortfolio manages: accountOfSubPortfolio).! !

!PortfolioTest methodsFor: 'tests' stamp: 'fz 10/20/2019 19:39:30'!
test12PortfolioBalanceReflectsAddedPortfolios

	Deposit register: 100 on: anAccountManagedBySubPortfolio. 
	
	self assert: aPortfolio balance equals: 100.! !

!PortfolioTest methodsFor: 'tests' stamp: 'fz 10/20/2019 21:16:05'!
test13CannotAddAPortfolioWithDuplicatedAccounts

	| portfolioWithRepitedAccount |

	portfolioWithRepitedAccount  := Portfolio new.
	
	portfolioWithRepitedAccount manage: aManagedAccount.
	
	self should: [aPortfolio manage: portfolioWithRepitedAccount] 
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: Portfolio financialRecordAlreadyAddedErrorMessage.
				self assert: (aPortfolio manages: aManagedAccount).
				self deny: (aPortfolio manages: portfolioWithRepitedAccount)]! !

!PortfolioTest methodsFor: 'tests' stamp: 'fz 10/20/2019 21:18:08'!
test14CannotAddADuplicatedPortfolio

	self should: [aPortfolio manage: aManagedSubPortfolio] 
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: Portfolio financialRecordAlreadyAddedErrorMessage.]! !

!PortfolioTest methodsFor: 'tests' stamp: 'fz 10/20/2019 21:18:12'!
test15PortfolioCannotAddItself

	self should: [aPortfolio manage: aPortfolio] 
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: Portfolio financialRecordAlreadyAddedErrorMessage.]! !

!PortfolioTest methodsFor: 'tests' stamp: 'fz 10/20/2019 21:25:40'!
test16PortfolioFailsInCasesWhereItNeedsToKnowItsParents

    | portfolioA portfolioB portfolioC |
    portfolioA := Portfolio new.
    portfolioB := Portfolio new.
    portfolioC := Portfolio new.

    portfolioA manage: portfolioB.
    portfolioA manage: portfolioC.
    
    self should: [portfolioC manage: portfolioB] 
        raise: Error - MessageNotUnderstood 
        withExceptionDo: [:anError | self assert: anError messageText equals: Portfolio financialRecordAlreadyAddedErrorMessage.
                        self deny: (portfolioC manages: portfolioB).]! !


!PortfolioTest methodsFor: 'setup' stamp: 'fz 10/20/2019 19:54:16'!
setUp
	anEmptyPortfolio := Portfolio new.
	
	aPortfolio := Portfolio new.	
	aManagedSubPortfolio  := Portfolio new.
	aManagedAccount := ReceptiveAccount new.
	
	anAccountManagedBySubPortfolio := ReceptiveAccount new.
	aManagedSubPortfolio manage: anAccountManagedBySubPortfolio.
	
	aPortfolio manage: aManagedAccount.
	aPortfolio manage: aManagedSubPortfolio.
	
	notManagedAccount := ReceptiveAccount new.! !


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

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'fz 10/20/2019 19:10:24'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account registers: deposit).
	self assert: (account registers: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'fz 10/20/2019 19:10:24'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100.
	withdraw := Withdraw for: 50.
		
	self deny: (account registers: deposit).
	self deny: (account registers:withdraw).
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

!FinancialRecord methodsFor: 'testing' stamp: 'MFD 10/21/2019 11:41:47'!
allHoldings
	^self subclassResponsibility.! !

!FinancialRecord methodsFor: 'testing' stamp: 'fz 10/20/2019 20:53:08'!
manages: aFinancialRecord 
	^self subclassResponsibility.! !

!FinancialRecord methodsFor: 'testing' stamp: 'fz 10/20/2019 19:10:24'!
registers: aTransaction
	^self subclassResponsibility.! !


!FinancialRecord methodsFor: 'balance' stamp: 'jy 10/17/2019 20:19:33'!
balance
	^self subclassResponsibility.! !


!FinancialRecord methodsFor: 'transactions' stamp: 'jy 10/17/2019 20:19:59'!
transactions
	^self subclassResponsibility.! !


!FinancialRecord methodsFor: 'roots management' stamp: 'MFD 10/21/2019 11:25:55'!
replaceOldRoot: oldRootPortfolio for: newRootPortfolios

	^ self subclassResponsibility.! !


!classDefinition: #Portfolio category: #'Portfolio-Ejercicio'!
FinancialRecord subclass: #Portfolio
	instanceVariableNames: 'children rootPortfolios'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'balance' stamp: 'fz 10/20/2019 19:49:09'!
balance
	^children sum: [:aFinancialRecord | aFinancialRecord balance] ifEmpty: [0].
	! !


!Portfolio methodsFor: 'initialization' stamp: 'MFD 10/21/2019 11:16:13'!
initialize
	children := Set new.
	rootPortfolios := Set with: self.! !


!Portfolio methodsFor: 'manage' stamp: 'MFD 10/21/2019 11:41:47'!
hasConflictsWith: aFinancialRecord 	
	(aFinancialRecord allHoldings anySatisfy: [:anAccount | self manages: anAccount]) ifTrue:[^true].
	
	^false.! !

!Portfolio methodsFor: 'manage' stamp: 'MFD 10/21/2019 11:22:26'!
manage: aFinancialRecord 	
	
	(rootPortfolios anySatisfy: [:aRootPortfolio | aRootPortfolio hasConflictsWith: aFinancialRecord]) ifTrue: [self error: self class financialRecordAlreadyAddedErrorMessage].
	
	children add: aFinancialRecord.
	aFinancialRecord replaceOldRoot: aFinancialRecord for: rootPortfolios.! !


!Portfolio methodsFor: 'testing' stamp: 'MFD 10/21/2019 11:42:16'!
allHoldings
	
	| holdings |
	holdings := Set with: self.
	^ children inject: holdings into: [:theAccounts :aFinancialRecord | theAccounts addAll: aFinancialRecord allHoldings]. ! !

!Portfolio methodsFor: 'testing' stamp: 'fz 10/20/2019 19:49:09'!
manages: aFinancialRecord 
	^(children anySatisfy: [:aHoldee | aHoldee manages: aFinancialRecord]) or:[aFinancialRecord = self]! !

!Portfolio methodsFor: 'testing' stamp: 'fz 10/20/2019 19:49:09'!
registers: aTransaction
	^ children anySatisfy: [:aFinancialRecord | aFinancialRecord registers: aTransaction].! !


!Portfolio methodsFor: 'transactions' stamp: 'fz 10/20/2019 21:22:46'!
transactions
	
	^children inject: Set new into: [:aTransactionsSet :aChild| aTransactionsSet addAll: aChild transactions].
	
	! !


!Portfolio methodsFor: 'roots management' stamp: 'MFD 10/21/2019 11:26:59'!
replaceOldRoot: oldRootPortfolio for: newRootPortfolios
	
	rootPortfolios remove: oldRootPortfolio ifAbsent: [].
	rootPortfolios addAll: newRootPortfolios.
	
	children do: [:aChild | aChild replaceOldRoot: oldRootPortfolio for: newRootPortfolios.]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: #'Portfolio-Ejercicio'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'error message' stamp: 'fz 10/20/2019 21:16:18'!
financialRecordAlreadyAddedErrorMessage
	^'el registro financiero ya fue agregado'! !


!classDefinition: #ReceptiveAccount category: #'Portfolio-Ejercicio'!
FinancialRecord subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccount methodsFor: 'balance' stamp: 'jy 10/17/2019 19:39:31'!
balance
	^transactions inject: 0 into: [:aBalance :aTransaction| aTransaction updateBalance: aBalance].
! !


!ReceptiveAccount methodsFor: 'initialization' stamp: 'NR 10/17/2019 15:06:56'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'MFD 10/21/2019 11:41:47'!
allHoldings
	^Set with: self.! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'fz 10/20/2019 19:41:41'!
manages: aFinancialRecord 
	^aFinancialRecord = self! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'fz 10/20/2019 19:10:24'!
registers: aTransaction

	^ transactions includes: aTransaction 
! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'roots management' stamp: 'MFD 10/21/2019 11:26:14'!
replaceOldRoot: oldRootPortfolio for: newRootPortfolios

	^self.! !
