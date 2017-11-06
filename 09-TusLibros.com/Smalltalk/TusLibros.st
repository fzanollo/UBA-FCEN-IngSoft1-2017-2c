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

!CashierTest methodsFor: 'tests' stamp: 'fz 11/6/2017 15:40:53'!
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
	
	self assert: (cashier checkout) equals: 10.
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

!CashierTest methodsFor: 'tests' stamp: 'fz 11/6/2017 15:43:05'!
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
		
	total := cashier checkout.
					
	self assert: salesBook size = 1.
	self assert: salesBook first = total.
	! !

!CashierTest methodsFor: 'tests' stamp: 'fz 11/6/2017 15:36:57'!
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
	total := cashier checkout.
					
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
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:04:40'!
createDefaultInterface
		
	^TusLibrosInteface authenticatingWith: self validUsersAndPasswords! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:12:52'!
invalidCartId
	^45! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:07:44'!
invalidPassword
	^'sarasa'! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:03:27'!
invalidUser
	^'sarasa'! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 15:57:06'!
test01CanCreateCartWithValidUserAndPassword

	| interface |
	
	interface := self createDefaultInterface.

	self 
		shouldnt: [interface createCartFor: self validUser authenticatedWith: self validUserPassword]
		 raise: Error - MessageNotUnderstood ! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:03:09'!
test02CanNotCreateCartWithInvalidUser

	| interface |

	interface := self createDefaultInterface.

	self
		should: [ interface createCartFor: self invalidUser authenticatedWith: self validUserPassword ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = interface invalidUserAndOrPasswordErrorDescription]! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:07:24'!
test03CanNotCreateCartWithInvalidPassword

	| interface |

	interface := self createDefaultInterface.

	self
		should: [ interface createCartFor: self validUser authenticatedWith: self invalidPassword ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = interface invalidUserAndOrPasswordErrorDescription ]! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:16:17'!
test04CanAddItemsToACreatedCart

	| interface cartId |

	interface := self createDefaultInterface.

	cartId := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	self
		shouldnt: [interface add: self validBook quantity: 1 toCartIdentifiedAs: cartId]
		raise: Error - MessageNotUnderstood
		! !

!TusLibrosInterfaceTest methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:16:25'!
test05CanNotAddItemToNotCreatedCart

	| interface |

	interface := self createDefaultInterface.

	self
		should: [interface add: self validBook quantity: 1 toCartIdentifiedAs: self invalidCartId]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = interface invalidCartIdErrorDescription ]
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

!Cart methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:00:29'!
total
	|total|
	
	total:=0.
	 items do: [:item | total := total + (catalog at: item) ].
	
	^total! !

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
	instanceVariableNames: 'cart creditCard salesBook merchantProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'initialization' stamp: 'fz 11/6/2017 15:36:24'!
toCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook 
	cart := aCart.
	creditCard := aCreditCard.
	salesBook := aSalesBook.
	merchantProcessor := aMerchantProcessor ! !


!Cashier methodsFor: 'checkout' stamp: 'fz 11/6/2017 15:59:49'!
checkout
	|total|
	
	total := cart total.
	
	self debitTotal: total.
	self registerOnSalesBook: total.
	
	^total.! !


!Cashier methodsFor: 'private' stamp: 'fz 11/6/2017 15:49:54'!
debitTotal: total
	merchantProcessor debit: total from: creditCard.! !

!Cashier methodsFor: 'private' stamp: 'fz 11/6/2017 15:50:38'!
registerOnSalesBook: total
	salesBook add: total.! !

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


!classDefinition: #TusLibrosInteface category: #TusLibros!
Object subclass: #TusLibrosInteface
	instanceVariableNames: 'validUsersAndPasswords carts lastId catalog'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:16:36'!
add: aBook quantity: anAmount toCartIdentifiedAs: aCartId

	carts at: aCartId ifAbsent: [ self signalInvalidCartId ].! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:17:27'!
createCartFor: aUser authenticatedWith: aPassword

	| cartId |
	
	(self is: aUser authenticatingWith: aPassword) ifFalse: [ self signalInvalidUserAndOrPassword ].
	
	cartId := self generateCartId.
	carts at: cartId put: (Cart newWithCatalog: catalog).
	
	^cartId ! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:17:10'!
generateCartId
		
	lastId := lastId + 1.
	^lastId! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:13:54'!
initializeAuthenticatingWith: aValidUsersAndPasswords

	validUsersAndPasswords := aValidUsersAndPasswords.
	carts := Dictionary new.
	lastId := 0.! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:14:48'!
invalidCartIdErrorDescription
	^'invalid cart ID'! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:06:56'!
invalidUserAndOrPasswordErrorDescription
	^'invalid user and/or password'! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:11:44'!
is: aUser authenticatingWith: aPassword 
	
	| storedPassword |
	
	storedPassword := validUsersAndPasswords at: aUser ifAbsent: [ ^false ].
	^aPassword = storedPassword ! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:14:37'!
signalInvalidCartId
	self error: self invalidCartIdErrorDescription ! !

!TusLibrosInteface methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 16:06:29'!
signalInvalidUserAndOrPassword
	
	self error: self invalidUserAndOrPasswordErrorDescription! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TusLibrosInteface class' category: #TusLibros!
TusLibrosInteface class
	instanceVariableNames: ''!

!TusLibrosInteface class methodsFor: 'initialization' stamp: 'fz 11/6/2017 16:05:21'!
authenticatingWith: aValidUsersAndPasswords

	^self new initializeAuthenticatingWith: aValidUsersAndPasswords! !


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

!TusLibrosTestObjectFactory methodsFor: 'as yet unclassified' stamp: 'fz 11/6/2017 15:25:32'!
today
	^today! !
