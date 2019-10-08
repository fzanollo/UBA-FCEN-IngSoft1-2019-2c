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

!CardinalDirection methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 17:09:48'!
rotateLeft

	^ self subclassResponsibility.! !

!CardinalDirection methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 17:09:53'!
rotateRight

	^ self subclassResponsibility.! !


!classDefinition: #East category: #MarsRover!
CardinalDirection subclass: #East
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!East methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 17:13:34'!
rotateLeft

	^ North new.! !

!East methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 17:14:18'!
rotateRight

	^ South new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'East class' category: #MarsRover!
East class
	instanceVariableNames: 'soleInstance'!

!East class methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 17:40:36'!
new
	soleInstance isNil ifTrue: [soleInstance := super new].
	^ soleInstance! !


!classDefinition: #North category: #MarsRover!
CardinalDirection subclass: #North
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!North methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 17:13:47'!
rotateLeft

	^ West new.! !

!North methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 17:14:27'!
rotateRight

	^ East new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'North class' category: #MarsRover!
North class
	instanceVariableNames: 'soleInstance'!

!North class methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 17:41:15'!
new
	soleInstance isNil ifTrue: [soleInstance := super new].
	^ soleInstance! !


!classDefinition: #South category: #MarsRover!
CardinalDirection subclass: #South
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!South methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 17:13:55'!
rotateLeft

	^ East new.! !

!South methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 17:14:35'!
rotateRight

	^ West new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'South class' category: #MarsRover!
South class
	instanceVariableNames: 'soleInstance'!

!South class methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 17:41:22'!
new
	soleInstance isNil ifTrue: [soleInstance := super new].
	^ soleInstance! !


!classDefinition: #West category: #MarsRover!
CardinalDirection subclass: #West
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!West methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 17:14:04'!
rotateLeft

	^ South new.! !

!West methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 17:14:43'!
rotateRight

	^ North new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'West class' category: #MarsRover!
West class
	instanceVariableNames: 'soleInstance'!

!West class methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 17:41:27'!
new
	soleInstance isNil ifTrue: [soleInstance := super new].
	^ soleInstance! !


!classDefinition: #MarsRover category: #MarsRover!
Object subclass: #MarsRover
	instanceVariableNames: 'position direction'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRover methodsFor: 'initialization' stamp: 'fz 10/3/2019 21:01:18'!
initializeStartingAt: aPosition facing: aDirection

	position := aPosition.
	direction := aDirection.! !


!MarsRover methodsFor: 'instructions' stamp: 'fz 10/8/2019 17:15:51'!
do: anInstructions

	anInstructions do:[:instruction | 
		(instruction = $f or: [instruction = $b]) ifTrue: [
			self move: instruction.
		].
		instruction = $r ifTrue: [ direction := direction rotateRight].
		instruction = $l ifTrue: [direction := direction rotateLeft ].
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
