!classDefinition: #OOStackTest category: #'Stack-Exercise'!
TestCase subclass: #OOStackTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test01StackShouldBeEmptyWhenCreated

	| stack |
	
	stack := OOStack new.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test02PushAddElementsToTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'Something'.
	
	self deny: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:31'!
test03PopRemovesElementsFromTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'Something'.
	stack pop.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/8/2012 08:20'!
test04PopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'Something'.
	stack push: pushedObject.
	
	self assert: stack pop = pushedObject! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:33'!
test05StackBehavesLIFO

	| stack firstPushedObject secondPushedObject |
	
	stack := OOStack new.
	firstPushedObject := 'First'.
	secondPushedObject := 'Second'.
	
	stack push: firstPushedObject.
	stack push: secondPushedObject.
	
	self assert: stack pop = secondPushedObject.
	self assert: stack pop = firstPushedObject.
	self assert: stack isEmpty 
	! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:35'!
test06TopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'Something'.
	
	stack push: pushedObject.
	
	self assert: stack top = pushedObject.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:36'!
test07TopDoesNotRemoveObjectFromStack

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'Something'.
	
	stack push: pushedObject.
	
	self assert: stack size = 1.
	stack top.
	self assert: stack size = 1.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:26'!
test08CanNotPopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:36'!
test09CanNotPopWhenThereAreNoObjectsInTheStackAndTheStackHadObjects

	| stack  |
	
	stack := OOStack new.
	stack push: 'Something'.
	stack pop.
	
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:44'!
test10CanNotTopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack top ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !


!classDefinition: #OOStack category: #'Stack-Exercise'!
Object subclass: #OOStack
	instanceVariableNames: 'top'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStack methodsFor: 'initialization' stamp: 'fz 9/17/2017 22:27:54'!
initialize
	top := OOStackBase new.! !


!OOStack methodsFor: 'testing' stamp: 'fz 9/17/2017 22:28:36'!
isEmpty
	^top isEmpty.! !

!OOStack methodsFor: 'testing' stamp: 'fz 9/17/2017 22:29:47'!
size
	^top position.! !


!OOStack methodsFor: 'adding' stamp: 'fz 9/17/2017 22:31:09'!
push: anElement
	top := OOStackElement over: top with: anElement.! !


!OOStack methodsFor: 'removing' stamp: 'fz 9/17/2017 22:33:45'!
pop
	|currentTop|
	
	currentTop _ self top.
	top _ top previous.
	
	^ currentTop.! !


!OOStack methodsFor: 'accessing' stamp: 'fz 9/17/2017 22:34:15'!
top
	^top content.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStack class' category: #'Stack-Exercise'!
OOStack class
	instanceVariableNames: ''!

!OOStack class methodsFor: 'error descriptions' stamp: 'HernanWilkinson 5/7/2012 11:51'!
stackEmptyErrorDescription
	
	^ 'Stack is empty'! !


!classDefinition: #OOStackTop category: #'Stack-Exercise'!
Object subclass: #OOStackTop
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackTop methodsFor: 'testing' stamp: 'fz 9/17/2017 22:34:42'!
isEmpty
	self subclassResponsibility.! !

!OOStackTop methodsFor: 'testing' stamp: 'fz 9/17/2017 22:40:41'!
position
	self subclassResponsibility.! !


!OOStackTop methodsFor: 'accessing' stamp: 'fz 9/17/2017 22:42:56'!
content
	self subclassResponsibility.! !


!classDefinition: #OOStackBase category: #'Stack-Exercise'!
OOStackTop subclass: #OOStackBase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackBase methodsFor: 'testing' stamp: 'fz 9/17/2017 22:35:01'!
isEmpty
	^true.! !

!OOStackBase methodsFor: 'testing' stamp: 'fz 9/17/2017 22:42:28'!
position
	^0.! !


!OOStackBase methodsFor: 'accessing' stamp: 'fz 9/17/2017 22:44:11'!
content
	^self error: OOStack stackEmptyErrorDescription.! !


!classDefinition: #OOStackElement category: #'Stack-Exercise'!
OOStackTop subclass: #OOStackElement
	instanceVariableNames: 'previous content position'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackElement methodsFor: 'initialization' stamp: 'fz 9/17/2017 22:41:32'!
over: aStackElement with: aContent 
	previous := aStackElement.
	content := aContent.
	position := aStackElement position +1.! !


!OOStackElement methodsFor: 'testing' stamp: 'fz 9/17/2017 22:38:44'!
isEmpty
	^false.! !

!OOStackElement methodsFor: 'testing' stamp: 'fz 9/17/2017 22:41:02'!
position
	^position.! !


!OOStackElement methodsFor: 'accessing' stamp: 'fz 9/17/2017 22:39:05'!
content
	^content! !


!OOStackElement methodsFor: 'previous' stamp: 'fz 9/17/2017 22:39:40'!
previous
	^previous! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStackElement class' category: #'Stack-Exercise'!
OOStackElement class
	instanceVariableNames: ''!

!OOStackElement class methodsFor: 'initialization' stamp: 'fz 9/17/2017 22:38:25'!
over: aStackElement with: aContent 
	^self new over: aStackElement with: aContent.! !
