!classDefinition: #TerniLapilliTest category: #TerniLapilli!
TestCase subclass: #TerniLapilliTest
	instanceVariableNames: 'juegoNuevo juegoCon6Fichas'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!TerniLapilliTest methodsFor: 'tests - puesta de fichas' stamp: 'fz 10/15/2019 21:20:20'!
test04SePuedePonerUnaFichaDentroDelTablero

	juegoNuevo placeXAt: 0@0.
	
	self assert: juegoNuevo isPlayingO.
	self assert: (juegoNuevo isXAt: 0@0).
	! !

!TerniLapilliTest methodsFor: 'tests - puesta de fichas' stamp: 'fz 10/15/2019 21:20:20'!
test05NoPuedoPonerFichaFueraDelTablero

	self should: [juegoNuevo placeXAt: -1@0]
		raise: Error 
		withExceptionDo: [:anError | self assert: anError messageText equals: (TerniLapilli cannotPlacePieceOutsideBoardErrorMessageWith: -1@0)].
	
	
	
	! !

!TerniLapilliTest methodsFor: 'tests - puesta de fichas' stamp: 'fz 10/15/2019 21:19:53'!
test06NoPuedePonerFichaQuienNoJuega
	
	self should: [juegoNuevo placeOAt: 0@0.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotPlayOutOfTurnErrorMessage.
							self deny: (juegoNuevo isOAt: 0@0)].
	
	! !

!TerniLapilliTest methodsFor: 'tests - puesta de fichas' stamp: 'fz 10/15/2019 21:20:20'!
test07SePuedenPonerHasta6Fichas
			
	self should: [juegoCon6Fichas placeXAt: 2@1]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotPlaceMoreThan6PiecesOnBoardErrorMessage.
							self deny: (juegoCon6Fichas isXAt: 2@1)].! !

!TerniLapilliTest methodsFor: 'tests - puesta de fichas' stamp: 'fz 10/15/2019 21:20:20'!
test08NoSePuedePonerFichaEnPosicionOcupada
	
	juegoNuevo placeXAt: 0@0.
	
	self should: [juegoNuevo placeOAt: 0@0]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotPlaceAPieceOnAnOccupiedPositionErrorMessage.
							self deny: (juegoNuevo isOAt: 0@0)].! !


!TerniLapilliTest methodsFor: 'setUp' stamp: 'MD 10/16/2019 19:06:39'!
setUp

	juegoNuevo := TerniLapilli new.
	
	juegoCon6Fichas := TerniLapilli new.
	juegoCon6Fichas placeXAt: 0@0.
	juegoCon6Fichas placeOAt: 0@1.
	juegoCon6Fichas placeXAt: 1@0.
	juegoCon6Fichas placeOAt: 1@1.
	juegoCon6Fichas placeXAt: 2@2.
	juegoCon6Fichas placeOAt: 0@2.! !


!TerniLapilliTest methodsFor: 'tests - cambios de turno' stamp: 'MD 10/10/2019 17:31:46'!
test01InicialmenteJuegaX
	
	self assert: juegoNuevo isPlayingX.
	! !

!TerniLapilliTest methodsFor: 'tests - cambios de turno' stamp: 'MD 10/10/2019 17:29:03'!
test02DespuesDeXJuegaO

	juegoNuevo := TerniLapilli new.
	
	juegoNuevo  pasaTurno.
	
	self assert: juegoNuevo  isPlayingO.
	! !

!TerniLapilliTest methodsFor: 'tests - cambios de turno' stamp: 'MD 10/10/2019 19:55:55'!
test03DespuesDeOJuegaX

	juegoNuevo  pasaTurno.
	juegoNuevo  pasaTurno.
	
	self assert: juegoNuevo isPlayingX.
	! !


!TerniLapilliTest methodsFor: 'tests - movida de fichas' stamp: 'MD 10/15/2019 17:43:47'!
test09DespuesDe6FichasXPuedeMoverUnaSuya
	
	juegoCon6Fichas moveXFrom: 2@2 to: 2@1.
	
	self deny: (juegoCon6Fichas isXAt: 2@2).
	self assert: (juegoCon6Fichas isXAt: 2@1).
	! !

!TerniLapilliTest methodsFor: 'tests - movida de fichas' stamp: 'MD 10/15/2019 17:43:47'!
test10NoSePuedeMoverFichasDeOtroJugador
	
	self should: [juegoCon6Fichas moveXFrom: 0@2 to: 1@2.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotMoveTheOtherPlayersPiecesErrorMessage.
							self deny: (juegoCon6Fichas isXAt: 1@2).
							self deny: (juegoCon6Fichas isOAt: 1@2).
							self assert: (juegoCon6Fichas isOAt: 0@2)].! !

!TerniLapilliTest methodsFor: 'tests - movida de fichas' stamp: 'MD 10/15/2019 17:43:47'!
test11NoSePuedeMoverUnaFichaQueNoExiste
	
	self should: [juegoCon6Fichas moveXFrom: 2@1 to: 2@0.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotMoveNonExistingPieceErrorMessage.
							self deny: (juegoCon6Fichas isXAt: 2@0).
							self deny: (juegoCon6Fichas isXAt: 2@1)].
						
						
	! !

!TerniLapilliTest methodsFor: 'tests - movida de fichas' stamp: 'MD 10/15/2019 17:43:47'!
test12NoSePuedeMoverUnaFichaAfueraDelTablero
	
	self should: [juegoCon6Fichas moveXFrom: 2@2 to: 3@2.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: (TerniLapilli cannotPlacePieceOutsideBoardErrorMessageWith: 3@2).
							self assert: (juegoCon6Fichas isXAt: 2@2)].
						
	! !

!TerniLapilliTest methodsFor: 'tests - movida de fichas' stamp: 'MD 10/15/2019 17:43:47'!
test13NoSePuedeMoverUnaFichaAUnLugarOcupado
	
	self should: [juegoCon6Fichas moveXFrom: 1@0 to: 1@1.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotPlaceAPieceOnAnOccupiedPositionErrorMessage.
							self assert: (juegoCon6Fichas isXAt: 1@0).
							self assert: (juegoCon6Fichas isOAt: 1@1)].
				
	! !

!TerniLapilliTest methodsFor: 'tests - movida de fichas' stamp: 'MD 10/15/2019 17:43:37'!
test14NoSePuedeMoverUnaFichaFueraDeTurno
	
	self should: [juegoCon6Fichas moveOFrom: 1@1 to: 1@2.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotPlayOutOfTurnErrorMessage.
							self deny: (juegoCon6Fichas isOAt: 1@2).
							self assert: (juegoCon6Fichas isOAt: 1@1)].
				
	! !

!TerniLapilliTest methodsFor: 'tests - movida de fichas' stamp: 'fz 10/15/2019 21:20:20'!
test15NoSePuedeMoverUnaFichaAntesDeColocar6Fichas
	
	juegoNuevo placeXAt: 0@0.
	juegoNuevo placeOAt: 2@0.	
	
	self should: [juegoNuevo moveXFrom: 0@0 to: 0@1.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotMovePiecesBeforeSixArePlacedErrorMessage.
							self deny: (juegoNuevo isXAt: 0@1).
							self assert: (juegoNuevo isXAt: 0@0)].
				
	! !



!classDefinition: #TerniLapilli category: #TerniLapilli!
Object subclass: #TerniLapilli
	instanceVariableNames: 'tablero turn piezasEnJuego'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!TerniLapilli methodsFor: 'error checking' stamp: 'MD 10/16/2019 19:23:58'!
checkIfLegalPlace: aPosition

	((aPosition x between: 0 and: 2) and: [aPosition y between: 0 and: 2]) ifFalse: [self error: (self class cannotPlacePieceOutsideBoardErrorMessageWith: aPosition)].
	
	(tablero at: aPosition) checkIfCanPlacePieceHere.
! !

!TerniLapilli methodsFor: 'error checking' stamp: 'MD 10/16/2019 19:03:02'!
checkIfOnMovingPhase
	
	piezasEnJuego  < 6 ifTrue: [self error: self class cannotMovePiecesBeforeSixArePlacedErrorMessage].! !

!TerniLapilli methodsFor: 'error checking' stamp: 'MD 10/16/2019 19:03:08'!
checkIfOnPlacingPhase
	piezasEnJuego >= 6 ifTrue: [self error: self class cannotPlaceMoreThan6PiecesOnBoardErrorMessage].! !


!TerniLapilli methodsFor: 'initialization' stamp: 'MD 10/16/2019 19:02:52'!
initialize

	turn := TerniLapilliXTurn new.
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


!TerniLapilli methodsFor: 'moving pieces' stamp: 'fz 10/16/2019 20:10:50'!
moveOFrom: previousPosition to: newPosition

	turn checkIfOIsPlaying.
	
	(tablero at: previousPosition) checkLegalMovingPieceForO.
	
	self movePieceFrom: previousPosition to: newPosition.
	! !

!TerniLapilli methodsFor: 'moving pieces' stamp: 'fz 10/16/2019 20:11:04'!
moveXFrom: previousPosition to: newPosition
	
	turn checkIfXIsPlaying.
	
	(tablero at: previousPosition) checkLegalMovingPieceForX.
	
	self movePieceFrom: previousPosition to: newPosition.
	
	! !


!TerniLapilli methodsFor: 'place pieces' stamp: 'MD 10/16/2019 19:05:30'!
placeOAt: aPosition 
	
	turn checkIfOIsPlaying.
	
	self at: aPosition place: TerniLapilliPositionO new.! !

!TerniLapilli methodsFor: 'place pieces' stamp: 'MD 10/16/2019 19:05:34'!
placeXAt: aPosition

	turn checkIfXIsPlaying.
	
	self at: aPosition place: TerniLapilliPositionX new.! !


!TerniLapilli methodsFor: 'position testing' stamp: 'MD 10/16/2019 18:54:52'!
isOAt: aPosition
	^(tablero at: aPosition) isO.
	! !

!TerniLapilli methodsFor: 'position testing' stamp: 'MD 10/16/2019 18:55:08'!
isXAt: aPosition
	^(tablero at: aPosition) isX.
	! !


!TerniLapilli methodsFor: 'turn testing' stamp: 'fz 10/15/2019 21:36:39'!
isPlayingO

	^ turn isPlayingO.! !

!TerniLapilli methodsFor: 'turn testing' stamp: 'fz 10/15/2019 21:36:39'!
isPlayingX

	^ turn isPlayingX.! !


!TerniLapilli methodsFor: 'private' stamp: 'MD 10/16/2019 19:02:42'!
at: aPosition place: aPiece
	self checkIfLegalPlace: aPosition.
	self checkIfOnPlacingPhase.

	tablero at: aPosition put: aPiece.
	piezasEnJuego := piezasEnJuego +1.
	turn := turn nextTurn.! !

!TerniLapilli methodsFor: 'private' stamp: 'MD 10/16/2019 19:16:07'!
movePieceFrom: previousPosition to: newPosition
	|piece|
	
	self checkIfLegalPlace: newPosition.
	self checkIfOnMovingPhase.
	
	piece := tablero at: previousPosition.
	
	tablero at: previousPosition put: TerniLapilliPositionEmpty new.
	
	tablero at: newPosition put: piece.
	
	turn := turn nextTurn.! !

!TerniLapilli methodsFor: 'private' stamp: 'MD 10/16/2019 18:34:28'!
pasaTurno
	"este mensaje es solo para testear, no debe ser llamado fuera de dicha situación"

	turn := turn nextTurn.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TerniLapilli class' category: #TerniLapilli!
TerniLapilli class
	instanceVariableNames: ''!

!TerniLapilli class methodsFor: 'errorMessages' stamp: 'MD 10/15/2019 14:41:08'!
cannotMoveNonExistingPieceErrorMessage
	^ 'solo se pueden mover las 3 fichas desde las posiciones en las que estan'! !

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


!classDefinition: #TerniLapilliTurn category: #TerniLapilli!
Object subclass: #TerniLapilliTurn
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!


!classDefinition: #TerniLapilliOTurn category: #TerniLapilli!
TerniLapilliTurn subclass: #TerniLapilliOTurn
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!TerniLapilliOTurn methodsFor: 'error checking' stamp: 'MD 10/16/2019 18:14:32'!
checkIfOIsPlaying! !

!TerniLapilliOTurn methodsFor: 'error checking' stamp: 'MD 10/16/2019 18:17:02'!
checkIfXIsPlaying

	self error: TerniLapilli cannotPlayOutOfTurnErrorMessage! !


!TerniLapilliOTurn methodsFor: 'testing' stamp: 'fz 10/15/2019 22:04:33'!
isPlayingO
	^true! !

!TerniLapilliOTurn methodsFor: 'testing' stamp: 'fz 10/15/2019 22:04:47'!
isPlayingX
	^false! !


!TerniLapilliOTurn methodsFor: 'turn taking' stamp: 'MD 10/16/2019 18:26:45'!
nextTurn
	^TerniLapilliXTurn new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TerniLapilliOTurn class' category: #TerniLapilli!
TerniLapilliOTurn class
	instanceVariableNames: 'uniqueInstance'!

!TerniLapilliOTurn class methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 18:19:36'!
initialize
	uniqueInstance := self basicNew.! !

!TerniLapilliOTurn class methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 18:19:22'!
new
	uniqueInstance isNil ifTrue: [uniqueInstance := super new].
	^ uniqueInstance! !


!classDefinition: #TerniLapilliXTurn category: #TerniLapilli!
TerniLapilliTurn subclass: #TerniLapilliXTurn
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!TerniLapilliXTurn methodsFor: 'error checking' stamp: 'MD 10/16/2019 18:17:10'!
checkIfOIsPlaying

	self error: TerniLapilli cannotPlayOutOfTurnErrorMessage! !

!TerniLapilliXTurn methodsFor: 'error checking' stamp: 'MD 10/16/2019 18:15:12'!
checkIfXIsPlaying
! !


!TerniLapilliXTurn methodsFor: 'testing' stamp: 'fz 10/15/2019 22:12:46'!
isPlayingO
	^false! !

!TerniLapilliXTurn methodsFor: 'testing' stamp: 'fz 10/15/2019 22:05:35'!
isPlayingX
	^true! !


!TerniLapilliXTurn methodsFor: 'turn taking' stamp: 'MD 10/16/2019 18:26:52'!
nextTurn
	^TerniLapilliOTurn new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TerniLapilliXTurn class' category: #TerniLapilli!
TerniLapilliXTurn class
	instanceVariableNames: 'uniqueInstance'!

!TerniLapilliXTurn class methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 18:19:47'!
initialize
	uniqueInstance := self basicNew.! !

!TerniLapilliXTurn class methodsFor: 'as yet unclassified' stamp: 'MD 10/16/2019 18:19:41'!
new
	uniqueInstance isNil ifTrue: [uniqueInstance := super new].
	^ uniqueInstance! !

TerniLapilliPositionEmpty initialize!
TerniLapilliPositionO initialize!
TerniLapilliPositionX initialize!
TerniLapilliOTurn initialize!
TerniLapilliXTurn initialize!