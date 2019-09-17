!classDefinition: #OOStackTest category: #'Stack-Exercise'!
TestCase subclass: #OOStackTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test01StackShouldBeEmptyWhenCreated

	| stack |
	
	stack := OOStack new.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test02PushAddElementsToTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'Something'.
	
	self deny: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:31'!
test03PopRemovesElementsFromTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'Something'.
	stack pop.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/8/2012 08:20'!
test04PopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'Something'.
	stack push: pushedObject.
	
	self assert: stack pop = pushedObject! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:33'!
test05StackBehavesLIFO

	| stack firstPushedObject secondPushedObject |
	
	stack := OOStack new.
	firstPushedObject := 'First'.
	secondPushedObject := 'Second'.
	
	stack push: firstPushedObject.
	stack push: secondPushedObject.
	
	self assert: stack pop = secondPushedObject.
	self assert: stack pop = firstPushedObject.
	self assert: stack isEmpty 
	! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:35'!
test06TopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'Something'.
	
	stack push: pushedObject.
	
	self assert: stack top = pushedObject.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:36'!
test07TopDoesNotRemoveObjectFromStack

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'Something'.
	
	stack push: pushedObject.
	
	self assert: stack size = 1.
	stack top.
	self assert: stack size = 1.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:26'!
test08CanNotPopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:36'!
test09CanNotPopWhenThereAreNoObjectsInTheStackAndTheStackHadObjects

	| stack  |
	
	stack := OOStack new.
	stack push: 'Something'.
	stack pop.
	
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:44'!
test10CanNotTopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack top ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !


!classDefinition: #SentenceFinderByPrefixTest category: #'Stack-Exercise'!
TestCase subclass: #SentenceFinderByPrefixTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 21:37:18'!
test01FinderWithoutSentenceShouldReturnEmptyOnFind
	| emptyFinder |
	
	emptyFinder := SentenceFinderByPrefix with: OOStack new.
	
	self assert: (emptyFinder find: 'something') isEmpty! !

!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 21:36:52'!
test02FinderWithOneSentenceShouldFindPrefixOfIt
	| emptyFinder |
	
	emptyFinder := SentenceFinderByPrefix with: OOStack new.
	
	self assert: (emptyFinder find: 'something') isEmpty! !

!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 21:40:07'!
test03FinderShouldReturnEmptyIfPrefixIsNotPresent
	| emptyFinder |
	
	emptyFinder := SentenceFinderByPrefix with: OOStack new.
	
	self assert: (emptyFinder find: 'something') isEmpty! !


!classDefinition: #Cell category: #'Stack-Exercise'!
Object subclass: #Cell
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!Cell methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 20:09:22'!
element
	^self subclassResponsibility ! !

!Cell methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 20:30:17'!
isEmpty
	^self subclassResponsibility ! !

!Cell methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 20:09:37'!
previous
	^self subclassResponsibility ! !


!classDefinition: #EmptyCell category: #'Stack-Exercise'!
Cell subclass: #EmptyCell
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!EmptyCell methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 21:22:21'!
element
	^self error: OOStack stackEmptyErrorDescription ! !

!EmptyCell methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 20:30:33'!
isEmpty
	^true! !

!EmptyCell methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 21:22:30'!
previous
	^self error: OOStack stackEmptyErrorDescription ! !


!classDefinition: #FullCell category: #'Stack-Exercise'!
Cell subclass: #FullCell
	instanceVariableNames: 'previous element'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!FullCell methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 20:07:25'!
element
	^element! !

!FullCell methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 20:07:41'!
initializeWith: aString over: anUndefinedObject 
	element := aString.
	previous := anUndefinedObject.! !

!FullCell methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 20:30:41'!
isEmpty
	^false! !

!FullCell methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 20:07:55'!
previous
	^previous! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FullCell class' category: #'Stack-Exercise'!
FullCell class
	instanceVariableNames: ''!

!FullCell class methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 20:08:27'!
with: aString over: elElementoDeAbajo
	^self new initializeWith: aString over: elElementoDeAbajo.! !


!classDefinition: #OOStack category: #'Stack-Exercise'!
Object subclass: #OOStack
	instanceVariableNames: 'top size'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStack methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 20:20:19'!
initialize
	size := 0. 
	top := EmptyCell new.! !

!OOStack methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 20:29:38'!
isEmpty
	^ top isEmpty! !

!OOStack methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 19:43:42'!
pop
	| valueOfCurrentTop |
	
	valueOfCurrentTop := top element.
	top := top previous.
	
	^valueOfCurrentTop 
! !

!OOStack methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 20:21:23'!
push: aString 
	top := FullCell with: aString over: top.
	size := size+1! !

!OOStack methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 19:47:08'!
size
	^size ! !

!OOStack methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 19:45:33'!
top
	^top element ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStack class' category: #'Stack-Exercise'!
OOStack class
	instanceVariableNames: ''!

!OOStack class methodsFor: 'error descriptions' stamp: 'fz 9/16/2019 20:23:18'!
stackEmptyErrorDescription
	
	^ 'Stack is empty'! !


!classDefinition: #SentenceFinderByPrefix category: #'Stack-Exercise'!
Object subclass: #SentenceFinderByPrefix
	instanceVariableNames: 'collectionToSearch'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefix methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 21:34:19'!
find: aPrefix
	^OrderedCollection new.! !

!SentenceFinderByPrefix methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 21:26:37'!
initializeWith: aStack

	collectionToSearch := aStack
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SentenceFinderByPrefix class' category: #'Stack-Exercise'!
SentenceFinderByPrefix class
	instanceVariableNames: ''!

!SentenceFinderByPrefix class methodsFor: 'as yet unclassified' stamp: 'fz 9/16/2019 21:28:04'!
with: aStack
	^self new initializeWith: aStack.! !
