!classDefinition: #CartTest category: #'Tus-Libros' stamp: 'fz_md 10/30/2019 23:57:47'!
TestCase subclass: #CartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tus-Libros'!

!CartTest methodsFor: 'tests' stamp: 'fz_md 10/30/2019 23:20:34'!
test01newCartIsEmpty
	|cart|
	
	cart := Cart new.
	
	self assert: cart isEmpty.! !

!CartTest methodsFor: 'tests' stamp: 'fz_md 10/30/2019 23:26:12'!
test02cartWithABookIsNotEmpty
	|cart book|
	
	cart := Cart new.
	
	book := 'ISBN'.
	cart add: 1 copiesOf: book.
	
	self deny: cart isEmpty.! !

!CartTest methodsFor: 'tests' stamp: 'fz_md 10/30/2019 23:42:12'!
test03booksAddedAreContainedInCart
	|cart book|
	
	cart := Cart new.
	
	book := 'ISBN'.
	cart add: 1 copiesOf: book.
	
	self assert: (cart has: book).! !

!CartTest methodsFor: 'tests' stamp: 'fz_md 10/30/2019 23:46:21'!
test04booksNotAddedAreNotContainedInCart
	|cart addedBook notAddedBook|
	
	cart := Cart new.
	
	addedBook := 'ISBN1'.
	notAddedBook := 'ISBN2'.
	
	cart add: 1 copiesOf: addedBook.
	
	self assert: (cart has: addedBook).
	self deny: (cart has: notAddedBook).! !

!CartTest methodsFor: 'tests' stamp: 'fz_md 10/30/2019 23:51:28'!
test05listingOfAnEmptyCartIsEmpty
	|cart|
	
	cart := Cart new.
	
	self assert: cart list equals: ''! !

!CartTest methodsFor: 'tests' stamp: 'fz_md 10/30/2019 23:53:40'!
test06listingOfACartHasOnlyContainedBooks
	|cart addedBook|
	
	cart := Cart new.
	
	addedBook := 'ISBN1'.
	
	cart add: 1 copiesOf: addedBook.
	
	self assert: cart list equals: (addedBook, '|1')! !


!classDefinition: #Cart category: #'Tus-Libros' stamp: 'fz_md 10/30/2019 23:57:47'!
Object subclass: #Cart
	instanceVariableNames: 'items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tus-Libros'!

!Cart methodsFor: 'testing' stamp: 'fz_md 10/30/2019 23:45:40'!
has: aBook
	^items includesKey: aBook! !

!Cart methodsFor: 'testing' stamp: 'fz_md 10/30/2019 23:28:34'!
isEmpty
	^items isEmpty! !

!Cart methodsFor: 'testing' stamp: 'fz_md 10/30/2019 23:55:47'!
list
	|listing|
	listing := ''.
	items keysAndValuesDo: [:aKey :aValue | listing := listing, aKey, '|', aValue asString].
	
	^listing.! !


!Cart methodsFor: 'initialization' stamp: 'fz_md 10/30/2019 23:27:43'!
initialize
	items := Dictionary new.! !


!Cart methodsFor: 'adding books' stamp: 'fz_md 10/30/2019 23:27:58'!
add: aQuantity copiesOf: aBook
	items at: aBook put: aQuantity.! !
