# sLang

The idea is to make a data-centric, typed scripting language, easy to read but most importantly easy to learn for new programmers


## Comments

```bash
# Single line comment

#{
	This is a multiline
	comment.
	For when you need to write long
	comments.
#}
```

# Operators

## Arithmetic operators

| Operation      | Symbol | Example |
| -------------- | ------ | ------- |
| Addition       | +      | 10 + 5  |
| Subtraction    | -      | 10 - 5  |
| Multiplication | *      | 10 * 5  |
| Division       | /      | 10 / 5  |
| Modulo         | %      | 10 % 5  |
| Exponential    | ^      | 2 ^ 64  |


## Assignment

| Operation           | Symbol | Example                      |
| ------------------- | ------ | ---------------------------- |
| Content redirection | >      | "Hello world" > message Text |
| Increment by value  | >+     | 10 >+ count                  |
| Decrement by value  | >-     | 10 >- count                  |
| Mutiply by value    | >*     | 10 >* count                  |
| Divide by value     | >/     | 10 >/ count                  |


## Relational

| Operation                  | Symbol | Example    |
| -------------------------- | ------ | ---------- |
| More than value            | >      | if 10 > 2  |
| Less than value            | <      | if 2 < 10  |
| More or equal to the value | >=     | if 10 >= 2 |
| Less or equal to the value | <=     | if 2 <= 10 |
| Equal                      | =      | if 10 = 10 |
| Not equal                  | !=     | if 10 != 2 |


## Text related

| Operation                      | Symbol | Example                   | Output                     |
| ------------------------------ | ------ | ------------------------- | -------------------------- |
| Concatenation                  | +      | "Hello" + " " + "World"   | "Hello World"              |
| Remove substring               | -      | "Hello world" - "world"   | "Hello "                   |
| Append to variable             | >+     | "Hello world" >+ someText | "$someText Hello world"    |
| Remove substring from variable | >-     | "substring" >- someText   | someText without substring |


## Variables

### Primitive Types

| Type name | Possible values | Default value |
| --------- | --------------- | ------------- |
| Natural   | 0 .. +inf       | 0             |
| Int       | -inf .. +inf    | 0             |
| Real      | -inf .. +inf    | 0.0           |
| Bool      | false / true    | false         |
| Text      |                 | (empty text)  |

```bash
# Declaration
index Int                 # Example declaration of int
age Natural               # Example declaration of natural
height Real               # Example declaration of height
name Text                 # Example declaration of text
surname, loremIpsum Text  # Example of multiple declaration of type text

# Assignment
69 > index
22 > age
1.70 > height

"Simone" > name         
"Van der Sar" > name  # unless there is space

# Text blocks are possible. Spaces, new lines and tabs will be kept
# Work like Java (https://docs.oracle.com/en/java/javase/13/text_blocks/index.html)
"""
Aut quod excepturi officia tempore. 
Quia non molestiae non aut.
Sit quos saepe exercitationem dolor voluptatem.
Et culpa voluptatem quos eligendi.
""" > loremIpsum

# Initialization (declaration and assignment)
420.50 > money Real
"Alessio" > secondName Text

"""
This is my biography.
Lol
Pretty empty
""" > biography Text
```

Assign variables to other variables is possible
```bash
number Int
copyOfNumber Int

69 > number
number > copyOfNumber
```

### Text handling

Double quotes will interpret variables (dollar sign will need escaping)
Single quotes will not
```bash
"Simone" > name Text
"Vicinanza" > surname Text

fullName Text
"$name $surname" > fullName        # fullName will be equal to "Simone Vicinanza"
'$name $surname' > fullName        # fullName will be equal to "$name $surname"
"$name \$surname" > fullName       # fullName will be equal to "Simone $surname"
```

If you need to have something immediately after the variable, without a space, you can wrap the variable name in curly braces
```bash
"Mario" > name Text
"Rossi" > surname Text

"${name}_${surname}" > fullName Text

# Writing this would have been an error
"$name_$surname" > fullName Text
# since the name_ variable doesn't exists
# (the underscore is a valid character for a variable name)

```

Text can also interpret code block (see Functions)
```bash
getName() => Text { 
	"simonvic" =>
}

"""
Hello world
I'm am ${getName()}
""" > someText Text
```


## Variable naming rules

The general rules for naming variables are:
  - Names must be unique
  - Names can contain letters, digits, underscores and dashes
  - Names must begin with a letter
  - Names cannot contain whitespace
  - Names are case sensitive ("myVar" and "myvar" are different variables)
  - Types, Structs and Functions name cannot be used as names
  - Reserved words cannot be used as names

### Reserved words

  - Types names
  - Structs names
  - Functions names
  - constant
  - if
  - else
  - for
  - in
  - repeat
  - break
  - continue
  - true / false
  - null


### Struct

A Struct is a structured data type that you can define.

It can contains primitive types or other Structs. It can also be a recursive struct (a Struct containing a Struct of the same type), but a default value must be specified. See Linked List example.

```bash
# Definition

Color (
	red Natural
	green Natural
	blue Natural
)

Person (
	name Text
	surname Text
	age Natural
	favoriteColor Color
	favoriteCar Car (     # Inline struct definition
		model Text        # it will be reusable from now on
		paint Color       # within the Person scope
	)
	ownedCar Car
)

# Declaration
# If not initialized, all values will have their type default value
red Color  # (0 0 0)
(255 0 0) > red
(255 0 255) > magenta Color

(	"Simon"              # Name
	"Vic"                # Surname
	22                   # Age
	red                  # Favorite color
	(                    # Favorite car
		"Ferrari"
		red
	)
	(                    # Owned car
		"Fiat 600"
		420.69
	)
) > me Person

# Setting struct attribute
(237 144 45) > me.favoriteColor

# Accessing struct attributes
me.name > myName Text
me.favoriteColor > myFavoriteColor Color
```

Specific attribute ???
```bash
(	age: 22
	surname: "Vic"
	favoriteColor: red
	favoriteCar: (
		"Ferrari"
		red
	)
) > me Person
```


### Constants

Constants are readonly, its value is defined at declaration
```bash
# constant <VARIABLE_NAME> <type> <value>
constant LIGHT_SPEED Natural 299792458
constant EARTH_GRAVITY Real 9.81
constant BEST_LANGUAGE Text "sLang"
constant ORIGIN Vector (0 0 0)

constant RED Color (
	255
	0
	0
)

constant NAME_LIST List[Text] (
	"Simone"
	"Luca"
	"Alessio"
	"Giada"
	"Francesca"
	"Paolo"
)

```


### Default value

The `_` (underscore) symbol represent the default value of a type
```bash
69 > number Natural
-420 > anotherNumber Integer
69.69 > someOtherNumber Real
"This is a text" > someText Text
true > someBoolean Bool

_ > number            # This will set number to 0
_ > anotherNumber     # This will set anotherNumber to 0
_ > someOtherNumber   # This will set someOtherNumber to 0.0
_ > someText          # This will set someText to empty string
_ > someBoolean       # This will set someBoolean to false
```


### Struct default value

Struct default value is a struct with all primitives default
```bash
someColor Color           # By default structs values will have their type default value   
(255 255 0) > someColor   # Setting someColor to (255 255 0)
_ > someColor             # This will set someColor to (0 0 0)
_ > someOtherColor Color  # This will be initialized with default values
```

```bash
# Color with overridden defaults
Color (
	red Natural _< 255
	green Natural _< 255
	blue Natural _< 255
)

(0 255 0) > someColor Color
_ > someColor                  # Set someColor to default (255 255 255)
```

If the default is not defined, the type default will be used
```bash
Person (
	name Text _< "No name"
	surname Text _< "No surname"
	age Natural
	favoriteColor Color _< (255 0 0)
	favoriteCar Car (
		model Text
		paint Color _< (40 40 40) 
	)
	# ownderCar will be a default Car
	ownedCar Car
)

aDefaultPerson Person

# aDefaultPerson.name is "No name"
# aDefaultPerson.surna is "No surname"
# aDefaultPerson.age is 0 (zero, Natural default)
# aDefaultPerson.favoriteColor is (255 0 0)
# aDefaultPerson.favoriteCar is ("" (40 40 40))
# aDefaultPerson.ownedCar is ("" (40 40 40))

( "Fiat 600" (10 100 20)) > aDefaultPerson.ownedCar
# aDefaultPerson.ownedCar is now ("Fiat 600" (10 100 20))

_ > aDefaultPerson.ownedCar
# aDefaultPerson.ownedCar is now ("" (40 40 40))


( "Ferrari" (255 255 255)) > aDefaultPerson.favoriteCar
# aDefaultPerson.favoriteCar is now ("Ferrari" (255 255 255))

_ > aDefaultPerson.favoriteCar.paint
# aDefaultPerson.favoriteCar is now ("Ferrari" (40 40 40 ))
```


### Structs inheritance ???

```bash
Vehicle (
	paint Color
	wheelCount Natural
)

Vehicle : Car (
	wheelCount _< 4
	licensePlate Text
)

Vehicle : Bike (
	wheelCount _< 2
	tireType Text
)

Bike : MotorBike (
	isOffroad Bool
)
```


## Logical operators

| Operation | Symbol | Example            |
| --------- | ------ | ------------------ |
| And       | &      | if 10 > 2 & 10 > 5 |
| Or        | \|     | if 10 > 2 \| 5 > 2 |
| Not       | !      | if ![2 > 10]       |


## Control structure

### if

```
# Square parenthesis around condition are optional
if <condition> {
	<true body>
}

if <condition> {
	<true body>
} else {
	<false body>
}
```

Example:
```bash
1 > x Int
69 > y Int

if x > y {
	# x is greater than y
} else {
	# y is greater or equal to x
}

if [x > y] & [x > 10] {
	# x is greater than y AND greater than 10
}
```



### Muliple if (switch)

```
if <variable> {
	<condition> {
		<condition body>
	}

	<condition 2> {
		<condition 2 body>
	}

} else {
	# no conditions have been met
	<else body>
}
```

Example:
```bash
69 > x Int

if x {
	= 1 {                          # x is equal 1
	}

	[= 2] | [= 3] {                # x is equal 2 or equal 3
	}

	[ [> 3] & [< 8] ]  & [!= 5] {  # x is between 3 and 8 exclusive and not equal to 5
	}

	>= 10 {                        # x is greater or equal to 10
	}

	= _ {                          # when x is equal to its type default value (zero)
	}

} else {
	# no conditions have been met
}

"Simone" > name Text
if name {
	= _ {}                # name is empty string
	= "Simone" {}         # name is Simone
	= "Alessio" {}        # name is Alessio
	= "Paolo" {}          # name is Paolo
	= "Gian Carlo" {}     # name is Gian Carlo
}
```

Comparing struct
```bash
FullName (
	name Text
	surname Text
)

myFullName FullName
adminName FullName

("Simone" "Vicinanza") > myFullName
myFullName > adminName

if myFullName {
	= _ {}                                                   # myFullName is default FullName value
	= ("Max" "Power") {}                                     # myFullName is ("Max" "Power")
	= ("Gian Carlo" "Esposito") {}                           # myFullName is ("Gian Carlo" "Esposito")
	[=("Simone" "Vicinanza")] | [=("Alessio" "Vicinanza")]   # myFullName is ("Simone" "Vicinanza") or ("Alessio" "Vicinanza")
	[= adminName] | [=("Paolo" adminName.surname) ]          # myFullName is adminName or ("Paolo" adminName.surname)
}
```


# Collections

## List

A list is a collection of variables that can be accessed via the index. The indexes are 0-based
```bash
# Declaration
# NOTE: Default value is an empty list
listOfNames List[Text]

# Assignment
["Simone" "Giada"] > listOfNames

# Insertion
# When inserting single element, round parentesis can be omitted
"Francesca" >+ listOfNames
"Alessio" >+ listOfNames
"Giovanna" >+ listOfNames
["Lucia" "Alessandra"] >+ listOfNames
"Gian Luca" >+ listOfNames

#{
	listOfNames is now:
	- Simone
	- Giada
	- Francesca
	- Alessio
	- Giovanna
	- Lucia
	- Alessandra
	- Gian Luca
#}
```

```bash
# List type can be omitted when declaring and initializing
# It will be inferred from the first element inserted
[1.0 0.5 2.5] > listOfReal List                  # List of Real (List[Real])
[1 2 3 4 5] > listOfNatural List                 # List of Natural (List[Natural])
[-1 0 4 5] > listOfInteger List                  # List of Integer (List[Int])
[4 5 6 7] > listOfInteger List[Int]              # List of Integer
["Simone" "Luca" "Paolo"] > listOfText List      # List of Text (List[Text])

# When creating list of Struct, the type must be declared
[ (62 65 10) (0 64 0) (12 50 255) ] > listOfColors List[Color]

[	("Simone" "Vicinanza")
	("Mario" "Rossi")
	("Luigi" "Bianchi")
] > listOfFullNames List[FullName]
```

Accessing list elements
```bash
# Defining a "Vector" (Struct with 3 Real representing x, y, z coordinates)
Vector (
	x Real
	y Real
	z Real
)

# Defining list of Vectors
[ (0 0 0) (0.5 1.5 3.2) (4 5.0 60.1) ] > vectors List[Vector]

# Accessing with index
coordinates[0] > firstElement Vector
coordinates[1] > secondElement Vector

# Negative indexes are valid
# It will return element count minus index
coordinates[-1] > lastElement Vector
coordinates[-2] > secondToLastElement Vector

# If negative index absolute value is greater than List count
# list element count will be subtracted from the index, therefore
# "cylcying" through the list

["a" "b" "c" "d" "e" "f" "g" "h" "i" "j"] > letters List[Text]    # List of 10 elements
letters[-12] secondToLastElement Text
# Will return "i", because -(abs(-12) - 10) = -2
# So it's the same as typing letters(-2)


# List length
coordinates[#] > coordinatesCount Int

# Copy list to another List
coordinates > copyOfCoordinates List[Vector]
```

Comparing Lists
```bash
numbers List[Int]
[ 1 2 3 4 ] > numbers

if numbers = _ {
	# if list is equal to List default (empty list)
}

if numbers {
	= [1 2 3] {}                      # if equal to a list of [1 2 3]
	= [1 2 3 4] | = [4 5 6 7] {}      # if equal to a list of [1 2 3 4] or [4 5 6 7]
	= [1 2 3 4] | numbers[#] = 10 {}  # if equal to a list of [1 2 3 4] or elements count equal to 10
	= _ | numbers[#] < 3 {}           # if empty list or elements count less then 3
	= _ & numbers[0] = 6 {}           # if empty list and first element equal to 6
}
```


## Set

A set is an unordered collections in which duplicates element are not allowed


## Map

A map contains values on the basis of key, i.e. key and value pair. Each key and value pair is known as an entry. A Map contains unique keys.

```bash
carCount Map[Text Int]

[ "Audi" 1 ] > carCount    # Insert new key "Audi"
[ "Audi" 5 ] > carCount    # Set "Audi" key value to 5

[                          # Insert/Set new key value pair
	"Mercedes" 10
	"Audi" 7
	"BMW" 15
	"Ferrari" 20
] > carCount

26 > carCount["Ferrari"]  # Set "Ferrari" value to 26
```

Default values can be used

```bash
[ "Fiat" _ ] > carCount
_ > carCount["Fiat"]
```

Accessing values

```bash
carCount["BMW"] > bmwCount Int     # Get value of key "BMW"

# Special characters
carCount[#] > entriesCount Int     # Get count of key/value pairs
carCount[@] > keys List[Text]      # Get all keys
carCount[*] > values List[Int]     # Get all values
```

Examples

```bash
bank Map[Text Real]
[
	"Simone" 69.0
	"Alessio" 15.50
	"Francesco" 125.15
] > bank

for name money in bank {
	"$name has $money € in his wallet" >
}

"List of names: " >
for name in bank[@] {
	"- $name" >
}

sum Real
for money in bank[*] {
	money >+ sum
}
"The bank has $sum €" >
```

## Matrix

```bash

```

## Sequence operator

The sequence operator lets you quickly define a sequence of elements
```bash
[0..5] > fromZeroToFive List                # List of Integer equal to [0 1 2 3 4 5]
[3..5] > fromThreeToFiveReal List[Real]     # List of Real equal to [3.0 4.0 5.0]
["a".."d"] > fromAtoZ List                  # List of Text equal to [a b c d]
["aaa".."zzz"] > listOfWords List           # List of text containing all possible words of 3 characters with letters from A to Z
```

Descending sequences can be defined
```bash
[5..0] > fromZeroToFive List                # List of Integer equal to [5 4 3 2 1]
[5..3] > fromThreeToFiveReal List[Real]     # List of Real equal to [5.0 4.0 3.0]
["d".."a"] > fromAtoZ List                  # List of Text equal to [d c b a]
["zzz".."aaa"] > listOfWords List           # List of text containing all possible words of 3 characters with letters from Z to A
```

A step value can also be used
```bash
[0..10..2] > evenNumbers List               # List of Integer equal to [0 2 4 6 8 10]
[0..0.5..0.1] > fromZeroToOne List          # List of Real equal to [0.1 0.2 0.3 0.4 0.5]
[a..g..2] > listOfLetters List              # List of Text equal to [a c e g]
```

Variables can be used
```bash
0 > start Int
10 > end Int
2 > step Int
[$start..$end..$step] > List                # List of Integer equal to [0 2 4 6 8 10]
```

# Loops

A loop is block of code that will be repeated (looped)


## Loop control

### break

The break keyword will break the loop


### continue

The continue keyword will skip the current iteration, and continue with the next


## repeat keyword

```bash
repeat {
	<body> # the body will be repeated for an undefined amount of time
}

repeat if <condition> {
	<body>  # the body will be repeated if the condition is true
}
```

A do-while loop can be achieved like so
```bash
repeat {
	<body>  # the body will be executed once and repeated if the condition is false
	if <condition> {
		break
	}
}
```


## For loop

The for loop is mainly used to iterate over List
```bash
# <variable> type will be inferred from the List type
for <variable> in <List> {
	<body>
}
```

```bash
[0 1 2 3 4] > numbers List
for number in numbers {}

["Simone" "Luca" "Paolo"] > names List
for name in names {}

# The sequence operator can be used
for i in [0..10] {}

# Iterating list over indeces
for i in [0..$names[#]] {}

# Iterating over list of struct
[(0 255 0) (55 0 255) (255 255 255)] > colors List[Color]
for color in colors {}
```

Iterating over list of struct

```bash
[(0 255 0) (55 0 255) (255 255 255)] > colors List[Color]
for color in colors {}
```

The for loop also tries to deconstruct the struct if the variables are the same of the struct

```bash
for red green blue in colors {}
```


# Content redirection

`content` > `destination`


## Special destinations

| Destination     | Symbol | Shorthand symbol |
| --------------- | ------ | ---------------- |
| Standard output | \out   | \                |
| Standard error  | \error |                  |


### Standard output

Print to standard output
```bash
"Hello world" > \out
"Hello world" > \
"I'm going to print the lorem ipsum" > \
"""
Qui odit molestias commodi omnis magni sunt. Et et et dolorem mollitia eum repellendus fuga qui. Numquam sint numquam sed delectus. Necessitatibus pariatur voluptatem ad ut eos in eos quo. Cupiditate et ut fuga. Aut enim aut amet non.

Pariatur nam nobis placeat. Consequuntur laborum consequatur accusantium totam occaecati possimus illo repellat. In fuga earum ea modi ut perspiciatis iusto. Iste voluptate qui at. Eos eaque cumque quisquam non nemo tenetur quo fugit.
""" > \
```


### Standard error

Print to standard error
```bash
"Some error happened" > \error
"I'm going to print some details:" > \error
"""
This program has crashed
because you tried to perform a
division by zero.
""" > \error
```

Multiple redirection can be achieved like so

`content` > `destination` > `destination2`


## New line split

If a line of code is too long, you can split it and use a new line by prefixing it with `|` (pipe)
```bash
# Declare three Text variables
aVariable Text
anotherVariable Text
someOtherVariable Text

# Assign "Hello World" to all of them
"Hello World" > aVariable > anotherVariable > someOtherVariable

# The previous line can be split like so:
"Hello World" > aVariable
	| > anotherVariable
	| > someOtherVariable
```


## Block return ???

Each code block (scope) can yield a value by redirecting content without specifying the destination
NOTE: instruction after the yield will be executed!

???


## Functions

Functions are special types of code block
```
<function name>(<param name> <param type> <default value> | <other params>) => <return type> {
	<body>
	<return value> =>
}
```

```bash
printHelloWorld() {
	"Hello World" >\
}

greetPerson(name Text, surname Text) {
	"Greetings $name, $surname" >\
}

getBestLanguage() => Text {
	"sLang" =>
}

sum(x Int, y Int) => Int {
	x + y =>
}

division(x Real, y Real) => Real {
	x / y =>
}

intToBool(x Int) => Bool {
	if x <= 0 {
		false =>
	}
	true =>
}

fibonacci(maxCount Natural) => Natural {
	sum Natural
	for i in [0..maxCount] {
		i >+ sum
	}
	sum =>
}

```

```bash
printHelloWorld()
greetPerson()
sum(2, 2) > sumResult Int
division(10, 3) > divisionResult Real
```

Function parameters can also have default values
```bash
# if num is not specified when calling the
# function, num will be 10
count(num Natural _< 10) {
	for i in (0..$num) {
		i >\
	}
}

# if name is not specified when calling the function
# its type default value will be used
greet(name Text _<_ ){
	if name = _ {
		"Greetings everybody!" >\
	} else {
		"Hello $name" >\
	}
}

count()          # Will count to 10
count(69)        # Will count to 69
greet()
greet("Simone")
```

Functions parameters can be explicitly specified, so the order doesn't matter
```bash
greet(name Text, age Natural) {
	"My name is $name" >\
	"My age is $age" >\
}

greet("Simone", 22)
greet(name:"Simone", age:22)
greet(age:22, name:"Simone")
```

Recursion can be used
```bash
fibonacci(count Natural) => Natural {
	if [count = 0] | [count = 1] {
		count =>
	}
	fibonacci(count - 1) + fibonacci(count - 2) =>
}

factorial(n Natural) {
	if n = 0 {
		1 =>
	}
	n * factorial(n-1) =>
}
```


# Code examples

## Book store

```bash
Author (
	name Text
	surname Text
	age Natural
)

Book (
	title Text
	description Text
	author Author
	price Real
	pagesCount Natural
)

printShelfStandard(shelf List[Book]) {
	for book in shelf {
		"""
		Title:        $book.title
		Description:  $book.description 
		Price:        $book.price
		Page count:   $book.pageCount
		Author:       $book.author
			Name:       $book.author.name
			Surname:    $book.author.surname
			Age:        $book.author.age
		""" >\
	}
}

printShelfTableHTML(shelf List[Book]) {
	table Text
	"""
	<table>
		<thead>
			<tr>
				<th>Title</th>
				<th>Description</th>
				<th>Price(€)</th>
				<th>Page Count</th>
				<th>Author</th>
			</tr>
		</thead>
	<tbody>
	""" > table

	for book in shelf {
		"""
		${toRowHTML(book)}
		""" >+ table
	}

	"""
		</tbody>
	</table>
	""" >+ table

	table >\
}

toRowHTML(book Book) {
	"""
	<tr>
		<td>$book.name</td>
		<td>$book.description</td>
		<td>$book.price</td>
		<td>$book.pageCount</td>
		<td>$book.author</td>
	</tr>
	""" =>
}



("Simone" "Vicinanza" 22) > author1 Author
("Mario" "Rossi" 35) > author2 Author

(
	(
		"sLang for dummies"
		"A book describing very easily the sLang"
		author1
		0.0
		69
	)
	(
		"How to make a new Language"
		"""
		A step by step guide on how to build a new language from scratch
		It even has pictures!!!
		"""
		author2
		6.9
		420
	)
	(
		"How to make a new Language | 2 edition"
		"""
		A step by step guide on how to build a new language from scratch
		It even has pictures!!!
		Revisioned edition
		"""
		author2
		4.2
		690
	)
	(
		"Story of a bored programmer"
		"Biography of a bored programmer"
		("Luigi" "Bianchi" 55)
		10.5
		120
	)
) > shelf List[Book]

printShelfStandard(shelf)
printShelfTableHTML(shelf)
```


## Linked List

```bash
Node (
	text Text
	next Node _< null
)

(
	"This is the root"
	(
		"This is the second node"
		(
			"This is the third node"
		)
	)
) > root Node

recursivePrintList(node Node) {
	node.text >\
	if node != null {
		recursivePrintList(node)
	}
}

recursivePrintList(root)
```
