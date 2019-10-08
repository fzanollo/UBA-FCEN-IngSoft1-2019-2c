!classDefinition: #MarsRoverTest category: #MarsRover!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRoverTest methodsFor: 'tests' stamp: 'fz 10/3/2019 21:25:12'!
test01WithNoInstructionsStaysInPlace
	
	| myRobot |
	myRobot := MarsRover startingAt: 0@0 facing: 'N'.
	
	myRobot do: ''.
	
	self assert: myRobot hasPosition: 0@0 andDirection: 'N'.! !

!MarsRoverTest methodsFor: 'tests' stamp: 'fz 10/3/2019 21:25:26'!
test02WithFMovesForward
	
	| myRobot |
	myRobot := MarsRover startingAt: 0@0 facing: 'N'.
	
	myRobot do: 'f'.
	
	self assert: myRobot hasPosition: 0@1 andDirection: 'N'.! !

!MarsRoverTest methodsFor: 'tests' stamp: 'fz 10/3/2019 21:25:36'!
test03WithBMovesBackward
	
	| myRobot |
	myRobot := MarsRover startingAt: 0@0 facing: 'N'.
	
	myRobot do: 'b'.
	
	self assert: myRobot hasPosition: 0@-1 andDirection: 'N'. ! !

!MarsRoverTest methodsFor: 'tests' stamp: 'fz 10/3/2019 21:25:46'!
test04WithRRotatesRightward
	
	| myRobot |
	myRobot := MarsRover startingAt: 0@0 facing: 'N'.
	
	myRobot do: 'r'.
	
	self assert: myRobot hasPosition: 0@0 andDirection: 'E'.
	! !

!MarsRoverTest methodsFor: 'tests' stamp: 'fz 10/3/2019 21:25:53'!
test05WithLRotatesLeftward
	
	| myRobot |
	myRobot := MarsRover startingAt: 0@0 facing: 'N'.
	
	myRobot do: 'l'.
	
	self assert: myRobot hasPosition: 0@0 andDirection: 'W'.! !

!MarsRoverTest methodsFor: 'tests' stamp: 'fz 10/3/2019 21:29:37'!
test06WithNFsMovesForwardNTimes
	
	| myRobot |
	myRobot := MarsRover startingAt: 2@2 facing: 'N'.
	
	myRobot do: 'ff'.
	
	self assert: myRobot hasPosition: 2@4 andDirection: 'N'.! !

!MarsRoverTest methodsFor: 'tests' stamp: 'fz 10/8/2019 16:08:36'!
test07CanMoveBackwardsFacingEast
	
	| myRobot |
	myRobot := MarsRover startingAt: 3@2 facing: 'E'.
	
	myRobot do: 'bbb'.
	
	self assert: myRobot hasPosition: 0@2 andDirection: 'E'.! !


!MarsRoverTest methodsFor: 'assertions' stamp: 'fz 10/3/2019 21:24:17'!
assert: myRobot hasPosition: aPosition andDirection: aDirection	
	self assert: myRobot position equals: aPosition.
	self assert: myRobot direction equals: aDirection. ! !


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


!MarsRover methodsFor: 'instructions' stamp: 'fz 10/8/2019 16:29:13'!
do: anInstructions

	anInstructions do:[:instruction | 
		(instruction = $f or: [instruction = $b]) ifTrue: [
			self move: instruction.
		].
		instruction = $r ifTrue: [direction := 'E'].
		instruction = $l ifTrue: [direction := 'W']
	].! !


!MarsRover methodsFor: 'testing' stamp: 'fz 10/3/2019 21:13:18'!
direction
	^direction.! !

!MarsRover methodsFor: 'testing' stamp: 'fz 10/3/2019 21:04:26'!
position
	^position! !


!MarsRover methodsFor: 'private' stamp: 'fz 10/8/2019 16:30:26'!
move: forwardOrBackward
	|multiplier|
	
	(forwardOrBackward = $f) ifTrue:[multiplier := 1].
	(forwardOrBackward = $b) ifTrue:[multiplier := -1].
	
	(direction = 'N') ifTrue: [position := position + (0@1*multiplier)].
	(direction = 'S') ifTrue: [position := position + (0@-1*multiplier)].
	(direction = 'W') ifTrue: [position := position + (-1@0*multiplier)].
	(direction = 'E') ifTrue: [position := position + (1@0*multiplier)].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: #MarsRover!
MarsRover class
	instanceVariableNames: ''!

!MarsRover class methodsFor: 'instance creation' stamp: 'fz 10/3/2019 21:00:26'!
startingAt: aPosition facing: aDirection
	^self new initializeStartingAt: aPosition facing: aDirection! !
