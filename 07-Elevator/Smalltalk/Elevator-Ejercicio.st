!classDefinition: #ElevatorEmergency category: #'Elevator-Ejercicio'!
Error subclass: #ElevatorEmergency
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!


!classDefinition: #ElevatorTest category: #'Elevator-Ejercicio'!
TestCase subclass: #ElevatorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:38'!
test09RequestToGoUpAreEnqueueWhenRequestedWhenCabinIsMoving

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorOpened.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinWaitingForPeople.
	self assert: elevatorController isCabinDoorOpened.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:39'!
test10CabinDoorStartClosingAfterWaitingForPeople

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorOpened.
	elevatorController waitForPeopleTimedOut.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:39'!
test11StopsWaitingForPeopleIfCloseDoorIsPressed

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorOpened.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinWaitingForPeople.
	self assert: elevatorController isCabinDoorOpened.

	elevatorController closeCabinDoor.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.
! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:39'!
test12CloseDoorDoesNothingIfIdle

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController closeCabinDoor.

	self assert: elevatorController isIdle.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpened.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:40'!
test13CloseDoorDoesNothingWhenCabinIsMoving

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.

	elevatorController closeCabinDoor.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:40'!
test14CloseDoorDoesNothingWhenOpeningTheDoorToWaitForPeople

	| elevatorController |
	elevatorController := ElevatorController new.
		
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.

	elevatorController closeCabinDoor.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !


!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:42'!
test15ElevatorHasToEnterEmergencyIfStoppedAndOtherFloorSensorTurnsOn

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	self 
		should: [ elevatorController cabinOnFloor:0 ]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de cabina desincronizado' ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:47'!
test16ElevatorHasToEnterEmergencyIfFalling

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	self 
		should: [ elevatorController cabinOnFloor:0 ]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de cabina desincronizado'. ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:47'!
test17ElevatorHasToEnterEmergencyIfJumpsFloors

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:3.
	elevatorController cabinDoorClosed.
	self 
		should: [ elevatorController cabinOnFloor: 3 ]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de cabina desincronizado'. ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:48'!
test18ElevatorHasToEnterEmergencyIfDoorClosesAutomatically
	| elevatorController |
	elevatorController := ElevatorController new.
	
	self 
		should: [ elevatorController cabinDoorClosed.]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de puerta desincronizado' ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:48'!
test19ElevatorHasToEnterEmergencyIfDoorClosedSensorTurnsOnWhenClosed

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	self 
		should: [elevatorController cabinDoorClosed.]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de puerta desincronizado'. ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:49'!
test20ElevatorHasToEnterEmergencyIfDoorClosesWhenOpening
	| elevatorController |
	elevatorController := ElevatorController new.
		
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	self 
		should: [elevatorController cabinDoorClosed.]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de puerta desincronizado'.]! !


!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 7/10/2011 17:35'!
test06DoorKeepsOpenedWhenOpeningIsRequested

	| elevatorController |
	elevatorController := ElevatorController new.
	
	self assert: elevatorController isCabinDoorOpened.
	
	elevatorController openCabinDoor.

	self assert: elevatorController isCabinDoorOpened.! !

!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 6/16/2014 13:24'!
test07DoorMustBeOpenedWhenCabinIsStoppedAndClosingDoors

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
		
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.
		
	elevatorController openCabinDoor.
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.
! !

!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 7/10/2011 17:36'!
test08CanNotOpenDoorWhenCabinIsMoving

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.

	elevatorController openCabinDoor.
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 7/10/2011 17:51'!
test09DoorKeepsOpeneingWhenItIsOpeneing

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.

	elevatorController openCabinDoor.
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !


!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:50'!
test21CabinHasToStopOnTheFloorsOnItsWay
	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinOnFloor:1.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !

!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:50'!
test22ElevatorCompletesAllTheRequests
	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinOnFloor:1.
	elevatorController cabinDoorOpened.
	elevatorController waitForPeopleTimedOut.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:2.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !

!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:50'!
test23CabinHasToStopOnFloorsOnItsWayNoMatterHowTheyWellCalled

	| elevatorController |
	elevatorController := ElevatorController new.
		
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinOnFloor:1.
		
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !

!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:51'!
test24CabinHasToStopAndWaitForPeopleOnFloorsOnItsWayNoMatterHowTheyWellCalled

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinOnFloor:1.
	elevatorController cabinDoorOpened.
	elevatorController waitForPeopleTimedOut.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.! !


!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/10/2011 17:33'!
test01ElevatorStartsIdleWithDoorOpenOnFloorZero

	| elevatorController |
		
	elevatorController := ElevatorController new.
		
	self assert: elevatorController isIdle.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpened.
	self assert: elevatorController cabinFloorNumber = 0
! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 17:53'!
test02CabinDoorStartsClosingWhenElevatorGetsCalled

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor: 1.
	
	self deny: elevatorController isIdle.
	self assert: elevatorController isWorking.
	
	self assert: elevatorController isCabinStopped.
	self deny: elevatorController isCabinMoving.
	
	self deny: elevatorController isCabinDoorOpened.
	self deny: elevatorController isCabinDoorOpening.
	self assert: elevatorController isCabinDoorClosing.
	self deny: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 17:57'!
test03CabinStartsMovingWhenDoorGetsClosed

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	
	self deny: elevatorController isIdle.
	self assert: elevatorController isWorking.

	self deny: elevatorController isCabinStopped.
	self assert: elevatorController isCabinMoving.
	
	self deny: elevatorController isCabinDoorOpened.
	self deny: elevatorController isCabinDoorOpening.
	self deny: elevatorController isCabinDoorClosing.
	self assert: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 18:00'!
test04CabinStopsAndStartsOpeningDoorWhenGetsToDestination

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor: 1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor: 1.

	self deny: elevatorController isIdle.
	self assert: elevatorController isWorking.
	
	self assert: elevatorController isCabinStopped.
	self deny: elevatorController isCabinMoving.
			
	self deny: elevatorController isCabinDoorOpened.
	self assert: elevatorController isCabinDoorOpening.
	self deny: elevatorController isCabinDoorClosing.
	self deny: elevatorController isCabinDoorClosed.

	self assert: elevatorController cabinFloorNumber = 1
! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 18:00'!
test05ElevatorGetsIdleWhenDoorGetOpened

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor: 1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor: 1.
	elevatorController cabinDoorOpened.
		
	self assert: elevatorController isIdle.
	self deny: elevatorController isWorking.
		
	self assert: elevatorController isCabinStopped.
	self deny: elevatorController isCabinMoving.

	self assert: elevatorController isCabinDoorOpened.
	self deny: elevatorController isCabinDoorOpening.
	self deny: elevatorController isCabinDoorClosing.
	self deny: elevatorController isCabinDoorClosed.
		
	self assert: elevatorController cabinFloorNumber = 1! !


!classDefinition: #Cabin category: #'Elevator-Ejercicio'!
Object subclass: #Cabin
	instanceVariableNames: 'state'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Cabin methodsFor: 'testing' stamp: 'fz 10/10/2017 23:18:59'!
isMoving
	^state = self class movingState! !

!Cabin methodsFor: 'testing' stamp: 'fz 10/10/2017 23:19:40'!
isStopped
	^state = self class stoppedState! !

!Cabin methodsFor: 'testing' stamp: 'fz 10/10/2017 23:20:34'!
isWaitingForPeople
	^state = self class waitingForPeopleState! !


!Cabin methodsFor: 'initialize' stamp: 'fz 10/10/2017 23:32:44'!
initialize
	state := self class stoppedState.! !


!Cabin methodsFor: 'actions' stamp: 'fz 10/10/2017 23:28:15'!
move
	state := self class movingState.! !

!Cabin methodsFor: 'actions' stamp: 'fz 10/10/2017 23:31:22'!
stop
	state := self class stoppedState.! !

!Cabin methodsFor: 'actions' stamp: 'fz 10/10/2017 23:34:56'!
waitForPeople
	state := self class waitingForPeopleState.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cabin class' category: #'Elevator-Ejercicio'!
Cabin class
	instanceVariableNames: ''!

!Cabin class methodsFor: 'states' stamp: 'fz 10/10/2017 23:18:28'!
movingState
	^#Moving! !

!Cabin class methodsFor: 'states' stamp: 'fz 10/10/2017 23:19:57'!
stoppedState
	^#Stopped.! !

!Cabin class methodsFor: 'states' stamp: 'fz 10/10/2017 23:20:50'!
waitingForPeopleState
	^#WaitingForPeople.! !


!classDefinition: #CabinDoor category: #'Elevator-Ejercicio'!
Object subclass: #CabinDoor
	instanceVariableNames: 'state'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinDoor methodsFor: 'testing' stamp: 'fz 10/10/2017 23:40:55'!
isClosed
	^state = self class closedState.! !

!CabinDoor methodsFor: 'testing' stamp: 'fz 10/10/2017 23:41:07'!
isClosing
	^state = self class closingState.! !

!CabinDoor methodsFor: 'testing' stamp: 'fz 10/10/2017 23:41:21'!
isOpened
	^state = self class openedState.! !

!CabinDoor methodsFor: 'testing' stamp: 'fz 10/10/2017 23:41:32'!
isOpening
	^state = self class openingState.! !


!CabinDoor methodsFor: 'initialize' stamp: 'fz 10/10/2017 23:46:01'!
initialize
	state := self class openedState.! !


!CabinDoor methodsFor: 'actions' stamp: 'fz 10/10/2017 23:47:19'!
close
	state := self class closingState ! !

!CabinDoor methodsFor: 'actions' stamp: 'fz 10/10/2017 23:47:59'!
open
	state := self class openingState ! !


!CabinDoor methodsFor: 'signals' stamp: 'fz 10/10/2017 23:49:26'!
closed
	state := self class closedState ! !

!CabinDoor methodsFor: 'signals' stamp: 'fz 10/10/2017 23:49:45'!
opened
	state := self class openedState ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CabinDoor class' category: #'Elevator-Ejercicio'!
CabinDoor class
	instanceVariableNames: ''!

!CabinDoor class methodsFor: 'states' stamp: 'fz 10/10/2017 23:42:34'!
closedState
	^#Closed! !

!CabinDoor class methodsFor: 'states' stamp: 'fz 10/10/2017 23:42:45'!
closingState
	^#Closing! !

!CabinDoor class methodsFor: 'states' stamp: 'fz 10/10/2017 23:42:55'!
openedState
	^#Opened! !

!CabinDoor class methodsFor: 'states' stamp: 'fz 10/10/2017 23:43:05'!
openingState
	^#Opening! !


!classDefinition: #ElevatorController category: #'Elevator-Ejercicio'!
Object subclass: #ElevatorController
	instanceVariableNames: 'state cabinFloorNumber floorsToGo cabin cabinDoor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorController methodsFor: 'testing' stamp: 'fz 10/10/2017 23:45:14'!
cabinFloorNumber
	^cabinFloorNumber! !

!ElevatorController methodsFor: 'testing' stamp: 'fz 10/10/2017 23:43:56'!
isCabinDoorClosed
	^cabinDoor isClosed.! !

!ElevatorController methodsFor: 'testing' stamp: 'fz 10/10/2017 23:44:11'!
isCabinDoorClosing
	^cabinDoor isClosing.! !

!ElevatorController methodsFor: 'testing' stamp: 'fz 10/10/2017 23:44:26'!
isCabinDoorOpened
	^cabinDoor isOpened.! !

!ElevatorController methodsFor: 'testing' stamp: 'fz 10/10/2017 23:44:34'!
isCabinDoorOpening
	^cabinDoor isOpening.! !

!ElevatorController methodsFor: 'testing' stamp: 'fz 10/10/2017 23:18:51'!
isCabinMoving
	^cabin isMoving! !

!ElevatorController methodsFor: 'testing' stamp: 'fz 10/10/2017 23:20:09'!
isCabinStopped
	^cabin isStopped ! !

!ElevatorController methodsFor: 'testing' stamp: 'fz 10/10/2017 23:21:43'!
isCabinWaitingForPeople
	^cabin isWaitingForPeople ! !

!ElevatorController methodsFor: 'testing' stamp: 'LT 10/2/2017 19:07:43'!
isIdle
	^(state = 'idle')! !

!ElevatorController methodsFor: 'testing' stamp: 'LT 10/2/2017 19:49:25'!
isWorking
	^((state = 'working')or: (floorsToGo notEmpty)).! !


!ElevatorController methodsFor: 'initialize' stamp: 'fz 10/10/2017 23:45:30'!
initialize
	state := 'idle'.
	cabin := Cabin new.
	cabinDoor := CabinDoor new.
	cabinFloorNumber := 0.
	floorsToGo := OrderedCollection new.! !


!ElevatorController methodsFor: 'actions' stamp: 'fz 10/11/2017 00:30:15'!
closeCabinDoor
"si esta idle entonces no cierra la puerta"
	(self isWorking) ifTrue: [
		"si la cabina está esperando gente, con la puerta abierta, cerrar la puerta y 'frenar' la cabina"
		(self isCabinWaitingForPeople and: self isCabinDoorOpened) ifTrue:[cabin stop. cabinDoor close].
		
		"si la cabina se mueve, no hacer nada"
		
		"si se está abriendo la puerta para esperar gente, no hacer nada"
		
	]! !

!ElevatorController methodsFor: 'actions' stamp: 'fz 10/10/2017 23:46:31'!
goUpPushedFromFloor: aFloor
"empieza a trabajar, cierra la puerta"

	state  := 'working'.
	cabinDoor close.
	
	floorsToGo add: aFloor.! !

!ElevatorController methodsFor: 'actions' stamp: 'fz 10/10/2017 23:47:49'!
openCabinDoor
	(self isCabinMoving) ifFalse:[
		(self isCabinDoorClosed or: self isCabinDoorClosing) ifTrue: [cabinDoor open].
	].! !


!ElevatorController methodsFor: 'signals' stamp: 'fz 10/11/2017 00:42:32'!
cabinDoorClosed
"Signal de puerta cerrada, se puede empezar a mover la cabina"
	(self isIdle) ifTrue:[ElevatorEmergency signal: 'Sensor de puerta desincronizado'].
	(self isCabinDoorClosed or: self isCabinDoorOpening) ifTrue:[ElevatorEmergency signal: 'Sensor de puerta desincronizado'].
	
	cabinDoor closed. "< en realidad debería ser la misma puerta quien tire el signal"
	cabin move.! !

!ElevatorController methodsFor: 'signals' stamp: 'fz 10/10/2017 23:50:14'!
cabinDoorOpened
	(floorsToGo isEmpty) ifTrue: [
		state := 'idle'. 
		cabin stop.
	] ifFalse:[	
		cabin waitForPeople.
	].
	
	cabinDoor opened. "< en realidad debería ser la misma puerta quien tire el signal"! !

!ElevatorController methodsFor: 'signals' stamp: 'fz 10/11/2017 00:37:12'!
cabinOnFloor: aFloor
	(self isCabinStopped) ifTrue:[ElevatorEmergency signal: 'Sensor de cabina desincronizado'].
	
	(cabinFloorNumber = (aFloor-1) or: cabinFloorNumber = (aFloor+1)) ifFalse: [ElevatorEmergency signal: 'Sensor de cabina desincronizado'].

	state := 'working'.
	cabin stop.
	cabinDoor open.
	cabinFloorNumber := aFloor.
	
	floorsToGo := floorsToGo allButFirst.! !

!ElevatorController methodsFor: 'signals' stamp: 'fz 10/11/2017 00:05:45'!
waitForPeopleTimedOut
	cabin stop.
	cabinDoor close.! !
