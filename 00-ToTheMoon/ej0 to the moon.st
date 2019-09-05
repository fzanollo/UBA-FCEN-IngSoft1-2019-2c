!classDefinition: #Brazo category: #'ej0 to the moon'!
DenotativeObject subclass: #Brazo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ej0 to the moon'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Brazo class' category: #'ej0 to the moon'!
Brazo class
	instanceVariableNames: 'porosidadMinima durezaMinima tiposDeSuelo durezaMaxima porosidadMaxima'!

!Brazo class methodsFor: 'acciones' stamp: 'fz 9/4/2019 21:54:52'!
cerrarPinza
	^ 'cierro la pinza'.! !

!Brazo class methodsFor: 'acciones' stamp: 'fz 9/5/2019 00:52:57'!
guardarMuestra
	^ 'guardo la muestra'.
	"acá debería ir la lógica para guardar la muestra, con las interacciones a otros módulos necesarias para hacerlo"! !

!Brazo class methodsFor: 'acciones' stamp: 'fz 9/4/2019 21:59:37'!
tomarMuestraConDureza: dureza yPorosidad: porosidad

	tiposDeSuelo keysAndValuesDo: [ :condiciones :procedimiento |
		(self cumpleCondiciones: condiciones conDureza: dureza yPorosidad: porosidad) ifTrue: [ 
			procedimiento value ]
	].
	
	self guardarMuestra.! !


!Brazo class methodsFor: 'inicializacion' stamp: 'fz 9/4/2019 23:12:24'!
agregarTipoDeSueloConDurezaEntre: intervaloDureza porosidadEntre: intervaloPorosidad yProcedimiento: procedimiento
	| condiciones |
	
	(self intervaloDeDurezaValido: intervaloDureza) ifFalse: [^self error: self descripcionIntervaloDurezaInvalido].
	(self intervaloDePorosidadValido: intervaloPorosidad ) ifFalse: [^self error: self descripcionIntervaloPorosidadInvalido].
	
	condiciones _ Array
		with: intervaloDureza 
		with: intervaloPorosidad .
	
	(self lasCondicionesSeSolapanConOtras: condiciones) ifTrue: [^self error: self descripcionParaSolapamientoDeCondiciones].
	
	tiposDeSuelo
		at: condiciones
		put: procedimiento.! !

!Brazo class methodsFor: 'inicializacion' stamp: 'fz 9/5/2019 00:29:25'!
iniciarConDurezaMinima: durezaMin durezaMaxima: durezaMax porosidadMinima: porosidadMin porosidadMaxima: porosidadMax
	durezaMinima := durezaMin.
	durezaMaxima := durezaMax.
	porosidadMinima := porosidadMin.
	porosidadMaxima := porosidadMax.
	
	tiposDeSuelo _ Dictionary new.! !


!Brazo class methodsFor: 'mensajesQueDeberianEstarEnOtroLado' stamp: 'fz 9/5/2019 00:47:23'!
inicializarCasosPedidosPorElEjercicio
	"debido a que tuvimos un problema con el parser de denotativeObjects dejamos acá las colaboraciones necesarias para inicializar nuestro objeto Brazo en función de resolver el ejercicio"
	
	|intervaloDureza intervaloPorosidad instrucciones|
	
	"agregar caso 1"
	intervaloDureza := Interval from: 60 to: 100.
	intervaloPorosidad := Interval from: 60 to: 100.

	instrucciones := [Mecha girarConDireccion: #der velocidad: 150 duracion: 10*minute.
	Brazo cerrarPinza.
	Mecha girarConDireccion: #izq velocidad: 150 duracion: 10*minute ].

	Brazo agregarTipoDeSueloConDurezaEntre: intervaloDureza porosidadEntre: intervaloPorosidad yProcedimiento: instrucciones.
	
	"agregar caso 2"
	intervaloDureza := Interval from: 0 to: 30.
	intervaloPorosidad := Interval from: 0 to: 30.

	instrucciones := [Mecha girarConDireccion: #izq velocidad: 100 duracion: 5*minute.
	Brazo cerrarPinza.
	Mecha girarConDireccion: #der velocidad: 100 duracion: 5*minute ].

	Brazo agregarTipoDeSueloConDurezaEntre: intervaloDureza porosidadEntre: intervaloPorosidad yProcedimiento: instrucciones.
	
	"agregar caso 3"
	intervaloDureza := Interval from: 31 to: 59.
	intervaloPorosidad := Interval from: 31 to: 59.

	instrucciones := [Mecha girarConDireccion: #der velocidad: 150 duracion: 5*minute.
	Brazo cerrarPinza.
	Mecha girarConDireccion: #izq velocidad: 100 duracion: 10*minute ].

	Brazo agregarTipoDeSueloConDurezaEntre: intervaloDureza porosidadEntre: intervaloPorosidad yProcedimiento: instrucciones.! !

!Brazo class methodsFor: 'mensajesQueDeberianEstarEnOtroLado' stamp: 'fz 9/5/2019 00:32:41'!
intervalo: intervalo seSolapaCon: intervaloNuevo
	"este mensaje lo dejamos aca pero deberia ir en la clase Interval"

	^(intervalo includes: intervaloNuevo first) or: [(intervalo includes: intervaloNuevo last)
		or:[ (intervaloNuevo includes: intervalo first) or: [(intervaloNuevo includes: intervalo last)
				]]].! !


!Brazo class methodsFor: 'auxiliares' stamp: 'fz 9/2/2019 20:56:16'!
cumpleCondiciones: condiciones conDureza: dureza yPorosidad: porosidad

	^((condiciones at: 1) includes: dureza) and: [ (condiciones at: 2) includes: porosidad ]! !


!Brazo class methodsFor: 'descripcionesError' stamp: 'fz 9/4/2019 23:16:03'!
descripcionIntervaloDurezaInvalido
	^'Intervalo de dureza invalido'
	! !

!Brazo class methodsFor: 'descripcionesError' stamp: 'fz 9/4/2019 23:16:11'!
descripcionIntervaloPorosidadInvalido
	^'Intervalo de porosidad invalido'
	! !

!Brazo class methodsFor: 'descripcionesError' stamp: 'fz 9/4/2019 21:33:16'!
descripcionParaSolapamientoDeCondiciones
	^'los intervalos señalados tienen solapamiento con los ya definidos'.! !


!Brazo class methodsFor: 'validaciones' stamp: 'fz 9/5/2019 00:39:45'!
intervaloDeDurezaValido: intervaloDureza
	^ durezaMinima <= intervaloDureza first and:[intervaloDureza last <= durezaMaxima].! !

!Brazo class methodsFor: 'validaciones' stamp: 'fz 9/5/2019 00:40:45'!
intervaloDePorosidadValido: intervaloPorosidad
	^ porosidadMinima <= intervaloPorosidad first and:[intervaloPorosidad last <= porosidadMaxima ].! !

!Brazo class methodsFor: 'validaciones' stamp: 'fz 9/5/2019 00:33:38'!
lasCondicionesSeSolapanConOtras: condicionesNuevas

	tiposDeSuelo keysDo: [:condiciones | 
		((self intervalo: (condiciones at:1) seSolapaCon: (condicionesNuevas at:1)) 
		and:[self intervalo: (condiciones at:2) seSolapaCon: (condicionesNuevas at:2)]
		) ifTrue: [^true]
	].

	^false.! !


!Brazo class methodsFor: 'as yet unclassified' stamp: 'fz 9/5/2019 00:54:40'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	porosidadMinima := 0.
	durezaMinima := 0.
	tiposDeSuelo := ((Dictionary new)).
	durezaMaxima := 100.
	porosidadMaxima := 100.! !


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

!Mecha class methodsFor: 'acciones' stamp: 'fz 9/5/2019 00:50:34'!
girarConDireccion: direccion velocidad: velocidad duracion: duracion
	"agregamos una mecha y chequeos basicos para mostrar como sería la interacción"
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


!Mecha class methodsFor: 'as yet unclassified' stamp: 'fz 9/5/2019 00:54:40'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	velocidadMaxima := 1000.
	duracionMaxima := (SimpleMeasure basicNew instVarAt: 1 put: 100; instVarAt: 2 put: (ProportionalDerivedUnit basicNew instVarAt: 1 put: 'minute'; instVarAt: 2 put: 'minutes'; instVarAt: 3 put: 'NO SIGN'; instVarAt: 4 put: (BaseUnit basicNew instVarAt: 1 put: 'day'; instVarAt: 2 put: 'days'; instVarAt: 3 put: 'NO SIGN'; yourself); instVarAt: 5 put: (1/1440); yourself); yourself).! !

Brazo initializeAfterFileIn!
Mecha initializeAfterFileIn!