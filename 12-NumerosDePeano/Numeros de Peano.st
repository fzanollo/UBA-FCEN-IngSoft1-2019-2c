!classDefinition: #DenotativeObjectBrowser category: #'Numeros de Peano'!
Browser subclass: #DenotativeObjectBrowser
	instanceVariableNames: ''
	classVariableNames: 'RecentDenotativeObjects'
	poolDictionaries: ''
	category: 'Numeros de Peano'!

!DenotativeObjectBrowser methodsFor: 'accessing' stamp: 'HAW 7/22/2017 09:08:17'!
acceptedStringOrText
	"Depending on the current selection, different information is retrieved.
	Answer a string description of that information. This information is the
	method of the currently selected class and message."

	| comment theClass latestCompiledMethod |
	latestCompiledMethod := currentCompiledMethod.
	currentCompiledMethod := nil.

	editSelection == #none ifTrue: [^ ''].
	editSelection == #editSystemCategories
		ifTrue: [^ systemOrganizer printString].
	editSelection == #newClass
		ifTrue: [
			theClass := self selectedClass.
			^DenotativeObject template: selectedSystemCategory].

	editSelection == #editClass
		ifTrue: [
			^ self classDefinitionText ].
	editSelection == #editComment
		ifTrue: [
			(theClass := self selectedClass) ifNil: [^ ''].
			comment := theClass comment.
			currentCompiledMethod := theClass organization commentRemoteStr.
			^ comment size = 0
				ifTrue: ['This class has not yet been commented.']
				ifFalse: [comment]].
	editSelection == #hierarchy
		ifTrue: [^ self selectedClassOrMetaClass printHierarchy].
	editSelection == #editMessageCategories
		ifTrue: [^ self classOrMetaClassOrganizer printString].
	editSelection == #newMessage
		ifTrue: [
			^ (theClass := self selectedClassOrMetaClass)
				ifNil: ['']
				ifNotNil: [theClass sourceCodeTemplate]].
	editSelection == #editMessage
		ifTrue: [
			self showingByteCodes ifTrue: [^ self selectedBytecodes].
			currentCompiledMethod := latestCompiledMethod.
			^ self selectedMessage].

	self error: 'Browser internal error: unknown edit selection.'! !


!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 3/31/2018 20:25:37'!
addChildDenotativeObject
	
	self withSelectedCategoryNameDo: [ :systemCategoryName |
		self withObjectNameDo: [ :objectName |
			self withParentNameDo: [ :parentName |
				self addDenotativeObjectNamed: objectName asChildOf: parentName inCategory:  systemCategoryName ]]]! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 8/26/2017 18:15:55'!
addChildDenotativeObjectInCategory
	
	self withObjectNameDo: [ :objectName |
		self withParentNameDo: [ :parentName |
			self withCategoryNameDo: [ :categoryName |
				self addDenotativeObjectNamed: objectName asChildOf: parentName inCategory: categoryName ]]]
	! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 3/31/2018 20:24:11'!
addDenotativeObject
	
	self withSelectedCategoryNameDo: [ :systemCategoryName | 
		self withObjectNameDo: [ :objectName |
			self addDenotativeObjectNamed: objectName inCategory:  systemCategoryName ]]! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 8/26/2017 18:13:46'!
addDenotativeObjectInCategory
	
	self withObjectNameDo: [ :objectName |
		self withCategoryNameDo: [ :categoryName |
			self addDenotativeObjectNamed: objectName inCategory: categoryName ]]
	! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 9/7/2017 15:30:59'!
addDenotativeObjectNamed: objectName asChildOf: parentName inCategory: categoryName
	
	| definitionString collaborators |

	collaborators := Array 
		with: '#', objectName 
		with: parentName
		with: ''''''
		with: '''', categoryName, ''''.
	
	definitionString := String streamContents: [ :stream |
		stream  nextPutAll:  ObjectBuilder name asString.		
		#create:asChildOf:collaboratorNames:in: keywords withIndexDo: [ :keyword :index |
			stream
				space;
				nextPutAll: keyword;
				space;
				nextPutAll: (collaborators at: index) ]].
	
	self defineClass: definitionString  notifying: nil 
	! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 8/26/2017 18:13:21'!
addDenotativeObjectNamed: objectName inCategory: categoryName
	
	^self addDenotativeObjectNamed: objectName asChildOf: DenotativeObject name asString inCategory: categoryName ! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 7/22/2017 09:05:19'!
classDefinitionText
	"return the text to display for the definition of the currently selected class"
	| theClass |
	
	^(theClass := self selectedClassOrMetaClass) ifNil: [''] ifNotNil: [DenotativeObject definitionOf: theClass]! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 9/13/2017 16:05:55'!
collaboratorWithReferencesErrorMessageFrom: anUndeclareVariableWarning
	
	^String streamContents: [:stream |
		stream
			nextPutAll: 'The collaborator ';
			nextPutAll: anUndeclareVariableWarning variableName;
			nextPutAll: ' is reference in ';
			nextPutAll: anUndeclareVariableWarning classImplementingSelector theNonMetaClass name;
			nextPutAll: '>>';
			nextPutAll: anUndeclareVariableWarning selector;
			newLine;
			nextPutAll: 'Do you want to continue?' ]! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 7/22/2017 13:32:34'!
copyClass

	| originalClass originalName copysName  |

	selectedClassName ifNil: [^ self].
	originalClass := self selectedClass.
	originalName := originalClass name.
	copysName _ self request: 'Please type new object name' initialAnswer: originalName.
	copysName = '' ifTrue: [^ self].  " Cancel returns '' "
	
	[ originalClass cloneNamed: copysName.
	self classListIndex: 0.
	self changed: #classList ]
		on: Error
		do: [ :anError | self inform: anError printString ].
			
	! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 10/1/2018 14:52:20'!
createClass

	self selectedClass ifNotNil: [ :aDenotativeObject | | superclass className categoryName |	
		className := ClassNameRequestMorph request: 'Class for ', aDenotativeObject name onCancel: [ ^self ].
		(Smalltalk classNamed: className) ifNotNil: [
			(PopUpMenu confirm: className, ' already exist. Do you want to recreate?' trueChoice: 'Recreate it' falseChoice: 'Do not continue') 
				ifFalse: [ ^self ]].			
		categoryName := FillInTheBlankMorph request: 'Enter category name' initialAnswer: aDenotativeObject category onCancel: [ ^self ].
		
		[ superclass := self createSuperclassOf: aDenotativeObject onCancel: [ ^self ].
		aDenotativeObject createClassNamed: className asSymbol subclassOf: superclass category: categoryName ]
			on: Error
			do: [ :anError | self inform: anError messageText ]]! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 10/1/2018 14:52:33'!
createSuperclassOf: aDenotativeObject onCancel: aBlock

	| denotativeObjectParent categoryName superclass superclassName |
	
	denotativeObjectParent := aDenotativeObject parentIfNone: [ ^Object ].
	
	superclassName := ClassNameRequestMorph request: 'Class for ', denotativeObjectParent name onCancel: [ ^aBlock value ].
	(Smalltalk classNamed: superclassName) ifNotNil: [ :alreadyExistingSuperclass |
		(PopUpMenu confirm: superclassName, ' already exist. Do you want to recreate or reuse it?' trueChoice: 'Recreate it' falseChoice: 'Reuse it')
			ifFalse: [ ^alreadyExistingSuperclass ]].
		
	categoryName := FillInTheBlankMorph request: 'Enter category name' initialAnswer: denotativeObjectParent category onCancel: [ ^aBlock value ].	
	superclass := self createSuperclassOf: denotativeObjectParent onCancel: aBlock.
	
	^denotativeObjectParent createClassNamed: superclassName asSymbol subclassOf: superclass category: categoryName! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 9/13/2017 16:02:36'!
defineClass: defString notifying: aRequestor

	^[self defineClassWithoutHandlingWarning: defString notifying: aRequestor]		
		on: Warning
		do: [ :aWarning |
			(self confirm: aWarning printString) 
				ifTrue: [ aWarning resume ]
				ifFalse: [ aWarning return: false ]].! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 9/13/2017 16:01:54'!
defineClassWihoutHandlingErrors: defString notifying: aRequestor 
		
 	| class classCreated |
	
	self validateDefinitionString: defString.
	class := Compiler evaluate: defString notifying: aRequestor logged: true.
	
	classCreated := class isKindOf: Behavior.
	classCreated ifTrue: [ self newClassCreated: class ].
	
	^classCreated! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 5/10/2019 12:34:39'!
defineClassWithoutHandlingParseNotification: defString notifying: aRequestor 
		
	^[self defineClassWihoutHandlingErrors: defString notifying: aRequestor ]
		on: Error - MessageNotUnderstood 
		do: [ :anError | 
			self filterErrorMessagesWithClassStringFrom: anError.
			self inform: anError messageText.
			anError return: false ]! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 9/13/2017 15:57:26'!
defineClassWithoutHandlingUndeclareVariableWaring: defString notifying: aRequestor 
			
	^[self defineClassWithoutHandlingParseNotification: defString notifying: aRequestor ]
		on: ParserNotification 
		do: [ :parserNotification |
			self inform: self invalidDefinitionErrorDescription.
			parserNotification return: false ]! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 9/13/2017 16:04:07'!
defineClassWithoutHandlingWarning: defString notifying: aRequestor
	
	^[self defineClassWithoutHandlingUndeclareVariableWaring: defString notifying: aRequestor ]
		on: UndeclaredVariableWarning 
		do: [ :anUndeclareVariableWarning |
			(self confirm: (self collaboratorWithReferencesErrorMessageFrom: anUndeclareVariableWarning)) 
				ifTrue: [ anUndeclareVariableWarning resume ]
				ifFalse: [ anUndeclareVariableWarning return: false ]]! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 9/13/2017 16:06:59'!
filterErrorMessagesWithClassStringFrom: anError
		
	anError messageText = 'Class names must be capitalized' ifTrue: [ ^anError messageText: 'Object names must be capitalized' ].
	anError messageText: (anError messageText copyReplaceAll: ' class' with: '').
	anError messageText: (anError messageText copyReplaceAll: ' inherits from ' with: ' is child of ').
	anError messageText: (anError messageText copyReplaceAll: ' subclass ' with: ' child ').! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 9/13/2017 16:01:32'!
newClassCreated: aClass
	
	self 
		changed: #systemCategoryList;
		changed: #classList;
		changed: #clearUserEdits;
		setClass: aClass selector: nil.
! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 8/1/2018 17:56:48'!
removeClass
	
	^self safelyRemoveClass ! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 9/10/2017 19:06:32'!
renameClass

	self selectedClassOrMetaClass ifNotNil: [ :aBehavior |
		(DenotativeObjectRenameApplier on: self for: aBehavior theNonMetaClass) value ].! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 9/14/2018 13:49:17'!
safelyRemoveClass

	self selectedClassOrMetaClass ifNotNil: [ :aBehavior |
		(DenotativeObjectSafelyRemoveApplier on: self of: aBehavior theNonMetaClass) value ].
	
	! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 8/26/2017 18:15:10'!
withObjectNameDo: aBlock
	
	^self withObjectNameDo: aBlock label: 'Enter object name' 
	! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 10/1/2018 14:52:54'!
withObjectNameDo: aBlock label: aLabel
	
	| objectName |
	
	objectName := DenotativeObjectNameRequestMorph request: aLabel onCancel: [^self].
	objectName := objectName withBlanksTrimmed.
	"This is just to provide a better error message - Hernan"
	[ ObjectBuilder assertIsValidName: objectName ] on: Error do: [:anError | ^self inform: anError messageText ].
	^aBlock value: objectName ! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 8/26/2017 18:15:23'!
withParentNameDo: aBlock
	
	^self withObjectNameDo: aBlock label: 'Enter parent name' 
! !

!DenotativeObjectBrowser methodsFor: 'class functions' stamp: 'HAW 3/31/2018 20:24:57'!
withSelectedCategoryNameDo: aBlock

	^self selectedSystemCategoryName 
		ifNil: [ self inform: 'An object category must be selected' ]
		ifNotNil: aBlock 
! !


!DenotativeObjectBrowser methodsFor: 'class list' stamp: 'HAW 2/21/2019 16:37:48'!
defaultClassList

	^super defaultClassList select: [ :aClassName | Smalltalk isDenotativeObjectNamed: aClassName ] ! !


!DenotativeObjectBrowser methodsFor: 'tdd' stamp: 'HAW 8/23/2017 15:23:05'!
debugMethodTest

	^self debugDenotativeObjectMethodTest! !

!DenotativeObjectBrowser methodsFor: 'tdd' stamp: 'HAW 8/23/2017 15:26:31'!
runClassTests

	^self runDenotativeObjectTests! !

!DenotativeObjectBrowser methodsFor: 'tdd' stamp: 'HAW 8/23/2017 15:28:28'!
runMessageCategoryTests

	^self runDenotativeObjectMessageCategoryTests! !

!DenotativeObjectBrowser methodsFor: 'tdd' stamp: 'HAW 8/23/2017 15:29:35'!
runMethodTest

	^self runDenotativeObjectMethodTest! !

!DenotativeObjectBrowser methodsFor: 'tdd' stamp: 'HAW 8/23/2017 15:31:02'!
runSystemCategoryTests

	^self runDenotativeObjectSystemCategoryTests! !


!DenotativeObjectBrowser methodsFor: 'initialization' stamp: 'HAW 4/11/2018 15:30:27'!
defaultBrowserTitle
	^ 'DenotativeObject Browser'! !

!DenotativeObjectBrowser methodsFor: 'initialization' stamp: 'HAW 7/9/2017 12:18:37'!
systemOrganizer: aSystemOrganizer
	"Initialize the receiver as a perspective on the system organizer,
	aSystemOrganizer. Typically there is only one--the system variable
	SystemOrganization."

	systemOrganizer := aSystemOrganizer.
	selectedSystemCategory := nil.
	selectedClassName := nil.
	selectedMessageCategory := nil.
	selectedMessage := nil.
	metaClassIndicated := true.
	self setClassOrganizer.
	self editSelection: #none.! !


!DenotativeObjectBrowser methodsFor: 'message functions' stamp: 'HAW 8/1/2017 09:48:21'!
defineMessageFrom: aString notifying: aRequestor

	| selectedMessageName selector category oldMessageList |

	selectedMessageName _ self selectedMessageName.
	oldMessageList _ self messageList.
	selector _ self selectedClassOrMetaClass parserClass selectorFrom: aString.
	(self metaClassIndicated
		and: [ selector ~= #printOn: 
		and: [(self selectedClassOrMetaClass includesSelector: selector) not
		and: [Metaclass isScarySelector: selector]]])
		ifTrue: ["A frist-time definition overlaps the protocol of Metaclasses"
				(self confirm: (selector bold, ' is used in the existing system.
Overriding it could cause serious problems.
Is this really what you want to do?'))
				ifFalse: [^nil]].
			
	[ selector _ self selectedClassOrMetaClass
				compile: aString
				classified: (category _ self selectedMessageCategoryName)
				notifying: aRequestor ]
		on: UndeclaredVariable 
		do: [ :undeclaredVariable | undeclaredVariable handleForDenotativeObjectIn: self ].
	
	selector
		ifNil: [^ nil].
	selector ~~ selectedMessageName
		ifTrue: [
			category = ClassOrganizer nullCategory
				ifTrue: [self changed: #classSelectionChanged.
						self changed: #classList.
						self messageCategoryListIndex: 1].
			self setClassOrganizer.  "In case organization not cached"
			(oldMessageList includes: selector)
				ifFalse: [self changed: #messageList].
			self messageListIndex: (self messageList indexOf: selector)].
	^ selector
	
	! !


!DenotativeObjectBrowser methodsFor: 'user interface support' stamp: 'HAW 2/19/2019 15:32:07'!
autoCompleterClassFor: textGetter
	
	^DenotativeObjectCompleter! !

!DenotativeObjectBrowser methodsFor: 'user interface support' stamp: 'HAW 7/14/2017 20:46:27'!
editorClassFor: textGetter

	^DenotativeObjectSmalltalkEditor! !


!DenotativeObjectBrowser methodsFor: 'system category functions' stamp: 'HAW 7/18/2017 21:08:22'!
fileInSystemCategory

	[| fileName |

	fileName := FillInTheBlankMorph request: 'Enter file name' onCancel: [ ^self ].
	ChangeSet fileIn: fileName asFileEntry ]
		on: FileDoesNotExistException
		do: [:anError |
			(PopUpMenu confirm: 'File ', anError messageText, ' does not exist. Try again?') ifTrue: [ anError retry ] ifFalse: [ anError return ]]! !

!DenotativeObjectBrowser methodsFor: 'system category functions' stamp: 'HAW 7/22/2017 11:45:50'!
firstExperimentCategoryName
	
	^'First Experiment'! !

!DenotativeObjectBrowser methodsFor: 'system category functions' stamp: 'RNG 5/27/2018 01:03:53'!
potentialClassNames

	^ DenotativeObject allSubclasses collect: [ :class | class name ]! !

!DenotativeObjectBrowser methodsFor: 'system category functions' stamp: 'HAW 8/1/2017 09:31:11'!
removeSystemCategory

	selectedSystemCategory ifNil: [^ self].
	(self classList isEmpty or: [ self confirm: 'Are you sure you want to
remove this system category 
and all its objects?'])
		ifTrue: [
			systemOrganizer removeSystemCategory: selectedSystemCategory.
			self systemCategoryListIndex: 0.
			self changed: #systemCategoryList ]! !

!DenotativeObjectBrowser methodsFor: 'system category functions' stamp: 'HAW 8/22/2017 09:53:35'!
withCategoryNameDo: aBlock
	
	| categoryName |
	
	categoryName := FillInTheBlankMorph request: 'Enter category name' onCancel: [^self].
	categoryName := categoryName withBlanksTrimmed.
	categoryName isEmpty ifTrue: [ ^self inform: 'Category name can not be empty' ].
	^aBlock value: categoryName ! !


!DenotativeObjectBrowser methodsFor: 'exceptions' stamp: 'HAW 8/26/2017 18:35:22'!
invalidDefinitionErrorDescription

	^'Invalid definition'! !

!DenotativeObjectBrowser methodsFor: 'exceptions' stamp: 'HAW 8/6/2017 11:09:34'!
invalidObjectErrorDescription: name

	^name, ' is not a denotative object'! !

!DenotativeObjectBrowser methodsFor: 'exceptions' stamp: 'HAW 5/10/2019 11:45:38'!
objectNameMustBeSymbolErrorDescription
	
	^'Object name must be symbol. It has to start wiht #'! !

!DenotativeObjectBrowser methodsFor: 'exceptions' stamp: 'HAW 9/13/2017 15:11:23'!
validateDefinitionString: defString

	| defTokens |
	
	defTokens := defString findTokens: Character separators.
	defTokens isEmpty ifTrue: [ self error: self invalidDefinitionErrorDescription ].
	
	defTokens first = ObjectBuilder name asString 
		ifTrue: [ self validateObjectCreation: defTokens ]
		ifFalse: [ self validateObjectRedefinition: defTokens ]! !

!DenotativeObjectBrowser methodsFor: 'exceptions' stamp: 'HAW 5/10/2019 12:36:46'!
validateObjectCreation: defTokens 

	| denotativeObjectName nameIndex |
	
	nameIndex := defTokens findFirst: [ :token | token beginsWith: '#' ].
	nameIndex = 0 ifTrue: [ self error: self objectNameMustBeSymbolErrorDescription ].
	
	denotativeObjectName := (defTokens at: nameIndex) copyWithoutAll: '#()'.
	(NewDenotativeObjectPrecondition for: denotativeObjectName asSymbol in: Smalltalk undeclared: Undeclared) value.
! !

!DenotativeObjectBrowser methodsFor: 'exceptions' stamp: 'HAW 2/21/2019 16:41:15'!
validateObjectRedefinition: defTokens 

	(Smalltalk isDenotativeObjectNamed: defTokens first asSymbol) ifFalse: [ self error: (self invalidObjectErrorDescription: defTokens first)]

		! !


!DenotativeObjectBrowser methodsFor: 'metaclass' stamp: 'HAW 7/9/2017 12:17:35'!
metaClassIndicated: trueOrFalse
	"Indicate whether browsing instance or class messages."

	^super metaClassIndicated: true! !


!DenotativeObjectBrowser methodsFor: 'system category list' stamp: 'HAW 7/22/2017 11:45:30'!
systemCategoryList

	| denotativeObjecCategories |
	
	denotativeObjecCategories := (systemOrganizer categories select: [:aCategory | 
		(systemOrganizer classesAt: aCategory) anySatisfy: [ :aClass | aClass is: #DenotativeObject ]]) asSortedCollection.
	
	^denotativeObjecCategories isEmpty ifTrue: [ {self firstExperimentCategoryName} ] ifFalse: [ denotativeObjecCategories ]

! !

!DenotativeObjectBrowser methodsFor: 'system category list' stamp: 'HAW 3/31/2018 19:46:57'!
systemCategoryListIndex: anInteger
	"Set the selected system category index to be anInteger. Update all other
	selections to be deselected."

	| index systemCategoryList |
	
	systemCategoryList _ self systemCategoryList.
	index _ systemCategoryList ifInBounds: anInteger ifNot: 0.

	selectedSystemCategory _ index = 0 ifFalse: [ systemCategoryList at: index ].
	selectedClassName := nil.
	selectedMessageCategory := nil.
	selectedMessage := nil.
	self editSelection: ( index = 0 ifTrue: [#none] ifFalse: [#newClass]).
	metaClassIndicated := true.
	self setClassOrganizer.
	self changed: #systemCategorySelectionChanged.
	self changed: #systemCategoryListIndex.	"update my selection"
	self changed: #classList.
	self changed: #messageCategoryList.
	self changed: #messageList.
	self changed: #relabel.
	self changed: #instanceMessagesIndicated.
	self changed: #classCommentIndicated.
	self changed: #classMessagesIndicated.
	self acceptedContentsChanged! !


!DenotativeObjectBrowser methodsFor: 'morph handling' stamp: 'HAW 9/27/2018 15:07:14'!
hasMorphObjectSelected

	^ self selectedClass notNil and: [ self selectedClass isDescendantOf: DenotativeObjectMorph ]! !

!DenotativeObjectBrowser methodsFor: 'morph handling' stamp: 'RNG 9/27/2018 11:18:46'!
hideSelectedMorph

	self selectedClass delete! !

!DenotativeObjectBrowser methodsFor: 'morph handling' stamp: 'RNG 9/27/2018 11:18:58'!
showSelectedMorph

	self selectedClass openInWorld! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DenotativeObjectBrowser class' category: #'Numeros de Peano'!
DenotativeObjectBrowser class
	instanceVariableNames: ''!

!DenotativeObjectBrowser class methodsFor: 'cached state access' stamp: 'HAW 2/21/2019 16:53:49'!
recentClasses

	RecentDenotativeObjects ifNil: [ RecentDenotativeObjects := OrderedCollection new ].
	
	^RecentDenotativeObjects ! !

!DenotativeObjectBrowser class methodsFor: 'cached state access' stamp: 'HAW 2/21/2019 16:54:14'!
releaseClassCachedState
	"
	DenotativeObjectBrowser  releaseClassCachedState
	"
	RecentDenotativeObjects _ nil! !


!classDefinition: #I category: #'Numeros de Peano'!
DenotativeObject subclass: #I
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros de Peano'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'I class' category: #'Numeros de Peano'!
I class
	instanceVariableNames: ''!

!I class methodsFor: 'as yet unclassified' stamp: 'fz 8/26/2019 20:38:57'!
* unNumeroDePeano
	^ unNumeroDePeano ! !

!I class methodsFor: 'as yet unclassified' stamp: 'fz 8/26/2019 18:52:07'!
+ unNumeroDePeano
	^ unNumeroDePeano next! !

!I class methodsFor: 'as yet unclassified' stamp: 'fz 8/28/2019 16:28:16'!
- unNroPeano

	self error: self descripcionDeErrorDeNumerosNegativosNoSoportados.! !

!I class methodsFor: 'as yet unclassified' stamp: 'fz 8/30/2019 17:28:53'!
/ unNroPeano

	unNroPeano  = I ifTrue: [^ self].
	
	self error: self descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor .! !

!I class methodsFor: 'as yet unclassified' stamp: 'fz 8/26/2019 20:55:24'!
<= unNroPeano
	^true! !

!I class methodsFor: 'as yet unclassified' stamp: 'fz 8/30/2019 17:16:05'!
>= unNroPeano
	unNroPeano = I ifTrue: [^true] ifFalse: [^false].! !

!I class methodsFor: 'as yet unclassified' stamp: 'fz 8/28/2019 16:36:24'!
descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor
	^'No se puede dividir por un numero mayor'.! !

!I class methodsFor: 'as yet unclassified' stamp: 'fz 8/28/2019 16:27:14'!
descripcionDeErrorDeNumerosNegativosNoSoportados
	^'Numeros negativos no soportados'.! !

!I class methodsFor: 'as yet unclassified' stamp: 'fz 8/26/2019 18:25:50'!
next
	^ II.
	
	! !


!classDefinition: #II category: #'Numeros de Peano'!
DenotativeObject subclass: #II
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros de Peano'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'II class' category: #'Numeros de Peano'!
II class
	instanceVariableNames: 'next previous'!

!II class methodsFor: 'as yet unclassified' stamp: 'fz 8/26/2019 20:40:28'!
* unNumeroDePeano
	
	^ self previous * unNumeroDePeano + unNumeroDePeano.! !

!II class methodsFor: 'as yet unclassified' stamp: 'fz 8/26/2019 18:54:11'!
+ unNumeroDePeano
	
	^ self previous + unNumeroDePeano next
	! !

!II class methodsFor: 'as yet unclassified' stamp: 'fz 8/26/2019 19:09:35'!
- unNroPeano

	unNroPeano=I ifTrue: [^ self previous].

	^ self previous - unNroPeano previous! !

!II class methodsFor: 'as yet unclassified' stamp: 'fz 8/30/2019 17:27:01'!
/ unNroPeano

	unNroPeano=I ifTrue: [^self].
	
	self >= (unNroPeano + unNroPeano ) ifTrue: [^ I + (self - unNroPeano / unNroPeano)].
	self >= unNroPeano ifTrue: [^ I].	
		
	"divisor es menor que el dividendo"
	self error: self descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor.
	! !

!II class methodsFor: 'as yet unclassified' stamp: 'fz 8/28/2019 16:58:17'!
<= unNroPeano
	unNroPeano = I ifTrue: [^false].
	
	^ self previous <= unNroPeano previous.! !

!II class methodsFor: 'as yet unclassified' stamp: 'fz 8/30/2019 17:14:59'!
>= unNroPeano
	unNroPeano = I ifTrue: [^true].
	
	^ self previous >= unNroPeano previous.! !

!II class methodsFor: 'as yet unclassified' stamp: 'fz 8/30/2019 17:03:22'!
descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor
	^'No se puede dividir por un numero mayor'.! !

!II class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:27'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := III.
	previous := I.! !

!II class methodsFor: 'as yet unclassified' stamp: 'fz 8/26/2019 18:55:49'!
next
	next ifNil: [
		next := self cloneNamed: self name , 'I'.
		next previous: self.
	].

	^ next
	
	! !

!II class methodsFor: 'as yet unclassified' stamp: 'fz 8/26/2019 18:54:38'!
previous

	^previous! !

!II class methodsFor: 'as yet unclassified' stamp: 'fz 8/26/2019 18:59:54'!
previous: unNumeroDePeano

	previous := unNumeroDePeano ! !

!II class methodsFor: 'as yet unclassified' stamp: 'fz 8/26/2019 18:41:09'!
removeAllNext
	next ifNotNil: [
		next removeAllNext.
		next removeFromSystem.	
		next := nil.
	]! !


!classDefinition: #III category: #'Numeros de Peano'!
DenotativeObject subclass: #III
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros de Peano'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'III class' category: #'Numeros de Peano'!
III class
	instanceVariableNames: 'next previous'!

!III class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
* unNumeroDePeano
	
	^ self previous * unNumeroDePeano + unNumeroDePeano.! !

!III class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
+ unNumeroDePeano
	
	^ self previous + unNumeroDePeano next
	! !

!III class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
- unNroPeano

	unNroPeano=I ifTrue: [^ self previous].

	^ self previous - unNroPeano previous! !

!III class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
/ unNroPeano

	unNroPeano=I ifTrue: [^self].
	
	self >= (unNroPeano + unNroPeano ) ifTrue: [^ I + (self - unNroPeano / unNroPeano)].
	self >= unNroPeano ifTrue: [^ I].	
		
	"divisor es menor que el dividendo"
	self error: self descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor.
	! !

!III class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
<= unNroPeano
	unNroPeano = I ifTrue: [^false].
	
	^ self previous <= unNroPeano previous.! !

!III class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
>= unNroPeano
	unNroPeano = I ifTrue: [^true].
	
	^ self previous >= unNroPeano previous.! !

!III class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor
	^'No se puede dividir por un numero mayor'.! !

!III class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:27'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IIII.
	previous := II.! !

!III class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
next
	next ifNil: [
		next := self cloneNamed: self name , 'I'.
		next previous: self.
	].

	^ next
	
	! !

!III class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
previous

	^previous! !

!III class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
previous: unNumeroDePeano

	previous := unNumeroDePeano ! !

!III class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
removeAllNext
	next ifNotNil: [
		next removeAllNext.
		next removeFromSystem.	
		next := nil.
	]! !


!classDefinition: #IIII category: #'Numeros de Peano'!
DenotativeObject subclass: #IIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros de Peano'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIII class' category: #'Numeros de Peano'!
IIII class
	instanceVariableNames: 'next previous'!

!IIII class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
* unNumeroDePeano
	
	^ self previous * unNumeroDePeano + unNumeroDePeano.! !

!IIII class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
+ unNumeroDePeano
	
	^ self previous + unNumeroDePeano next
	! !

!IIII class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
- unNroPeano

	unNroPeano=I ifTrue: [^ self previous].

	^ self previous - unNroPeano previous! !

!IIII class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
/ unNroPeano

	unNroPeano=I ifTrue: [^self].
	
	self >= (unNroPeano + unNroPeano ) ifTrue: [^ I + (self - unNroPeano / unNroPeano)].
	self >= unNroPeano ifTrue: [^ I].	
		
	"divisor es menor que el dividendo"
	self error: self descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor.
	! !

!IIII class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
<= unNroPeano
	unNroPeano = I ifTrue: [^false].
	
	^ self previous <= unNroPeano previous.! !

!IIII class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
>= unNroPeano
	unNroPeano = I ifTrue: [^true].
	
	^ self previous >= unNroPeano previous.! !

!IIII class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor
	^'No se puede dividir por un numero mayor'.! !

!IIII class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:27'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := nil.
	previous := III.! !

!IIII class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
next
	next ifNil: [
		next := self cloneNamed: self name , 'I'.
		next previous: self.
	].

	^ next
	
	! !

!IIII class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
previous

	^previous! !

!IIII class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
previous: unNumeroDePeano

	previous := unNumeroDePeano ! !

!IIII class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 16:39:21'!
removeAllNext
	next ifNotNil: [
		next removeAllNext.
		next removeFromSystem.	
		next := nil.
	]! !

II initializeAfterFileIn!
III initializeAfterFileIn!
IIII initializeAfterFileIn!