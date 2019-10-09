!classDefinition: #MarsRoverTest category: #MarsRover!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: 'north south west east defaultStartingPoint defaultFacingDirection defaultRover'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRoverTest methodsFor: 'tests' stamp: 'fz 10/8/2019 17:20:19'!
test01WithNoInstructionsStaysInPlace
	
	defaultRover do: ''.
	
	self assert: defaultRover hasPosition: defaultStartingPoint andDirection: defaultFacingDirection.! !

!MarsRoverTest methodsFor: 'tests' stamp: 'fz 10/8/2019 17:24:25'!
test02WithFMovesForward

	defaultRover do: 'f'.
	
	self assert: defaultRover hasPosition: defaultStartingPoint +(0@1) andDirection: defaultFacingDirection.! !

!MarsRoverTest methodsFor: 'tests' stamp: 'fz 10/8/2019 17:41:47'!
test03WithBMovesBackward
	
	defaultRover do: 'b'.
	
	self assert: defaultRover hasPosition: defaultStartingPoint  + (0@-1) andDirection: defaultFacingDirection. ! !

!MarsRoverTest methodsFor: 'tests' stamp: 'fz 10/8/2019 17:23:15'!
test04WithRRotatesRightward
	
	| myRobot |
	myRobot := MarsRover startingAt: 0@0 facing: north.
	
	myRobot do: 'r'.
	
	self assert: myRobot hasPosition: 0@0 andDirection: east.
	! !

!MarsRoverTest methodsFor: 'tests' stamp: 'fz 10/8/2019 17:23:26'!
test05WithLRotatesLeftward
	
	| myRobot |
	myRobot := MarsRover startingAt: 0@0 facing: north.
	
	myRobot do: 'l'.
	
	self assert: myRobot hasPosition: 0@0 andDirection: west.! !

!MarsRoverTest methodsFor: 'tests' stamp: 'fz 10/8/2019 17:23:34'!
test06WithNFsMovesForwardNTimes
	
	| myRobot |
	myRobot := MarsRover startingAt: 2@2 facing: north.
	
	myRobot do: 'ff'.
	
	self assert: myRobot hasPosition: 2@4 andDirection: north.! !

!MarsRoverTest methodsFor: 'tests' stamp: 'fz 10/8/2019 17:23:42'!
test07CanMoveBackwardsFacingEast
	
	| myRobot |
	myRobot := MarsRover startingAt: 3@2 facing: east.
	
	myRobot do: 'bbb'.
	
	self assert: myRobot hasPosition: 0@2 andDirection: east.! !

!MarsRoverTest methodsFor: 'tests' stamp: 'fz 10/8/2019 17:23:51'!
test08CanRotateMultipleTimes
	
	| myRobot |
	myRobot := MarsRover startingAt: 3@2 facing: north.
	
	myRobot do: 'rrr'.
	
	self assert: myRobot hasPosition: 3@2 andDirection: west.! !

!MarsRoverTest methodsFor: 'tests' stamp: 'fz 10/8/2019 19:19:51'!
test09WrongInstructionFails

	|invalidInstruction|
	
	invalidInstruction := 'x'.
	
	self should: [defaultRover do: invalidInstruction.]
		raise: Error 
		withExceptionDo: [:anError | self assert: anError messageText equals: (MarsRover wrongInstructionErrorMessageWith: invalidInstruction)].! !


!MarsRoverTest methodsFor: 'assertions' stamp: 'fz 10/3/2019 21:24:17'!
assert: myRobot hasPosition: aPosition andDirection: aDirection	
	self assert: myRobot position equals: aPosition.
	self assert: myRobot direction equals: aDirection. ! !


!MarsRoverTest methodsFor: 'setUp' stamp: 'fz 10/8/2019 17:19:52'!
setUp
	north := North new.
	south := South new.
	west := West new.
	east := East new.
	
	defaultStartingPoint := 0@0.
	defaultFacingDirection := north.
	defaultRover := MarsRover startingAt: defaultStartingPoint facing: defaultFacingDirection.
	! !


!classDefinition: #CardinalDirection category: #MarsRover!
Object subclass: #CardinalDirection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!CardinalDirection methodsFor: 'directions' stamp: 'fz 10/8/2019 18:54:39'!
left

	^ self subclassResponsibility.! !

!CardinalDirection methodsFor: 'directions' stamp: 'fz 10/8/2019 18:54:46'!
right

	^ self subclassResponsibility.! !


!classDefinition: #East category: #MarsRover!
CardinalDirection subclass: #East
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!East methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:54:39'!
left

	^ North new.! !

!East methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:54:46'!
right

	^ South new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'East class' category: #MarsRover!
East class
	instanceVariableNames: 'uniqueInstance'!

!East class methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:51:48'!
initialize

	uniqueInstance := self basicNew ! !

!East class methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:43:41'!
new
	^ uniqueInstance! !


!classDefinition: #North category: #MarsRover!
CardinalDirection subclass: #North
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!North methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:54:39'!
left

	^ West new.! !

!North methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:54:46'!
right

	^ East new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'North class' category: #MarsRover!
North class
	instanceVariableNames: 'uniqueInstance'!

!North class methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:51:52'!
initialize

	uniqueInstance := self basicNew ! !

!North class methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:43:16'!
new
	uniqueInstance isNil ifTrue: [uniqueInstance := super new].
	^ uniqueInstance! !


!classDefinition: #South category: #MarsRover!
CardinalDirection subclass: #South
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!South methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:54:39'!
left

	^ East new.! !

!South methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:54:46'!
right

	^ West new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'South class' category: #MarsRover!
South class
	instanceVariableNames: 'uniqueInstance'!

!South class methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:51:57'!
initialize

	uniqueInstance := self basicNew ! !

!South class methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:43:22'!
new
	uniqueInstance isNil ifTrue: [uniqueInstance := super new].
	^ uniqueInstance! !


!classDefinition: #West category: #MarsRover!
CardinalDirection subclass: #West
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!West methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:54:39'!
left

	^ South new.! !

!West methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:54:46'!
right

	^ North new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'West class' category: #MarsRover!
West class
	instanceVariableNames: 'uniqueInstance'!

!West class methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:52:00'!
initialize

	uniqueInstance := self basicNew ! !

!West class methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:43:29'!
new
	uniqueInstance isNil ifTrue: [uniqueInstance := super new].
	^ uniqueInstance! !


!classDefinition: #MarsRover category: #MarsRover!
Object subclass: #MarsRover
	instanceVariableNames: 'position direction validInstructions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRover methodsFor: 'initialization' stamp: 'MD 10/9/2019 18:44:34'!
initializeStartingAt: aPosition facing: aDirection

	position := aPosition.
	direction := aDirection.
	
	validInstructions := Dictionary new.
	validInstructions add: $f-> [self move: $f.]; add: $b-> [self move: $b.];
					 add: $r-> [direction := direction right]; add: $l -> [direction := direction left].
	! !


!MarsRover methodsFor: 'instructions' stamp: 'MD 10/9/2019 18:52:37'!
do: anInstructions
	
	anInstructions do:[:instruction | 
		(validInstructions includesKey: instruction) ifFalse:[self error: (self class wrongInstructionErrorMessageWith: instruction)].
		(validInstructions at: instruction) value.
]! !


!MarsRover methodsFor: 'testing' stamp: 'fz 10/3/2019 21:13:18'!
direction
	^direction.! !

!MarsRover methodsFor: 'testing' stamp: 'fz 10/3/2019 21:04:26'!
position
	^position! !


!MarsRover methodsFor: 'private' stamp: 'fz 10/8/2019 17:25:51'!
move: forwardOrBackward
	|multiplier|
	
	(forwardOrBackward = $f) ifTrue:[multiplier := 1].
	(forwardOrBackward = $b) ifTrue:[multiplier := -1].
	
	(direction = North new) ifTrue: [position := position + (0@1*multiplier)].
	(direction = South new) ifTrue: [position := position + (0@-1*multiplier)].
	(direction = West new) ifTrue: [position := position + (-1@0*multiplier)].
	(direction = East new) ifTrue: [position := position + (1@0*multiplier)].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: #MarsRover!
MarsRover class
	instanceVariableNames: ''!

!MarsRover class methodsFor: 'instance creation' stamp: 'fz 10/3/2019 21:00:26'!
startingAt: aPosition facing: aDirection
	^self new initializeStartingAt: aPosition facing: aDirection! !


!MarsRover class methodsFor: 'error messages' stamp: 'fz 10/8/2019 19:19:03'!
wrongInstructionErrorMessageWith: anInvalidInstruction
	^ anInvalidInstruction asString, ' is not a valid instruction'! !

East initialize!
North initialize!
South initialize!
West initialize!