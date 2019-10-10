!classDefinition: #TerniLapilliTest category: #TerniLapilli!
TestCase subclass: #TerniLapilliTest
	instanceVariableNames: 'juegoNuevo juegoCon6Fichas'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!TerniLapilliTest methodsFor: 'tests - puesta de fichas' stamp: 'MD 10/10/2019 20:14:19'!
test04SePuedePonerUnaFichaDentroDelTablero

	juegoNuevo putXAt: 0@0.
	
	self assert: juegoNuevo isPlayingO.
	self assert: (juegoNuevo isXAt: 0@0).
	! !

!TerniLapilliTest methodsFor: 'tests - puesta de fichas' stamp: 'MD 10/10/2019 19:38:01'!
test05NoPuedoPonerFichaFueraDelTablero

	self should: [juegoNuevo putXAt: -1@0]
		raise: Error 
		withExceptionDo: [:anError | self assert: anError messageText equals: (TerniLapilli cannotPutPieceOutsideBoardErrorMessageWith: -1@0)].
	
	
	
	! !

!TerniLapilliTest methodsFor: 'tests - puesta de fichas' stamp: 'MD 10/10/2019 19:41:42'!
test06NoPuedePonerFichaQuienNoJuega
	
	self should: [juegoNuevo putOAt: 0@0.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotPlayOutOfTurnErrorMessage.
							self deny: (juegoNuevo isOAt: 0@0)].
	
	! !

!TerniLapilliTest methodsFor: 'tests - puesta de fichas' stamp: 'MD 10/10/2019 20:15:46'!
test07SePuedenPonerHasta6Fichas
			
	self should: [juegoCon6Fichas putXAt: 2@1]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotPutMoreThan6PiecesOnBoardErrorMessage.
							self deny: (juegoCon6Fichas isXAt: 2@1)].! !

!TerniLapilliTest methodsFor: 'tests - puesta de fichas' stamp: 'MD 10/10/2019 20:16:38'!
test08NoSePuedePonerFichaEnPosicionOcupada
	
	juegoNuevo putXAt: 0@0.
	
	self should: [juegoNuevo putOAt: 0@0]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: TerniLapilli cannotPutAPieceOnAnOccupiedPositionErrorMessage.
							self deny: (juegoNuevo isOAt: 0@0)].! !


!TerniLapilliTest methodsFor: 'setUp' stamp: 'MD 10/10/2019 18:48:54'!
setUp

	juegoNuevo := TerniLapilli new.
	
	juegoCon6Fichas := TerniLapilli new.
	juegoCon6Fichas putXAt: 0@0.
	juegoCon6Fichas putOAt: 0@1.
	juegoCon6Fichas putXAt: 1@0.
	juegoCon6Fichas putOAt: 1@1.
	juegoCon6Fichas putXAt: 2@2.
	juegoCon6Fichas putOAt: 0@2.! !


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


!TerniLapilliTest methodsFor: 'tests - movida de fichas' stamp: 'MD 10/10/2019 20:36:20'!
test09DespuesDe6FichasXPuedeMoverUnaSuya
	
	juegoCon6Fichas moveXFrom: 1@1 To: 2@1.
	
	self deny: (juegoCon6Fichas isXAt: 1@1).
	self assert: (juegoCon6Fichas isXAt: 2@1).
	
	"10 no se puede mover ficha de otro jugador"
	"11 no se puede mover ficha si previous no es ficha existente"
	"12 no se puede mover a una posicion ocupada (funcionaria bien porque usamos putXto ?? que ya chequea eso), no irme de tablero" "se podria abstraer checkIfLegalPlace en vez de reutilizar putX"
	"en vez de generalizar de una, hacer varios tests que rompan el move y copiar de uno a uno los chequeos del put"! !


!classDefinition: #TerniLapilli category: #TerniLapilli!
Object subclass: #TerniLapilli
	instanceVariableNames: 'aQuienLeToca tablero'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!TerniLapilli methodsFor: 'initialization' stamp: 'MD 10/10/2019 17:34:34'!
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


!TerniLapilli methodsFor: 'turnTaking' stamp: 'MD 10/10/2019 17:25:36'!
pasaTurno

	self isPlayingX ifTrue: [aQuienLeToca := $O] ifFalse: [aQuienLeToca := $X].! !

!TerniLapilli methodsFor: 'turnTaking' stamp: 'MD 10/10/2019 20:30:13'!
playAs: aPlayer at: aPosition onTurn: isOnTurn

	((aPosition x between: 0 and: 2) and: [aPosition y between: 0 and: 2]) ifFalse: [self error: (self class cannotPutPieceOutsideBoardErrorMessageWith: aPosition)].
	(tablero includesKey: aPosition) ifTrue: [self error: self class cannotPutAPieceOnAnOccupiedPositionErrorMessage ].
	isOnTurn ifFalse: [self error: self class cannotPlayOutOfTurnErrorMessage].
	
	tablero size >= 6 ifTrue: [self error: self class cannotPutMoreThan6PiecesOnBoardErrorMessage].
	tablero at: aPosition put: aPlayer.
	self pasaTurno.! !

!TerniLapilli methodsFor: 'turnTaking' stamp: 'MD 10/10/2019 18:34:00'!
putOAt: aPosition 

	self playAs: $O at: aPosition onTurn: self isPlayingO.! !

!TerniLapilli methodsFor: 'turnTaking' stamp: 'MD 10/10/2019 18:35:22'!
putXAt: aPosition

	self playAs: $X at: aPosition onTurn: self isPlayingX ! !


!TerniLapilli methodsFor: 'private' stamp: 'MD 10/10/2019 20:13:24'!
pieceAt: aPosition equals: aPlayer

	^ (tablero includesKey: aPosition) and: [(tablero at: aPosition) = aPlayer].! !


!TerniLapilli methodsFor: 'as yet unclassified' stamp: 'MD 10/10/2019 20:35:03'!
moveXFrom: previousPosition To: newPosition
	tablero removeKey: previousPosition.
	tablero at: newPosition put: $X.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TerniLapilli class' category: #TerniLapilli!
TerniLapilli class
	instanceVariableNames: ''!

!TerniLapilli class methodsFor: 'errorMessages' stamp: 'MD 10/10/2019 18:24:34'!
cannotPlayOutOfTurnErrorMessage
	^ 'no puede jugar el jugador que no le toca'! !

!TerniLapilli class methodsFor: 'errorMessages' stamp: 'MD 10/10/2019 18:53:13'!
cannotPutAPieceOnAnOccupiedPositionErrorMessage

	^'no se pueden poner piezas en posiciones ocupadas'! !

!TerniLapilli class methodsFor: 'errorMessages' stamp: 'MD 10/10/2019 18:46:58'!
cannotPutMoreThan6PiecesOnBoardErrorMessage
	^ 'no se pueden poner mas de 6 fichas en el tablero'! !

!TerniLapilli class methodsFor: 'errorMessages' stamp: 'MD 10/10/2019 17:45:50'!
cannotPutPieceOutsideBoardErrorMessageWith: aPosition

	^'no se pueden poner piezas fuera del rango 0@0 -- 2@2. ', aPosition asString , 'cae fuera del tablero'! !
