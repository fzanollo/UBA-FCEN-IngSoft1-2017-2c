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

!Cabin methodsFor: 'testing' stamp: 'fz 10/11/2017 23:33:08'!
isMoving
	^state isMoving .
	! !

!Cabin methodsFor: 'testing' stamp: 'fz 10/11/2017 23:33:13'!
isStopped
	^state isStopped .! !

!Cabin methodsFor: 'testing' stamp: 'fz 10/11/2017 23:33:16'!
isWaitingForPeople
	^state isWaitingForPeople! !


!Cabin methodsFor: 'initialize' stamp: 'fz 10/11/2017 23:33:04'!
initialize
	state := CabinStopped new.! !


!Cabin methodsFor: 'actions' stamp: 'fz 10/11/2017 23:33:19'!
move
	state := CabinMoving new.! !

!Cabin methodsFor: 'actions' stamp: 'fz 10/11/2017 23:33:22'!
stop
	state := CabinStopped new.! !

!Cabin methodsFor: 'actions' stamp: 'fz 10/11/2017 23:33:25'!
waitForPeople
	state := CabinWaitingForPeople new.! !


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

!CabinDoor methodsFor: 'testing' stamp: 'fz 10/11/2017 23:25:25'!
isClosed
	^state isClosed .! !

!CabinDoor methodsFor: 'testing' stamp: 'fz 10/11/2017 23:25:28'!
isClosing
	^state isClosing.! !

!CabinDoor methodsFor: 'testing' stamp: 'fz 10/11/2017 23:25:34'!
isOpened
	^state isOpened.! !

!CabinDoor methodsFor: 'testing' stamp: 'fz 10/11/2017 23:25:36'!
isOpening
	^state isOpening.! !


!CabinDoor methodsFor: 'initialize' stamp: 'fz 10/11/2017 23:25:20'!
initialize
	state := CabinDoorOpened new.! !


!CabinDoor methodsFor: 'actions' stamp: 'fz 10/11/2017 23:25:01'!
close
	state := CabinDoorClosing new.! !

!CabinDoor methodsFor: 'actions' stamp: 'fz 10/11/2017 23:25:04'!
open
	state := CabinDoorOpening new. ! !


!CabinDoor methodsFor: 'signals' stamp: 'fz 10/11/2017 23:25:09'!
closed
	state := CabinDoorClosed new.! !

!CabinDoor methodsFor: 'signals' stamp: 'fz 10/11/2017 23:25:14'!
opened
	state := CabinDoorOpened new.! !


!CabinDoor methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:24:45'!
cabinDoorClosed
	state cabinDoorClosed: self.! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:24:49'!
cabinDoorClosedWhenClosing
	state := CabinDoorClosed new.! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:22:05'!
cabinDoorClosedWhenIsClosed
	ElevatorEmergency signal: 'Sensor de puerta desincronizado'.! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:28:07'!
cabinDoorClosedWhenIsOpening
	ElevatorEmergency signal: 'Sensor de puerta desincronizado'.! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:02:12'!
cabinDoorClosedWhenOpened
	ElevatorEmergency signal: 'Sensor de puerta desincronizado'.! !

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


!classDefinition: #CabinDoorState category: #'Elevator-Ejercicio'!
Object subclass: #CabinDoorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:00:09'!
cabinDoorClosed: aCabinDoor 
	self subclassResponsibility .! !

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:04:08'!
isClosed
	self subclassResponsibility ! !

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:11:25'!
isClosing
	self subclassResponsibility ! !

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:06:34'!
isOpened
	^self subclassResponsibility ! !

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:53:50'!
isOpening
	self subclassResponsibility ! !

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'fz 10/12/2017 00:35:07'!
openCabinDoor: aCabinDoor 
	self subclassResponsibility ! !


!classDefinition: #CabinDoorClosed category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #CabinDoorClosed
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinDoorClosed methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:21:00'!
cabinDoorClosed: aCabinDoor 
	^aCabinDoor cabinDoorClosedWhenIsClosed! !

!CabinDoorClosed methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:10:21'!
isClosed
	^true! !

!CabinDoorClosed methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:22:27'!
isClosing
	^false! !

!CabinDoorClosed methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:22:09'!
isOpened
	^false! !

!CabinDoorClosed methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:55:37'!
isOpening
	^false! !

!CabinDoorClosed methodsFor: 'as yet unclassified' stamp: 'fz 10/12/2017 00:34:02'!
openCabinDoor: aCabinDoor 
	^aCabinDoor openCabinDoorWhenIsClosed! !


!classDefinition: #CabinDoorClosing category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #CabinDoorClosing
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinDoorClosing methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:15:09'!
cabinDoorClosed: aCabinDoor 
	aCabinDoor cabinDoorClosedWhenClosing.! !

!CabinDoorClosing methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:10:52'!
isClosed
	^false! !

!CabinDoorClosing methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:11:35'!
isClosing
	^true.! !

!CabinDoorClosing methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:09:53'!
isOpened
	^false! !

!CabinDoorClosing methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:55:12'!
isOpening
	^false! !


!classDefinition: #CabinDoorOpened category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #CabinDoorOpened
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinDoorOpened methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:01:45'!
cabinDoorClosed: aCabinDoor 
	aCabinDoor cabinDoorClosedWhenOpened.! !

!CabinDoorOpened methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:09:48'!
isClosed
	^false! !

!CabinDoorOpened methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:54:42'!
isClosing
	^false! !

!CabinDoorOpened methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:06:57'!
isOpened
	^true! !

!CabinDoorOpened methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:54:00'!
isOpening
	^false! !


!classDefinition: #CabinDoorOpening category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #CabinDoorOpening
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinDoorOpening methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:27:47'!
cabinDoorClosed: aCabinDoor 
	^aCabinDoor cabinDoorClosedWhenIsOpening! !

!CabinDoorOpening methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:04:27'!
isClosed
	^false! !

!CabinDoorOpening methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:01:57'!
isClosing
	^false! !

!CabinDoorOpening methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:01:21'!
isOpened
	^false.! !

!CabinDoorOpening methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:01:42'!
isOpening
	^true! !


!classDefinition: #CabinState category: #'Elevator-Ejercicio'!
Object subclass: #CabinState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinState methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:47:59'!
isMoving
	self subclassResponsibility .! !

!CabinState methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:42:02'!
isStopped
	self subclassResponsibility ! !

!CabinState methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:31:20'!
isWaitingForPeople
	self subclassResponsibility ! !


!classDefinition: #CabinMoving category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinMoving
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinMoving methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:48:11'!
isMoving
	^true.! !

!CabinMoving methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:46:17'!
isStopped
	^false.! !

!CabinMoving methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:31:46'!
isWaitingForPeople
	^false! !


!classDefinition: #CabinStopped category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinStopped
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinStopped methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:51:26'!
isMoving
	^false! !

!CabinStopped methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 22:37:14'!
isStopped
	^true.! !

!CabinStopped methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:31:55'!
isWaitingForPeople
	^false! !


!classDefinition: #CabinWaitingForPeople category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinWaitingForPeople
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinWaitingForPeople methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:32:15'!
isMoving
	^false! !

!CabinWaitingForPeople methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:32:24'!
isStopped
	^false.! !

!CabinWaitingForPeople methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:32:03'!
isWaitingForPeople
	^true! !


!classDefinition: #ElevatorController category: #'Elevator-Ejercicio'!
Object subclass: #ElevatorController
	instanceVariableNames: 'cabinFloorNumber floorsToGo cabin cabinDoor elevatorState cabinDoorState'
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

!ElevatorController methodsFor: 'testing' stamp: 'fz 10/11/2017 19:27:48'!
isIdle
	^elevatorState isIdle! !

!ElevatorController methodsFor: 'testing' stamp: 'fz 10/11/2017 19:28:16'!
isWorking
	^((elevatorState isWorking) or: (floorsToGo notEmpty)).! !


!ElevatorController methodsFor: 'initialize' stamp: 'fz 10/11/2017 21:06:51'!
initialize
	elevatorState _ Idle new.
	cabin _ Cabin new.
	cabinDoor _ CabinDoor new.
	cabinFloorNumber _ 0.
	floorsToGo _ OrderedCollection new.! !


!ElevatorController methodsFor: 'actions' stamp: 'fz 10/12/2017 00:29:44'!
closeCabinDoor
	elevatorState closeCabinDoor: self.! !

!ElevatorController methodsFor: 'actions' stamp: 'fz 10/11/2017 21:13:18'!
goUpPushedFromFloor: aFloor
"empieza a trabajar, cierra la puerta"

	elevatorState := Working new.
	cabinDoor close.
	
	floorsToGo add: aFloor.! !

!ElevatorController methodsFor: 'actions' stamp: 'fz 10/12/2017 00:39:04'!
openCabinDoor
	
	(self isCabinMoving) ifFalse:[
		(self isCabinDoorClosed or: self isCabinDoorClosing) ifTrue: [cabinDoor open].
	].! !


!ElevatorController methodsFor: 'signals' stamp: 'fz 10/12/2017 00:23:36'!
cabinDoorClosed
	elevatorState cabinDoorClosed: self.! !

!ElevatorController methodsFor: 'signals' stamp: 'fz 10/11/2017 22:31:42'!
cabinDoorOpened
	(floorsToGo isEmpty) ifTrue: [
		"elevatorState stopWorking."
		elevatorState := Idle new.
		cabin stop.
	] ifFalse:[	
		cabin waitForPeople.
	].
	
	cabinDoor opened. "< en realidad debería ser la misma puerta quien tire el signal"! !

!ElevatorController methodsFor: 'signals' stamp: 'fz 10/11/2017 22:58:24'!
cabinOnFloor: aFloor
	(self isCabinStopped) ifTrue:[ElevatorEmergency signal: 'Sensor de cabina desincronizado'].
	
	(cabinFloorNumber = (aFloor-1) or: cabinFloorNumber = (aFloor+1)) ifFalse: [ElevatorEmergency signal: 'Sensor de cabina desincronizado'].

	elevatorState := Working new.
	cabin stop.
	cabinDoor open.
	cabinFloorNumber := aFloor.
	
	floorsToGo := floorsToGo allButFirst.! !

!ElevatorController methodsFor: 'signals' stamp: 'fz 10/11/2017 00:05:45'!
waitForPeopleTimedOut
	cabin stop.
	cabinDoor close.! !


!ElevatorController methodsFor: 'as yet unclassified' stamp: 'fz 10/12/2017 00:23:41'!
cabinDoorClosedWhenIsWorking
	cabinDoor cabinDoorClosed.
	cabin move.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 21:08:50'!
cabindDoorClosedWhenIsIdle
	ElevatorEmergency signal: 'Sensor de puerta desincronizado'.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'fz 10/12/2017 00:28:31'!
closeCabinDoorWhenIdle
! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'fz 10/12/2017 00:29:56'!
closeCabinDoorWhenWorking
	(self isCabinWaitingForPeople and: self isCabinDoorOpened) ifTrue:[cabin stop. cabinDoor close]

	"si la cabina está esperando gente, con la puerta abierta, cerrar la puerta y 'frenar' la cabina"
	"si la cabina se mueve, no hacer nada"
	"si se está abriendo la puerta para esperar gente, no hacer nada"! !


!classDefinition: #ElevatorStates category: #'Elevator-Ejercicio'!
Object subclass: #ElevatorStates
	instanceVariableNames: 'state'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorStates methodsFor: 'testing' stamp: 'fz 10/11/2017 21:40:37'!
cabinDoorClosed: anElevator

	self subclassResponsibility .! !

!ElevatorStates methodsFor: 'testing' stamp: 'fz 10/11/2017 21:39:09'!
isIdle
	self subclassResponsibility .! !

!ElevatorStates methodsFor: 'testing' stamp: 'fz 10/11/2017 23:06:57'!
isWorking
	self subclassResponsibility ! !


!ElevatorStates methodsFor: 'actions' stamp: 'fz 10/11/2017 19:25:40'!
stopWorking
	state := self class idleState! !

!ElevatorStates methodsFor: 'actions' stamp: 'fz 10/11/2017 19:25:24'!
work
	state := self class workingState! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ElevatorStates class' category: #'Elevator-Ejercicio'!
ElevatorStates class
	instanceVariableNames: ''!

!ElevatorStates class methodsFor: 'states' stamp: 'fz 10/11/2017 19:24:50'!
idleState
	^#Idle! !

!ElevatorStates class methodsFor: 'states' stamp: 'fz 10/11/2017 19:24:43'!
workingState
	^#Working! !


!classDefinition: #Idle category: #'Elevator-Ejercicio'!
ElevatorStates subclass: #Idle
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Idle methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 21:01:38'!
cabinDoorClosed: anElevator

	^anElevator cabindDoorClosedWhenIsIdle.! !

!Idle methodsFor: 'as yet unclassified' stamp: 'fz 10/12/2017 00:28:08'!
closeCabinDoor: anElevatorController 
	anElevatorController closeCabinDoorWhenIdle! !

!Idle methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 21:39:45'!
isIdle
	^true.! !

!Idle methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:07:59'!
isWorking
	^false! !


!classDefinition: #Working category: #'Elevator-Ejercicio'!
ElevatorStates subclass: #Working
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Working methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 21:40:26'!
cabinDoorClosed: anElevator

	anElevator cabinDoorClosedWhenIsWorking.! !

!Working methodsFor: 'as yet unclassified' stamp: 'fz 10/12/2017 00:27:13'!
closeCabinDoor: anElevatorController 
	anElevatorController closeCabinDoorWhenWorking! !

!Working methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 21:39:59'!
isIdle
	^false.! !

!Working methodsFor: 'as yet unclassified' stamp: 'fz 10/11/2017 23:10:05'!
isWorking
	^true! !
