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

!MarsRoverTest methodsFor: 'tests' stamp: 'MD 10/9/2019 19:20:54'!
test04WithRRotatesRightward
	
	defaultRover do: 'r'.
	
	self assert: defaultRover hasPosition: defaultStartingPoint andDirection: east.
	! !

!MarsRoverTest methodsFor: 'tests' stamp: 'MD 10/9/2019 19:21:14'!
test05WithLRotatesLeftward
	
	defaultRover do: 'l'.
	
	self assert: defaultRover hasPosition: defaultStartingPoint andDirection: west.! !

!MarsRoverTest methodsFor: 'tests' stamp: 'fz 10/8/2019 17:23:34'!
test06WithNFsMovesForwardNTimes
	
	| myRobot |
	myRobot := MarsRover startingAt: 2@2 facing: north.
	
	myRobot do: 'ff'.
	
	self assert: myRobot hasPosition: 2@4 andDirection: north.! !

!MarsRoverTest methodsFor: 'tests' stamp: 'MD 10/10/2019 13:09:57'!
test07CanMoveBackwardsFacingEast
	
	"este test nos ayudó a ver que hay que tener en cuenta la dirección del mars rover al moverse. Ahora, una vez notado esto, generalizamos a todas las direcciones, ya que nos pareció que el caso a testear es el de mirar en otra dirección, en cambio cada dirección en particular es el 'dato'  "
	
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

!MarsRoverTest methodsFor: 'tests' stamp: 'MD 10/9/2019 19:18:22'!
test10ComplexInstructionsExample

	"este test paso de una, pero nos parece una buena idea despues de haber testeado todos los casos chicos hacer al menos un test mas complejo como para  mezclar todas las cosas"
	
	| myRobot |
	myRobot := MarsRover startingAt: -1@-2 facing: west.
	
	myRobot do: 'rfffllflbblf'.
	
	self assert: myRobot hasPosition: -3@1 andDirection: north.! !


!MarsRoverTest methodsFor: 'assertions' stamp: 'fz 10/3/2019 21:24:17'!
assert: myRobot hasPosition: aPosition andDirection: aDirection	
	self assert: myRobot position equals: aPosition.
	self assert: myRobot direction equals: aDirection. ! !


!MarsRoverTest methodsFor: 'setUp' stamp: 'MD 10/9/2019 19:08:02'!
setUp
	north := MarsRoverNorth new.
	south := MarsRoverSouth new.
	west := MarsRoverWest new.
	east := MarsRoverEast new.
	
	defaultStartingPoint := 0@0.
	defaultFacingDirection := north.
	defaultRover := MarsRover startingAt: defaultStartingPoint facing: defaultFacingDirection.
	! !


!classDefinition: #MarsRover category: #MarsRover!
Object subclass: #MarsRover
	instanceVariableNames: 'position direction validInstructions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRover methodsFor: 'initialization' stamp: 'MD 10/10/2019 13:10:53'!
initializeStartingAt: aPosition facing: aDirection

	position := aPosition.
	direction := aDirection.
	
	validInstructions := Dictionary new.
	validInstructions add: $f-> [position := position+direction forwardsDisplacement.]; 
					add: $b-> [position := position+direction backwardsDisplacement.];
					add: $r-> [direction := direction right]; 
					add: $l -> [direction := direction left].
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


!classDefinition: #MarsRoverCardinalDirection category: #MarsRover!
Object subclass: #MarsRoverCardinalDirection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRoverCardinalDirection methodsFor: 'directions' stamp: 'fz 10/8/2019 18:54:39'!
left

	^ self subclassResponsibility.! !

!MarsRoverCardinalDirection methodsFor: 'directions' stamp: 'fz 10/8/2019 18:54:46'!
right

	^ self subclassResponsibility.! !


!MarsRoverCardinalDirection methodsFor: 'displacements' stamp: 'MD 10/9/2019 19:09:24'!
backwardsDisplacement

	^self subclassResponsibility.! !

!MarsRoverCardinalDirection methodsFor: 'displacements' stamp: 'MD 10/9/2019 19:09:20'!
forwardsDisplacement

	^self subclassResponsibility.! !


!classDefinition: #MarsRoverEast category: #MarsRover!
MarsRoverCardinalDirection subclass: #MarsRoverEast
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRoverEast methodsFor: 'directions' stamp: 'MD 10/9/2019 19:07:52'!
left

	^ MarsRoverNorth new.! !

!MarsRoverEast methodsFor: 'directions' stamp: 'MD 10/9/2019 19:07:57'!
right

	^ MarsRoverSouth new.! !


!MarsRoverEast methodsFor: 'displacements' stamp: 'MD 10/9/2019 19:12:37'!
backwardsDisplacement

	^-1@0! !

!MarsRoverEast methodsFor: 'displacements' stamp: 'MD 10/9/2019 19:12:29'!
forwardsDisplacement

	^1@0! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverEast class' category: #MarsRover!
MarsRoverEast class
	instanceVariableNames: 'uniqueInstance'!

!MarsRoverEast class methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:51:48'!
initialize

	uniqueInstance := self basicNew ! !

!MarsRoverEast class methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:43:41'!
new
	^ uniqueInstance! !


!classDefinition: #MarsRoverNorth category: #MarsRover!
MarsRoverCardinalDirection subclass: #MarsRoverNorth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRoverNorth methodsFor: 'directions' stamp: 'MD 10/9/2019 19:08:02'!
left

	^ MarsRoverWest new.! !

!MarsRoverNorth methodsFor: 'directions' stamp: 'MD 10/9/2019 19:07:32'!
right

	^ MarsRoverEast new.! !


!MarsRoverNorth methodsFor: 'displacements' stamp: 'MD 10/9/2019 19:12:00'!
backwardsDisplacement
	^0@-1! !

!MarsRoverNorth methodsFor: 'displacements' stamp: 'MD 10/9/2019 19:11:54'!
forwardsDisplacement

	^0@1! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverNorth class' category: #MarsRover!
MarsRoverNorth class
	instanceVariableNames: 'uniqueInstance'!

!MarsRoverNorth class methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:51:52'!
initialize

	uniqueInstance := self basicNew ! !

!MarsRoverNorth class methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:43:16'!
new
	uniqueInstance isNil ifTrue: [uniqueInstance := super new].
	^ uniqueInstance! !


!classDefinition: #MarsRoverSouth category: #MarsRover!
MarsRoverCardinalDirection subclass: #MarsRoverSouth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRoverSouth methodsFor: 'directions' stamp: 'MD 10/9/2019 19:07:32'!
left

	^ MarsRoverEast new.! !

!MarsRoverSouth methodsFor: 'directions' stamp: 'MD 10/9/2019 19:08:02'!
right

	^ MarsRoverWest new.! !


!MarsRoverSouth methodsFor: 'displacements' stamp: 'MD 10/9/2019 19:12:19'!
backwardsDisplacement

	^0@1! !

!MarsRoverSouth methodsFor: 'displacements' stamp: 'MD 10/9/2019 19:12:15'!
forwardsDisplacement

	^0@-1! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverSouth class' category: #MarsRover!
MarsRoverSouth class
	instanceVariableNames: 'uniqueInstance'!

!MarsRoverSouth class methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:51:57'!
initialize

	uniqueInstance := self basicNew ! !

!MarsRoverSouth class methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:43:22'!
new
	uniqueInstance isNil ifTrue: [uniqueInstance := super new].
	^ uniqueInstance! !


!classDefinition: #MarsRoverWest category: #MarsRover!
MarsRoverCardinalDirection subclass: #MarsRoverWest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRoverWest methodsFor: 'directions' stamp: 'MD 10/9/2019 19:07:57'!
left

	^ MarsRoverSouth new.! !

!MarsRoverWest methodsFor: 'directions' stamp: 'MD 10/9/2019 19:07:52'!
right

	^ MarsRoverNorth new.! !


!MarsRoverWest methodsFor: 'displacements' stamp: 'MD 10/9/2019 19:12:50'!
backwardsDisplacement

	^1@0! !

!MarsRoverWest methodsFor: 'displacements' stamp: 'MD 10/9/2019 19:12:46'!
forwardsDisplacement

	^-1@0! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverWest class' category: #MarsRover!
MarsRoverWest class
	instanceVariableNames: 'uniqueInstance'!

!MarsRoverWest class methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:52:00'!
initialize

	uniqueInstance := self basicNew ! !

!MarsRoverWest class methodsFor: 'as yet unclassified' stamp: 'fz 10/8/2019 18:43:29'!
new
	uniqueInstance isNil ifTrue: [uniqueInstance := super new].
	^ uniqueInstance! !

MarsRoverEast initialize!
MarsRoverNorth initialize!
MarsRoverSouth initialize!
MarsRoverWest initialize!