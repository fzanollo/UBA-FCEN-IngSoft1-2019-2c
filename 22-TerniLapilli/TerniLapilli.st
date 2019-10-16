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


!TerniLapilliTest methodsFor: 'setUp' stamp: 'fz 10/15/2019 21:20:20'!
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
	instanceVariableNames: 'aQuienLeToca tablero'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!TerniLapilli methodsFor: 'initialization' stamp: 'fz 10/15/2019 21:22:42'!
initialize

	aQuienLeToca := $X.
	tablero := Dictionary new.! !


!TerniLapilli methodsFor: 'testing' stamp: 'MD 10/10/2019 19:51:49'!
isOAt: aPosition
	^self pieceAt: aPosition equals: $O
	! !

!TerniLapilli methodsFor: 'testing' stamp: 'MD 10/10/2019 17:25:13'!
isPlayingO

	^ aQuienLeToca = $O .! !

!TerniLapilli methodsFor: 'testing' stamp: 'MD 10/10/2019 17:25:05'!
isPlayingX

	^ aQuienLeToca = $X .! !

!TerniLapilli methodsFor: 'testing' stamp: 'MD 10/10/2019 19:51:56'!
isXAt: aPosition
	^self pieceAt: aPosition equals: $X
	! !


!TerniLapilli methodsFor: 'place pieces' stamp: 'fz 10/15/2019 21:20:52'!
placeAPieceOf: aPlayer at: aPosition onTurn: isOnTurn

	self checkIfLegalPlace: aPosition .
	isOnTurn ifFalse: [self error: self class cannotPlayOutOfTurnErrorMessage].
	
	tablero size >= 6 ifTrue: [self error: self class cannotPlaceMoreThan6PiecesOnBoardErrorMessage].
	tablero at: aPosition put: aPlayer.
	self pasaTurno.! !

!TerniLapilli methodsFor: 'place pieces' stamp: 'fz 10/15/2019 21:20:52'!
placeOAt: aPosition 

	self placeAPieceOf: $O at: aPosition onTurn: self isPlayingO.! !

!TerniLapilli methodsFor: 'place pieces' stamp: 'fz 10/15/2019 21:20:52'!
placeXAt: aPosition

	self placeAPieceOf: $X at: aPosition onTurn: self isPlayingX ! !


!TerniLapilli methodsFor: 'private' stamp: 'MD 10/10/2019 20:13:24'!
pieceAt: aPosition equals: aPlayer

	^ (tablero includesKey: aPosition) and: [(tablero at: aPosition) = aPlayer].! !


!TerniLapilli methodsFor: 'moving pieces' stamp: 'fz 10/15/2019 21:02:59'!
move: aPiece from: previousPosition to: newPosition onTurn: isOnTurn

	| pieza |
	self checkIfLegalPlace: newPosition.
	isOnTurn ifFalse: [self error: self class cannotPlayOutOfTurnErrorMessage].
	
	tablero size < 6 ifTrue: [self error: self class cannotMovePiecesBeforeSixArePlacedErrorMessage].

	pieza := tablero at: previousPosition ifAbsent: [self error: self class cannotMoveNonExistingPieceErrorMessage ].
	pieza = aPiece ifFalse: [self error: self class cannotMoveTheOtherPlayersPiecesErrorMessage ].

	tablero removeKey: previousPosition.
	tablero at: newPosition put: aPiece.
	! !

!TerniLapilli methodsFor: 'moving pieces' stamp: 'MD 10/15/2019 17:44:12'!
moveOFrom: previousPosition to: newPosition

	self move: $O from: previousPosition to: newPosition onTurn: self isPlayingO.
	! !

!TerniLapilli methodsFor: 'moving pieces' stamp: 'MD 10/15/2019 17:44:22'!
moveXFrom: previousPosition to: newPosition

	self move: $X from: previousPosition to: newPosition onTurn: self isPlayingX .
	! !


!TerniLapilli methodsFor: 'turn taking' stamp: 'MD 10/10/2019 17:25:36'!
pasaTurno

	self isPlayingX ifTrue: [aQuienLeToca := $O] ifFalse: [aQuienLeToca := $X].! !


!TerniLapilli methodsFor: 'error checking' stamp: 'MD 10/15/2019 17:37:35'!
checkIfLegalPlace: aPosition

	((aPosition x between: 0 and: 2) and: [aPosition y between: 0 and: 2]) ifFalse: [self error: (self class cannotPlacePieceOutsideBoardErrorMessageWith: aPosition)].
	(tablero includesKey: aPosition) ifTrue: [self error: self class cannotPlaceAPieceOnAnOccupiedPositionErrorMessage ].
! !

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
