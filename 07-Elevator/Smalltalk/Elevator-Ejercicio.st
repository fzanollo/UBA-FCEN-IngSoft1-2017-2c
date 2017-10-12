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
	instanceVariableNames: 'state cabinDoor floorNumber'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Cabin methodsFor: 'testing' stamp: 'fz 10/12/2017 02:06:29'!
floorNumber
	^floorNumber ! !

!Cabin methodsFor: 'testing' stamp: 'fz 10/12/2017 00:58:00'!
isCabinDoorClosed
	^cabinDoor isClosed ! !

!Cabin methodsFor: 'testing' stamp: 'fz 10/12/2017 00:57:45'!
isCabinDoorClosing
	^cabinDoor isClosing ! !

!Cabin methodsFor: 'testing' stamp: 'fz 10/12/2017 00:55:43'!
isCabinDoorOpened
	^cabinDoor isOpened ! !

!Cabin methodsFor: 'testing' stamp: 'fz 10/12/2017 00:57:30'!
isCabinDoorOpening
	^cabinDoor isOpening ! !

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


!Cabin methodsFor: 'initialize' stamp: 'fz 10/12/2017 02:05:51'!
initialize
	state := CabinStopped new.
	cabinDoor _ CabinDoor new.
	floorNumber := 0.! !


!Cabin methodsFor: 'actions' stamp: 'fz 10/12/2017 00:57:11'!
closeDoor
	cabinDoor close.! !

!Cabin methodsFor: 'actions' stamp: 'fz 10/12/2017 01:28:14'!
move
	cabinDoor closed.
	state := CabinMoving new.! !

!Cabin methodsFor: 'actions' stamp: 'fz 10/12/2017 00:51:33'!
openCabinDoor
	state openCabinDoor: self.! !

!Cabin methodsFor: 'actions' stamp: 'fz 10/12/2017 01:01:27'!
waitForPeople
	cabinDoor opened.
	state := CabinWaitingForPeople new.! !


!Cabin methodsFor: 'event handler' stamp: 'fz 10/12/2017 02:12:22'!
floorReachedWhenMoving: aFloor 
	floorNumber := aFloor.
	state := CabinStopped new.
	cabinDoor open.! !

!Cabin methodsFor: 'event handler' stamp: 'fz 10/12/2017 02:14:33'!
floorReachedWhenStopped: aFloor 
	ElevatorEmergency signal: 'Sensor de cabina desincronizado'! !

!Cabin methodsFor: 'event handler' stamp: 'fz 10/12/2017 00:52:55'!
openCabinDoorWhenMoving
	! !

!Cabin methodsFor: 'event handler' stamp: 'fz 10/12/2017 00:53:59'!
openCabinDoorWhenStopped
	cabinDoor open.! !

!Cabin methodsFor: 'event handler' stamp: 'fz 10/12/2017 01:39:19'!
stopWaitingForPeople
	state stopWaitingForPeople: self.! !

!Cabin methodsFor: 'event handler' stamp: 'fz 10/12/2017 01:52:12'!
stopWaitingForPeopleWhenMoving
	! !

!Cabin methodsFor: 'event handler' stamp: 'fz 10/12/2017 01:54:53'!
stopWaitingForPeopleWhenStopped
! !

!Cabin methodsFor: 'event handler' stamp: 'fz 10/12/2017 01:53:51'!
stopWaitingForPeopleWhenWaitingForPeople
	state := CabinStopped new.
	cabinDoor close.! !


!Cabin methodsFor: 'signals' stamp: 'fz 10/12/2017 01:07:35'!
doorOpened
	cabinDoor opened! !

!Cabin methodsFor: 'signals' stamp: 'fz 10/12/2017 02:26:43'!
floorReached: aFloor
	(floorNumber = (aFloor - 1) or: floorNumber = (aFloor + 1)) ifFalse: [ ElevatorEmergency signal: 'Sensor de cabina desincronizado' ].
	
	state floorReached: aFloor for: self.! !

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

!CabinDoor methodsFor: 'actions' stamp: 'fz 10/12/2017 01:30:24'!
open
	state open: self.! !


!CabinDoor methodsFor: 'signals' stamp: 'fz 10/12/2017 01:25:50'!
closed
	state closed: self.! !

!CabinDoor methodsFor: 'signals' stamp: 'fz 10/11/2017 23:25:14'!
opened
	state := CabinDoorOpened new.! !


!CabinDoor methodsFor: 'event handler' stamp: 'fz 10/12/2017 01:50:19'!
closedWhenClosed
	ElevatorEmergency signal: 'Sensor de puerta desincronizado'.! !

!CabinDoor methodsFor: 'event handler' stamp: 'fz 10/12/2017 01:26:10'!
closedWhenClosing
	state := CabinDoorClosed new.! !

!CabinDoor methodsFor: 'event handler' stamp: 'fz 10/12/2017 01:26:45'!
closedWhenOpened
	ElevatorEmergency signal: 'Sensor de puerta desincronizado'.! !

!CabinDoor methodsFor: 'event handler' stamp: 'fz 10/12/2017 01:50:42'!
closedWhenOpening
	ElevatorEmergency signal: 'Sensor de puerta desincronizado'.! !

!CabinDoor methodsFor: 'event handler' stamp: 'fz 10/12/2017 01:31:55'!
openWhenClosed
	state := CabinDoorOpening new. ! !

!CabinDoor methodsFor: 'event handler' stamp: 'fz 10/12/2017 01:32:35'!
openWhenClosing
	state := CabinDoorOpening new. ! !

!CabinDoor methodsFor: 'event handler' stamp: 'fz 10/12/2017 01:31:15'!
openWhenOpened
	! !

!CabinDoor methodsFor: 'event handler' stamp: 'fz 10/12/2017 01:33:16'!
openWhenOpening! !

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

!CabinDoorState methodsFor: 'testing' stamp: 'fz 10/11/2017 23:04:08'!
isClosed
	self subclassResponsibility ! !

!CabinDoorState methodsFor: 'testing' stamp: 'fz 10/11/2017 22:11:25'!
isClosing
	self subclassResponsibility ! !

!CabinDoorState methodsFor: 'testing' stamp: 'fz 10/11/2017 22:06:34'!
isOpened
	^self subclassResponsibility ! !

!CabinDoorState methodsFor: 'testing' stamp: 'fz 10/11/2017 22:53:50'!
isOpening
	self subclassResponsibility ! !


!CabinDoorState methodsFor: 'actions' stamp: 'fz 10/12/2017 01:23:36'!
closed: aCabinDoor 
	self subclassResponsibility .! !

!CabinDoorState methodsFor: 'actions' stamp: 'fz 10/12/2017 01:30:34'!
open: aCabinDoor 
	self subclassResponsibility .! !


!classDefinition: #CabinDoorClosed category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #CabinDoorClosed
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinDoorClosed methodsFor: 'testing' stamp: 'fz 10/11/2017 23:10:21'!
isClosed
	^true! !

!CabinDoorClosed methodsFor: 'testing' stamp: 'fz 10/11/2017 22:22:27'!
isClosing
	^false! !

!CabinDoorClosed methodsFor: 'testing' stamp: 'fz 10/11/2017 22:22:09'!
isOpened
	^false! !

!CabinDoorClosed methodsFor: 'testing' stamp: 'fz 10/11/2017 22:55:37'!
isOpening
	^false! !


!CabinDoorClosed methodsFor: 'actions' stamp: 'fz 10/12/2017 01:50:19'!
closed: aCabinDoor
	^ aCabinDoor closedWhenClosed.! !

!CabinDoorClosed methodsFor: 'actions' stamp: 'fz 10/12/2017 01:31:39'!
open: aCabinDoor 
	aCabinDoor openWhenClosed! !


!classDefinition: #CabinDoorClosing category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #CabinDoorClosing
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinDoorClosing methodsFor: 'testing' stamp: 'fz 10/11/2017 23:10:52'!
isClosed
	^false! !

!CabinDoorClosing methodsFor: 'testing' stamp: 'fz 10/11/2017 22:11:35'!
isClosing
	^true.! !

!CabinDoorClosing methodsFor: 'testing' stamp: 'fz 10/11/2017 22:09:53'!
isOpened
	^false! !

!CabinDoorClosing methodsFor: 'testing' stamp: 'fz 10/11/2017 22:55:12'!
isOpening
	^false! !


!CabinDoorClosing methodsFor: 'actions' stamp: 'fz 10/12/2017 01:27:47'!
closed: aCabinDoor 
	aCabinDoor closedWhenClosing.! !

!CabinDoorClosing methodsFor: 'actions' stamp: 'fz 10/12/2017 01:32:23'!
open: aCabinDoor 
	aCabinDoor openWhenClosing! !


!classDefinition: #CabinDoorOpened category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #CabinDoorOpened
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinDoorOpened methodsFor: 'testing' stamp: 'fz 10/11/2017 23:09:48'!
isClosed
	^false! !

!CabinDoorOpened methodsFor: 'testing' stamp: 'fz 10/11/2017 22:54:42'!
isClosing
	^false! !

!CabinDoorOpened methodsFor: 'testing' stamp: 'fz 10/11/2017 22:06:57'!
isOpened
	^true! !

!CabinDoorOpened methodsFor: 'testing' stamp: 'fz 10/11/2017 22:54:00'!
isOpening
	^false! !


!CabinDoorOpened methodsFor: 'actions' stamp: 'fz 10/12/2017 01:26:52'!
closed: aCabinDoor 
	aCabinDoor closedWhenOpened.! !

!CabinDoorOpened methodsFor: 'actions' stamp: 'fz 10/12/2017 01:31:01'!
open: aCabinDoor 
	aCabinDoor openWhenOpened! !


!classDefinition: #CabinDoorOpening category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #CabinDoorOpening
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinDoorOpening methodsFor: 'testing' stamp: 'fz 10/11/2017 23:04:27'!
isClosed
	^false! !

!CabinDoorOpening methodsFor: 'testing' stamp: 'fz 10/11/2017 23:01:57'!
isClosing
	^false! !

!CabinDoorOpening methodsFor: 'testing' stamp: 'fz 10/11/2017 23:01:21'!
isOpened
	^false.! !

!CabinDoorOpening methodsFor: 'testing' stamp: 'fz 10/11/2017 23:01:42'!
isOpening
	^true! !


!CabinDoorOpening methodsFor: 'actions' stamp: 'fz 10/12/2017 01:50:42'!
closed: aCabinDoor
	^ aCabinDoor closedWhenOpening.! !

!CabinDoorOpening methodsFor: 'actions' stamp: 'fz 10/12/2017 01:33:04'!
open: aCabinDoor 
	aCabinDoor openWhenOpening! !


!classDefinition: #CabinState category: #'Elevator-Ejercicio'!
Object subclass: #CabinState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinState methodsFor: 'testing' stamp: 'fz 10/11/2017 22:47:59'!
isMoving
	self subclassResponsibility .! !

!CabinState methodsFor: 'testing' stamp: 'fz 10/11/2017 22:42:02'!
isStopped
	self subclassResponsibility ! !

!CabinState methodsFor: 'testing' stamp: 'fz 10/11/2017 23:31:20'!
isWaitingForPeople
	self subclassResponsibility ! !


!CabinState methodsFor: 'actions' stamp: 'fz 10/12/2017 01:43:04'!
openCabinDoor: aCabin.
	self subclassResponsibility ! !


!CabinState methodsFor: 'signals' stamp: 'fz 10/12/2017 02:23:50'!
floorReached: aFloor for: aCabin 
	self subclassResponsibility ! !

!CabinState methodsFor: 'signals' stamp: 'fz 10/12/2017 02:23:15'!
stopWaitingForPeople: aCabin 
	self subclassResponsibility ! !


!classDefinition: #CabinMoving category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinMoving
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinMoving methodsFor: 'testing' stamp: 'fz 10/11/2017 22:48:11'!
isMoving
	^true.! !

!CabinMoving methodsFor: 'testing' stamp: 'fz 10/11/2017 22:46:17'!
isStopped
	^false.! !

!CabinMoving methodsFor: 'testing' stamp: 'fz 10/11/2017 23:31:46'!
isWaitingForPeople
	^false! !


!CabinMoving methodsFor: 'signals' stamp: 'fz 10/12/2017 02:10:02'!
floorReached: aFloor for: aCabin 
	aCabin floorReachedWhenMoving: aFloor! !

!CabinMoving methodsFor: 'signals' stamp: 'fz 10/12/2017 01:51:52'!
stopWaitingForPeople: aCabin 
	aCabin stopWaitingForPeopleWhenMoving! !


!CabinMoving methodsFor: 'actions' stamp: 'fz 10/12/2017 00:52:37'!
openCabinDoor: aCabin.
	aCabin openCabinDoorWhenMoving! !


!classDefinition: #CabinStopped category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinStopped
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinStopped methodsFor: 'testing' stamp: 'fz 10/11/2017 22:51:26'!
isMoving
	^false! !

!CabinStopped methodsFor: 'testing' stamp: 'fz 10/11/2017 22:37:14'!
isStopped
	^true.! !

!CabinStopped methodsFor: 'testing' stamp: 'fz 10/11/2017 23:31:55'!
isWaitingForPeople
	^false! !


!CabinStopped methodsFor: 'signals' stamp: 'fz 10/12/2017 02:13:14'!
floorReached: aFloor for: aCabin 
	aCabin floorReachedWhenStopped: aFloor.! !

!CabinStopped methodsFor: 'signals' stamp: 'fz 10/12/2017 01:54:20'!
stopWaitingForPeople: aCabin 
	aCabin stopWaitingForPeopleWhenStopped! !


!CabinStopped methodsFor: 'actions' stamp: 'fz 10/12/2017 00:53:25'!
openCabinDoor: aCabin.
	aCabin openCabinDoorWhenStopped! !


!classDefinition: #CabinWaitingForPeople category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinWaitingForPeople
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinWaitingForPeople methodsFor: 'testing' stamp: 'fz 10/11/2017 23:32:15'!
isMoving
	^false! !

!CabinWaitingForPeople methodsFor: 'testing' stamp: 'fz 10/11/2017 23:32:24'!
isStopped
	^false.! !

!CabinWaitingForPeople methodsFor: 'testing' stamp: 'fz 10/11/2017 23:32:03'!
isWaitingForPeople
	^true! !


!CabinWaitingForPeople methodsFor: 'signals' stamp: 'fz 10/12/2017 01:52:40'!
stopWaitingForPeople: aCabin 
	aCabin stopWaitingForPeopleWhenWaitingForPeople! !


!classDefinition: #ElevatorController category: #'Elevator-Ejercicio'!
Object subclass: #ElevatorController
	instanceVariableNames: 'floorsToGo cabin elevatorState'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorController methodsFor: 'testing' stamp: 'fz 10/12/2017 02:06:17'!
cabinFloorNumber
	^cabin floorNumber! !

!ElevatorController methodsFor: 'testing' stamp: 'fz 10/12/2017 00:48:25'!
isCabinDoorClosed
	^cabin isCabinDoorClosed.! !

!ElevatorController methodsFor: 'testing' stamp: 'fz 10/12/2017 00:48:32'!
isCabinDoorClosing
	^cabin isCabinDoorClosing.! !

!ElevatorController methodsFor: 'testing' stamp: 'fz 10/12/2017 00:48:39'!
isCabinDoorOpened
	^cabin isCabinDoorOpened.! !

!ElevatorController methodsFor: 'testing' stamp: 'fz 10/12/2017 00:48:48'!
isCabinDoorOpening
	^cabin isCabinDoorOpening.! !

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

!ElevatorController methodsFor: 'testing' stamp: 'fz 10/12/2017 02:18:40'!
isWorking
	^elevatorState isWorking! !


!ElevatorController methodsFor: 'initialize' stamp: 'fz 10/12/2017 02:05:58'!
initialize
	elevatorState _ Idle new.
	cabin _ Cabin new.
	floorsToGo _ OrderedCollection new.! !


!ElevatorController methodsFor: 'actions' stamp: 'fz 10/12/2017 00:29:44'!
closeCabinDoor
	elevatorState closeCabinDoor: self.! !

!ElevatorController methodsFor: 'actions' stamp: 'fz 10/12/2017 01:56:48'!
goUpPushedFromFloor: aFloor
	elevatorState := Working new.
	cabin closeDoor.
	
	floorsToGo add: aFloor.! !

!ElevatorController methodsFor: 'actions' stamp: 'fz 10/12/2017 00:54:33'!
openCabinDoor
	cabin openCabinDoor.! !


!ElevatorController methodsFor: 'signals' stamp: 'fz 10/12/2017 00:23:36'!
cabinDoorClosed
	elevatorState cabinDoorClosed: self.! !

!ElevatorController methodsFor: 'signals' stamp: 'fz 10/12/2017 02:44:15'!
cabinDoorOpened
"Este if se puede remover utilizando el Stack hecho para Stack-Exercise. No sabemos si se pueden entregar soluciones como package, por eso preferimos dejarlo así."
	(floorsToGo isEmpty) ifTrue: [
		elevatorState := Idle new.
	] ifFalse:[	
		cabin waitForPeople.
	].

	cabin doorOpened.! !

!ElevatorController methodsFor: 'signals' stamp: 'fz 10/12/2017 02:07:21'!
cabinOnFloor: aFloor
	cabin floorReached: aFloor.
	
	floorsToGo _ floorsToGo allButFirst.! !

!ElevatorController methodsFor: 'signals' stamp: 'fz 10/12/2017 01:35:43'!
waitForPeopleTimedOut
	cabin stopWaitingForPeople.! !


!ElevatorController methodsFor: 'event handler' stamp: 'fz 10/12/2017 01:58:12'!
cabinDoorClosedWhenIsIdle
	ElevatorEmergency signal: 'Sensor de puerta desincronizado'.! !

!ElevatorController methodsFor: 'event handler' stamp: 'fz 10/12/2017 00:58:38'!
cabinDoorClosedWhenIsWorking
	cabin move.! !

!ElevatorController methodsFor: 'event handler' stamp: 'fz 10/12/2017 00:28:31'!
closeCabinDoorWhenIdle
! !

!ElevatorController methodsFor: 'event handler' stamp: 'fz 10/12/2017 01:45:53'!
closeCabinDoorWhenWorking
	cabin stopWaitingForPeople.! !


!classDefinition: #ElevatorStates category: #'Elevator-Ejercicio'!
Object subclass: #ElevatorStates
	instanceVariableNames: 'state'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorStates methodsFor: 'testing' stamp: 'fz 10/11/2017 21:39:09'!
isIdle
	self subclassResponsibility .! !

!ElevatorStates methodsFor: 'testing' stamp: 'fz 10/11/2017 23:06:57'!
isWorking
	self subclassResponsibility ! !


!ElevatorStates methodsFor: 'actions' stamp: 'fz 10/12/2017 02:21:25'!
closeCabinDoor: anElevatorController 
	self subclassResponsibility ! !


!ElevatorStates methodsFor: 'signals' stamp: 'fz 10/12/2017 02:18:17'!
cabinDoorClosed: anElevator
	self subclassResponsibility .! !

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

!Idle methodsFor: 'testing' stamp: 'fz 10/11/2017 21:39:45'!
isIdle
	^true.! !

!Idle methodsFor: 'testing' stamp: 'fz 10/11/2017 23:07:59'!
isWorking
	^false! !


!Idle methodsFor: 'actions' stamp: 'fz 10/12/2017 00:28:08'!
closeCabinDoor: anElevatorController 
	anElevatorController closeCabinDoorWhenIdle! !


!Idle methodsFor: 'signals' stamp: 'fz 10/12/2017 01:58:12'!
cabinDoorClosed: anElevator
	^ anElevator cabinDoorClosedWhenIsIdle.! !


!classDefinition: #Working category: #'Elevator-Ejercicio'!
ElevatorStates subclass: #Working
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Working methodsFor: 'testing' stamp: 'fz 10/11/2017 21:39:59'!
isIdle
	^false.! !

!Working methodsFor: 'testing' stamp: 'fz 10/11/2017 23:10:05'!
isWorking
	^true! !


!Working methodsFor: 'signals' stamp: 'fz 10/11/2017 21:40:26'!
cabinDoorClosed: anElevator

	anElevator cabinDoorClosedWhenIsWorking.! !


!Working methodsFor: 'actions' stamp: 'fz 10/12/2017 00:27:13'!
closeCabinDoor: anElevatorController 
	anElevatorController closeCabinDoorWhenWorking! !
