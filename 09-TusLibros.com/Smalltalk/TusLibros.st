!classDefinition: #CartTest category: #TusLibros!
TestCase subclass: #CartTest
	instanceVariableNames: 'objectFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'fz 11/5/2017 22:42:06'!
setUp

	objectFactory := TusLibrosTestObjectFactory new.! !

!CartTest methodsFor: 'tests' stamp: 'fz 11/5/2017 22:42:25'!
test01NewCartIsEmpty
	|cart|
	
	cart := objectFactory createCart.
	
	self assert: cart isEmpty.! !

!CartTest methodsFor: 'tests' stamp: 'fz 11/5/2017 22:42:55'!
test02CanNotAddItemsNotFromTheStore
	|cart|
		
	cart := objectFactory createCart.
	
	self 
		should: [cart add: objectFactory itemNotFromTheStore]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | 
			self assert: cart isEmpty.
			self assert: anError messageText = Cart itemNotFromTheStoreErrorMessage]! !

!CartTest methodsFor: 'tests' stamp: 'fz 11/5/2017 22:43:06'!
test03AfterAddingAnItemCartIsNoMoreEmpty
	|cart|
	
	cart := objectFactory createCart.
	
	cart add: objectFactory itemFromTheStore.
	self deny: cart isEmpty.! !

!CartTest methodsFor: 'tests' stamp: 'fz 11/5/2017 22:43:21'!
test04ItemAddedIsInTheCart
	|cart|

	cart := objectFactory createCart.
	
	cart add: objectFactory itemFromTheStore.
	self assert: (cart includes: objectFactory itemFromTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'fz 11/5/2017 22:43:38'!
test05CanAddItemsByQuantity
	|cart|
	
	cart := objectFactory createCart.
	
	cart add: 1 of: objectFactory itemFromTheStore.
	self assert: (cart includes: objectFactory itemFromTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'fz 11/5/2017 22:43:55'!
test06CartRemembersQuantityOfEveryAddedItem
	|cart|

	cart := objectFactory createCart.
	
	cart add: 2 of: objectFactory itemFromTheStore.
	self assert: (cart quantityOf: objectFactory itemFromTheStore) equals: 2! !

!CartTest methodsFor: 'tests' stamp: 'fz 11/5/2017 22:44:07'!
test07CanNotAddMultipleItemsNotFromTheStore
	|cart |

	cart := objectFactory createCart.
	
	self 
		should: [cart add: 2 of: objectFactory itemNotFromTheStore.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | 
			self assert: cart isEmpty.
			self assert: anError messageText = Cart itemNotFromTheStoreErrorMessage]
		
	! !

!CartTest methodsFor: 'tests' stamp: 'fz 11/5/2017 22:44:23'!
test08CanOnlyAddPositivesQuantitiesOfAnItem
	|cart|

	cart := objectFactory createCart.
	
	self 
		should: [cart add: 0 of: objectFactory itemFromTheStore.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | 
			self assert: cart isEmpty.
			self assert: anError messageText = Cart negativeOrZeroQuantityErrorMessage]
		
	! !

!CartTest methodsFor: 'tests' stamp: 'fz 11/5/2017 22:44:35'!
test09ItemNotAddedIsNotInTheCart
	|cart|

	cart := objectFactory createCart.
	
	self deny: (cart includes: objectFactory itemFromTheStore)! !



!classDefinition: #CashierTest category: #TusLibros!
TestCase subclass: #CashierTest
	instanceVariableNames: 'objectFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 22:37:04'!
setUp

	objectFactory := TusLibrosTestObjectFactory new.! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 23:28:39'!
test01CanNotCheckoutAnEmptyCart
	| cart salesBook |

	cart := objectFactory createCart.
	salesBook := OrderedCollection new.
		
	self should: [
		Cashier 
			toCheckout: cart 
			withCard: objectFactory notExpiredCreditCard 
			registeringOn: salesBook.
		] 
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText = Cashier emptyCartErrorMessage].! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 23:29:24'!
test02TotalCheckoutIsCorrect
	| cart cashier salesBook |

	cart := objectFactory createCart.
	cart add: 2 of: objectFactory itemFromTheStore. 
	
	salesBook := OrderedCollection new.
	cashier:= Cashier 
		toCheckout: cart 
		withCard: objectFactory notExpiredCreditCard 
		registeringOn: salesBook.
	
	self assert: (cashier checkout) equals: 10.
	! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 23:30:32'!
test03CanNotCheckoutWithExpiredCreditCard
	| cart salesBook|

	cart := objectFactory createCart.
	cart add: objectFactory itemFromTheStore.
	salesBook := OrderedCollection new.
	
	self should: [
		Cashier 
			toCheckout: cart 
			withCard: objectFactory expiredCreditCard 
			registeringOn: salesBook
		] 
		raise:  Error - MessageNotUnderstood 
		withExceptionDo: [:anError | 
			anError messageText = Cashier expiredCreditCardErrorMessage]

	! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 23:27:10'!
test04CheckoutRegistersASale
	| cart cashier salesBook total |

	cart := objectFactory createCart.
	cart add: objectFactory itemFromTheStore.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		withCard: objectFactory notExpiredCreditCard 
		registeringOn: salesBook.
		
	total := cashier checkout.
					
	self assert: salesBook size = 1.
	self assert: salesBook first = total.
	! !


!classDefinition: #Cart category: #TusLibros!
Object subclass: #Cart
	instanceVariableNames: 'catalog items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'testing' stamp: 'fz 11/5/2017 14:23:18'!
includes: anItem
	^items includes: anItem! !

!Cart methodsFor: 'testing' stamp: 'fz 11/5/2017 21:04:49'!
isEmpty
	^items isEmpty.! !

!Cart methodsFor: 'testing' stamp: 'fz 11/5/2017 14:33:25'!
quantityOf: anItem
	^items occurrencesOf: anItem.! !


!Cart methodsFor: 'adding' stamp: 'fz 11/5/2017 14:40:51'!
add: anItem
	self add: 1 of: anItem! !

!Cart methodsFor: 'adding' stamp: 'fz 11/5/2017 22:32:12'!
add: quantity of: anItem
	(catalog includesKey: anItem) ifFalse: [self error: self class itemNotFromTheStoreErrorMessage].
	(quantity <1) ifTrue:[self error: self class negativeOrZeroQuantityErrorMessage].
	
	items add: anItem withOccurrences: quantity! !


!Cart methodsFor: 'initialization' stamp: 'fz 11/5/2017 14:35:26'!
initializeWithCatalog: aCatalog
	catalog := aCatalog.
	items := Bag new.! !



!Cart methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 22:27:24'!
catalog
	^catalog! !

!Cart methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 22:27:43'!
items
	
	^items! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: #TusLibros!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'initialization' stamp: 'fz 10/30/2017 22:26:03'!
newWithCatalog: aCatalog
	^self new initializeWithCatalog: aCatalog.! !


!Cart class methodsFor: 'messages' stamp: 'fz 11/5/2017 21:48:37'!
itemNotFromTheStoreErrorMessage
	^'Can not add items not from the store'! !

!Cart class methodsFor: 'messages' stamp: 'fz 11/5/2017 21:47:57'!
negativeOrZeroQuantityErrorMessage
	^'Can only add positives quantities of items'! !


!classDefinition: #Cashier category: #TusLibros!
Object subclass: #Cashier
	instanceVariableNames: 'cart creditCard salesBook'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'initialization' stamp: 'fz 11/5/2017 23:25:45'!
toCheckout: aCart withCard: aCreditCard registeringOn: aSalesBook 
	cart := aCart.
	creditCard := aCreditCard.
	salesBook := aSalesBook.! !


!Cashier methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 23:27:00'!
checkout
	|total catalog|
	
	total := 0.
	catalog := cart catalog.
	cart items do: [:item | total := total + (catalog at: item) ].
	
	salesBook add: total.
	
	^total.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: #TusLibros!
Cashier class
	instanceVariableNames: ''!


!Cashier class methodsFor: 'messages' stamp: 'fz 11/5/2017 21:59:40'!
emptyCartErrorMessage
	^'Cannot checkout an empty cart'! !

!Cashier class methodsFor: 'messages' stamp: 'fz 11/5/2017 22:57:32'!
expiredCreditCardErrorMessage
	^'Cannot checkout with expired credit card'! !


!Cashier class methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 23:21:34'!
toCheckout: aCart withCard: aCreditCard registeringOn: aSalesBook 
	(aCart isEmpty ) ifTrue: [self error: self emptyCartErrorMessage ].
	(aCreditCard  isExpiredOn: DateAndTime now) ifTrue: [self error: self expiredCreditCardErrorMessage].
	
	^self new toCheckout: aCart withCard: aCreditCard registeringOn: aSalesBook .! !


!classDefinition: #CreditCard category: #TusLibros!
Object subclass: #CreditCard
	instanceVariableNames: 'expirationDate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'testing' stamp: 'fz 11/5/2017 23:22:13'!
isExpiredOn: aDate 
	
	^expirationDate start < (Month month: aDate monthIndex year: aDate yearNumber) start ! !


!CreditCard methodsFor: 'initialization' stamp: 'fz 11/5/2017 23:19:41'!
expiringOn: aMonth 
	expirationDate := aMonth ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: #TusLibros!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'initialization' stamp: 'fz 11/5/2017 23:19:34'!
expiringOn: aMonth 
	
	^self new expiringOn: aMonth ! !


!classDefinition: #TusLibrosTestObjectFactory category: #TusLibros!
Object subclass: #TusLibrosTestObjectFactory
	instanceVariableNames: 'today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibrosTestObjectFactory methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 22:34:15'!
createCart
	|cart catalog|
	
	catalog := Dictionary new. 
	catalog at: self itemFromTheStore put: 5.
	
	cart := Cart newWithCatalog: catalog.
	
	^cart! !

!TusLibrosTestObjectFactory methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 23:24:02'!
expiredCreditCard
	
	^CreditCard expiringOn: self expiredMonthOfYear ! !

!TusLibrosTestObjectFactory methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 23:24:11'!
expiredMonthOfYear 

	^ Month month: today monthIndex year: today yearNumber - 1! !

!TusLibrosTestObjectFactory methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 23:23:39'!
initialize

	today := DateAndTime now! !

!TusLibrosTestObjectFactory methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 22:34:32'!
itemFromTheStore
	^'book1'! !

!TusLibrosTestObjectFactory methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 22:40:43'!
itemNotFromTheStore
	^'book2'! !

!TusLibrosTestObjectFactory methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 23:23:54'!
notExpiredCreditCard
	
	^CreditCard expiringOn: self notExpiredMonthOfYear! !

!TusLibrosTestObjectFactory methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 23:23:26'!
notExpiredMonthOfYear

	^ Month month: today monthIndex year: today yearNumber + 1! !
