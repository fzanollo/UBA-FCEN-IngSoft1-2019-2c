!classDefinition: #TerniLapilliTest category: #TerniLapilli!
TestCase subclass: #TerniLapilliTest
	instanceVariableNames: 'juegoNuevo juegoCon6Fichas'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!TerniLapilliTest methodsFor: 'setUp' stamp: 'fz 10/16/2019 22:15:11'!
setUp

	juegoNuevo := TerniLapilli new.
	
	juegoCon6Fichas := TerniLapilli new.
	juegoCon6Fichas placeXAt: 0@0.
	juegoCon6Fichas placeOAt: 0@1.
	juegoCon6Fichas placeXAt: 1@0.
	juegoCon6Fichas placeOAt: 1@1.
	juegoCon6Fichas placeXAt: 2@2.
	juegoCon6Fichas placeOAt: 0@2.! !


!TerniLapilliTest methodsFor: 'tests 1- cambios de turno' stamp: 'MD 10/10/2019 17:31:46'!
test01InicialmenteJuegaX
	
	self assert: juegoNuevo isPlayingX.
	! !

!TerniLapilliTest methodsFor: 'tests 1- cambios de turno' stamp: 'MD 10/10/2019 17:29:03'!
test02DespuesDeXJuegaO

	juegoNuevo := TerniLapilli new.
	
	juegoNuevo  pasaTurno.
	
	self assert: juegoNuevo  isPlayingO.
	! !

!TerniLapilliTest methodsFor: 'tests 1- cambios de turno' stamp: 'MD 10/10/2019 19:55:55'!
test03DespuesDeOJuegaX

	juegoNuevo  pasaTurno.
	juegoNuevo  pasaTurno.
	
	self assert: juegoNuevo isPlayingX.
	! !


!TerniLapilliTest methodsFor: 'tests 2- puesta de fichas' stamp: 'fz 10/15/2019 21:20:20'!
test04SePuedePonerUnaFichaDentroDelTablero

	juegoNuevo placeXAt: 0@0.
	
	self assert: juegoNuevo isPlayingO.
	self assert: (juegoNuevo isXAt: 0@0).
	! !

!TerniLapilliTest methodsFor: 'tests 2- puesta de fichas' stamp: 'fz 10/15/2019 21:20:20'!
test05NoPuedoPonerFichaFueraDelTablero

	self should: [juegoNuevo placeXAt: -1@0]
		raise: Error 
		withExceptionDo: [:anError | self assert: anError messageText equals: (TerniLapilli cannotPlacePieceOutsideBoardErrorMessageWith: -1@0)].
	
	
	
	! !

!TerniLapilliTest methodsFor: 'tests 2- puesta de fichas' stamp: 'fz 10/15/2019 21:19:53'!
test06NoPuedePonerFichaQuienNoJuega
	
	self should: [juegoNuevo placeOAt: 0@0.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotPlayOutOfTurnErrorMessage.
							self deny: (juegoNuevo isOAt: 0@0)].
	
	! !

!TerniLapilliTest methodsFor: 'tests 2- puesta de fichas' stamp: 'fz 10/15/2019 21:20:20'!
test07SePuedenPonerHasta6Fichas
			
	self should: [juegoCon6Fichas placeXAt: 2@1]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotPlaceMoreThan6PiecesOnBoardErrorMessage.
							self deny: (juegoCon6Fichas isXAt: 2@1)].! !

!TerniLapilliTest methodsFor: 'tests 2- puesta de fichas' stamp: 'fz 10/15/2019 21:20:20'!
test08NoSePuedePonerFichaEnPosicionOcupada
	
	juegoNuevo placeXAt: 0@0.
	
	self should: [juegoNuevo placeOAt: 0@0]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotPlaceAPieceOnAnOccupiedPositionErrorMessage.
							self deny: (juegoNuevo isOAt: 0@0)].! !


!TerniLapilliTest methodsFor: 'tests 3- movida de fichas' stamp: 'MD 10/15/2019 17:43:47'!
test09DespuesDe6FichasXPuedeMoverUnaSuya
	
	juegoCon6Fichas moveXFrom: 2@2 to: 2@1.
	
	self deny: (juegoCon6Fichas isXAt: 2@2).
	self assert: (juegoCon6Fichas isXAt: 2@1).
	! !

!TerniLapilliTest methodsFor: 'tests 3- movida de fichas' stamp: 'MD 10/15/2019 17:43:47'!
test10NoSePuedeMoverFichasDeOtroJugador
	
	self should: [juegoCon6Fichas moveXFrom: 0@2 to: 1@2.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotMoveTheOtherPlayersPiecesErrorMessage.
							self deny: (juegoCon6Fichas isXAt: 1@2).
							self deny: (juegoCon6Fichas isOAt: 1@2).
							self assert: (juegoCon6Fichas isOAt: 0@2)].! !

!TerniLapilliTest methodsFor: 'tests 3- movida de fichas' stamp: 'MD 10/15/2019 17:43:47'!
test11NoSePuedeMoverUnaFichaQueNoExiste
	
	self should: [juegoCon6Fichas moveXFrom: 2@1 to: 2@0.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotMoveNonExistingPieceErrorMessage.
							self deny: (juegoCon6Fichas isXAt: 2@0).
							self deny: (juegoCon6Fichas isXAt: 2@1)].
						
						
	! !

!TerniLapilliTest methodsFor: 'tests 3- movida de fichas' stamp: 'MD 10/15/2019 17:43:47'!
test12NoSePuedeMoverUnaFichaAfueraDelTablero
	
	self should: [juegoCon6Fichas moveXFrom: 2@2 to: 3@2.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: (TerniLapilli cannotPlacePieceOutsideBoardErrorMessageWith: 3@2).
							self assert: (juegoCon6Fichas isXAt: 2@2)].
						
	! !

!TerniLapilliTest methodsFor: 'tests 3- movida de fichas' stamp: 'MD 10/15/2019 17:43:47'!
test13NoSePuedeMoverUnaFichaAUnLugarOcupado
	
	self should: [juegoCon6Fichas moveXFrom: 1@0 to: 1@1.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotPlaceAPieceOnAnOccupiedPositionErrorMessage.
							self assert: (juegoCon6Fichas isXAt: 1@0).
							self assert: (juegoCon6Fichas isOAt: 1@1)].
				
	! !

!TerniLapilliTest methodsFor: 'tests 3- movida de fichas' stamp: 'MD 10/15/2019 17:43:37'!
test14NoSePuedeMoverUnaFichaFueraDeTurno
	
	self should: [juegoCon6Fichas moveOFrom: 1@1 to: 1@2.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotPlayOutOfTurnErrorMessage.
							self deny: (juegoCon6Fichas isOAt: 1@2).
							self assert: (juegoCon6Fichas isOAt: 1@1)].
				
	! !

!TerniLapilliTest methodsFor: 'tests 3- movida de fichas' stamp: 'fz 10/15/2019 21:20:20'!
test15NoSePuedeMoverUnaFichaAntesDeColocar6Fichas
	
	juegoNuevo placeXAt: 0@0.
	juegoNuevo placeOAt: 2@0.	
	
	self should: [juegoNuevo moveXFrom: 0@0 to: 0@1.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotMovePiecesBeforeSixArePlacedErrorMessage.
							self deny: (juegoNuevo isXAt: 0@1).
							self assert: (juegoNuevo isXAt: 0@0)].
				
	! !


!TerniLapilliTest methodsFor: 'tests 4- topologia del tablero' stamp: 'fz 10/16/2019 21:02:22'!
test16NoSePuedeMoverUnaFichaAMasDeUnoDeDistancia
	
	self should: [juegoCon6Fichas moveXFrom: 2@2 to: 2@0.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotMoveOutsideOfNeighboursErrorMessage.
							self deny: (juegoCon6Fichas isXAt: 2@0).
							self assert: (juegoCon6Fichas isXAt: 2@2)].
				
	! !


!classDefinition: #TerniLapilli category: #TerniLapilli!
Object subclass: #TerniLapilli
	instanceVariableNames: 'tablero piezasEnJuego state'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!TerniLapilli methodsFor: 'error checking' stamp: 'fz 10/16/2019 22:32:53'!
checkForLegalPlace: aPosition

	((aPosition x between: 0 and: 2) and: [aPosition y between: 0 and: 2]) ifFalse: [self error: (self class cannotPlacePieceOutsideBoardErrorMessageWith: aPosition)].
	
	(tablero at: aPosition) checkIfCanPlacePieceHere.
! !


!TerniLapilli methodsFor: 'initialization' stamp: 'fz 10/16/2019 22:05:15'!
initialize

	state := PlacingPhaseX new.
	piezasEnJuego := 0.
	
	tablero := Dictionary new.
	tablero add: 0@0 -> TerniLapilliPositionEmpty new; 
			add: 0@1 -> TerniLapilliPositionEmpty new;
			add: 0@2 -> TerniLapilliPositionEmpty new;
			add: 1@0 -> TerniLapilliPositionEmpty new;
			add: 1@1 -> TerniLapilliPositionEmpty new;
			add: 1@2 -> TerniLapilliPositionEmpty new;
			add: 2@0 -> TerniLapilliPositionEmpty new;
			add: 2@1 -> TerniLapilliPositionEmpty new;
			add: 2@2 -> TerniLapilliPositionEmpty new.
			! !


!TerniLapilli methodsFor: 'moving pieces' stamp: 'fz 10/16/2019 22:27:28'!
moveOFrom: previousPosition to: newPosition

	state moveOFrom: previousPosition to: newPosition on: self.! !

!TerniLapilli methodsFor: 'moving pieces' stamp: 'fz 10/16/2019 22:21:13'!
moveXFrom: previousPosition to: newPosition
	
	state moveXFrom: previousPosition to: newPosition on: self.! !


!TerniLapilli methodsFor: 'place pieces' stamp: 'fz 10/16/2019 22:13:22'!
placeOAt: aPosition 
	
	state placeOAt: aPosition on: self.! !

!TerniLapilli methodsFor: 'place pieces' stamp: 'fz 10/16/2019 22:09:36'!
placeXAt: aPosition

	state placeXAt: aPosition on: self.! !


!TerniLapilli methodsFor: 'position testing' stamp: 'MD 10/16/2019 18:54:52'!
isOAt: aPosition
	^(tablero at: aPosition) isO.
	! !

!TerniLapilli methodsFor: 'position testing' stamp: 'MD 10/16/2019 18:55:08'!
isXAt: aPosition
	^(tablero at: aPosition) isX.
	! !


!TerniLapilli methodsFor: 'turn testing' stamp: 'fz 10/16/2019 22:04:18'!
isPlayingO

	^ state isPlayingO.! !

!TerniLapilli methodsFor: 'turn testing' stamp: 'fz 10/16/2019 22:04:18'!
isPlayingX

	^ state isPlayingX.! !


!TerniLapilli methodsFor: 'private' stamp: 'fz 10/16/2019 22:32:53'!
at: aPosition place: aPiece
	self checkForLegalPlace: aPosition.

	tablero at: aPosition put: aPiece.
	piezasEnJuego := piezasEnJuego +1.
	
	state := state nextStateFor: self.! !

!TerniLapilli methodsFor: 'private' stamp: 'fz 10/16/2019 22:32:53'!
movePieceFrom: previousPosition to: newPosition
	|piece|
	
	self checkForLegalPlace: newPosition.
	(previousPosition dist: newPosition) > 1 ifTrue:[self error: self class cannotMoveOutsideOfNeighboursErrorMessage].
	
	piece := tablero at: previousPosition.
	
	tablero at: previousPosition put: TerniLapilliPositionEmpty new.
	
	tablero at: newPosition put: piece.
	
	state := state nextStateFor: self.! !

!TerniLapilli methodsFor: 'private' stamp: 'fz 10/16/2019 22:06:02'!
pasaTurno
	"este mensaje es solo para testear, no debe ser llamado fuera de dicha situación"

	state := state nextStateFor: self.! !


!TerniLapilli methodsFor: 'testing' stamp: 'fz 10/16/2019 22:25:35'!
pieceAt: aPosition
	^tablero at: aPosition 
	! !

!TerniLapilli methodsFor: 'testing' stamp: 'fz 10/16/2019 22:24:13'!
piecesPlaced
	^piezasEnJuego ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TerniLapilli class' category: #TerniLapilli!
TerniLapilli class
	instanceVariableNames: ''!

!TerniLapilli class methodsFor: 'errorMessages' stamp: 'MD 10/15/2019 14:41:08'!
cannotMoveNonExistingPieceErrorMessage
	^ 'solo se pueden mover las 3 fichas desde las posiciones en las que estan'! !

!TerniLapilli class methodsFor: 'errorMessages' stamp: 'fz 10/16/2019 21:00:23'!
cannotMoveOutsideOfNeighboursErrorMessage
	^'no se puede mover a más de un espacio de distancia'! !

!TerniLapilli class methodsFor: 'errorMessages' stamp: 'fz 10/15/2019 20:59:09'!
cannotMovePiecesBeforeSixArePlacedErrorMessage
	^'No se pueden mover las piezas antes de que se hayan colocado todas'! !

!TerniLapilli class methodsFor: 'errorMessages' stamp: 'MD 10/15/2019 14:22:13'!
cannotMoveTheOtherPlayersPiecesErrorMessage

	^ 'solo se pueden mover las fichas del jugador al que le toca el turno actual'.! !

!TerniLapilli class methodsFor: 'errorMessages' stamp: 'MD 10/15/2019 17:36:09'!
cannotPlaceAPieceOnAnOccupiedPositionErrorMessage

	^'no se pueden poner piezas en posiciones ocupadas'! !

!TerniLapilli class methodsFor: 'errorMessages' stamp: 'MD 10/15/2019 17:36:02'!
cannotPlaceMoreThan6PiecesOnBoardErrorMessage
	^ 'no se pueden poner mas de 6 fichas en el tablero'! !

!TerniLapilli class methodsFor: 'errorMessages' stamp: 'MD 10/15/2019 17:35:48'!
cannotPlacePieceOutsideBoardErrorMessageWith: aPosition

	^'no se pueden poner piezas fuera del rango 0@0 -- 2@2. ', aPosition asString , 'cae fuera del tablero'! !

!TerniLapilli class methodsFor: 'errorMessages' stamp: 'MD 10/10/2019 18:24:34'!
cannotPlayOutOfTurnErrorMessage
	^ 'no puede jugar el jugador que no le toca'! !


!classDefinition: #TerniLapilliPosition category: #TerniLapilli!
Object subclass: #TerniLapilliPosition
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!TerniLapilliPosition methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 19:23:58'!
checkIfCanPlacePieceHere
	^ self subclassResponsibility.! !

!TerniLapilliPosition methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 19:26:45'!
isEmpty
	^self subclassResponsibility.! !


!classDefinition: #TerniLapilliPositionEmpty category: #TerniLapilli!
TerniLapilliPosition subclass: #TerniLapilliPositionEmpty
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!TerniLapilliPositionEmpty methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 19:23:58'!
checkIfCanPlacePieceHere! !

!TerniLapilliPositionEmpty methodsFor: 'as yet unclassified' stamp: 'fz 10/16/2019 20:13:40'!
checkLegalMovingPieceForO
	self error: TerniLapilli cannotMoveNonExistingPieceErrorMessage ! !

!TerniLapilliPositionEmpty methodsFor: 'as yet unclassified' stamp: 'fz 10/16/2019 20:12:45'!
checkLegalMovingPieceForX
	self error: TerniLapilli cannotMoveNonExistingPieceErrorMessage ! !

!TerniLapilliPositionEmpty methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 19:26:59'!
isEmpty
	^true! !

!TerniLapilliPositionEmpty methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 18:55:19'!
isO
	^false.! !

!TerniLapilliPositionEmpty methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 18:55:23'!
isX
	^false.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TerniLapilliPositionEmpty class' category: #TerniLapilli!
TerniLapilliPositionEmpty class
	instanceVariableNames: 'uniqueInstance'!

!TerniLapilliPositionEmpty class methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 19:08:52'!
initialize
	uniqueInstance := self basicNew.! !

!TerniLapilliPositionEmpty class methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 19:08:22'!
new
	uniqueInstance isNil ifTrue: [uniqueInstance := super new].
	^ uniqueInstance! !


!classDefinition: #TerniLapilliPositionO category: #TerniLapilli!
TerniLapilliPosition subclass: #TerniLapilliPositionO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!TerniLapilliPositionO methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 19:23:58'!
checkIfCanPlacePieceHere
	^ self error: TerniLapilli cannotPlaceAPieceOnAnOccupiedPositionErrorMessage.! !

!TerniLapilliPositionO methodsFor: 'as yet unclassified' stamp: 'fz 10/16/2019 20:13:35'!
checkLegalMovingPieceForO! !

!TerniLapilliPositionO methodsFor: 'as yet unclassified' stamp: 'fz 10/16/2019 20:12:17'!
checkLegalMovingPieceForX
	self error: TerniLapilli cannotMoveTheOtherPlayersPiecesErrorMessage! !

!TerniLapilliPositionO methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 19:27:12'!
isEmpty
	^false! !

!TerniLapilliPositionO methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 18:55:31'!
isO
	^true! !

!TerniLapilliPositionO methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 18:55:35'!
isX
	^false! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TerniLapilliPositionO class' category: #TerniLapilli!
TerniLapilliPositionO class
	instanceVariableNames: 'uniqueInstance'!

!TerniLapilliPositionO class methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 19:08:56'!
initialize
	uniqueInstance := self basicNew.! !

!TerniLapilliPositionO class methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 19:08:28'!
new
	uniqueInstance isNil ifTrue: [uniqueInstance := super new].
	^ uniqueInstance! !


!classDefinition: #TerniLapilliPositionX category: #TerniLapilli!
TerniLapilliPosition subclass: #TerniLapilliPositionX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!TerniLapilliPositionX methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 19:23:58'!
checkIfCanPlacePieceHere
	^ self error: TerniLapilli cannotPlaceAPieceOnAnOccupiedPositionErrorMessage.! !

!TerniLapilliPositionX methodsFor: 'as yet unclassified' stamp: 'fz 10/16/2019 20:13:24'!
checkLegalMovingPieceForO
	self error: TerniLapilli cannotMoveTheOtherPlayersPiecesErrorMessage! !

!TerniLapilliPositionX methodsFor: 'as yet unclassified' stamp: 'fz 10/16/2019 20:11:40'!
checkLegalMovingPieceForX
	! !

!TerniLapilliPositionX methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 19:27:07'!
isEmpty
	^false! !

!TerniLapilliPositionX methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 18:55:47'!
isO
	^false! !

!TerniLapilliPositionX methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 18:55:43'!
isX
	^true! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TerniLapilliPositionX class' category: #TerniLapilli!
TerniLapilliPositionX class
	instanceVariableNames: 'uniqueInstance'!

!TerniLapilliPositionX class methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 19:08:59'!
initialize
	uniqueInstance := self basicNew.! !

!TerniLapilliPositionX class methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 19:08:31'!
new
	uniqueInstance isNil ifTrue: [uniqueInstance := super new].
	^ uniqueInstance! !


!classDefinition: #TerniLapilliState category: #TerniLapilli!
Object subclass: #TerniLapilliState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!


!classDefinition: #GameOver category: #TerniLapilli!
TerniLapilliState subclass: #GameOver
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!


!classDefinition: #MovingPhase category: #TerniLapilli!
TerniLapilliState subclass: #MovingPhase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!


!classDefinition: #MovingPhaseO category: #TerniLapilli!
MovingPhase subclass: #MovingPhaseO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!MovingPhaseO methodsFor: 'moving' stamp: 'fz 10/16/2019 22:28:56'!
moveOFrom: previousPosition to: newPosition on: aTerniLapilli
	
	(aTerniLapilli pieceAt: previousPosition) checkLegalMovingPieceForO.
	
	aTerniLapilli movePieceFrom: previousPosition to: newPosition.
	! !

!MovingPhaseO methodsFor: 'moving' stamp: 'fz 10/16/2019 22:29:15'!
moveXFrom: aPoint to: aPoint2 on: aTerniLapilli 
	self error: TerniLapilli cannotPlayOutOfTurnErrorMessage ! !


!MovingPhaseO methodsFor: 'placing' stamp: 'fz 10/16/2019 22:30:19'!
placeOAt: aPosition on: aTerniLapilli 
	self error: TerniLapilli cannotPlaceMoreThan6PiecesOnBoardErrorMessage ! !

!MovingPhaseO methodsFor: 'placing' stamp: 'fz 10/16/2019 22:30:22'!
placeXAt: aPosition on: aTerniLapilli 
	self error: TerniLapilli cannotPlaceMoreThan6PiecesOnBoardErrorMessage ! !


!classDefinition: #MovingPhaseX category: #TerniLapilli!
MovingPhase subclass: #MovingPhaseX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!MovingPhaseX methodsFor: 'moving' stamp: 'fz 10/16/2019 22:28:24'!
moveOFrom: aPoint to: aPoint2 on: aTerniLapilli 
	self error: TerniLapilli cannotPlayOutOfTurnErrorMessage ! !

!MovingPhaseX methodsFor: 'moving' stamp: 'fz 10/16/2019 22:25:52'!
moveXFrom: previousPosition to: newPosition on: aTerniLapilli
	
	(aTerniLapilli pieceAt: previousPosition) checkLegalMovingPieceForX.
	
	aTerniLapilli movePieceFrom: previousPosition to: newPosition.
	
	! !


!MovingPhaseX methodsFor: 'next' stamp: 'fz 10/16/2019 22:26:51'!
nextStateFor: aTerniLapilli 
	^MovingPhaseO! !


!MovingPhaseX methodsFor: 'placing' stamp: 'fz 10/16/2019 22:30:09'!
placeOAt: aPosition on: aTerniLapilli 
	self error: TerniLapilli cannotPlaceMoreThan6PiecesOnBoardErrorMessage ! !

!MovingPhaseX methodsFor: 'placing' stamp: 'fz 10/16/2019 22:30:11'!
placeXAt: aPosition on: aTerniLapilli 
	self error: TerniLapilli cannotPlaceMoreThan6PiecesOnBoardErrorMessage ! !


!classDefinition: #PlacingPhase category: #TerniLapilli!
TerniLapilliState subclass: #PlacingPhase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!


!classDefinition: #PlacingPhaseO category: #TerniLapilli!
PlacingPhase subclass: #PlacingPhaseO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!PlacingPhaseO methodsFor: 'turn testing' stamp: 'fz 10/16/2019 22:08:05'!
isPlayingO
	^true! !


!PlacingPhaseO methodsFor: 'next' stamp: 'fz 10/16/2019 22:25:10'!
nextStateFor: aTerniLapilli 
	aTerniLapilli piecesPlaced = 6 ifTrue: [^MovingPhaseX new] ifFalse: [^PlacingPhaseX new]! !


!PlacingPhaseO methodsFor: 'placing' stamp: 'fz 10/16/2019 22:15:42'!
placeOAt: aPosition on: aTerniLapilli 
	
	aTerniLapilli at: aPosition place: TerniLapilliPositionO new.! !

!PlacingPhaseO methodsFor: 'placing' stamp: 'fz 10/16/2019 22:12:34'!
placeXAt: aPosition on: aTerniLapilli 
	self error: TerniLapilli cannotPlayOutOfTurnErrorMessage! !


!PlacingPhaseO methodsFor: 'moving' stamp: 'fz 10/16/2019 22:20:11'!
moveOFrom: previousPosition to: newPosition on: aTerniLapilli
	self error: TerniLapilli cannotMovePiecesBeforeSixArePlacedErrorMessage ! !

!PlacingPhaseO methodsFor: 'moving' stamp: 'fz 10/16/2019 22:20:08'!
moveXFrom: previousPosition to: newPosition on: aTerniLapilli
	self error: TerniLapilli cannotMovePiecesBeforeSixArePlacedErrorMessage ! !


!classDefinition: #PlacingPhaseX category: #TerniLapilli!
PlacingPhase subclass: #PlacingPhaseX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!PlacingPhaseX methodsFor: 'turn testing' stamp: 'fz 10/16/2019 22:07:02'!
isPlayingX
	^true! !


!PlacingPhaseX methodsFor: 'next' stamp: 'fz 10/16/2019 22:23:49'!
nextStateFor: aTerniLapilli 
	aTerniLapilli piecesPlaced = 6 ifTrue: [^MovingPhaseO new] ifFalse: [^PlacingPhaseO new]! !


!PlacingPhaseX methodsFor: 'placing' stamp: 'fz 10/16/2019 22:14:39'!
placeOAt: aPosition on: aTerniLapilli 
	self error: TerniLapilli cannotPlayOutOfTurnErrorMessage! !

!PlacingPhaseX methodsFor: 'placing' stamp: 'fz 10/16/2019 22:10:03'!
placeXAt: aPosition on: aTerniLapilli 
	
	aTerniLapilli at: aPosition place: TerniLapilliPositionX new.! !


!PlacingPhaseX methodsFor: 'moving' stamp: 'fz 10/16/2019 22:19:37'!
moveOFrom: previousPosition to: newPosition on: aTerniLapilli
	self error: TerniLapilli cannotMovePiecesBeforeSixArePlacedErrorMessage ! !

!PlacingPhaseX methodsFor: 'moving' stamp: 'fz 10/16/2019 22:19:29'!
moveXFrom: previousPosition to: newPosition on: aTerniLapilli
	self error: TerniLapilli cannotMovePiecesBeforeSixArePlacedErrorMessage ! !

TerniLapilliPositionEmpty initialize!
TerniLapilliPositionO initialize!
TerniLapilliPositionX initialize!