!classDefinition: #TerniLapilliTest category: #TerniLapilli!
TestCase subclass: #TerniLapilliTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!TerniLapilliTest methodsFor: 'tests' stamp: 'MD 10/10/2019 17:24:31'!
test01InicialmenteJuegaX

	| juego |
	juego := TerniLapilli new.
	
	self assert: juego isPlayingX.
	! !

!TerniLapilliTest methodsFor: 'tests' stamp: 'MD 10/10/2019 17:24:18'!
test02DespuesDeXJuegaO

	| juego |
	juego := TerniLapilli new.
	
	juego pasaTurno.
	
	self assert: juego isPlayingO.
	! !

!TerniLapilliTest methodsFor: 'tests' stamp: 'MD 10/10/2019 17:24:38'!
test03DespuesDeOJuegaX

	| juego |
	juego := TerniLapilli new.
	
	juego pasaTurno.
	juego pasaTurno.
	
	self assert: juego isPlayingX.
	! !


!classDefinition: #TerniLapilli category: #TerniLapilli!
Object subclass: #TerniLapilli
	instanceVariableNames: 'aQuienLeToca'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TerniLapilli'!

!TerniLapilli methodsFor: 'initialization' stamp: 'MD 10/10/2019 17:16:40'!
initialize

	aQuienLeToca := $X.! !


!TerniLapilli methodsFor: 'testing' stamp: 'MD 10/10/2019 17:25:13'!
isPlayingO

	^ aQuienLeToca = $O .! !

!TerniLapilli methodsFor: 'testing' stamp: 'MD 10/10/2019 17:25:05'!
isPlayingX

	^ aQuienLeToca = $X .! !


!TerniLapilli methodsFor: 'turnTaking' stamp: 'MD 10/10/2019 17:25:36'!
pasaTurno

	self isPlayingX ifTrue: [aQuienLeToca := $O] ifFalse: [aQuienLeToca := $X].! !
