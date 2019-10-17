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

!TerniLapilliTest methodsFor: 'tests 4- topologia del tablero' stamp: 'MD 10/17/2019 13:40:55'!
test17SePuedeMoverUnaFichaPorUnaDiagonalExistente
	juegoCon6Fichas moveXFrom: 2@2 to: 2@1.
	
	juegoCon6Fichas moveOFrom: 1@1 to: 2@0.
	
	self assert: (juegoCon6Fichas isOAt: 2@0).
				
	! !

!TerniLapilliTest methodsFor: 'tests 4- topologia del tablero' stamp: 'MD 10/17/2019 13:41:06'!
test18NoSePuedeMoverUnaFichaPorUnaDiagonalInexistente
	
	self should: [juegoCon6Fichas moveXFrom: 1@0 to: 2@1.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotMoveOverInvalidDIagonalErrorMessage.
							self deny: (juegoCon6Fichas isXAt: 2@1).
							self assert: (juegoCon6Fichas isXAt: 1@0)].
				
	! !


!TerniLapilliTest methodsFor: 'tests 5 - final del juego' stamp: 'MD 10/17/2019 14:47:45'!
test19CuandoNoHay3EnLineaNoHayGanador
	
	self deny: (juegoCon6Fichas hasWinner).
				
	! !

!TerniLapilliTest methodsFor: 'tests 5 - final del juego' stamp: 'MD 10/17/2019 14:26:27'!
test20AlPoner3EnLineaHorizontalSeGana
	
	juegoNuevo placeXAt: 0@0.
	juegoNuevo placeOAt: 0@1.
	juegoNuevo placeXAt: 1@0.
	juegoNuevo placeOAt: 1@1.
	juegoNuevo placeXAt: 2@0.
	
	self assert: (juegoNuevo hasWinner).
				
	! !

!TerniLapilliTest methodsFor: 'tests 5 - final del juego' stamp: 'MD 10/17/2019 14:28:24'!
test21AlPoner3EnLineaVerticalSeGana
	
	juegoNuevo placeXAt: 0@0.
	juegoNuevo placeOAt: 1@0.
	juegoNuevo placeXAt: 0@1.
	juegoNuevo placeOAt: 2@0.
	juegoNuevo placeXAt: 0@2.
	
	self assert: (juegoNuevo hasWinner).
				
	! !

!TerniLapilliTest methodsFor: 'tests 5 - final del juego' stamp: 'MD 10/17/2019 14:29:12'!
test22AlPoner3EnLineaDiagonalSeGana
	
	juegoNuevo placeXAt: 0@0.
	juegoNuevo placeOAt: 1@0.
	juegoNuevo placeXAt: 1@1.
	juegoNuevo placeOAt: 2@0.
	juegoNuevo placeXAt: 2@2.
	
	self assert: (juegoNuevo hasWinner).
				
	! !

!TerniLapilliTest methodsFor: 'tests 5 - final del juego' stamp: 'MD 10/17/2019 14:52:19'!
test23AlMoverYQuedan3EnLineaGana
	
	juegoCon6Fichas moveXFrom: 2@2 to: 2@1.
	juegoCon6Fichas moveOFrom: 1@1 to: 1@2.
	juegoCon6Fichas moveXFrom: 2@1 to: 2@0.
	
	self assert: (juegoCon6Fichas hasWinner).
				
	! !

!TerniLapilliTest methodsFor: 'tests 5 - final del juego' stamp: 'MD 10/17/2019 14:55:46'!
test24SeSabeQuienGana
	
	juegoCon6Fichas moveXFrom: 2@2 to: 2@1.
	juegoCon6Fichas moveOFrom: 1@1 to: 1@2.
	juegoCon6Fichas moveXFrom: 2@1 to: 2@0.
	
	self assert: (juegoCon6Fichas hasWinner).
	self assert: juegoCon6Fichas winner equals: $X.! !

!TerniLapilliTest methodsFor: 'tests 5 - final del juego' stamp: 'MD 10/17/2019 15:09:28'!
test25CuandoNoTerminoElJuegoNoHayGanador

	self should: [juegoCon6Fichas winner]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli theresNoWinnerWhenAGameHasntEndedErrorMessage].
	! !

!TerniLapilliTest methodsFor: 'tests 5 - final del juego' stamp: 'MD 10/17/2019 15:14:32'!
test26NoSePuedeAgregarFichaEnUnJuegoTerminado
	
	juegoNuevo placeXAt: 0@0.
	juegoNuevo placeOAt: 1@0.
	juegoNuevo placeXAt: 1@1.
	juegoNuevo placeOAt: 2@0.
	juegoNuevo placeXAt: 2@2.
	
	self should: [juegoNuevo placeOAt: 2@1]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotPlacePiecesWhenTheGameIsOverErrorMessage.
					self deny: (juegoNuevo isOAt: 2@1)].
	! !

!TerniLapilliTest methodsFor: 'tests 5 - final del juego' stamp: 'MD 10/17/2019 15:18:00'!
test27NoSePuedeMoverUnaFichaEnUnJuegoTerminado
	
	juegoCon6Fichas moveXFrom: 2@2 to: 2@1.
	juegoCon6Fichas moveOFrom: 1@1 to: 1@2.
	juegoCon6Fichas moveXFrom: 2@1 to: 2@0.
	
	self should: [juegoCon6Fichas moveOFrom: 1@2 to: 1@1]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotMovePiecesWhenTheGameIsOverErrorMessage.
					self deny: (juegoCon6Fichas isOAt: 1@1).
					self assert: (juegoCon6Fichas isOAt: 1@2)].
	! !


!classDefinition: #TerniLapilli category: #TerniLapilli!
Object subclass: #TerniLapilli
	instanceVariableNames: 'tablero piezasEnJuego state movimientosValidos'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!TerniLapilli methodsFor: 'error checking' stamp: 'fz 10/16/2019 22:32:53'!
checkForLegalPlace: aPosition

	((aPosition x between: 0 and: 2) and: [aPosition y between: 0 and: 2]) ifFalse: [self error: (self class cannotPlacePieceOutsideBoardErrorMessageWith: aPosition)].
	
	(tablero at: aPosition) checkIfCanPlacePieceHere.
! !


!TerniLapilli methodsFor: 'initialization' stamp: 'MD 10/17/2019 14:59:58'!
initialize
	|allPositions|
	
	allPositions := OrderedCollection new.
	(0 to: 2) do:[:x| (0 to: 2) do: [:y | allPositions add: x@y]].

	state := PlacingPhaseX new.
	piezasEnJuego := 0.
	
	tablero := Dictionary new.
	allPositions do: [:position| tablero add: position ->TerniLapilliPositionEmpty new].
			
	movimientosValidos := Dictionary new.
	movimientosValidos add: 0@0 -> (Set with: 0@1 with: 1@0 with: 1@1);
					add: 0@1 -> (Set with: 0@0 with: 0@2 with: 1@1);
					add: 0@2 -> (Set with: 0@1 with: 1@2 with: 1@1);
					add: 1@0 -> (Set with: 0@0 with: 2@0 with: 1@1);
					add: 1@1 -> (allPositions asSet remove: 1@1; yourself); 
					add: 1@2 -> (Set with: 0@2 with: 2@2 with: 1@1);
					add: 2@0 -> (Set with: 1@0 with: 2@1 with: 1@1);
					add: 2@1 -> (Set with: 2@0 with: 2@2 with: 1@1);
					add: 2@2 -> (Set with: 1@2 with: 2@1 with: 1@1).! !


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


!TerniLapilli methodsFor: 'private' stamp: 'MD 10/17/2019 14:34:45'!
at: aPosition place: aPiece
	self checkForLegalPlace: aPosition.

	tablero at: aPosition put: aPiece.
	piezasEnJuego := piezasEnJuego +1.
	
	self checkForWinnerOn: aPosition.
	
	state := state nextStateFor: self.! !

!TerniLapilli methodsFor: 'private' stamp: 'MD 10/17/2019 14:50:23'!
movePieceFrom: previousPosition to: newPosition
	|piece|
	
	self checkForLegalPlace: newPosition.
	(previousPosition dist: newPosition) >= 2 ifTrue:[self error: self class cannotMoveOutsideOfNeighboursErrorMessage].
	((movimientosValidos at: previousPosition) includes: newPosition) ifFalse: [self error: self class cannotMoveOverInvalidDIagonalErrorMessage ].
	
	piece := tablero at: previousPosition.
	
	tablero at: previousPosition put: TerniLapilliPositionEmpty new.
	tablero at: newPosition put: piece.
	
	self checkForWinnerOn: newPosition.
	
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


!TerniLapilli methodsFor: 'win conditions private' stamp: 'MD 10/17/2019 15:02:08'!
checkForWinnerOn: aPosition
	|x y|
	
	y := aPosition y.
	x := aPosition x.
	
	(self winningLineWith: (tablero at: 0@y) with: (tablero at: 1@y) with: (tablero at: 2@y)) ifTrue:[state := state thereWasAWinner].
	(self winningLineWith: (tablero at: x@0) with: (tablero at: x@1) with: (tablero at: x@2)) ifTrue:[state := state thereWasAWinner].
	(self winningLineWith: (tablero at: 0@0) with: (tablero at: 1@1) with: (tablero at: 2@2)) ifTrue:[state := state thereWasAWinner].
	(self winningLineWith: (tablero at: 0@2) with: (tablero at: 1@1) with: (tablero at: 2@0)) ifTrue:[state := state thereWasAWinner].
! !

!TerniLapilli methodsFor: 'win conditions private' stamp: 'MD 10/17/2019 14:45:07'!
winningLineWith: firstPiece with: secondPiece with: thirdPiece

	^ firstPiece isEmpty not and:[firstPiece = secondPiece and:[secondPiece = thirdPiece ]]
	! !


!TerniLapilli methodsFor: 'win testing' stamp: 'MD 10/17/2019 14:59:31'!
hasWinner
	^ state isGameOver! !

!TerniLapilli methodsFor: 'win testing' stamp: 'MD 10/17/2019 14:59:38'!
winner
	^ state winner! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TerniLapilli class' category: #TerniLapilli!
TerniLapilli class
	instanceVariableNames: ''!

!TerniLapilli class methodsFor: 'error messages' stamp: 'MD 10/15/2019 14:41:08'!
cannotMoveNonExistingPieceErrorMessage
	^ 'solo se pueden mover las 3 fichas desde las posiciones en las que estan'! !

!TerniLapilli class methodsFor: 'error messages' stamp: 'fz 10/16/2019 21:00:23'!
cannotMoveOutsideOfNeighboursErrorMessage
	^'no se puede mover a más de un espacio de distancia'! !

!TerniLapilli class methodsFor: 'error messages' stamp: 'MD 10/17/2019 13:35:40'!
cannotMoveOverInvalidDIagonalErrorMessage
	^'no se puede mover por diagonales invalidas'! !

!TerniLapilli class methodsFor: 'error messages' stamp: 'fz 10/15/2019 20:59:09'!
cannotMovePiecesBeforeSixArePlacedErrorMessage
	^'No se pueden mover las piezas antes de que se hayan colocado todas'! !

!TerniLapilli class methodsFor: 'error messages' stamp: 'MD 10/17/2019 15:17:33'!
cannotMovePiecesWhenTheGameIsOverErrorMessage
	^'ya te dije que el juego termino'! !

!TerniLapilli class methodsFor: 'error messages' stamp: 'MD 10/15/2019 14:22:13'!
cannotMoveTheOtherPlayersPiecesErrorMessage

	^ 'solo se pueden mover las fichas del jugador al que le toca el turno actual'.! !

!TerniLapilli class methodsFor: 'error messages' stamp: 'MD 10/15/2019 17:36:09'!
cannotPlaceAPieceOnAnOccupiedPositionErrorMessage

	^'no se pueden poner piezas en posiciones ocupadas'! !

!TerniLapilli class methodsFor: 'error messages' stamp: 'MD 10/15/2019 17:36:02'!
cannotPlaceMoreThan6PiecesOnBoardErrorMessage
	^ 'no se pueden poner mas de 6 fichas en el tablero'! !

!TerniLapilli class methodsFor: 'error messages' stamp: 'MD 10/15/2019 17:35:48'!
cannotPlacePieceOutsideBoardErrorMessageWith: aPosition

	^'no se pueden poner piezas fuera del rango 0@0 -- 2@2. ', aPosition asString , 'cae fuera del tablero'! !

!TerniLapilli class methodsFor: 'error messages' stamp: 'MD 10/17/2019 15:15:18'!
cannotPlacePiecesWhenTheGameIsOverErrorMessage
	^'ya termino el juego!!'! !

!TerniLapilli class methodsFor: 'error messages' stamp: 'MD 10/10/2019 18:24:34'!
cannotPlayOutOfTurnErrorMessage
	^ 'no puede jugar el jugador que no le toca'! !

!TerniLapilli class methodsFor: 'error messages' stamp: 'MD 10/17/2019 15:10:11'!
theresNoWinnerWhenAGameHasntEndedErrorMessage
	^'no se puede preguntar por el futuro ganador'! !


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


!classDefinition: #GameOverOWon category: #TerniLapilli!
GameOver subclass: #GameOverOWon
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!GameOverOWon methodsFor: 'win' stamp: 'MD 10/17/2019 15:05:58'!
isGameOver
	^true! !

!GameOverOWon methodsFor: 'win' stamp: 'MD 10/17/2019 15:07:17'!
winner
	^$O! !


!GameOverOWon methodsFor: 'next' stamp: 'MD 10/17/2019 15:06:23'!
nextStateFor: aTerniLapilli 
	^self! !


!GameOverOWon methodsFor: 'placing' stamp: 'MD 10/17/2019 15:15:49'!
placeOAt: aPosition on: aTerniLapilli 
	self error: TerniLapilli cannotPlacePiecesWhenTheGameIsOverErrorMessage! !

!GameOverOWon methodsFor: 'placing' stamp: 'MD 10/17/2019 15:15:45'!
placeXAt: aPosition on: aTerniLapilli 
	self error: TerniLapilli cannotPlacePiecesWhenTheGameIsOverErrorMessage! !


!GameOverOWon methodsFor: 'moving' stamp: 'MD 10/17/2019 15:19:06'!
moveOFrom: previousPosition to: newPosition on: aTerniLapilli
	self error: TerniLapilli cannotMovePiecesWhenTheGameIsOverErrorMessage! !

!GameOverOWon methodsFor: 'moving' stamp: 'MD 10/17/2019 15:19:03'!
moveXFrom: previousPosition to: newPosition on: aTerniLapilli
	self error: TerniLapilli cannotMovePiecesWhenTheGameIsOverErrorMessage! !


!classDefinition: #GameOverXWon category: #TerniLapilli!
GameOver subclass: #GameOverXWon
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!GameOverXWon methodsFor: 'win' stamp: 'MD 10/17/2019 15:06:01'!
isGameOver
	^true! !

!GameOverXWon methodsFor: 'win' stamp: 'MD 10/17/2019 15:06:58'!
winner
	^$X! !


!GameOverXWon methodsFor: 'next' stamp: 'MD 10/17/2019 15:06:35'!
nextStateFor: aTerniLapilli 
	^self! !


!GameOverXWon methodsFor: 'placing' stamp: 'MD 10/17/2019 15:15:03'!
placeOAt: aPosition on: aTerniLapilli 
	self error: TerniLapilli cannotPlacePiecesWhenTheGameIsOverErrorMessage! !

!GameOverXWon methodsFor: 'placing' stamp: 'MD 10/17/2019 15:15:37'!
placeXAt: aPosition on: aTerniLapilli 
	self error: TerniLapilli cannotPlacePiecesWhenTheGameIsOverErrorMessage! !


!GameOverXWon methodsFor: 'moving' stamp: 'MD 10/17/2019 15:18:50'!
moveOFrom: previousPosition to: newPosition on: aTerniLapilli
	self error: TerniLapilli cannotMovePiecesWhenTheGameIsOverErrorMessage! !

!GameOverXWon methodsFor: 'moving' stamp: 'MD 10/17/2019 15:18:54'!
moveXFrom: previousPosition to: newPosition on: aTerniLapilli
	self error: TerniLapilli cannotMovePiecesWhenTheGameIsOverErrorMessage! !


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

!MovingPhaseO methodsFor: 'moving' stamp: 'MD 10/17/2019 14:49:18'!
moveXFrom: previousPosition to: newPosition on: aTerniLapilli
	self error: TerniLapilli cannotPlayOutOfTurnErrorMessage ! !


!MovingPhaseO methodsFor: 'placing' stamp: 'fz 10/16/2019 22:30:19'!
placeOAt: aPosition on: aTerniLapilli 
	self error: TerniLapilli cannotPlaceMoreThan6PiecesOnBoardErrorMessage ! !

!MovingPhaseO methodsFor: 'placing' stamp: 'fz 10/16/2019 22:30:22'!
placeXAt: aPosition on: aTerniLapilli 
	self error: TerniLapilli cannotPlaceMoreThan6PiecesOnBoardErrorMessage ! !


!MovingPhaseO methodsFor: 'next' stamp: 'MD 10/17/2019 13:42:42'!
nextStateFor: aTerniLapilli 
	^MovingPhaseX new.! !


!MovingPhaseO methodsFor: 'win' stamp: 'MD 10/17/2019 15:05:21'!
isGameOver
	^false! !

!MovingPhaseO methodsFor: 'win' stamp: 'MD 10/17/2019 15:05:14'!
thereWasAWinner
	^GameOverOWon new! !

!MovingPhaseO methodsFor: 'win' stamp: 'MD 10/17/2019 15:10:33'!
winner
	self error: TerniLapilli theresNoWinnerWhenAGameHasntEndedErrorMessage! !


!MovingPhaseO methodsFor: 'turn testing' stamp: 'MD 10/17/2019 15:11:53'!
isPlayingO
	^true! !

!MovingPhaseO methodsFor: 'turn testing' stamp: 'MD 10/17/2019 15:11:58'!
isPlayingX
	^false! !


!classDefinition: #MovingPhaseX category: #TerniLapilli!
MovingPhase subclass: #MovingPhaseX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!MovingPhaseX methodsFor: 'moving' stamp: 'MD 10/17/2019 14:49:24'!
moveOFrom: previousPosition to: newPosition on: aTerniLapilli
	self error: TerniLapilli cannotPlayOutOfTurnErrorMessage ! !

!MovingPhaseX methodsFor: 'moving' stamp: 'fz 10/16/2019 22:25:52'!
moveXFrom: previousPosition to: newPosition on: aTerniLapilli
	
	(aTerniLapilli pieceAt: previousPosition) checkLegalMovingPieceForX.
	
	aTerniLapilli movePieceFrom: previousPosition to: newPosition.
	
	! !


!MovingPhaseX methodsFor: 'next' stamp: 'MD 10/17/2019 13:42:35'!
nextStateFor: aTerniLapilli 
	^MovingPhaseO new.! !


!MovingPhaseX methodsFor: 'placing' stamp: 'fz 10/16/2019 22:30:09'!
placeOAt: aPosition on: aTerniLapilli 
	self error: TerniLapilli cannotPlaceMoreThan6PiecesOnBoardErrorMessage ! !

!MovingPhaseX methodsFor: 'placing' stamp: 'fz 10/16/2019 22:30:11'!
placeXAt: aPosition on: aTerniLapilli 
	self error: TerniLapilli cannotPlaceMoreThan6PiecesOnBoardErrorMessage ! !


!MovingPhaseX methodsFor: 'win' stamp: 'MD 10/17/2019 15:00:22'!
isGameOver
	^false! !

!MovingPhaseX methodsFor: 'win' stamp: 'MD 10/17/2019 15:04:42'!
thereWasAWinner
	^GameOverXWon new! !

!MovingPhaseX methodsFor: 'win' stamp: 'MD 10/17/2019 15:09:47'!
winner
	self error: TerniLapilli theresNoWinnerWhenAGameHasntEndedErrorMessage! !


!MovingPhaseX methodsFor: 'turn testing' stamp: 'MD 10/17/2019 15:12:16'!
isPlayingO
	^false! !

!MovingPhaseX methodsFor: 'turn testing' stamp: 'MD 10/17/2019 15:12:12'!
isPlayingX
	^true! !


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

!PlacingPhaseO methodsFor: 'turn testing' stamp: 'MD 10/17/2019 15:11:27'!
isPlayingX
	^false! !


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


!PlacingPhaseO methodsFor: 'win' stamp: 'MD 10/17/2019 15:03:14'!
isGameOver
	^false! !

!PlacingPhaseO methodsFor: 'win' stamp: 'MD 10/17/2019 15:05:33'!
thereWasAWinner
	^GameOverOWon new! !

!PlacingPhaseO methodsFor: 'win' stamp: 'MD 10/17/2019 15:10:42'!
winner
	self error: TerniLapilli theresNoWinnerWhenAGameHasntEndedErrorMessage! !


!classDefinition: #PlacingPhaseX category: #TerniLapilli!
PlacingPhase subclass: #PlacingPhaseX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!PlacingPhaseX methodsFor: 'turn testing' stamp: 'MD 10/17/2019 15:11:17'!
isPlayingO
	^false! !

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


!PlacingPhaseX methodsFor: 'win' stamp: 'MD 10/17/2019 15:05:00'!
isGameOver
	^false! !

!PlacingPhaseX methodsFor: 'win' stamp: 'MD 10/17/2019 15:02:45'!
thereWasAWinner
	^GameOverXWon new! !

!PlacingPhaseX methodsFor: 'win' stamp: 'MD 10/17/2019 15:10:46'!
winner
	self error: TerniLapilli theresNoWinnerWhenAGameHasntEndedErrorMessage! !

TerniLapilliPositionEmpty initialize!
TerniLapilliPositionO initialize!
TerniLapilliPositionX initialize!