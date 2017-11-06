!classDefinition: #CartTest category: #TusLibros!
TestCase subclass: #CartTest
	instanceVariableNames: 'objectFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

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


!CartTest methodsFor: 'setup' stamp: 'fz 11/5/2017 22:42:06'!
setUp

	objectFactory := TusLibrosTestObjectFactory new.! !


!classDefinition: #CashierTest category: #TusLibros!
TestCase subclass: #CashierTest
	instanceVariableNames: 'objectFactory debitBehavior'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'fz 11/6/2017 15:40:26'!
test01CanNotCheckoutAnEmptyCart
	| cart salesBook creditCard  |

	cart := objectFactory createCart.
	creditCard := objectFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
		
	self should: [
		Cashier 
			toCheckout: cart
			charging: creditCard
			throught: self
			on: objectFactory today
			registeringOn: salesBook.
		] 
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText = Cashier emptyCartErrorMessage].! !

!CashierTest methodsFor: 'tests' stamp: 'fz 11/6/2017 17:04:49'!
test02TotalCheckoutIsCorrect
	| cart cashier salesBook creditCard  |

	cart := objectFactory createCart.
	cart add: 2 of: objectFactory itemFromTheStore. 
	creditCard := objectFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
	
	cashier:= Cashier 
		toCheckout: cart
		charging: creditCard
		throught: self
		on: objectFactory today
		registeringOn: salesBook.
	
	self assert: (cashier checkout total) equals: 10.
	! !

!CashierTest methodsFor: 'tests' stamp: 'fz 11/6/2017 15:42:16'!
test03CanNotCheckoutWithExpiredCreditCard
	| cart salesBook creditCard  |

	cart := objectFactory createCart.
	cart add: objectFactory itemFromTheStore .
	creditCard := objectFactory expiredCreditCard .
	salesBook := OrderedCollection new.
	
	self should: [
		Cashier 
			toCheckout: cart
			charging: creditCard
			throught: self
			on: objectFactory today
			registeringOn: salesBook.
		] 
		raise:  Error - MessageNotUnderstood 
		withExceptionDo: [:anError | 
			anError messageText = Cashier expiredCreditCardErrorMessage]

	! !

!CashierTest methodsFor: 'tests' stamp: 'fz 11/6/2017 17:05:43'!
test04CheckoutRegistersASale
	| cart cashier salesBook total creditCard  |

	cart := objectFactory createCart.
	cart add: objectFactory itemFromTheStore .
	creditCard := objectFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart
		charging: creditCard
		throught: self
		on: objectFactory today
		registeringOn: salesBook.
		
	total := cashier checkout total.
					
	self assert: salesBook size = 1.
	self assert: salesBook first total = total.
	! !

!CashierTest methodsFor: 'tests' stamp: 'fz 11/6/2017 17:05:55'!
test05CashierChargesCreditCardUsingMerchantProcessor
	| cart cashier salesBook total creditCard debitedAmout debitedCreditCard  |

	cart := objectFactory createCart.
	cart add: objectFactory itemFromTheStore .
	creditCard := objectFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart
		charging: creditCard
		throught: self
		on: objectFactory today
		registeringOn: salesBook.
		
	debitBehavior := [ :anAmount :aCreditCard | 
		debitedAmout := anAmount.
		debitedCreditCard := aCreditCard ].
	total := cashier checkout total.
					
	self assert: debitedCreditCard = creditCard.
	self assert: debitedAmout = total.
	! !

!CashierTest methodsFor: 'tests' stamp: 'fz 11/6/2017 15:44:44'!
test06CashierDoesNotSaleWhenTheCreditCardHasNoCredit

	| cart cashier salesBook creditCard |

	cart := objectFactory createCart.
	cart add: objectFactory itemFromTheStore .
	creditCard := objectFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 	debitBehavior := [ :anAmount :aCreditCard | self error: Cashier creditCardHasNoCreditErrorMessage].
	
	cashier:= Cashier 
		toCheckout: cart
		charging: creditCard
		throught: self
		on: objectFactory today
		registeringOn: salesBook.
		
	self 
		should: [cashier checkout ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier creditCardHasNoCreditErrorMessage.
			self assert: salesBook isEmpty ]! !


!CashierTest methodsFor: 'setup' stamp: 'fz 11/6/2017 15:41:44'!
setUp

	objectFactory := TusLibrosTestObjectFactory new.
	debitBehavior := [ :anAmount :aCreditCard | ]! !


!CashierTest methodsFor: 'merchant processor protocol' stamp: 'fz 11/6/2017 15:39:12'!
debit: anAmount from: aCreditCard 
	^debitBehavior value: anAmount value: aCreditCard 
	! !


!classDefinition: #TusLibrosInterfaceTest category: #TusLibros!
TestCase subclass: #TusLibrosInterfaceTest
	instanceVariableNames: 'testObjectsFactory clock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:09:27'!
advanceTime: aDuration 
	
	clock advanceTime: aDuration ! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:39:39'!
anotherValidBook
	^testObjectsFactory anotherItemSellByTheStore ! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:11:16'!
createClock

	clock := ClockForTesting now: testObjectsFactory today! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:11:48'!
createDefaultInterface
	
	self createClock.
	
	^TusLibrosInteface 
		authenticatingWith: self validUsersAndPasswords 
		acceptingItemsOf: testObjectsFactory defaultCatalog 
		registeringOn: self createSalesBook
		debitingThrought: self merchantProcessor 
		measuringTimeWith: clock! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:50:16'!
createSalesBook
	^OrderedCollection new! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:56:21'!
debit: aSmallInteger from: aCreditCard ! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:19:23'!
invalidBook
	^'book2'! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:12:52'!
invalidCartId
	^45! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:07:44'!
invalidPassword
	^'sarasa'! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:03:27'!
invalidUser
	^'sarasa'! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:50:28'!
merchantProcessor
	^self! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:19:47'!
revertTime: aDuration 
	
	clock revertTime: aDuration ! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:27:01'!
setUp 

	testObjectsFactory := TusLibrosTestObjectFactory new.
! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:21:29'!
test01CanCreateCartWithValidUserAndPassword

	| interface |
	
	interface := self createDefaultInterface.

	self 
		shouldnt: [interface createCartFor: self validUser authenticatedWith: self validUserPassword]
		raise: Error - MessageNotUnderstood ! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:21:36'!
test02CanNotCreateCartWithInvalidUser

	| interface |

	interface := self createDefaultInterface.

	self
		should: [ interface createCartFor: self invalidUser authenticatedWith: self validUserPassword ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = interface invalidUserAndOrPasswordErrorDescription ]! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:21:44'!
test03CanNotCreateCartWithInvalidPassword

	| interface |

	interface := self createDefaultInterface.

	self
		should: [ interface createCartFor: self validUser authenticatedWith: self invalidPassword ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = interface invalidUserAndOrPasswordErrorDescription ]! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:03:52'!
test04CanAddItemsToACreatedCart

	| interface cartId |

	interface := self createDefaultInterface.

	cartId := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	self
		shouldnt: [interface add: 1 of: self validBook toCartIdentifiedAs: cartId]
		raise: Error - MessageNotUnderstood
		! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:04:04'!
test05CanNotAddItemToNotCreatedCart

	| interface |

	interface := self createDefaultInterface.

	self
		should: [interface add: 1 of: self validBook toCartIdentifiedAs: self invalidCartId]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = interface invalidCartIdErrorDescription ]
		! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:04:10'!
test06CanNotAddItemNotSellByTheStore

	| interface cartId |

	interface := self createDefaultInterface.

	cartId := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	self
		should: [interface add: 1 of: self invalidBook toCartIdentifiedAs: cartId ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = interface invalidItemErrorMessage ]
		! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:31:37'!
test07ListCartOfAnEmptyCartReturnsAnEmptyBag

	| interface cartId |

	interface := self createDefaultInterface.

	cartId := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	self assert: (interface listCartIdentifiedAs: cartId) isEmpty 
	! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:32:43'!
test08CanNotListCartOfInvalidCartId

	| interface |

	interface := self createDefaultInterface.

	self 
		should: [interface listCartIdentifiedAs: self invalidCartId] 
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = interface invalidCartIdErrorDescription ]
	! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:04:27'!
test09ListCartReturnsTheRightNumberOfItems

	| interface cartId cartContent |

	interface := self createDefaultInterface.

	cartId := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	interface add: 1 of: self validBook toCartIdentifiedAs: cartId.
	interface add: 2 of: self anotherValidBook toCartIdentifiedAs: cartId.
	cartContent := interface listCartIdentifiedAs: cartId.
	
	self assert: (cartContent occurrencesOf: self validBook) = 1. 
	self assert: (cartContent occurrencesOf: self anotherValidBook) = 2
! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:04:34'!
test10CanCheckoutACart

	| interface cartId  |

	interface := self createDefaultInterface.

	cartId := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	interface add: 1 of: self validBook toCartIdentifiedAs: cartId.
	self
		shouldnt: [interface 
			checkOutCartIdentifiedAs: cartId 
			withCreditCardNumbered: '1111222233334444' 
			ownedBy: 'Juan Perez' 
			expiringOn: testObjectsFactory notExpiredMonthOfYear ]
		raise: Error - MessageNotUnderstood
		
		! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:40:36'!
test11CanNotCheckoutANotCreatedCart

	| interface |

	interface := self createDefaultInterface.

	self
		should: [interface 
			checkOutCartIdentifiedAs: self invalidCartId  
			withCreditCardNumbered: '1111222233334444' 
			ownedBy: 'Juan Perez' 
			expiringOn: testObjectsFactory notExpiredMonthOfYear ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = interface invalidCartIdErrorDescription ]
		
		! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:41:53'!
test12CanNotCheckoutAnEmptyCart

	| interface cartId |

	interface := self createDefaultInterface.

	cartId := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	self
		should: [interface 
			checkOutCartIdentifiedAs: cartId 
			withCreditCardNumbered: '1111222233334444' 
			ownedBy: 'Juan Perez' 
			expiringOn: testObjectsFactory notExpiredMonthOfYear ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = interface cartCanNotBeEmptyErrorMessage ]
		! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:45:22'!
test13CanNotCheckoutWithAnExpiredCreditCard

	| interface cartId |

	interface := self createDefaultInterface.

	cartId := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	interface add: 1 of: self validBook toCartIdentifiedAs: cartId.
	self
		should: [interface 
			checkOutCartIdentifiedAs: cartId 
			withCreditCardNumbered: '1111222233334444' 
			ownedBy: 'Juan Perez' 
			expiringOn: testObjectsFactory expiredMonthOfYear ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = interface canNotChargeAnExpiredCreditCardErrorMessage ]
		
		! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:03:14'!
test14ListPurchasesIncludesBoughtItems

	| interface cartId purchases |

	interface := self createDefaultInterface.

	cartId := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	interface add: 2 of: self validBook toCartIdentifiedAs: cartId.
	interface add: 1 of: self anotherValidBook toCartIdentifiedAs: cartId.
	interface 
		checkOutCartIdentifiedAs: cartId 
		withCreditCardNumbered: '1111222233334444' 
		ownedBy: 'Juan Perez' 
		expiringOn: testObjectsFactory notExpiredMonthOfYear.
		
	purchases := interface listPurchasesOf: self validUser authenticatingWith: self validUserPassword.

	self assert: (purchases at: self validBook) = (testObjectsFactory itemFromTheStorePrice * 2).
	self assert: (purchases at: self anotherValidBook) = testObjectsFactory anotherItemSellByTheStorePrice.! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:07:02'!
test15CanNotListPurchasesOfInvalidCustomer

	| interface |

	interface := self createDefaultInterface.

	self 
		should: [interface listPurchasesOf: self invalidUser authenticatingWith: self validUserPassword ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = interface invalidUserAndOrPasswordErrorDescription ]! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:08:24'!
test16CanNotListPurchasesOfValidCustomerWithInvalidPassword

	| interface |

	interface := self createDefaultInterface.

	self 
		should: [interface listPurchasesOf: self validUser authenticatingWith: self invalidPassword ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = interface invalidUserAndOrPasswordErrorDescription ]! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:18:58'!
test17CanNotAddToCartWhenSessionIsExpired

	| interface cartId |

	interface := self createDefaultInterface.
	cartId := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	self advanceTime: (interface sessionDuration + 1 minutes) . 
	self 
		should: [interface add: 2 of: self validBook toCartIdentifiedAs: cartId]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = interface sessionHasExpiredErrorDescription ].

	self revertTime: interface sessionDuration.
	self assert: (interface listCartIdentifiedAs: cartId)	isEmpty
! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:20:36'!
test18CanNotListCartWhenSessionIsExpired

	| interface cartId |

	interface := self createDefaultInterface.
	cartId := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	self advanceTime: (interface sessionDuration + 1 minutes) . 
	self 
		should: [interface listCartIdentifiedAs: cartId]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = interface sessionHasExpiredErrorDescription ].
! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:20:44'!
test19CanNotCheckOutCartWhenSessionIsExpired

	| interface cartId |

	interface := self createDefaultInterface.
	cartId := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	interface add: 2 of: self validBook toCartIdentifiedAs: cartId.
	self advanceTime: (interface sessionDuration + 1 minutes) . 
	self 
		should: [interface checkOutCartIdentifiedAs: cartId withCreditCardNumbered: '11' ownedBy: 'jp' expiringOn: testObjectsFactory notExpiredMonthOfYear ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = interface sessionHasExpiredErrorDescription ].

	! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:09:18'!
validBook
	^'book1'! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 15:57:49'!
validUser
	^'asd'! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 15:58:01'!
validUserPassword
	^'123'! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:04:54'!
validUsersAndPasswords
	
	^Dictionary new
		at: self validUser put: self validUserPassword;
		yourself! !


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

!Cart methodsFor: 'testing' stamp: 'fz 11/6/2017 17:25:36'!
signalInvalidItem 

	self error: self invalidItemErrorMessage! !

!Cart methodsFor: 'testing' stamp: 'fz 11/6/2017 17:25:43'!
signalInvalidQuantity 

	self error: self invalidQuantityErrorMessage ! !


!Cart methodsFor: 'adding' stamp: 'fz 11/5/2017 14:40:51'!
add: anItem
	self add: 1 of: anItem! !

!Cart methodsFor: 'adding' stamp: 'fz 11/6/2017 17:22:36'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	items add: anItem withOccurrences: aQuantity ! !


!Cart methodsFor: 'initialization' stamp: 'fz 11/5/2017 14:35:26'!
initializeWithCatalog: aCatalog
	catalog := aCatalog.
	items := Bag new.! !


!Cart methodsFor: 'messages' stamp: 'fz 11/6/2017 17:24:29'!
invalidItemErrorMessage
	
	^self class itemNotFromTheStoreErrorMessage ! !

!Cart methodsFor: 'messages' stamp: 'fz 11/6/2017 17:24:44'!
invalidQuantityErrorMessage
	
	^self class negativeOrZeroQuantityErrorMessage ! !


!Cart methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 22:27:24'!
catalog
	^catalog! !

!Cart methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:23:41'!
content
	
	^items copy! !

!Cart methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:25:09'!
itemsAndQuantitiesDo: aBlock
	
	^ items contents keysAndValuesDo: [ :anItem :aQuantity | aBlock value: anItem value: aQuantity ]! !

!Cart methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:00:29'!
total
	|total|
	
	total:=0.
	 items do: [:item | total := total + (catalog at: item) ].
	
	^total! !


!Cart methodsFor: 'assertions' stamp: 'fz 11/6/2017 17:22:58'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self signalInvalidItem]! !

!Cart methodsFor: 'assertions' stamp: 'fz 11/6/2017 17:23:08'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [self signalInvalidQuantity]! !

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


!classDefinition: #CartSession category: #TusLibros!
Object subclass: #CartSession
	instanceVariableNames: 'owner cart lastUsedTime duration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartSession methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:55:17'!
cart
	^cart! !

!CartSession methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:55:07'!
initializeOwnedBy: aClient with: aCart 

	owner := aClient.
	cart := aCart ! !

!CartSession methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:17:05'!
initializeOwnedBy: aClient with: aCart at: aTime expiringAfter: aDuration

	owner := aClient.
	cart := aCart.
	lastUsedTime := aTime.
	duration := aDuration ! !

!CartSession methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:15:23'!
isExpiredAt: aTime 
	
	^ (lastUsedTime + duration) < aTime! !

!CartSession methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:55:27'!
owner
	^owner! !

!CartSession methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:17:21'!
usedAt: aTime 
	
	lastUsedTime := aTime ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CartSession class' category: #TusLibros!
CartSession class
	instanceVariableNames: ''!

!CartSession class methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:54:55'!
ownedBy: aClient with: aCart 

	^self new initializeOwnedBy: aClient with: aCart ! !

!CartSession class methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:16:54'!
ownedBy: aClient with: aCart at: aTime expiringAfter: aDuration

	^self new initializeOwnedBy: aClient with: aCart at: aTime expiringAfter: aDuration ! !


!classDefinition: #Cashier category: #TusLibros!
Object subclass: #Cashier
	instanceVariableNames: 'cart creditCard salesBook merchantProcessor owner ticket'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'initialization' stamp: 'fz 11/6/2017 15:36:24'!
toCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook 
	cart := aCart.
	creditCard := aCreditCard.
	salesBook := aSalesBook.
	merchantProcessor := aMerchantProcessor ! !


!Cashier methodsFor: 'checkout' stamp: 'fz 11/6/2017 16:58:12'!
checkout

	self createTicket.
	self debitTotal.
	self registerSale.

	^ ticket ! !


!Cashier methodsFor: 'private' stamp: 'fz 11/6/2017 15:49:54'!
debitTotal: total
	merchantProcessor debit: total from: creditCard.! !

!Cashier methodsFor: 'private' stamp: 'fz 11/6/2017 15:50:38'!
registerOnSalesBook: total
	salesBook add: total.! !


!Cashier methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:59:04'!
createLineItemOf: anItem quantity: aQuantity 

	^LineItem of: anItem quantity: aQuantity total: (self totalOf: anItem quantity: aQuantity) ! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:01:38'!
createSale
	^ Sale doneBy: owner certifiedWith: ticket! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:58:30'!
createTicket

	| lineItems |
	
	lineItems := OrderedCollection new.
	cart itemsAndQuantitiesDo: [ :anItem :aQuantity | 
		lineItems add: (self createLineItemOf: anItem quantity: aQuantity)].
	
	ticket := Ticket of: lineItems 
	! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:00:50'!
debitTotal

	merchantProcessor debit: ticket total from: creditCard.
	! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:55:55'!
initializeToCheckout: aCart ownedBy: anOwner charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook
	
	cart := aCart.
	owner := anOwner.
	creditCard := aCreditCard.
	merchantProcessor := aMerchantProcessor.
	salesBook := aSalesBook! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:01:27'!
registerSale
	salesBook add: self createSale! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:59:20'!
totalOf: anItem quantity: aQuantity 

	^(cart catalog at: anItem) * aQuantity  ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: #TusLibros!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'initialization' stamp: 'fz 11/6/2017 15:35:49'!
toCheckout: aCart charging: aCreditCard throught: aMerchantProcessor on: aDate registeringOn: aSalesBook 
	self assertIsNotEmpty: aCart.
	self assertIsNotExpired: aCreditCard on: aDate.
	
	^self new toCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook ! !


!Cashier class methodsFor: 'messages' stamp: 'fz 11/6/2017 15:45:13'!
creditCardHasNoCreditErrorMessage
	^'credit card has no credit'! !

!Cashier class methodsFor: 'messages' stamp: 'fz 11/5/2017 21:59:40'!
emptyCartErrorMessage
	^'Cannot checkout an empty cart'! !

!Cashier class methodsFor: 'messages' stamp: 'fz 11/5/2017 22:57:32'!
expiredCreditCardErrorMessage
	^'Cannot checkout with expired credit card'! !


!Cashier class methodsFor: 'assertions' stamp: 'fz 11/6/2017 15:28:29'!
assertIsNotEmpty: aCart 
	(aCart isEmpty ) ifTrue: [self error: self emptyCartErrorMessage ].! !

!Cashier class methodsFor: 'assertions' stamp: 'fz 11/6/2017 15:28:43'!
assertIsNotExpired: aCreditCard on: aDateAndTime 
	(aCreditCard  isExpiredOn: DateAndTime now) ifTrue: [self error: self expiredCreditCardErrorMessage].! !


!Cashier class methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:55:43'!
toCheckout: aCart ownedBy: anOwner charging: aCreditCard throught: aMerchantProcessor on: aDate registeringOn: aSalesBook
	
	self assertIsNotEmpty: aCart.
	self assertIsNotExpired: aCreditCard on: aDate.
	
	^self new initializeToCheckout: aCart ownedBy: anOwner charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook! !


!classDefinition: #ClockForTesting category: #TusLibros!
Object subclass: #ClockForTesting
	instanceVariableNames: 'now'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!ClockForTesting methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:13:18'!
advanceTime: aDuration 
	
	now := now + aDuration ! !

!ClockForTesting methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:12:34'!
initializeNow: aTime 

	now := aTime ! !

!ClockForTesting methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:14:58'!
now
	^now! !

!ClockForTesting methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:19:56'!
revertTime: aDuration 
	
	now := now + aDuration negated ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ClockForTesting class' category: #TusLibros!
ClockForTesting class
	instanceVariableNames: ''!

!ClockForTesting class methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:12:24'!
now: aTime 
	
	^self new initializeNow: aTime ! !


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


!classDefinition: #LineItem category: #TusLibros!
Object subclass: #LineItem
	instanceVariableNames: 'item quantity total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!LineItem methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:59:46'!
initializeOf: anItem quantity: aQuantity total: aTotal

	item := anItem.
	quantity := aQuantity.
	total := aTotal 
! !

!LineItem methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:02:44'!
item
	^item! !

!LineItem methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:01:13'!
total
	^total! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LineItem class' category: #TusLibros!
LineItem class
	instanceVariableNames: ''!

!LineItem class methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:59:34'!
of: anItem quantity: aQuantity total: aTotal

	^self new initializeOf: anItem quantity: aQuantity total: aTotal

! !


!classDefinition: #Sale category: #TusLibros!
Object subclass: #Sale
	instanceVariableNames: 'customer ticket'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Sale methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:02:05'!
initializeDoneBy: aCustomer certifiedWith: aTicket 

	customer := aCustomer.
	ticket := aTicket ! !

!Sale methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:02:26'!
lineItemsDo: aBlock
	
	^ticket lineItemsDo: aBlock ! !

!Sale methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:05:20'!
total
	
	^ ticket total! !

!Sale methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:02:17'!
wasDoneBy: aCustomer

	^customer = aCustomer ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sale class' category: #TusLibros!
Sale class
	instanceVariableNames: ''!

!Sale class methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:01:53'!
doneBy: aCustomer certifiedWith: aTicket 

	^self new initializeDoneBy: aCustomer certifiedWith: aTicket ! !


!classDefinition: #Ticket category: #TusLibros!
Object subclass: #Ticket
	instanceVariableNames: 'lineItems'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Ticket methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:00:23'!
initializeOf: aCollectionOfLineItems 

	lineItems := aCollectionOfLineItems ! !

!Ticket methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:02:38'!
lineItemsDo: aBlock
	
	^lineItems do: aBlock ! !

!Ticket methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:01:05'!
total
	^lineItems sum: [ :aLineItem | aLineItem total]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Ticket class' category: #TusLibros!
Ticket class
	instanceVariableNames: ''!

!Ticket class methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:00:14'!
of: aCollectionOfLineItems

	^self new initializeOf: aCollectionOfLineItems ! !


!classDefinition: #TusLibrosInteface category: #TusLibros!
Object subclass: #TusLibrosInteface
	instanceVariableNames: 'validUsersAndPasswords carts lastId catalog merchantProcessor salesBook clock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:45:51'!
add: anAmount of: aBook toCartIdentifiedAs: aCartId
	self withCartIdentifiedAs: aCartId do: [ :cart | cart add: anAmount of: aBook ]! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:46:20'!
canNotChargeAnExpiredCreditCardErrorMessage
	^Cashier expiredCreditCardErrorMessage ! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:44:15'!
cartCanNotBeEmptyErrorMessage
	
	^Cashier emptyCartErrorMessage ! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:56:07'!
checkOutCartIdentifiedAs: aCartId withCreditCardNumbered: aCreditCartNumber ownedBy: anOwner expiringOn: anExpirationMonthOfYear

	self 
		withCartSessionIdentifiedAs: aCartId 
		do: [ :cartSession | 
			(Cashier 
				toCheckout: cartSession cart 
				ownedBy: cartSession owner
				charging: (CreditCard expiringOn: anExpirationMonthOfYear) 
				throught: merchantProcessor 
				on: self today 
				registeringOn: salesBook) checkout ]! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:16:10'!
createCartFor: aUser authenticatedWith: aPassword

	| cartId cartSession |
	
	(self is: aUser authenticatingWith: aPassword) ifFalse: [ self signalInvalidUserAndOrPassword ].
	
	cartId := self generateCartId.
	cartSession := CartSession ownedBy: aUser with: (Cart newWithCatalog: catalog) at: self now expiringAfter: self sessionDuration.
	carts at: cartId put: cartSession.
	
	^cartId ! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:17:10'!
generateCartId
		
	lastId := lastId + 1.
	^lastId! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:13:02'!
initializeAuthenticatingWith: aValidUsersAndPasswords acceptingItemsOf: aCatalog registeringOn: aSalesBook debitingThrought: aMerchantProcessor measuringTimeWith: aClock

	validUsersAndPasswords := aValidUsersAndPasswords.
	catalog := aCatalog.
	salesBook := aSalesBook.
	merchantProcessor := aMerchantProcessor.
	clock := aClock.
	
	carts := Dictionary new.
	lastId := 0.! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:14:48'!
invalidCartIdErrorDescription
	^'invalid cart ID'! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:31:22'!
invalidItemErrorMessage
	
	^Cart itemNotFromTheStoreErrorMessage ! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:06:56'!
invalidUserAndOrPasswordErrorDescription
	^'invalid user and/or password'! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:11:44'!
is: aUser authenticatingWith: aPassword 
	
	| storedPassword |
	
	storedPassword := validUsersAndPasswords at: aUser ifAbsent: [ ^false ].
	^aPassword = storedPassword ! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:07:56'!
list: aSale on: salesOrderedByBook 

	aSale lineItemsDo: [ :aLineItem | | oldTotal newTotal |
		oldTotal := salesOrderedByBook at: aLineItem item ifAbsentPut: [ 0 ].
		newTotal := oldTotal + aLineItem total.
		salesOrderedByBook at: aLineItem item put: newTotal ]! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:52:10'!
listCartIdentifiedAs: aCartId

	^ self withCartIdentifiedAs: aCartId do: [ :cart | cart content ]! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:07:32'!
listPurchasesOf: aUser authenticatingWith: aPassword

	| sales |

	(self is: aUser authenticatingWith: aPassword) ifFalse: [ self signalInvalidUserAndOrPassword ].

	sales := self salesDoneBy: aUser.	
	
	^ sales
		inject: Dictionary new
		into: [ :salesOrderedByBook :aSale | 
			self list: aSale on: salesOrderedByBook.
			salesOrderedByBook ]! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:16:31'!
now
	
	^clock now! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:07:48'!
salesDoneBy: aUser
	^ salesBook select: [ :aSale | aSale wasDoneBy: aUser ]! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:16:39'!
sessionDuration
	
	^30 minutes! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:19:25'!
sessionHasExpiredErrorDescription
	^'sesion expired'! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:19:15'!
signalCartSessionExpired
	self error: self sessionHasExpiredErrorDescription ! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:14:37'!
signalInvalidCartId
	self error: self invalidCartIdErrorDescription ! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:06:29'!
signalInvalidUserAndOrPassword
	
	self error: self invalidUserAndOrPasswordErrorDescription! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:43:41'!
today
	^DateAndTime now! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:51:38'!
withCartIdentifiedAs: aCartId do: aBlock

	^self withCartSessionIdentifiedAs: aCartId do: [ :aCartSession | aBlock value: aCartSession cart ]
! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:14:48'!
withCartSessionIdentifiedAs: aCartId do: aBlock

	| cartSession |
	
	cartSession := carts at: aCartId ifAbsent: [self signalInvalidCartId ].
	(cartSession isExpiredAt: clock now) ifTrue: [ self signalCartSessionExpired ].
	
	^ [aBlock value: cartSession] ensure: [ cartSession usedAt: clock now ] ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TusLibrosInteface class' category: #TusLibros!
TusLibrosInteface class
	instanceVariableNames: ''!


!TusLibrosInteface class methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 17:12:49'!
authenticatingWith: aValidUsersAndPasswords acceptingItemsOf: aCatalog registeringOn: aSalesBook debitingThrought: aMerchantProcessor measuringTimeWith: aClock

	^self new initializeAuthenticatingWith: aValidUsersAndPasswords acceptingItemsOf: aCatalog registeringOn: aSalesBook debitingThrought: aMerchantProcessor measuringTimeWith: aClock! !


!classDefinition: #TusLibrosTestObjectFactory category: #TusLibros!
Object subclass: #TusLibrosTestObjectFactory
	instanceVariableNames: 'today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibrosTestObjectFactory methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:34:08'!
anotherItemSellByTheStore
	^'anotherBook'! !

!TusLibrosTestObjectFactory methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:34:18'!
anotherItemSellByTheStorePrice
	^10! !

!TusLibrosTestObjectFactory methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 22:34:15'!
createCart
	|cart catalog|
	
	catalog := Dictionary new. 
	catalog at: self itemFromTheStore put: 5.
	
	cart := Cart newWithCatalog: catalog.
	
	^cart! !

!TusLibrosTestObjectFactory methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:33:51'!
defaultCatalog
	|catalog|
	catalog := Dictionary new.
	catalog at: self itemFromTheStore put: self itemFromTheStorePrice.
	catalog at: self anotherItemSellByTheStore put: self anotherItemSellByTheStorePrice.
		
	^catalog! !

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

!TusLibrosTestObjectFactory methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:28:21'!
itemFromTheStorePrice
	^5! !

!TusLibrosTestObjectFactory methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 22:40:43'!
itemNotFromTheStore
	^'book2'! !

!TusLibrosTestObjectFactory methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 23:23:54'!
notExpiredCreditCard
	
	^CreditCard expiringOn: self notExpiredMonthOfYear! !

!TusLibrosTestObjectFactory methodsFor: 'as yet unclassified' stamp: 'fz 11/5/2017 23:23:26'!
notExpiredMonthOfYear

	^ Month month: today monthIndex year: today yearNumber + 1! !

!TusLibrosTestObjectFactory methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 15:25:32'!
today
	^today! !
