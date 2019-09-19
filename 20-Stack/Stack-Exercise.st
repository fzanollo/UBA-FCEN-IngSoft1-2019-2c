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
	instanceVariableNames: 'nonMatchingSentence stackWithOneSentence stackWithMultipleSentences finderEmpty finderOneSentence finderMultipleSentences matchingPrefix nonMatchingPrefixBecauseUppercase nonMatchingPrefixBecauseDifferentLetters aMatchingSentence anotherMatchingSentence'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'fz 9/19/2019 16:20:34'!
test01FinderWithoutSentenceShouldNotReturnMatching
	
	self assert: (finderEmpty find: matchingPrefix) isEmpty! !

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'fz 9/19/2019 16:02:46'!
test02FinderWithOneSentenceShouldFindPrefixOfIt
	|sentencesFound|
	sentencesFound := finderOneSentence find: matchingPrefix.
	
	self assert: sentencesFound size = 1.
	self assert: sentencesFound includes: aMatchingSentence.! !

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'fz 9/19/2019 15:58:38'!
test03FinderShouldReturnEmptyIfPrefixIsNotPresent

	self assert: (finderOneSentence find: nonMatchingPrefixBecauseDifferentLetters) isEmpty! !

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'fz 9/19/2019 16:01:17'!
test04FinderWithMultipleMatchingSentencesShouldReturnAllMatchings

	| sentencesFound |

	sentencesFound := finderMultipleSentences find: matchingPrefix.
	
	self assert: sentencesFound size = 2.
	self assert: sentencesFound includes: anotherMatchingSentence.
	self assert: sentencesFound includes: aMatchingSentence.! !

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'fz 9/19/2019 16:06:50'!
test05FinderWithMatchingSentencesShouldNotReturnNonMatchingSentence

	| sentencesFound |

	sentencesFound := finderMultipleSentences find: matchingPrefix.
	
	self deny: sentencesFound isEmpty.
	self deny: (sentencesFound includes: nonMatchingSentence).! !

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'fz 9/19/2019 16:19:02'!
test06InternalStackIsNotModifiedAfterFind
	| previousStack newStack |
	
	previousStack := finderMultipleSentences stack copy.
	finderMultipleSentences find: matchingPrefix.
	newStack := finderMultipleSentences stack.
	
	self assert: previousStack size = newStack size.
	[previousStack isEmpty] whileFalse: [
		self assert: previousStack top = newStack top.
		previousStack pop.
		newStack pop.
	].! !

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'fz 9/19/2019 16:27:47'!
test07FindWithEmptyPrefixShouldFail

	self 
		should: [finderMultipleSentences find: '']
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: SentenceFinderByPrefix emptyPrefixNotAllowed ].! !

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'fz 9/19/2019 16:31:22'!
test08FindWithPrefixWithSpacesShouldFail

	self 
		should: [finderMultipleSentences find: matchingPrefix, ' ']
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: SentenceFinderByPrefix spacesNotAllowedInPrefix ].! !


!SentenceFinderByPrefixTest methodsFor: 'set up' stamp: 'fz 9/19/2019 16:01:17'!
setUp
	aMatchingSentence := 'something To Find'.
	anotherMatchingSentence := 'something else'.
	nonMatchingSentence := 'this will not match'.
	
	stackWithOneSentence := OOStack new.
	stackWithOneSentence push: aMatchingSentence.
	
	stackWithMultipleSentences := OOStack new.
	stackWithMultipleSentences push: aMatchingSentence.
	stackWithMultipleSentences push: anotherMatchingSentence.
	stackWithMultipleSentences push: nonMatchingSentence.
	
	finderEmpty := SentenceFinderByPrefix with: OOStack new.
	finderOneSentence := SentenceFinderByPrefix with: stackWithOneSentence.
	finderMultipleSentences := SentenceFinderByPrefix with: stackWithMultipleSentences.
	
	matchingPrefix := 'some'.
	nonMatchingPrefixBecauseUppercase := 'Some'.
	nonMatchingPrefixBecauseDifferentLetters := 'same'.! !


!classDefinition: #Cell category: #'Stack-Exercise'!
Object subclass: #Cell
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!Cell methodsFor: 'accesing' stamp: 'fz 9/16/2019 20:09:22'!
element
	^self subclassResponsibility ! !

!Cell methodsFor: 'accesing' stamp: 'fz 9/16/2019 20:09:37'!
previous
	^self subclassResponsibility ! !


!Cell methodsFor: 'testing' stamp: 'fz 9/16/2019 20:30:17'!
isEmpty
	^self subclassResponsibility ! !


!classDefinition: #EmptyCell category: #'Stack-Exercise'!
Cell subclass: #EmptyCell
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!EmptyCell methodsFor: 'accesing' stamp: 'fz 9/16/2019 21:22:21'!
element
	^self error: OOStack stackEmptyErrorDescription ! !

!EmptyCell methodsFor: 'accesing' stamp: 'fz 9/16/2019 21:22:30'!
previous
	^self error: OOStack stackEmptyErrorDescription ! !


!EmptyCell methodsFor: 'testing' stamp: 'fz 9/16/2019 20:30:33'!
isEmpty
	^true! !


!classDefinition: #FullCell category: #'Stack-Exercise'!
Cell subclass: #FullCell
	instanceVariableNames: 'previous element'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!FullCell methodsFor: 'accesing' stamp: 'fz 9/16/2019 20:07:25'!
element
	^element! !

!FullCell methodsFor: 'accesing' stamp: 'fz 9/16/2019 20:07:55'!
previous
	^previous! !


!FullCell methodsFor: 'initialization' stamp: 'fz 9/16/2019 20:07:41'!
initializeWith: aString over: anUndefinedObject 
	element := aString.
	previous := anUndefinedObject.! !


!FullCell methodsFor: 'testing' stamp: 'fz 9/16/2019 20:30:41'!
isEmpty
	^false! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FullCell class' category: #'Stack-Exercise'!
FullCell class
	instanceVariableNames: ''!

!FullCell class methodsFor: 'initialization' stamp: 'fz 9/16/2019 20:08:27'!
with: aString over: elElementoDeAbajo
	^self new initializeWith: aString over: elElementoDeAbajo.! !


!classDefinition: #OOStack category: #'Stack-Exercise'!
Object subclass: #OOStack
	instanceVariableNames: 'top size'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStack methodsFor: 'accesing' stamp: 'fz 9/16/2019 19:45:33'!
top
	^top element ! !


!OOStack methodsFor: 'initialization' stamp: 'fz 9/16/2019 20:20:19'!
initialize
	size := 0. 
	top := EmptyCell new.! !


!OOStack methodsFor: 'testing' stamp: 'fz 9/16/2019 20:29:38'!
isEmpty
	^ top isEmpty! !

!OOStack methodsFor: 'testing' stamp: 'fz 9/16/2019 19:47:08'!
size
	^size ! !


!OOStack methodsFor: 'adding' stamp: 'fz 9/16/2019 20:21:23'!
push: aString 
	top := FullCell with: aString over: top.
	size := size+1! !


!OOStack methodsFor: 'removing' stamp: 'fz 9/19/2019 15:15:55'!
pop
	| valueOfCurrentTop |
	
	valueOfCurrentTop := top element.
	top := top previous.
	size := size -1.
	
	^valueOfCurrentTop 
! !

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

!SentenceFinderByPrefix methodsFor: 'searching' stamp: 'fz 9/19/2019 16:25:04'!
find: aPrefix
	|collectionOfFoundSentences myBreakableStack|
	
	self isValid: aPrefix.
	collectionOfFoundSentences := Bag new.
	
	myBreakableStack := collectionToSearch copy.
	
	[myBreakableStack isEmpty] whileFalse: [
		(myBreakableStack top beginsWith: aPrefix) ifTrue: [
			collectionOfFoundSentences add: myBreakableStack top.
		]. 
		myBreakableStack pop.
	].
	
	^ collectionOfFoundSentences .! !

!SentenceFinderByPrefix methodsFor: 'searching' stamp: 'fz 9/19/2019 16:29:39'!
isValid: aPrefix
	(aPrefix isEmpty) ifTrue: [^self error: self class emptyPrefixNotAllowed].
	
	(aPrefix includes: $ ) ifTrue: [^self error: self class spacesNotAllowedInPrefix].! !


!SentenceFinderByPrefix methodsFor: 'initializing' stamp: 'fz 9/16/2019 21:26:37'!
initializeWith: aStack

	collectionToSearch := aStack
! !


!SentenceFinderByPrefix methodsFor: 'for testing only' stamp: 'fz 9/19/2019 16:11:25'!
stack
	^collectionToSearch ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SentenceFinderByPrefix class' category: #'Stack-Exercise'!
SentenceFinderByPrefix class
	instanceVariableNames: ''!

!SentenceFinderByPrefix class methodsFor: 'initialization' stamp: 'fz 9/16/2019 21:28:04'!
with: aStack
	^self new initializeWith: aStack.! !


!SentenceFinderByPrefix class methodsFor: 'error descriptions' stamp: 'fz 9/19/2019 16:28:19'!
emptyPrefixNotAllowed
	^'empty prefix not allowed on find'! !

!SentenceFinderByPrefix class methodsFor: 'error descriptions' stamp: 'fz 9/19/2019 16:32:01'!
spacesNotAllowedInPrefix
	^'spaces not allowed on prefix to find'.! !
