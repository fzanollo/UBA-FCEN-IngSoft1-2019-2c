!classDefinition: #Brazo category: #'ej0 to the moon'!
DenotativeObject subclass: #Brazo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ej0 to the moon'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Brazo class' category: #'ej0 to the moon'!
Brazo class
	instanceVariableNames: 'tiposDeSuelo'!

!Brazo class methodsFor: 'acciones' stamp: 'fz 9/2/2019 20:52:11'!
agregarTipoDeSueloConDurezaEntre: intervaloDureza porosidadEntre: intervaloPorosidad yProcesamiento: procesamiento
	| condiciones |
	condiciones _ Array
		with: intervaloDureza 
		with: intervaloPorosidad .
	tiposDeSuelo
		at: condiciones
		put: procesamiento.! !

!Brazo class methodsFor: 'acciones' stamp: 'fz 9/2/2019 20:45:33'!
cerrarPinza
	^ 'cerrar pinza'.! !

!Brazo class methodsFor: 'acciones' stamp: 'fz 9/2/2019 20:56:16'!
cumpleCondiciones: condiciones conDureza: dureza yPorosidad: porosidad

	^((condiciones at: 1) includes: dureza) and: [ (condiciones at: 2) includes: porosidad ]! !

!Brazo class methodsFor: 'acciones' stamp: 'fz 9/2/2019 20:45:18'!
guardarMuestra
	^ 'guardo la muestra'.! !

!Brazo class methodsFor: 'acciones' stamp: 'fz 9/2/2019 20:56:32'!
tomarMuestraConDureza: dureza yPorosidad: porosidad

	tiposDeSuelo keysAndValuesDo: [ :condiciones :procedimiento |
		(self cumpleCondiciones: condiciones conDureza: dureza yPorosidad: porosidad) ifTrue: [ 
			procedimiento value ]
	].
	
	self guardarMuestra.! !


!Brazo class methodsFor: 'inicializacion' stamp: 'fz 9/2/2019 20:45:09'!
inicializacion
	tiposDeSuelo _ Dictionary new.! !


!Brazo class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 20:56:58'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	tiposDeSuelo := ((Dictionary new)).! !


!classDefinition: #Mecha category: #'ej0 to the moon'!
DenotativeObject subclass: #Mecha
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ej0 to the moon'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Mecha class' category: #'ej0 to the moon'!
Mecha class
	instanceVariableNames: 'velocidadMaxima duracionMaxima'!

!Mecha class methodsFor: 'acciones' stamp: 'fz 9/2/2019 20:48:18'!
girarConDireccion: direccion velocidad: velocidad duracion: duracion
	(direccion = #izq or: [ direccion = #der ]) ifFalse: [ ^ self error: self descripcionErrorDireccionInvalida ].
	(velocidad < 0 or: [ velocidad > velocidadMaxima ]) ifTrue: [ ^ self error: self descripcionErrorVelocidadInvalida ].
	(duracion < 0 or: [ duracion > duracionMaxima ]) ifTrue: [ ^ self error: self descripcionErrorDuracionInvalida ].
	Transcript
		show: 'direccion: ' , direccion , ', velocidad: ' , velocidad printString , ', duracion: ' , duracion printString;
		newLine.! !


!Mecha class methodsFor: 'mensajes de error' stamp: 'fz 9/2/2019 20:48:46'!
descripcionErrorDireccionInvalida
	^ 'direccion inválida'.! !

!Mecha class methodsFor: 'mensajes de error' stamp: 'fz 9/2/2019 20:48:54'!
descripcionErrorDuracionInvalida
	^ 'duración inválida'.! !

!Mecha class methodsFor: 'mensajes de error' stamp: 'fz 9/2/2019 20:49:03'!
descripcionErrorVelocidadInvalida
	^ 'velocidad inválida'.! !


!Mecha class methodsFor: 'as yet unclassified' stamp: 'fz 9/2/2019 20:56:58'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	velocidadMaxima := 100.
	duracionMaxima := 100.! !

Brazo initializeAfterFileIn!
Mecha initializeAfterFileIn!