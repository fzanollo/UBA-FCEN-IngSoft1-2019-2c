!classDefinition: #PortfolioTest category: #'Portfolio-Solucion'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:16:26'!
test01BalanceOfPortfolioWithoutAccountsIsZero

	self assert: 0 equals: Portfolio new balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:17:51'!
test02BalanceOfPortfolioWithOneAccountIsAccountBalance

	| account portfolio |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: account balance equals: portfolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:23:25'!
test03BalanceOfPortfolioIsCalculatedRecursivelyOnPortfolios

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortofolio |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	Withdraw register: 50 on: composedPortfolioAccount.
	composedPortofolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolioAccount balance + simplePortfolio balance) equals: composedPortofolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:15'!
test04PortfolioWithoutAccountsHasNoRegisteredTransaction

	self deny: (Portfolio new hasRegistered: (Deposit for: 100))! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:11'!
test05PortfolioHasRegisteredItsAccountsTransactions

	| account portfolio deposit |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: (portfolio hasRegistered: deposit)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:06'!
test06PortfolioLooksForRegisteredTransactionsRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolio hasRegistered: simplePortfolioAccountDeposit).
	self assert: (composedPortfolio hasRegistered: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:10'!
test07PortfolioHasNoTransactionWhenHasNoAccounts

	self assert: Portfolio new transactions isEmpty! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:15'!
test08PortfolioTransasctionsIncludesAllItsAccountsTransactions

	| account portfolio accountDeposit anotherAccount portfolioTransactions anotherAccountWithdraw |
	
	account := ReceptiveAccount new.
	accountDeposit := Deposit register: 100 on: account.
	anotherAccount := ReceptiveAccount new.
	anotherAccountWithdraw := Withdraw register: 100 on: account.
	portfolio := Portfolio with: account.
	
	portfolioTransactions := portfolio transactions.
	
	self assert: 2 equals: portfolioTransactions size.
	self assert: (portfolioTransactions includes: accountDeposit).
	self assert: (portfolioTransactions includes: anotherAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:20'!
test09PortfolioTransactionsAreCalculatedRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit composedPortfolioTransactions |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	composedPortfolioTransactions := composedPortfolio transactions.
	self assert: 2 equals: composedPortfolioTransactions size.
	self assert: (composedPortfolioTransactions includes: simplePortfolioAccountDeposit).
	self assert: (composedPortfolioTransactions includes: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:24'!
test10PortfolioCanNotIncludeTheSameAccountMoreThanOnce

	| account portfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio with: account.
	
	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: portfolio accountsSize.
			self assert: (portfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:28'!
test11PortfolioCanNotIncludeAccountOfItsPortfolios

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	composedPortfolio := Portfolio with: simplePortfolio.
	
	self 
		should: [ composedPortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: composedPortfolio accountsSize.
			self assert: (composedPortfolio accountsIncludes: simplePortfolio) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:32'!
test12PortfolioCanNotIncludeItself

	| account simplePortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	
	self 
		should: [ simplePortfolio add: simplePortfolio ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: simplePortfolio accountsSize.
			self assert: (simplePortfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:01:51'!
test13ComposedPortfolioCanNotHaveParentPortfolioAccount

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio new.
	composedPortfolio := Portfolio with: simplePortfolio.
	composedPortfolio add: account.
	
	self 
		should: [ simplePortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: simplePortfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:12:16'!
test14ComposedPortfolioCanNotHaveAccountOfAnyRootParentRecursively

	| account leftParentPortfolio leftRootParentPortfolio portfolio rightParentPortfolio rightRootParentPortfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio new.
	leftParentPortfolio := Portfolio with: portfolio .
	leftRootParentPortfolio := Portfolio with: leftParentPortfolio.
	leftRootParentPortfolio add: account.
	
	rightParentPortfolio := Portfolio with: portfolio .
	rightRootParentPortfolio := Portfolio with: rightParentPortfolio.
	rightRootParentPortfolio add: account.

	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/29/2019 16:31:18'!
test15PortfolioCanNotIncludeAnyOfTheComposedAccountOfPortfolioToAdd

	| portfolioToAdd portfolioToModify rootPortfolio sharedAccount |
	
	sharedAccount := ReceptiveAccount new.
	portfolioToModify := Portfolio new.
	rootPortfolio := Portfolio with: sharedAccount with: portfolioToModify.
	portfolioToAdd := Portfolio with: sharedAccount.
	
	self 
		should: [ portfolioToModify add: portfolioToAdd ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolioToModify accountsIsEmpty ]! !


!classDefinition: #ReceptiveAccountTest category: #'Portfolio-Solucion'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

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


!classDefinition: #ReportTest category: #'Portfolio-Solucion'!
TestCase subclass: #ReportTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReportTest methodsFor: 'tests' stamp: 'jy 10/21/2019 21:15:46'!
test01AccountSummaryOfEmptyAccountIsCorrect

	|anAccount summaryReport|
	
	anAccount := ReceptiveAccount new.
	
	summaryReport := SummaryReport of: anAccount.
	self assert: summaryReport showReport equals: 'Balance = 0'.	! !

!ReportTest methodsFor: 'tests' stamp: 'jy 10/21/2019 21:18:50'!
test02AccountSummaryOfReceptiveAccountReflectsDeposit

	|anAccount summaryReport |
	
	anAccount := ReceptiveAccount new.
	Deposit register: 100 on: anAccount .
	
	summaryReport := SummaryReport of: anAccount.
	self assert: summaryReport showReport equals: 'Depósito por 100. Balance = 100'.	! !

!ReportTest methodsFor: 'tests' stamp: 'jy 10/21/2019 21:19:05'!
test03AccountSummaryOfReceptiveAccountReflectsWithdrawal

	|anAccount summaryReport |
	
	anAccount := ReceptiveAccount new.
	Withdraw register: 100 on: anAccount .
	
	summaryReport := SummaryReport of: anAccount.
	self assert: summaryReport showReport equals: 'Extracción por 100. Balance = -100'.	! !

!ReportTest methodsFor: 'tests' stamp: 'jy 10/21/2019 21:20:21'!
test04AccountSummaryOfReceptiveAccountReflectsTransfers

	|emisorAccount receptorAccount emisorReport receptorReport|
	
	emisorAccount := ReceptiveAccount new.
	receptorAccount := ReceptiveAccount new.
	Transfer from: emisorAccount to: receptorAccount ammount: 100.
	
	emisorReport := SummaryReport of: emisorAccount.
	receptorReport := SummaryReport of: receptorAccount.
	
	self assert: emisorReport showReport equals: 'Salida por transferencia de 100. Balance = -100'.
	self assert: receptorReport showReport equals: 'Entrada por transferencia de 100. Balance = 100'.	! !

!ReportTest methodsFor: 'tests' stamp: 'jy 10/21/2019 21:21:41'!
test05AccountSummaryOfReceptiveAccountReflectsWholeHistory

	|anAccount anotherAccount anAccountReport anotherAccountReport |
	
	anAccount := ReceptiveAccount new.
	anotherAccount := ReceptiveAccount new.
	Transfer from: anAccount to: anotherAccount ammount: 100.
	
	Deposit register: 50 on: anotherAccount.
	Withdraw register: 130 on: anotherAccount.
	
	Transfer from: anotherAccount to: anAccount ammount: 50.
	
	anAccountReport := SummaryReport of: anAccount.
	anotherAccountReport := SummaryReport of: anotherAccount.
	
	self assert: anAccountReport showReport equals: 'Salida por transferencia de 100. Entrada por transferencia de 50. Balance = -50'.	
	self assert: anotherAccountReport showReport equals: 'Entrada por transferencia de 100. Depósito por 50. Extracción por 130. Salida por transferencia de 50. Balance = -30'.! !


!classDefinition: #TransferTest category: #'Portfolio-Solucion'!
TestCase subclass: #TransferTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferTest methodsFor: 'tests' stamp: 'jy 10/21/2019 19:42:39'!
test01transfersAreRegistered
	|transfer emisorAccount receptorAccount|
	
	emisorAccount := ReceptiveAccount new.
	receptorAccount := ReceptiveAccount new.
	
	transfer := Transfer from: emisorAccount to: receptorAccount ammount: 100.
	
	self assert: (emisorAccount hasRegistered: transfer outTransaction).
	self assert: (receptorAccount hasRegistered: transfer inTransaction).! !

!TransferTest methodsFor: 'tests' stamp: 'jy 10/21/2019 19:29:25'!
test02transfersAreReflectedOnBalance
	|emisorAccount receptorAccount|
	
	emisorAccount := ReceptiveAccount new.
	receptorAccount := ReceptiveAccount new.
	
	Transfer from: emisorAccount to: receptorAccount ammount: 100.
	
	self assert: emisorAccount balance equals: -100.
	self assert: receptorAccount balance equals: 100.! !

!TransferTest methodsFor: 'tests' stamp: 'jy 10/21/2019 19:54:35'!
test03CannotTransferANegativeAmmount
	|emisorAccount receptorAccount|
	
	emisorAccount := ReceptiveAccount new.
	receptorAccount := ReceptiveAccount new.
	
	self should: [Transfer from: emisorAccount to: receptorAccount ammount: -100.] 
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: Transfer canOnlyTransferPositiveAmmountsErrorMessage equals: anError messageText.]! !

!TransferTest methodsFor: 'tests' stamp: 'jy 10/21/2019 19:56:47'!
test04CannotTransferWithZeroAmmount
	|emisorAccount receptorAccount|
	
	emisorAccount := ReceptiveAccount new.
	receptorAccount := ReceptiveAccount new.
	
	self should: [Transfer from: emisorAccount to: receptorAccount ammount: 0.] 
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: Transfer canOnlyTransferPositiveAmmountsErrorMessage equals: anError messageText.]! !

!TransferTest methodsFor: 'tests' stamp: 'jy 10/21/2019 20:23:22'!
test05CannotTransferToItself
	|onlyAccount |
	
	onlyAccount := ReceptiveAccount new.
	
	self should: [Transfer from: onlyAccount to: onlyAccount ammount: 100.] 
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: Transfer cannotTransferToSameAccountErrorMessage equals: anError messageText.]! !


!classDefinition: #Account category: #'Portfolio-Solucion'!
Object subclass: #Account
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:23:47'!
hasRegistered: aTransaction

	self subclassResponsibility ! !

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:24:25'!
isComposedBy: anAccount

	self subclassResponsibility ! !


!Account methodsFor: 'balance' stamp: 'HAW 5/25/2019 12:23:40'!
balance

	self subclassResponsibility ! !


!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:27'!
addTransactionsTo: aCollectionOfTransactions

	self subclassResponsibility ! !

!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:15'!
transactions

	self subclassResponsibility ! !


!Account methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:24:04'!
addedTo: aPortfolio

	self subclassResponsibility ! !


!classDefinition: #Portfolio category: #'Portfolio-Solucion'!
Account subclass: #Portfolio
	instanceVariableNames: 'accounts parents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:20'!
accountsIncludes: anAccount

	^accounts includes: anAccount ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:05:04'!
accountsIsEmpty
	
	^accounts isEmpty ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:06'!
accountsSize
	
	^accounts size! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:19:20'!
add: accountToAdd

	self assertCanAdd: accountToAdd.
		
	accounts add: accountToAdd.
	accountToAdd addedTo: self 
	! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:17:31'!
rootParents
	
	| rootParents |
	
	rootParents := Set new.
	self addRootParentsTo: rootParents.
	
	^ rootParents! !


!Portfolio methodsFor: 'initialization' stamp: 'HAW 5/25/2019 12:03:18'!
initialize

	accounts := OrderedCollection new.
	parents := OrderedCollection new.! !


!Portfolio methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:19:36'!
balance
	
	^accounts sum: [ :anAccount | anAccount balance ] ifEmpty: [ 0 ]! !


!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:42:55'!
addTransactionsTo: aCollectionOfTransactions

	accounts do: [ :anAccount | anAccount addTransactionsTo: aCollectionOfTransactions ]! !

!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:32'!
transactions
	
	| transactions |
	
	transactions := OrderedCollection new.
	accounts do: [ :anAccount | anAccount addTransactionsTo: transactions ].
	
	^transactions ! !


!Portfolio methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:02:59'!
addedTo: aPortfolio 
	
	parents add: aPortfolio ! !


!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:20:56'!
anyRootParentIsComposedBy: accountToAdd

	^self rootParents anySatisfy: [ :aParent | aParent isComposedBy: accountToAdd]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:28:29'!
hasRegistered: aTransaction

	^accounts anySatisfy: [ :anAccount | anAccount hasRegistered: aTransaction ]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/29/2019 16:24:54'!
isComposedBy: anAccount

	^ self = anAccount or: [ accounts anySatisfy: [ :composedAccount | (composedAccount isComposedBy: anAccount) or: [ anAccount isComposedBy: composedAccount ]]]! !


!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:17:31'!
addRootParentsTo: rootParents

	parents 
		ifEmpty: [ rootParents add: self ] 
		ifNotEmpty: [ parents do: [ :aParent | aParent addRootParentsTo: rootParents ]]! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:20:36'!
assertCanAdd: accountToAdd

	(self anyRootParentIsComposedBy: accountToAdd) ifTrue: [ self signalCanNotAddAccount ].
! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 11:48:34'!
signalCanNotAddAccount
	
	self error: self class canNotAddAccountErrorMessage! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: #'Portfolio-Solucion'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:48:55'!
canNotAddAccountErrorMessage
	
	^'Can not add repeated account to a portfolio'! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:18:21'!
with: anAccount

	^self new 
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:23:59'!
with: anAccount with: anotherAccount

	^self new 
		add: anAccount;
		add: anotherAccount;
		yourself! !


!classDefinition: #ReceptiveAccount category: #'Portfolio-Solucion'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:35'!
initialize

	super initialize.
	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:52'!
addTransactionsTo: aCollectionOfTransactions

	aCollectionOfTransactions addAll: transactions ! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:24:46'!
balance

	^transactions 
		inject: 0
		into: [ :currentBalance :transaction | transaction affectBalance: currentBalance ]! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/21/2019 18:55:56'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:54:51'!
isComposedBy: anAccount

	^self = anAccount ! !


!ReceptiveAccount methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:03:32'!
addedTo: aPortfolio 
	
	! !


!classDefinition: #AccountTransaction category: #'Portfolio-Solucion'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:39'!
affectBalance: aBalance

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: #'Portfolio-Solucion'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/21/2019 18:54:27'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: #'Portfolio-Solucion'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Deposit methodsFor: 'initialization' stamp: 'jy 10/21/2019 20:05:27'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:02'!
affectBalance: aBalance

	^aBalance + value ! !


!Deposit methodsFor: 'reports' stamp: 'jy 10/21/2019 21:02:20'!
summaryReport
	^'Depósito por ',value asString ,'.'.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: #'Portfolio-Solucion'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'jy 10/21/2019 20:05:27'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #TransferLeg category: #'Portfolio-Solucion'!
AccountTransaction subclass: #TransferLeg
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!


!classDefinition: #TransferDeposit category: #'Portfolio-Solucion'!
TransferLeg subclass: #TransferDeposit
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferDeposit methodsFor: 'initialization' stamp: 'jy 10/21/2019 20:18:56'!
initializeOf: aTransfer 
	transfer := aTransfer.! !


!TransferDeposit methodsFor: 'as yet unclassified' stamp: 'jy 10/21/2019 20:19:19'!
affectBalance: anAmmount 
	^anAmmount + transfer value! !

!TransferDeposit methodsFor: 'as yet unclassified' stamp: 'jy 10/21/2019 20:19:53'!
value
	^transfer value! !


!TransferDeposit methodsFor: 'reports' stamp: 'jy 10/21/2019 21:08:48'!
summaryReport
	^'Entrada por transferencia de ',self value asString ,'.'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferDeposit class' category: #'Portfolio-Solucion'!
TransferDeposit class
	instanceVariableNames: ''!

!TransferDeposit class methodsFor: 'instance creation' stamp: 'jy 10/21/2019 20:05:10'!
of: aTransfer
	^self new initializeOf: aTransfer.! !


!classDefinition: #TransferWithdraw category: #'Portfolio-Solucion'!
TransferLeg subclass: #TransferWithdraw
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferWithdraw methodsFor: 'initialization' stamp: 'jy 10/21/2019 20:18:46'!
initializeOf: aTransfer 
	transfer := aTransfer.! !


!TransferWithdraw methodsFor: 'as yet unclassified' stamp: 'jy 10/21/2019 20:19:27'!
affectBalance: anAmmount 
	^anAmmount - transfer value! !

!TransferWithdraw methodsFor: 'as yet unclassified' stamp: 'jy 10/21/2019 20:19:58'!
value
	^transfer value! !


!TransferWithdraw methodsFor: 'reports' stamp: 'jy 10/21/2019 21:08:17'!
summaryReport
	^'Salida por transferencia de ', self value asString,'.'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferWithdraw class' category: #'Portfolio-Solucion'!
TransferWithdraw class
	instanceVariableNames: ''!

!TransferWithdraw class methodsFor: 'instance creation' stamp: 'jy 10/21/2019 20:05:10'!
for: anAmmount
	^self new initializeOf: anAmmount ! !


!TransferWithdraw class methodsFor: 'as yet unclassified' stamp: 'jy 10/21/2019 20:21:18'!
of: aTransfer
	^self new initializeOf: aTransfer.! !


!classDefinition: #Withdraw category: #'Portfolio-Solucion'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Withdraw methodsFor: 'initialization' stamp: 'jy 10/21/2019 20:05:41'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !


!Withdraw methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:15'!
affectBalance: aBalance

	^aBalance - value! !


!Withdraw methodsFor: 'reports' stamp: 'jy 10/21/2019 21:04:58'!
summaryReport
	^'Extracción por ', value asString , '.'.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: #'Portfolio-Solucion'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'jy 10/21/2019 20:05:41'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Report category: #'Portfolio-Solucion'!
Object subclass: #Report
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!


!classDefinition: #SummaryReport category: #'Portfolio-Solucion'!
Report subclass: #SummaryReport
	instanceVariableNames: 'account'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!SummaryReport methodsFor: 'initialization' stamp: 'jy 10/21/2019 21:16:35'!
initializeOf: aReceptiveAccount 
	account := aReceptiveAccount.! !


!SummaryReport methodsFor: 'report' stamp: 'MD 10/24/2019 17:21:32'!
showReport
	|report|
	
	report := ''.
	account transactions do: [:aTransaction | report := report, (aTransaction summaryReport), ' '].
	report := report,'Balance = ', account balance asString .
	
	^report.
	
	"To do: cambiar [aTransaction summaryReport] por algo como aTransaction showOn: self y bla, double dispatch"
	"poner el report como variable de instancia, como haciamos en el method object"
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SummaryReport class' category: #'Portfolio-Solucion'!
SummaryReport class
	instanceVariableNames: ''!

!SummaryReport class methodsFor: 'instance creation' stamp: 'jy 10/21/2019 21:16:17'!
of: aReceptiveAccount 
	^self new initializeOf: aReceptiveAccount ! !


!classDefinition: #Transfer category: #'Portfolio-Solucion'!
Object subclass: #Transfer
	instanceVariableNames: 'transferIn transferOut value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Transfer methodsFor: 'initialization' stamp: 'jy 10/21/2019 20:15:17'!
initializeFrom: emisorAccount to: receptorAccount ammount: anAmmount
	
	transferOut := TransferWithdraw of: self.
	emisorAccount register: transferOut.
	
	transferIn := TransferDeposit of: self.
	receptorAccount register: transferIn.
	
	value := anAmmount.! !


!Transfer methodsFor: 'as yet unclassified' stamp: 'jy 10/21/2019 19:46:11'!
inTransaction
	^transferIn ! !

!Transfer methodsFor: 'as yet unclassified' stamp: 'jy 10/21/2019 19:44:57'!
outTransaction
	^transferOut ! !

!Transfer methodsFor: 'as yet unclassified' stamp: 'jy 10/21/2019 20:21:42'!
value
	^value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transfer class' category: #'Portfolio-Solucion'!
Transfer class
	instanceVariableNames: ''!

!Transfer class methodsFor: 'instance creation' stamp: 'jy 10/21/2019 20:35:18'!
from: emisorAccount to: receptorAccount ammount: anAmmount
	anAmmount <= 0 ifTrue:[self error: self canOnlyTransferPositiveAmmountsErrorMessage].
	emisorAccount = receptorAccount ifTrue: [self error: self cannotTransferToSameAccountErrorMessage ].
	
	^self new initializeFrom: emisorAccount to: receptorAccount ammount: anAmmount.! !


!Transfer class methodsFor: 'error messages' stamp: 'jy 10/21/2019 19:56:14'!
canOnlyTransferPositiveAmmountsErrorMessage
	^'solo se pueden transferir cantidades positivas!!'! !

!Transfer class methodsFor: 'error messages' stamp: 'jy 10/21/2019 20:23:47'!
cannotTransferToSameAccountErrorMessage
	^'no se puede hacer una transferencia a la misma cuenta'! !
