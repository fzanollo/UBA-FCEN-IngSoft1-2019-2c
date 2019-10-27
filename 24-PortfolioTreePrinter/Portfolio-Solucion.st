!classDefinition: #AllTest category: #'Portfolio-Solucion'!
TestCase subclass: #AllTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!
!AllTest commentStamp: '<historical>' prior: 0!
Esta clase es solo para ordenar visualmente la lista de clases!



!classDefinition: #AccountsReportTest category: #'Portfolio-Solucion'!
AllTest subclass: #AccountsReportTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountsReportTest methodsFor: 'tests' stamp: 'MD 10/27/2019 20:02:02'!
test01StructureOfAnEmptyPortfolioIsOnlyItsName
	|portfolio structureReport|
	
	portfolio := Portfolio named: 'Portfolio solito'.
	
	structureReport := TreeStructureReport of: portfolio.
	
	self assert: structureReport showReport equals: portfolio accountName! !

!AccountsReportTest methodsFor: 'tests' stamp: 'MD 10/27/2019 20:02:02'!
test02AccountsInsidePortfolioAreShowed
	|portfolio account structureReport|
	
	portfolio := Portfolio named: 'Portfolio solito'.
	account := ReceptiveAccount named:'una cuenta de adentro'.
	portfolio add: account.
	
	structureReport := TreeStructureReport of: portfolio.
	
	self assert: structureReport showReport equals: (portfolio accountName, String newLineString, '    ', account accountName).! !

!AccountsReportTest methodsFor: 'tests' stamp: 'MD 10/27/2019 20:02:02'!
test03StructureReportReflectsStructureDeepness
	|rootPortfolio account structureReport subPortfolio expectedReport actualReport |
	
	rootPortfolio := Portfolio named: 'Portfolio raiz'.
	subPortfolio := Portfolio named: 'Sub portfolio'.
	account := ReceptiveAccount named: 'Cuenta de nivel dos'.
	
	rootPortfolio add: subPortfolio.
	subPortfolio add: account.
	
	structureReport := TreeStructureReport of: rootPortfolio.
	
	expectedReport := rootPortfolio accountName, String newLineString, '    ', subPortfolio accountName, String newLineString, '        ', account accountName.
	actualReport := structureReport showReport.
	
	self assert: actualReport equals: expectedReport.! !

!AccountsReportTest methodsFor: 'tests' stamp: 'MD 10/27/2019 20:02:02'!
test04StructureReportWorksWithMultipleLevelsWithMultipleAccounts
	"Portfolio de la familia
	   Cuenta Mia
	   Portfolio de hijos
	      Cuenta de Juan
	      Cuenta de Angeles
	      Potfolio de hijos menores
		 Cuenta de Martin"
	
	|portfolioDeLaFamilia cuentaMia structureReport portfolioDeHijos cuentaDeJuan cuentaDeAngeles portfolioDeHijosMenores cuentaDeMartin expectedReport actualReport |
	
	portfolioDeLaFamilia := Portfolio named: 'Portfolio de la familia'.
	portfolioDeHijos := Portfolio named: 'Portfolio de hijos'.
	cuentaMia := ReceptiveAccount named: 'Cuenta Mia'.
	cuentaDeJuan := ReceptiveAccount named: 'Cuenta de Juan'.
	cuentaDeAngeles := ReceptiveAccount named: 'Cuenta de Angeles'.
	portfolioDeHijosMenores := Portfolio named: 'Portfolio de hijos menores'.
	cuentaDeMartin := ReceptiveAccount named: 'Cuenta de Martin'.
	
	portfolioDeLaFamilia add: cuentaMia.
	portfolioDeLaFamilia add: portfolioDeHijos.
	portfolioDeHijos add: cuentaDeJuan.
	portfolioDeHijos add: cuentaDeAngeles.
	portfolioDeHijos add: portfolioDeHijosMenores.
	portfolioDeHijosMenores add: cuentaDeMartin.
	
	structureReport := TreeStructureReport of: portfolioDeLaFamilia.
	
	expectedReport := portfolioDeLaFamilia accountName, String newLineString, '    ', cuentaMia accountName, String newLineString, '    ', portfolioDeHijos accountName,  String newLineString, '        ', cuentaDeJuan accountName, String newLineString, '        ', cuentaDeAngeles accountName , String newLineString, '        ', portfolioDeHijosMenores accountName , String newLineString, '            ', cuentaDeMartin accountName .
	
	actualReport := structureReport showReport.
	
	self assert: actualReport equals: expectedReport.! !

!AccountsReportTest methodsFor: 'tests' stamp: 'MD 10/27/2019 20:02:49'!
test05StructureReportOfReceptiveAccountShowsItsName
	|account structureReport report |
	
	account := ReceptiveAccount named:'una cuentita'.
	
	structureReport := TreeStructureReport of: account.
	report := structureReport showReport.
	
	self assert: report equals: account accountName.! !

!AccountsReportTest methodsFor: 'tests' stamp: 'MD 10/27/2019 20:14:49'!
test06SpecialSummaryReportOfReceptiveAccountShowsItsNameAndItsSummary
	|account specialSummaryReport report predictedReport |
	
	account := ReceptiveAccount named:'una cuentita'.
	Deposit register: 100 on: account.
	Withdraw register: 20 on: account.
	
	specialSummaryReport := SpecialSummaryReport of: account.
	report := specialSummaryReport showReport.
	predictedReport := account accountName, String newLineString, '    ','Depósito por 100.',String newLineString, '    ', 'Extracción por 20.'.
	
	self assert: report equals: predictedReport.! !


!classDefinition: #PortfolioTest category: #'Portfolio-Solucion'!
AllTest subclass: #PortfolioTest
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
AllTest subclass: #ReceptiveAccountTest
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


!classDefinition: #TransactionsReportTest category: #'Portfolio-Solucion'!
AllTest subclass: #TransactionsReportTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransactionsReportTest methodsFor: 'tests' stamp: 'jy 10/21/2019 21:15:46'!
test01AccountSummaryOfEmptyAccountIsCorrect

	|anAccount summaryReport|
	
	anAccount := ReceptiveAccount new.
	
	summaryReport := SummaryReport of: anAccount.
	self assert: summaryReport showReport equals: 'Balance = 0'.	! !

!TransactionsReportTest methodsFor: 'tests' stamp: 'fz 10/27/2019 16:05:14'!
test02AccountSummaryOfReceptiveAccountReflectsDeposit

	|anAccount summaryReport report|
	
	report := String newLineString join: #('Depósito por 100.' 'Balance = 100').
	
	anAccount := ReceptiveAccount new.
	Deposit register: 100 on: anAccount .
	
	summaryReport := SummaryReport of: anAccount.
	self assert: summaryReport showReport equals: report.! !

!TransactionsReportTest methodsFor: 'tests' stamp: 'fz 10/27/2019 16:05:39'!
test03AccountSummaryOfReceptiveAccountReflectsWithdrawal

	|anAccount summaryReport report|
	
	report := String newLineString join: #('Extracción por 100.' 'Balance = -100').
	
	anAccount := ReceptiveAccount new.
	Withdraw register: 100 on: anAccount .
	
	summaryReport := SummaryReport of: anAccount.
	self assert: summaryReport showReport equals: report.! !

!TransactionsReportTest methodsFor: 'tests' stamp: 'fz 10/27/2019 16:06:35'!
test04AccountSummaryOfReceptiveAccountReflectsTransfers

	|emisorAccount receptorAccount emisorReport receptorReport|
	
	emisorAccount := ReceptiveAccount new.
	receptorAccount := ReceptiveAccount new.
	Transfer from: emisorAccount to: receptorAccount ammount: 100.
	
	emisorReport := SummaryReport of: emisorAccount.
	receptorReport := SummaryReport of: receptorAccount.
	
	self assert: emisorReport showReport equals: (String newLineString join: #('Salida por transferencia de 100.' 'Balance = -100')).
	self assert: receptorReport showReport equals: (String newLineString join: #('Entrada por transferencia de 100.' 'Balance = 100')).! !

!TransactionsReportTest methodsFor: 'tests' stamp: 'MD 10/27/2019 19:22:20'!
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
	
	self assert: anAccountReport showReport equals: (String newLineString join: #('Salida por transferencia de 100.' 'Entrada por transferencia de 50.' 'Balance = -50')).
	self assert: anotherAccountReport showReport equals: (String newLineString join: #('Entrada por transferencia de 100.' 'Depósito por 50.' 'Extracción por 130.' 'Salida por transferencia de 50.' 'Balance = -30')).! !

!TransactionsReportTest methodsFor: 'tests' stamp: 'fz 10/27/2019 16:10:32'!
test06TransferNetReportOfAccountWithNoTransfersIsZero
	|anAccount transferNetReport|
	
	anAccount := ReceptiveAccount new.
	transferNetReport := TransferNetReport of: anAccount.
	
	self assert: transferNetReport showReport equals: 0.! !

!TransactionsReportTest methodsFor: 'tests' stamp: 'fz 10/27/2019 16:52:36'!
test07TransferNetReportIsNegativeForOutgoingTransferAndPositiveForIncoming
	|emisorAccount receptorAccount emisorReport receptorReport|
	
	emisorAccount := ReceptiveAccount new.
	receptorAccount := ReceptiveAccount new.
	
	Transfer from: emisorAccount to: receptorAccount ammount: 50.
	Transfer from: emisorAccount to: receptorAccount ammount: 50.	
	
	emisorReport := TransferNetReport of: emisorAccount.
	receptorReport := TransferNetReport of: receptorAccount.
	
	self assert: emisorReport showReport equals: -100.
	self assert: receptorReport showReport equals: 100.! !

!TransactionsReportTest methodsFor: 'tests' stamp: 'fz 10/27/2019 16:26:54'!
test08TransferNetReportDoesNotLookForDepositsNorWithdrawals
	|emisorAccount receptorAccount emisorReport receptorReport|
	
	emisorAccount := ReceptiveAccount new.
	receptorAccount := ReceptiveAccount new.
	
	Deposit register: 100 on: emisorAccount.
	Withdraw register: 50 on: receptorAccount.
	
	Transfer from: emisorAccount to: receptorAccount ammount: 100.
	
	emisorReport := TransferNetReport of: emisorAccount.
	receptorReport := TransferNetReport of: receptorAccount.
	
	self assert: emisorReport showReport equals: -100.
	self assert: receptorReport showReport equals: 100.! !

!TransactionsReportTest methodsFor: 'tests' stamp: 'MD 10/27/2019 19:31:01'!
test09AccountSummaryWorksForPortfolios

	|aPortfolio anAccount anotherPortfolio anotherAccount aPortfolioReport anotherPortfolioReport |
	
	aPortfolio := Portfolio new.
	anotherPortfolio := Portfolio new.
	anAccount := ReceptiveAccount new.
	anotherAccount := ReceptiveAccount new.
	aPortfolio add: anAccount.
	anotherPortfolio add: anotherAccount.
	
	Transfer from: anAccount to: anotherAccount ammount: 100.
	
	Deposit register: 50 on: anotherAccount .
	Withdraw register: 130 on: anotherAccount .
	
	Transfer from: anotherAccount to: anAccount ammount: 50.
	
	aPortfolioReport := SummaryReport of: aPortfolio.
	anotherPortfolioReport := SummaryReport of: anotherPortfolio.
	
	self assert: aPortfolioReport showReport equals: (String newLineString join: #('Salida por transferencia de 100.' 'Entrada por transferencia de 50.' 'Balance = -50')).
	self assert: anotherPortfolioReport showReport equals: (String newLineString join: #('Entrada por transferencia de 100.' 'Depósito por 50.' 'Extracción por 130.' 'Salida por transferencia de 50.' 'Balance = -30')).! !

!TransactionsReportTest methodsFor: 'tests' stamp: 'MD 10/27/2019 19:33:06'!
test10TransferNetWorksForPortfolios

	|aPortfolio anAccount anotherPortfolio anotherAccount aPortfolioReport anotherPortfolioReport |
	
	aPortfolio := Portfolio new.
	anotherPortfolio := Portfolio new.
	anAccount := ReceptiveAccount new.
	anotherAccount := ReceptiveAccount new.
	aPortfolio add: anAccount.
	anotherPortfolio add: anotherAccount.
	
	Transfer from: anAccount to: anotherAccount ammount: 100.
	
	Deposit register: 50 on: anotherAccount .
	Withdraw register: 130 on: anotherAccount .
	
	Transfer from: anotherAccount to: anAccount ammount: 50.
	
	aPortfolioReport := TransferNetReport of: aPortfolio.
	anotherPortfolioReport := TransferNetReport of: anotherPortfolio.
	
	self assert: aPortfolioReport showReport equals: -50.
	self assert: anotherPortfolioReport showReport equals: 50.! !


!classDefinition: #TransferTest category: #'Portfolio-Solucion'!
AllTest subclass: #TransferTest
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
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Account methodsFor: 'testing' stamp: 'MD 10/27/2019 18:50:16'!
accountName
	^name! !

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

!Account methodsFor: 'transactions' stamp: 'fz 10/27/2019 18:36:07'!
executeOnAllTransactions: aBlockToExecute
	^ self subclassResponsibility ! !

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

!Portfolio methodsFor: 'accounts management' stamp: 'fz 10/27/2019 18:18:47'!
executeOnAllAccounts: aBlockToExecute
	^ accounts do: aBlockToExecute! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:17:31'!
rootParents
	
	| rootParents |
	
	rootParents := Set new.
	self addRootParentsTo: rootParents.
	
	^ rootParents! !


!Portfolio methodsFor: 'initialization' stamp: 'MD 10/27/2019 19:57:11'!
initialize

	accounts := OrderedCollection new.
	parents := OrderedCollection new.
	name := 'default name'.! !

!Portfolio methodsFor: 'initialization' stamp: 'fz 10/27/2019 17:25:29'!
initializeNamed: aName
	name := aName! !


!Portfolio methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:19:36'!
balance
	
	^accounts sum: [ :anAccount | anAccount balance ] ifEmpty: [ 0 ]! !


!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:42:55'!
addTransactionsTo: aCollectionOfTransactions

	accounts do: [ :anAccount | anAccount addTransactionsTo: aCollectionOfTransactions ]! !

!Portfolio methodsFor: 'transactions' stamp: 'fz 10/27/2019 18:35:54'!
executeOnAllTransactions: aBlockToExecute
	^ self transactions do: aBlockToExecute! !

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


!Portfolio methodsFor: 'reports' stamp: 'fz 10/27/2019 18:31:44'!
showOn: aReport 
	aReport showPortfolio: self.! !

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


!Portfolio class methodsFor: 'instance creation' stamp: 'fz 10/27/2019 17:25:07'!
named: aName
	^self new initializeNamed: aName
	! !


!classDefinition: #ReceptiveAccount category: #'Portfolio-Solucion'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'MD 10/27/2019 19:57:21'!
initialize

	super initialize.
	transactions := OrderedCollection new.
	name := 'default name'.! !

!ReceptiveAccount methodsFor: 'initialization' stamp: 'fz 10/27/2019 17:31:48'!
initializeNamed: aName
	name := aName.
	! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:52'!
addTransactionsTo: aCollectionOfTransactions

	aCollectionOfTransactions addAll: transactions ! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'MD 10/25/2019 17:14:48'!
executeOnAllTransactions: aBlockToExecute
	^ transactions do: aBlockToExecute! !

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


!ReceptiveAccount methodsFor: 'reports' stamp: 'MD 10/27/2019 20:08:17'!
executeOnAllAccounts: aBlock

	"a ReceptiveAccount has no accounts to execute. This is only to make the class polymorphic for the reports"! !

!ReceptiveAccount methodsFor: 'reports' stamp: 'fz 10/27/2019 18:27:45'!
showOn: aReport 
	aReport showReceptiveAccount: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ReceptiveAccount class' category: #'Portfolio-Solucion'!
ReceptiveAccount class
	instanceVariableNames: ''!

!ReceptiveAccount class methodsFor: 'instance creation' stamp: 'fz 10/27/2019 17:31:31'!
named: aName
	^self new initializeNamed: aName.! !


!classDefinition: #AccountTransaction category: #'Portfolio-Solucion'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountTransaction methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:39'!
affectBalance: aBalance

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'reports' stamp: 'fz 10/27/2019 16:59:33'!
showOn: aReport 
	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

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

!Deposit methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:02'!
affectBalance: aBalance

	^aBalance + value ! !


!Deposit methodsFor: 'initialization' stamp: 'jy 10/21/2019 20:05:27'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'reports' stamp: 'fz 10/27/2019 16:33:54'!
showOn: aReport 
	aReport showDeposit: self.! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !

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

!TransferDeposit methodsFor: 'balance' stamp: 'jy 10/21/2019 20:19:19'!
affectBalance: anAmmount 
	^anAmmount + transfer value! !


!TransferDeposit methodsFor: 'initialization' stamp: 'jy 10/21/2019 20:18:56'!
initializeOf: aTransfer 
	transfer := aTransfer.! !


!TransferDeposit methodsFor: 'reports' stamp: 'fz 10/27/2019 16:32:48'!
showOn: aReport 
	aReport showTransferDeposit: self.! !


!TransferDeposit methodsFor: 'value' stamp: 'jy 10/21/2019 20:19:53'!
value
	^transfer value! !

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

!TransferWithdraw methodsFor: 'balance' stamp: 'jy 10/21/2019 20:19:27'!
affectBalance: anAmmount 
	^anAmmount - transfer value! !


!TransferWithdraw methodsFor: 'initialization' stamp: 'jy 10/21/2019 20:18:46'!
initializeOf: aTransfer 
	transfer := aTransfer.! !


!TransferWithdraw methodsFor: 'reports' stamp: 'fz 10/27/2019 16:29:01'!
showOn: aReport 
	aReport showTransferWithdraw: self.! !


!TransferWithdraw methodsFor: 'value' stamp: 'jy 10/21/2019 20:19:58'!
value
	^transfer value! !

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

!Withdraw methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:15'!
affectBalance: aBalance

	^aBalance - value! !


!Withdraw methodsFor: 'initialization' stamp: 'jy 10/21/2019 20:05:41'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'reports' stamp: 'fz 10/27/2019 16:34:29'!
showOn: aReport 
	aReport showWithdraw: self.! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !

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

!Report methodsFor: 'printing' stamp: 'fz 10/27/2019 17:22:10'!
showReport
	self subclassResponsibility ! !


!classDefinition: #AccountsReport category: #'Portfolio-Solucion'!
Report subclass: #AccountsReport
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!


!classDefinition: #SpecialSummaryReport category: #'Portfolio-Solucion'!
AccountsReport subclass: #SpecialSummaryReport
	instanceVariableNames: 'account'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!SpecialSummaryReport methodsFor: 'initialization' stamp: 'MD 10/27/2019 20:16:18'!
initializeOf: anAccount 
	account := anAccount.! !


!SpecialSummaryReport methodsFor: 'printing' stamp: 'MD 10/27/2019 20:17:07'!
showReport
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SpecialSummaryReport class' category: #'Portfolio-Solucion'!
SpecialSummaryReport class
	instanceVariableNames: ''!

!SpecialSummaryReport class methodsFor: 'instance creation' stamp: 'MD 10/27/2019 20:17:33'!
of: anAccount 
	^self new initializeOf: anAccount withDeepness: 0.! !

!SpecialSummaryReport class methodsFor: 'instance creation' stamp: 'MD 10/27/2019 20:17:54'!
of: anAccount withDeepness: deepness 
	^self new initializeOf: anAccount withDeepness: deepness.! !


!classDefinition: #TreeStructureReport category: #'Portfolio-Solucion'!
AccountsReport subclass: #TreeStructureReport
	instanceVariableNames: 'structureReport account deepness'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TreeStructureReport methodsFor: 'printing' stamp: 'MD 10/27/2019 19:14:49'!
showReport
	
	structureReport := (self baseTabs), account accountName.

	account executeOnAllAccounts:[:anAccount |
		anAccount showOn: self.
	].
	
	^structureReport ! !


!TreeStructureReport methodsFor: 'initialization' stamp: 'MD 10/27/2019 19:09:40'!
initializeOf: anAccount withDeepness: aDeepness
	
	account := anAccount.
	deepness := aDeepness.! !


!TreeStructureReport methodsFor: 'private' stamp: 'MD 10/27/2019 19:14:49'!
baseTabs
	|tabs result|

	tabs := '    '.
	
	result := ''.
	deepness timesRepeat: [result := result, tabs].
	
	^result
! !


!TreeStructureReport methodsFor: 'showing accounts' stamp: 'MD 10/27/2019 20:02:02'!
showPortfolio: aPortfolio 
	|subStructure|
	subStructure := TreeStructureReport of: aPortfolio withDeepness: deepness+1.
	
	structureReport := structureReport, String newLineString, subStructure showReport.! !

!TreeStructureReport methodsFor: 'showing accounts' stamp: 'MD 10/27/2019 19:15:02'!
showReceptiveAccount: aReceptiveAccount 
	structureReport := structureReport, String newLineString, (self baseTabs), '    ', aReceptiveAccount accountName.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TreeStructureReport class' category: #'Portfolio-Solucion'!
TreeStructureReport class
	instanceVariableNames: ''!

!TreeStructureReport class methodsFor: 'instance creation' stamp: 'fz 10/27/2019 18:38:54'!
of: anAccount 
	^self new initializeOf: anAccount withDeepness: 0.! !

!TreeStructureReport class methodsFor: 'instance creation' stamp: 'fz 10/27/2019 18:38:59'!
of: anAccount withDeepness: deepness 
	^self new initializeOf: anAccount withDeepness: deepness.! !


!classDefinition: #TransactionsReport category: #'Portfolio-Solucion'!
Report subclass: #TransactionsReport
	instanceVariableNames: 'account'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransactionsReport methodsFor: 'showing transactions' stamp: 'fz 10/27/2019 16:35:38'!
showDeposit: aDeposit 
	self subclassResponsibility ! !

!TransactionsReport methodsFor: 'showing transactions' stamp: 'fz 10/27/2019 16:35:53'!
showTransferDeposit: aTransferDeposit 
	self subclassResponsibility ! !

!TransactionsReport methodsFor: 'showing transactions' stamp: 'fz 10/27/2019 16:36:02'!
showTransferWithdraw: aTransferWithdraw 
	self subclassResponsibility ! !

!TransactionsReport methodsFor: 'showing transactions' stamp: 'fz 10/27/2019 16:36:08'!
showWithdraw: aWithdraw 
	self subclassResponsibility ! !


!TransactionsReport methodsFor: 'initialization' stamp: 'fz 10/27/2019 18:41:35'!
initializeOf: anAccount
	account := anAccount.
	"Creemos que account como colaborador está bien a esta altura, evita código repetido"! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransactionsReport class' category: #'Portfolio-Solucion'!
TransactionsReport class
	instanceVariableNames: ''!

!TransactionsReport class methodsFor: 'instance creation' stamp: 'fz 10/27/2019 18:39:12'!
of: anAccount 
	^self new initializeOf: anAccount ! !


!classDefinition: #SummaryReport category: #'Portfolio-Solucion'!
TransactionsReport subclass: #SummaryReport
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!SummaryReport methodsFor: 'printing' stamp: 'fz 10/27/2019 18:39:45'!
showReport
	 
	transactions := OrderedCollection new.
	
	account executeOnAllTransactions: [:aTransaction | aTransaction showOn: self].
	
	transactions add: 'Balance = ', account balance asString.
	
	^String newLineString join: transactions.
	! !


!SummaryReport methodsFor: 'registering account transactions' stamp: 'fz 10/27/2019 16:46:47'!
showDeposit: aDeposit 
	transactions add: 'Depósito por ',aDeposit value asString ,'.'.! !

!SummaryReport methodsFor: 'registering account transactions' stamp: 'fz 10/27/2019 16:50:10'!
showTransferDeposit: aTransferDeposit 
	transactions add: 'Entrada por transferencia de ', aTransferDeposit value asString ,'.'! !

!SummaryReport methodsFor: 'registering account transactions' stamp: 'fz 10/27/2019 16:49:35'!
showTransferWithdraw: aTransferWithdraw 
	transactions add: 'Salida por transferencia de ', aTransferWithdraw value asString,'.'! !

!SummaryReport methodsFor: 'registering account transactions' stamp: 'fz 10/27/2019 16:48:58'!
showWithdraw: aWithdraw 
	transactions add: 'Extracción por ', aWithdraw value asString , '.'.! !


!classDefinition: #TransferNetReport category: #'Portfolio-Solucion'!
TransactionsReport subclass: #TransferNetReport
	instanceVariableNames: 'transferNetValue'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferNetReport methodsFor: 'printing' stamp: 'fz 10/27/2019 18:39:45'!
showReport
	transferNetValue := 0.
	
	account executeOnAllTransactions: [:aTransaction | aTransaction showOn: self].
	
	^transferNetValue.! !


!TransferNetReport methodsFor: 'registering account transactions' stamp: 'fz 10/27/2019 16:34:06'!
showDeposit: aDeposit ! !

!TransferNetReport methodsFor: 'registering account transactions' stamp: 'fz 10/27/2019 16:33:17'!
showTransferDeposit: aTransferDeposit 
	transferNetValue := transferNetValue + aTransferDeposit value.! !

!TransferNetReport methodsFor: 'registering account transactions' stamp: 'fz 10/27/2019 16:29:53'!
showTransferWithdraw: aTransferWithdraw 
	transferNetValue := transferNetValue - aTransferWithdraw value.! !

!TransferNetReport methodsFor: 'registering account transactions' stamp: 'fz 10/27/2019 16:34:40'!
showWithdraw: aWithdraw 
	! !


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


!Transfer methodsFor: 'internal parts' stamp: 'jy 10/21/2019 19:46:11'!
inTransaction
	^transferIn ! !

!Transfer methodsFor: 'internal parts' stamp: 'jy 10/21/2019 19:44:57'!
outTransaction
	^transferOut ! !

!Transfer methodsFor: 'internal parts' stamp: 'jy 10/21/2019 20:21:42'!
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
