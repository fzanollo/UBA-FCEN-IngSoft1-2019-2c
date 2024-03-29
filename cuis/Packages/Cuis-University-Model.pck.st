'From Cuis 5.0 [latest update: #3913] on 10 October 2019 at 11:09:42 am'!
'Description Mejora de descripcion de error'!
!provides: 'Cuis-University-Model' 1 21!
!requires: 'DenotativeObject' 1 21 nil!
!requires: 'Chalten' 1 6 nil!
SystemOrganization addCategory: #'Cuis-University-Model'!


!classDefinition: #CuisUniversityInstallation category: #'Cuis-University-Model'!
Object subclass: #CuisUniversityInstallation
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Cuis-University-Model'!
!classDefinition: 'CuisUniversityInstallation class' category: #'Cuis-University-Model'!
CuisUniversityInstallation class
	instanceVariableNames: ''!


!CuisUniversityInstallation class methodsFor: 'initialization' stamp: 'HAW 10/9/2019 11:22:17'!
initialize

	UnitsTestResource  installUnitsAsGlobals.
	TimeUnits installUnitsAsGlobals.
	StackSizeWatcher startWatchingWithDefaults.
	DenotativeObjectLightTheme beCurrent.
	
	! !

!CuisUniversityInstallation class methodsFor: 'initialization' stamp: 'HAW 2/28/2019 22:40:25'!
initializeWhitLiveTypingVM

	self 
		runAllTests;
		removeSystemChangesFromChangeSet;
		openWelcomeWindow.

	TranscriptWindow allInstancesDo: [:aTranscriptWindow | aTranscriptWindow delete ].
! !

!CuisUniversityInstallation class methodsFor: 'welcome window' stamp: 'HAW 3/28/2018 19:59:40'!
openWelcomeWindow

	| welcomeWindow |
	
	welcomeWindow := SystemWindow editText: (TextModel withText: (self welcomeWindowContents)) label: '�Bienvenidos a CuisUniversity!!' wrap: true.
	welcomeWindow resize: (Rectangle origin: 45@40 extent: 910@435)! !

!CuisUniversityInstallation class methodsFor: 'welcome window' stamp: 'HAW 2/28/2019 19:51:03'!
welcomeWindowContents

	^Compiler evaluate:  '(Text string: ''CuisUniversity

Este es un ambiente creado especialmente para la ense�anza de la Programaci�n Orientada a Objetos, usando Smalltalk como herramienta y en particular la implementaci�n Argentina de Smalltalk denominada Cuis.

El objetivo es que los interesados empiecen aprendiendo qu� significa trabajar con objetos concretos (denotative objects) para luego pasar a implementaciones m�s complejas del paradigma.

Para trabajar con objetos concretos, solo basta elegir la opcion "DenotativeObject Browser" del men� principal.
Para videos que muestran c�mo usar CuisUniversity ir a: https://www.youtube.com/playlist?list=PLMkq_h36PcLCQiU5gxNmedxdXbl10JYeV

Este ambiente viene con los siguientes paquetes instalados:
- LiveTyping: Una VM especial con un ambiente de objetos extendido que anota los tipos de las variables
  a medida que el sistema ejecuta. Mejora muchisimo la experiencia del programador.
- DenotativeObject: Herramienta que permite trabajar con Objetos sin Clases.
- Refactoring: Implementacion de refactorings automatizados para Cuis.
- Aconcagua: Posibilita trabajar con medidas 
- Chalten: Implementaci�n del Calendario Gregoriano. Usa Aconcagua
- Themes: Package que permite seleccionar distintos temas (colores), como Dark. Ir a "Preferences -> Themes"
  (Usar preferentemente DenotativeObjectTheme y DenotativeObjectDarkTheme)

Implementadores:
- Hern�n Wilkinson, M�ximo Prieto, Juan Manuel Vuletich

Colaboradores
- Nahuel Garbezza, Gast�n Caruso, Angeles Tella Arena, Matias Melendi

Sponsors:
- 10Pines SRL: Este ambiente no ser�a posible sin la horas de trabajo cedidas por 10Pines para hacerlo.'' runs: (RunArray runs: #(14 1 1605 ) values: ((Array new: 3) at: 1 put: ((Array new: 4) at: 1 put: (TextFontFamilyAndSize basicNew instVarAt: 1 put: ''DejaVu''; instVarAt: 2 put: 22; yourself); at: 2 put: (TextEmphasis basicNew instVarAt: 1 put: 1; yourself); at: 3 put: (TextColor basicNew instVarAt: 1 put: (Color r: 0.000 g: 0.000 b: 1.000); yourself); at: 4 put: (TextAlignment basicNew instVarAt: 1 put: 2; yourself); yourself); at: 2 put: ((Array new: 1) at: 1 put: (TextAlignment basicNew instVarAt: 1 put: 2; yourself); yourself); at: 3 put: #(); yourself)))'! !

!CuisUniversityInstallation class methodsFor: 'initialization - private' stamp: 'HAW 2/28/2019 22:14:55'!
removeSystemChangesFromChangeSet

	ChangeSet allChangeSets 
		select: [ :aChangeSet | aChangeSet isForBaseSystem ] 
		thenDo: [ :aChangeSet | ChangeSet removeChangeSet: aChangeSet ]! !

!CuisUniversityInstallation class methodsFor: 'initialization - private' stamp: 'HAW 2/28/2019 22:14:40'!
runAllTests

	| testClasses testSuite |
	
	testClasses := TestCase allSubclasses reject: [:cls | cls isAbstract or: [ cls = DecompilerTests ]].
	testSuite := TestSuite new.
	testClasses do: [ :aTestClass | aTestClass addToSuiteFromSelectors: testSuite ].
	
	testSuite run.
	
	MenuMorph allInstances do: [:aMorph | aMorph delete ].
	SystemWindow allInstances select: [ :aSystemWindow | aSystemWindow label = 'old instance' ] thenDo: [:aMorph | aMorph delete ].! !

!Debugger methodsFor: '*Cuis-University-Model' stamp: 'HAW 10/9/2019 09:42:42'!
argumentNamesOf: aMessage sentIn: aContext
		
	| argumentNames |
	
	aContext methodNode nodesDo: [ :aNode |
		(aNode isMessageNode and: [ aNode selectorSymbol = aMessage selector ]) 
			ifTrue: [ argumentNames := aNode arguments collect: [ :argument | argument name ]]].
		
	^argumentNames 

		! !

!Debugger methodsFor: '*Cuis-University-Model' stamp: 'HAW 10/10/2019 08:18:02'!
compileInitilizationMessage: aMessage in: aCategory fromClass: aClass context: aContext 
	
	| argumentNames realCategory initializationMethodSourceCode |
	
	argumentNames := self argumentNamesOf: aMessage sentIn: aContext sender.
		
	"Just in case something went wrong... - Hernan"
	argumentNames ifNil: [ ^self compileMessage: aMessage inCategory: aCategory fromClass: aClass context: aContext ].
	
	realCategory := aCategory = Categorizer default ifTrue: [ Categorizer initialization ]  ifFalse: [ aCategory ].
	initializationMethodSourceCode := aMessage 
		createInitializeMessageWith: argumentNames 
		forEachInstVarNameDo: [ :anInstVarName |  
			(aClass definesInstanceVariableNamedInHierarchy: anInstVarName) ifFalse: [ aClass addInstVarName: anInstVarName ]].
		
	aClass
		compile: initializationMethodSourceCode
		classified: realCategory
		! !

!Debugger methodsFor: '*Cuis-University-Model' stamp: 'HAW 10/7/2019 14:43:50'!
compileInstanceCreationMessage: aMessage in: aCategory fromClass: aClass context: aContext 
	
	aClass
		compile: (aMessage createInstanceCreationMessageFor: aClass)
		classified: aCategory
! !

!Debugger methodsFor: '*Cuis-University-Model' stamp: 'HAW 10/7/2019 14:39:43'!
compileMessage: aMessage inCategory: aCategory fromClass: aClass context: aContext 
	
	aClass
		compile: (aMessage createStubMethodFor: aClass)
		classified: aCategory! !

!Debugger methodsFor: '*Cuis-University-Model' stamp: 'HAW 10/10/2019 11:08:45'!
implement: aMessage inCategory: aCategory fromClass: aClass context: aContext

	[ (aClass isMeta and: [ aCategory = Categorizer instanceCreation]) 
		ifTrue: [ self compileInstanceCreationMessage: aMessage in: aCategory fromClass: aClass context: aContext ]
		ifFalse: [ aMessage isInitializer 
			ifTrue: [ self compileInitilizationMessage: aMessage in: aCategory fromClass: aClass context: aContext ]
			ifFalse: [ self compileMessage: aMessage inCategory: aCategory fromClass: aClass context: aContext ]].
		
	aContext privRefreshWith: (aClass lookupSelector: aMessage selector).
	aMessage arguments withIndexDo: [ :arg :index | aContext tempAt: index put: arg ].
	self resetContext: aContext ]
		on: RecompilationFailure
		do: [ :aFailure | 
			self inform: 'There was a problem compiling ', aClass name, '>>#',aMessage selector,
				' because:', String newLineString ,aFailure messageText.
			self down; restart ]
! !

!Message methodsFor: '*Cuis-University-Model' stamp: 'HAW 10/8/2019 16:04:23'!
createInitializationMessageAssigmentsIn: stream with: argumentNames forEachInstVarNameDo: instVarNameBlock  

	| instVarName |
	
	argumentNames do: [ :anArgumentName | 
		instVarName := anArgumentName asInstanceVariableName.
		instVarNameBlock value: instVarName.
		stream
			newLine;tab;
			nextPutAll: instVarName;
			nextPutAll: ' := ';
			nextPutAll: anArgumentName;
			nextPut: $. ].		
! !

!Message methodsFor: '*Cuis-University-Model' stamp: 'HAW 10/8/2019 15:57:14'!
createInitializeMessageDefinitionIn: stream with: argumentNames

	self selector keywords withIndexDo: [ :keyword :index | 
		stream 
			nextPutAll: keyword;
			space;
			nextPutAll: (argumentNames at: index);
			space ].
! !

!Message methodsFor: '*Cuis-University-Model' stamp: 'HAW 10/8/2019 16:05:36'!
createInitializeMessageWith: argumentNames forEachInstVarNameDo: instVarNameBlock 

	^ String streamContents: [ :stream |
		self createInitializeMessageDefinitionIn: stream with: argumentNames.
		stream newLine;tab.		
		self writeShouldBeImplementedOn: stream.
		self createInitializationMessageAssigmentsIn: stream with: argumentNames forEachInstVarNameDo: instVarNameBlock ]! !

!Message methodsFor: '*Cuis-University-Model' stamp: 'HAW 10/8/2019 15:28:48'!
createInstanceCreationMessageFor: aClass

	| instanceCreationMessageString |
	
	^ String streamContents: [ :stream |
		self writeMessageNameOn: stream.
		instanceCreationMessageString := stream contents.
		stream newLine; tab; nextPutAll: '"DO NOT FORGET TO RENAME COLLABORATORS AND REMOVE THIS COMMENT!!!!"';newLine; tab.
		self writeShouldBeImplementedOn: stream.
		stream
			newLine; tab;
			nextPutAll: '^self new initialize', instanceCreationMessageString capitalized ]! !

!Message methodsFor: '*Cuis-University-Model' stamp: 'HAW 10/7/2019 14:49:23'!
isInitializer 

	^selector beginsWith: 'initialize'.! !

!String methodsFor: '*Cuis-University-Model' stamp: 'HAW 10/8/2019 15:40:22'!
asInstanceVariableName
	
	self hasAnPrefix ifTrue: [ ^self asInstanceVariableNameWithoutAnPrefix ].
	self hasAPrefix ifTrue: [ ^self asInstanceVariableNameWithoutAPrefix ].
	
	^self asInstanceVariableNameUncapitilized 
	! !

!String methodsFor: '*Cuis-University-Model' stamp: 'HAW 10/8/2019 15:42:10'!
asInstanceVariableNameUncapitilized 

	| instVarName |
	
	instVarName := self uncapitalized.
	^self = instVarName 
		ifTrue: [ instVarName, '_CHANGE_ME' ]
		ifFalse: [ instVarName ]! !

!String methodsFor: '*Cuis-University-Model' stamp: 'HAW 10/8/2019 15:25:13'!
asInstanceVariableNameWithoutAPrefix
	
	^self allButFirst uncapitalized ! !

!String methodsFor: '*Cuis-University-Model' stamp: 'HAW 10/8/2019 15:26:43'!
asInstanceVariableNameWithoutAnPrefix
	
	^(self allButFirst: 2) uncapitalized ! !

!String methodsFor: '*Cuis-University-Model' stamp: 'HAW 10/8/2019 15:23:38'!
hasAPrefix
	
	^(self beginsWith: 'a') and: [ self size > 1 and: [ self second isUppercase ]]! !

!String methodsFor: '*Cuis-University-Model' stamp: 'HAW 10/8/2019 15:22:54'!
hasAnPrefix
	
	^(self beginsWith: 'an') and: [ self size > 2 and: [ self third isUppercase ]]! !

!Parser methodsFor: '*Cuis-University-Model' stamp: 'HAW 8/13/2018 11:55:17'!
performInteractiveChecks: aMethodNode

	self
		warnIfPossibilityOfSelfRecursion: aMethodNode;
		declareUndeclaredTemps: aMethodNode;
		removeUnusedTemps! !

!Parser methodsFor: '*Cuis-University-Model' stamp: 'RNG 1/19/2018 20:46:19'!
possibleSelfRecursionWarningMessage: aSelector

	^ 'Warning: possibility of infinite recursion.'
	, String crString ,
	'Sending ' , aSelector printString
	, ' to self inside the method body'! !

!Parser methodsFor: '*Cuis-University-Model' stamp: 'HAW 1/7/2019 15:02:24'!
warnIfPossibilityOfSelfRecursion: aMethodNode

	^ aMethodNode sendsRecursivelyToSelf ifTrue: [
		| answer |
		answer := PopUpMenu
			confirm: (self possibleSelfRecursionWarningMessage: aMethodNode selector)
			trueChoice: 'Ignore and continue'
			falseChoice: 'Change'
			 icons: #(acceptIcon cancelIcon).
		answer ifFalse: [ self fail ]
	]! !

!ParseNode methodsFor: '*Cuis-University-Model' stamp: 'RNG 12/31/2017 19:16:13'!
referencesSelf

	^ false! !

!ParseNode methodsFor: '*Cuis-University-Model' stamp: 'RNG 12/31/2017 19:10:30'!
sendsMessageToSelf: aSelector

	^ false! !

!ParseNode methodsFor: '*Cuis-University-Model' stamp: 'RNG 12/31/2017 19:06:07'!
sendsRecursivelyToSelf

	^ false! !

!BlockNode methodsFor: '*Cuis-University-Model' stamp: 'RNG 12/31/2017 19:11:55'!
sendsMessageToSelf: aSelector

	^ self statements anySatisfy: [ :statementNode | statementNode sendsMessageToSelf: aSelector ]! !

!BlockNode class methodsFor: '*Cuis-University-Model' stamp: 'RNG 1/19/2018 21:06:55'!
empty

	^ self statements: #() returns: false! !

!SelectorNode methodsFor: '*Cuis-University-Model' stamp: 'HAW 3/14/2019 11:14:25'!
isNamed: aSelectorName

	^ self key = aSelectorName! !

!VariableNode methodsFor: '*Cuis-University-Model' stamp: 'RNG 12/31/2017 19:16:41'!
referencesSelf

	^ self name = 'self'! !

!VariableNode class methodsFor: '*Cuis-University-Model' stamp: 'RNG 1/19/2018 20:50:48'!
named: aString 

	^ self new name: aString; yourself! !

!MessageNode methodsFor: '*Cuis-University-Model' stamp: 'HAW 3/14/2019 11:13:47'!
sendsMessageToSelf: aSelector

	^ self receiver referencesSelf and: [ self selector isNamed: aSelector ]! !

!MethodNode methodsFor: '*Cuis-University-Model' stamp: 'RNG 12/31/2017 19:10:04'!
sendsRecursivelyToSelf

	^ self body sendsMessageToSelf: self selector! !
CuisUniversityInstallation initialize!
