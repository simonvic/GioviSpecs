# Giovi

Giovi is a typed scripting language, which is easy to read, quick to write with
no syntax clutter.<br>
It aims to be multipurpose: it can be used as a terminal shell, scripting,
embedded configuration

# Comments

```ruby
# Single line comment

#{
	This is a multiline
	comment block.
	For when you need to write long
	comments.
#}

#{ this is an inline comment block #}
```

## Documentation

```ruby
x Int #? Some number that means something

#? Some other number
y Int

#?{
#   @brief Sum two values
#   @param x
#       @pre x has some precodition
#       @post x has some postcondition
#   @param y
#       @pre y has some precodition
#       @post y has some postcondition
#   @return x + y
#
#   @code
#       sum(1, 2) > \out
#
#   @see Math
#}
sum(x Int, y Int) => Int {
    => x + y
}
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
| Multiply by value   | >*     | 10 >* count                  |
| Divide by value     | >/     | 10 >/ count                  |

## Relational

| Operation                  | Symbol | Example |
| -------------------------- | ------ | ------- |
| More than value            | >      | 10 > 2  |
| Less than value            | <      | 2 < 10  |
| More or equal to the value | >=     | 10 >= 2 |
| Less or equal to the value | <=     | 2 <= 10 |
| Equal                      | =      | 10 = 10 |
| Not equal                  | !=     | 10 != 2 |

## Logical operators

| Operation | Symbol | Example         |
| --------- | ------ | --------------- |
| And       | &      | 10 > 2 & 10 > 5 |
| Or        | \|     | 10 > 2 \| 5 > 2 |
| Not       | !      | !{2 > 10}       |

## Access operator

The access operator `@` is used to access special properties of variable/type.<br>
The "key" used for access can be a special symbol, a literal (e.g. `Int`) or a variable

```ruby
accessed@key
```

A key can also be an expression, but it must be enclosed in braces

```ruby
accessed@{key}
```

The output of the access depends on the "key" and to what type you're accessing.<br>
See:
- [Text access](#text-access)
- [List access](#list-access)
- [Map access](#map-access)
- [Struct access](#struct-access)

# Variables

A variable is identified by a unique name and its of a specified type

## Variable naming rules

The general rules for naming variables are:
  - Names must be unique
  - Names can contain letters, digits, underscores and dashes
  - Names must begin with a letter
  - Names cannot contain whitespace
  - Names are case-sensitive ("myVar" and "myvar" are different variables)
  - Types and Structs name cannot be used as names
  - Reserved words cannot be used as names


# Data types

## Primitive Types

| Type name | Possible values                  | Default value |
| --------- | -------------------------------- | ------------- |
| Natural   | 0 .. +4,294,967,295              | 0             |
| Int       | -2,147,483,648 .. +2,147,483.647 | 0             |
| Real      | up to 16 decimal digits          | 0.0           |
| Bool      | false / true                     | false         |
| Text      |                                  | (empty text)  |

### Declaration

```ruby
# <identifier> <type>
index Int
age Natural
height Real
name Text
```

### Assignment

```ruby
# <value> > <identifier>
69 > index
22 > age
1.70 > height

"Simone" > name         

# Text blocks. Spaces, new lines and tabs will be kept
# Work similar to Java (https://docs.oracle.com/en/java/javase/13/text_blocks/index.html)
"{
Aut quod excepturi officia tempore.
Quia non molestiae non aut.
Sit quos saepe exercitationem dolor voluptatem.
Et culpa voluptatem quos eligendi.
"} > loremIpsum

# Initialization (declaration and assignment)
420.50 > money Real
"Alessio" > secondName Text

"{
This is my biography.
Lol
Pretty empty
"} > biography Text
```

### Text type

#### Operators

| Operation                      | Symbol | Example                    | Output                     |
| ------------------------------ | ------ | -------------------------- | -------------------------- |
| Concatenation                  | +      | "Hello" + " " + "World"    | "Hello World"              |
| Remove substring               | -      | "Hello world" - "world"    | "Hello "                   |
| Append to variable             | >+     | "Hello world" >+ someText  | "$someText Hello world"    |
| Remove substring from variable | >-     | "substring" >- someText    | someText without substring |
| Text contains                  | =~     | "Hello world" =~ "lo worl" | true                       |
| Text is contained              | ~=     | "lo worl" ~= "Hello world" | true                       |

#### Text Access

| key   | output                     |
|-------|----------------------------|
| Int   | char at that index         |
| Range | substring                  |
| %     | length                     |
| *     | List of chars (Text)       |
| @     | Range from 0 to length - 1 |

```ruby
"hello world" > text Text
text@0 # will print "h"
text@1 # will print "e"

# Out of bounds indexes can be used to "cycle" the chars.
# Bound checking is left to the business logic to do.
letters@12     # "e"
letters@{-2}   # "l"

text@1..6     # "ello w"
text@0..10..2 # "hlowrd"
text@10..0    # will print "dlrow olleh"

text@% # 11 (chars count)
text@@ # 0..10 (range)
text@* # [ "h" "e" "l" "l" "o" " " "w" "o" "r" "l" "d" ]
```


#### Text interpolation

Double quotes will interpret variables (dollar sign will need escaping)<br>
Single quotes will not
```ruby
"Simone" > name Text
"Vicinanza" > surname Text

fullName Text
"$name $surname" > fullName        # fullName will be equal to "Simone Vicinanza"
'$name $surname' > fullName        # fullName will be equal to "$name $surname"
"$name \$surname" > fullName       # fullName will be equal to "Simone $surname"
```

If you need to have something immediately after the variable, without a space,
you can wrap the variable name in curly braces
```ruby
"Mario" > name Text
"Rossi" > surname Text

"${name}_${surname}" > fullName Text

# Writing this would have been an error
"$name_$surname" > fullName Text
# since the name_ variable doesn't exists
# (the underscore is a valid character for a variable name)

```

Text can also interpret code blocks
```ruby
x Int
y Int
"Sum is ${x + y}" > \out

getName() => Text { => "simonvic" }

"{
Hello world
I'm am ${getName()}
"} > someText Text
```

If you don't want variables/code to be interpreted, use single quotes (`'`)
text block
```ruby
'{
Hello,
I have $USD 69
'}
```

#### Text types @candidate
```ruby
Raw."hello how are you?"
Sql.""{
    SELECT * 
    FROM table
        FILTER BY name
    }""
Sql."SELECT * FROM table"

Json."{"field": "value"}"
Json.""{
    {
        "field": "value",
        "field2": "value2"
    }
    }""

Xml."<test attr='true'>yeah</test>"
Xml.""{
    <test attr="true">
        yeah
    </test>
    }""

fetchData(query Text.Sql) => Text.Json {}
```

##### Custom text type processors @candidate

```ruby
Text : Yaml (
    format() => Text {}
    isValid() => Bool {}
)
Yaml.""{
    something:
      - awfawf
      - awfaw
    }""
```

### Other primitive types

#### Function reference @candidate

The reference of a function is used to refer to the function itself.<br>
It is represented with `::` (double colon).

It can be stored in variables and struct, and can be passed as a parameter to
other functions as well.
```ruby
printSomething(txt Text) {
	txt > \out
}

functionRef ::(Text)

::printSomething > functionRef

# functionRef is now a reference to printSomething function
functionRef("hello world") # will print "hello world"
```

Function types are defined as follows
```
::([parameters]) [=> return type] [_ default implementation]
```

Anonymous function can also be defined
```ruby
functionRef ::()

# Assign an anonymouse function to functionRef
::{
	"hello world" > \out
} > functionRef

# I can now invoke functionRef
functionRef()
```

When the function has parameters, their names can be omitted in the signature;
but naming the parameters is advised for better readability
```ruby
# both are valid definitions of a reference to a function with a signature of (Text,Int) => Bool
stringContainsNumber1 ::(myText Text, myNumber Int) => Bool
stringContainsNumber2 ::(Text, Int) => Bool
```

A function type can also have a default value (implementation)
```ruby
functionRef ::(Text) _ ::(txt Text) {
	txt > \out
}
```

The types and return type can be inferred, making the definition less verbose
```ruby
# A verbose definition of a function reference which takes a Int and return an Int
# with a default implementation which returns the sum of the parameters

# variable ::(params)   => return  _ default implementation
myFunction ::(Int, Int) => Int     _ ::(x Int, y Int) => Int {=> x + y}
```
```ruby
# the default implementation can infer the type and return value
# variable ::(params)   => return  _ default implementation
myFunction ::(Int, Int) => Int     _ ::(x, y) {=> x + y}


# Alternatively, if parameters are named...
# variable ::(params)       => return  _ default implementation
myFunction ::(x Int, y Int) => Int     _ ::{=> x + y}
```

Some more examples
```ruby
myFunction ::(Int, Int) => Int

::(x, y) {=> x + y} > myFunction
myFunction(60, 9) > \out #myFunction will print 69 (60 + 9 = 69)

::(x, y) {=> x - y} > myFunction
myFunction(79, 10) > \out #myFunction will print 69 (79 - 10 = 69)

::(x, y) {=> x * y} > myFunction
myFunction(23, 3) > \out #myFunction will print 69 (23 * 3 = 69)

::(x, y) {=> x / y} > myFunction
myFunction(28980, 420) > \out #myFunction will print 69 (28980 / 420 = 69)
```

If the function doesn't take parameters, the parenthesis can be omitted
```ruby
functionRef ::()
::{"hello world" > \out} > functionRef
```

Some more complex examples.

A struct called `Callbacks`, holding a bunch of function references
```ruby
Callbacks (
	# A reference to a function with no parameters and no return value
	callback0 ::()

	# A reference to a function with an Int parameter
	callback1 ::(Int)

	# A reference to a function with an Int and a Text parameter
	callback2 ::(Int,Text)

	# A reference to a function with an Int and a Text parameter, with a Bool return type
	callback3 ::(Int,Text) => Bool

	# A reference to a function with no parameters with a Bool return type
	callback4 ::() => Bool

	# A reference to a function with a default implementation
	callback5 ::() _ ::{
		"default hello world" > \out
	}

	# A reference to a function with two Bool parameters, a Bool return value and a default implementation
	callback6 ::(a Bool, b Bool) => Bool _ ::{
		=> a & b
	}

	#{
	#	Invoke callback "count" times
	#	@param count
	#	@param callback
	#}
	aFunction1(count Int, callback ::()) {
		for i in 0..count do {
			callback()
		}
	}

	#{
	#	Invoke callback "count" times
	#	@param count
	#	@param callback with default implementation that prints hello world
	#	@code
	#	# will print "hello world" 69 times
	#	aFunction2(69)
	#
	#	@code
	#	# will print "something else" 69 times
	#	aFunction2(69, ::{
	#		"something else" > \out
	#	})
	#}
	aFunction2(count Int, callback ::() _ ::{"hello world" > \out}) {
		for i in 0..count do {
			callback()
		}
	}

	#{
	#	Invoke a callback 69 times
	#	@param callback ::(iteration index)
	#}
	aFunction3(callback ::(Int)){
		for i in 0..69 do {
			callback(i)
		}
	}
	
	#{
	#	Invoke a callback and print its return value 69 times
	#	@param callback ::(iteration index)
	#	@code
	#	aFunction4(::(index){=> index^2})
	#}
	aFunction4(callback ::(Int) => Int){
		for i in 0..69 do {
			callback(i) > \out
		}
	}
)

c Callbacks
```

Let's assign some functions
```ruby
::{
	"hello world" > \out
} > c.callback0

c.callback0() # will print "hello world"
```

```ruby
::(num Int) {
	for i in 0..num do {
		"hello world" > \out
	}
} > c.callback1

c.callback1() # will print "hello world" num times
```

```ruby
::(num, txt) { # the types are inferred
	for i in 0..num do {
		txt > \out
	}
} > c.callback2

c.callback2() # will print txt num times
```

```ruby
# the return type can be inferred too, but for redeability here it is explicit
::(num, txt) => Bool {
	for i in 0..num do {
		txt > \out
	}
	# return true if number is even
	=> num < 10
} > c.callback3

c.callback3() > result Bool # will print txt num times, and return true if num is less than 10
```

```ruby
::{
	=> true
} > c.callback4

c.callback4() > result Bool # will return true
```

```ruby
c.callback5() # will print "default hello world"

::{
	'hello world' > \out
} > c.callback5

c.callback5() # will print "hello world"

_ > c.callback5
c.callback5() # will print "default hello world"
```

```ruby
::(a, b) {
	=> a | b
} > c.callback6
c.callback6(true, false) > result Bool # will return true if a OR b are true

_ > c.callback5
c.callback6(true, false) > defaultResult Bool # will return true if a AND b are true (default implementation)
```

```ruby
someFunction() {
	"Hello from someFunction" > \out
}

c.aFunction1(3, ::{
	"hello from anonymous function" > \out
})

c.aFunction1(3, ::someFunction)
```

## Composite types

### List

A list is a collection of variables that can be accessed via the index.<br>
The indexes are 0-based

#### Operators

| Operation  | Symbol | Example        |
| ---------- | ------ | -------------- |
| Assignment | >      | [1 2 3] > list |
| Insert     | >+     | 4 >+ list      |
| Remove     | >-     | 4 >- list      |

##### Relational

| Operation    | Symbol | Example           |
| ------------ | ------ | ----------------- |
| Equal        | =      | [1 2 3] = [1 2 3] |
| Contains     | =~     | list =~ 2         |
| Is contained | ~=     | 2 ~= list         |

#### Syntax

```ruby
# <identifier> [<entry type>]
# NOTE: Default value is an empty list
listOfNames [Text]

# Assignment
["Simone" "Giada"] > listOfNames

# Insertion
# When inserting single element, square parentesis can be omitted
"Francesca" >+ listOfNames
"Alessio" >+ listOfNames
"Giovanna" >+ listOfNames
["Lucia" "Alessandra"] >+ listOfNames
"Gian Luca" >+ listOfNames
```

##### List type inference @candidate

```ruby
# List type can be omitted when declaring and initializing
# It will be inferred from the first element inserted
[1.0 0.5 2.5] > listOfReal []                  # List of Real ([Real])
[1 2 3 4 5] > listOfNatural []                 # List of Natural ([Natural])
[-1 0 4 5] > listOfInteger []                  # List of Integer ([Int])
[4 5 6 7] > listOfInteger [Int]                # List of Integer
["Simone" "Luca" "Paolo"] > listOfText []      # List of Text ([Text])

# When creating list of Struct, the type must be declared
[ .(62 65 10) .(0 64 0) .(12 50 255) ] > listOfColors [Color]

[	.("Simone" "Vicinanza")
	.("Mario" "Rossi")
	.("Luigi" "Bianchi")
] > listOfFullNames [FullName]
```

#### List Access

| key   | output                     |
|-------|----------------------------|
| Int   | element at that index      |
| Range | "sub list"                 |
| %     | elements count             |
| @     | Range from 0 to length - 1 |

```ruby
["a" "b" "c" "d" "e" "f" "g" "h" "i" "j"] > letters [Text]

letters@0 > \out    # "a"

# Indexes out of bounds can be used to "cycle" the list.
# Bound checking is left to the business logic to do.
letters@15     # "f"
letters@{-2}   # "i"

letters@2..5        # ["c" "d" "e" "f"]
letters@0..10..2    # ["a" "c" "e" "g" "i"]
letters@10..0       # ["j" "i" "h" "g" "f" "e" "d" "e" "c" "b" "a"] aka the drunk test :)

letters@% > \out    # 10 (elements count)
letters@@ > \out    # 0..9 (range) useful when you need to iterate a list with indexes
```

Comparing Lists

```ruby
numbers [Int]
[ 1 2 3 4 ] > numbers

if numbers = _ do {
	# if list is equal to List default (empty list)
}

if numbers {
	# if equal to a list of [1 2 3]
	= [1 2 3] do {}
	
	# if equal to a list of [1 2 3 4] or [4 5 6 7]
	= [1 2 3 4]
	| = [4 5 6 7] do {}
	
	# if equal to a list of [1 2 3 4] or elements count equal to 10
	= [1 2 3 4] | numbers@{%} = 10 do {}
	
	# if empty list or elements count less then 3
	= _ | numbers@{%} < 3 do {}
	
	# if empty list and first element equal to 6
	= _ & numbers@0 = 6 do {}

	# if contains 69
	=~ 69 do {}
	
}
```

##### Multidimensional list (matrix) @candidate

A multidimensional list (matrix) can be defined as follows

```ruby
identityMatrix [[Real]]

[	
	[1 0 0]
	[0 1 0]
	[0 0 1]
] > matrix
```

Values can be accessed as normal lists

`nameOfList@row@column`

```ruby
# Example of a Rubik cube multidimensional list
# for simplicity, we're storing color name instead of a Color struct
rubikCube [[[Text]]]
[
	[
		[ "Red" "Red" "Red" ]
		[ "Red" "Red" "Red" ]
		[ "Red" "Red" "Red" ]
	]
	[
		[ "White" "White" "White" ]
		[ "White" "White" "White" ]
		[ "White" "White" "White" ]
	]
	[
		[ "Green" "Green" "Green" ]
		[ "Green" "Green" "Green" ]
		[ "Green" "Green" "Green" ]
	]
	[
		[ "Yellow" "Yellow" "Yellow" ]
		[ "Yellow" "Yellow" "Yellow" ]
		[ "Yellow" "Yellow" "Yellow" ]
	]
	[
		[ "Blue" "Blue" "Blue" ]
		[ "Blue" "Blue" "Blue" ]
		[ "Blue" "Blue" "Blue" ]
	]
	[
		[ "Orange" "Orange" "Orange" ]
		[ "Orange" "Orange" "Orange" ]
		[ "Orange" "Orange" "Orange" ]
	]
] > rubikCube

rubikCube@2@1@1   # will refer to the central tile of green face
```

### Set @candidate

A set is an unordered collection in which duplicates element are not allowed


### Map

A map contains values on the basis of key, i.e. key and value pair.<br>
Each key and value pair is known as an entry.<br>
Map keys are unique.

#### Operators

| Operation  | Symbol | Example                    |
| ---------- | ------ | -------------------------- |
| Assignment | >      | ["a":1 "b":2 "c":3] > map  |
| Put        | >+     | ["d":4] >+ map             |
| Remove     | >-     | "d" >- map                 |
| Remove all | >-     | ["a" "b"] >- map           |
| Remove all | >-     | ["a":1 "b":2] >- map       |

##### Relational

| Operation    | Symbol | Example                       |
| ------------ | ------ | ----------------------------- |
| Equal        | =      | ["a":1 "b":2] = ["a":1 "b":2] |
| Contains key | =~     | map =~ "a"                    |
| Is contained | ~=     | "a" ~= map                    |


#### Syntax

```ruby
carCount [Text : Int]

[ "Audi" : 1 ] >+ carCount    # Insert new key "Audi" with value 1
[ "Audi" : 5 ] >+ carCount    # Set "Audi" key value to 5

[                          # Insert/Set new key value pair
	"Mercedes" : 10
	"Audi" : 7
	"BMW" : 15
	"Ferrari" : 20
] >+ carCount

26 > carCount@{"Ferrari"}  # Set "Ferrari" value to 26
```

Default values can be used

```ruby
[ "Fiat" : _ ] >+ carCount
_ > carCount@{"Fiat"}
```

#### Map Access

| key           | output                     |
|---------------|----------------------------|
| map key value | element mapped to that key |
| %             | entries count              |
| @             | List of map keys           |
| *             | List of map elements       |

```ruby
[
	"Mercedes" : 10
	"Audi" : 7
	"BMW" : 15
	"Ferrari" : 20
] > carCount [Text : Int]

carCount@"Audi"  # 7
carCount@%       # 4
carCount@@       # ["Mercedes" "Audi" "BMW" "Ferrari"]
carCount@*       # [10 7 15 20]
```

Examples

```ruby
bank [Text : Real]
[
	"Simone" : 69.0
	"Alessio" : 15.50
	"Francesco" : 125.15
] > bank

for name money in bank do {
	"$name has $money € in his wallet" > \out
}

"List of names: " > \out
for name in bank@{@} do {
	"- $name" > \out
}

sum Real
for money in bank@{*} do {
	money >+ sum
}
"The bank has a total of $sum €" > \out
```

### Struct

A Struct is a structured data type that you can define; it can contain
heterogeneous types (primitive or composite)

#### Syntax

```ruby
# Definition
# <name> ( <fields> )
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
	Car (     # Nested struct definition
		model Text        # it will be reusable within the Person scope
		paint Color
	)
	favoriteCar Car
	ownedCar Car
)
```

##### Creation

```ruby
Color.(255 0 0) > red Color
Person.(
	"Simon"
	"Vic"
	22
	red
	("Ferrari" red)
	("Fiat600" magenta)
) > me Person
```

When creating a struct, you can name the fields to improve readability.
By doing so, the order of the fields won't matter

```ruby
Person.(
	age: 22
	surname: "Vic"
	name: "Simon"
	favoriteColor: Color.(
		red: 255
		green: 69
		blue: 42
	)
	favoriteCar: Car.(
		model: "Ferrari"
		paint: red
	)
) > me Person
```

You can also specify a subset of the fields; unspecified fields will be
initialized with their default value.
Note that this is not possible when the field names are not specified.

```ruby
Person.(
	age: 23
	favoriteCar: Car.(model: "Ferrari")
) > me Person
```

Creating a struct with a type but no fields, will create a default struct of
that type
```ruby
Color.() > \out
```

###### Anonymous structs (tuples)

When creating a struct the type can be omitted, hence creating an anonymous
struct (aka tuple)

Tuples can be named (fields are indexed by names) or unnamed (fields are
indexed by 0-based index)
```ruby
# Named tuple with three fields
.(
    field1: "a"
    field2: true
    field3: 420.69
)

# Unnamed tuple with three fields
.("a" true 420.69)
```

Tuples can be assigned to structs, as long as they're compatible.<br>
Named tuples are compatible to all structs of which the fields are a superset
of the tuple; in this case only the fields in the subset will change in the
assigned struct

```ruby
me Person

.(
    name: "Simon"
    age: 23
    favoriteCar: .(
        model: "Ferrari"
    )
) > me Person
```

When assigning with an unnamed tuple, all fields must be specified for the
tuple to be compatible

```ruby
color Color
.(255 255 255) > color
.(255) > color # Error! Incompatible structs
.(red: 255) > color # Ok!
```

This allows for a less verbose variable declaration

```ruby
# From most verbose to less verbose
Color.(
    red: 255
    blue: 255
    green: 255
) > c Color

.(
    red: 255
    blue: 255
    green: 255
) > c Color

.(255 255 255) > c Color
```

#### Struct Access

| key | output                   |
|-----|--------------------------|
| Int | field value at the index |
| %   | fields count             |
| @   | list of fields names     |

```ruby
Color (
    red Natural
    green Natural
    blue Natural
)
.(255 100 50) > color Color

color@0  # 255
color@%  # 3
color@@  # ["red" "green" "blue"]
```

You can access fields by their name with the dot notation

```ruby
Color (
    red Natural
    green Natural
    blue Natural
)
.(255 100 50) > color Color

color.red > \out
255 > color.blue # setting blue channel to 255
```

##### Nested struct @candidate

You can define struct within struct.

```ruby
Car (
	Engine (
		horsePower Real
		isElectric Bool
	)
	model Text
	primaryEngine Engine
	secondaryEngine Engine
)
Person (
	name Text
	favoriteCar Car
)
```

The nested struct definition will be evaluated immediately and can be used by
other fields. But it's good practice to put it on top.

You can access the nested struct using the dot notation

```ruby
engine Car.Engine
```

You can also define nested struct inline (immediately after the field
definition), but the type definition won't be immediately available, hence
not usable from fields defined before.

```ruby
Person (
	name Text
	age Natural
	# someColor Color
	#           ^^^^^ Error! Color not defined
	favoriteColor Color (
		red Natural
		green Natural
		blue Natural
	)
)
```

##### Recursive struct @candidate

You can define recursive struct (struct defined with itself)

```ruby
Node (
	data Text
	nextNode Node _ null
)
```

##### Struct functions @candidate

```ruby
Vehicle (
	speedKmH Int
	
	accelerate(amount Int) {
		amount >+ speed
	}
	
	brake() {
		1 >- speed
	}

	speedToMilesPerHour() => Int{
		=> speed / 1.6093
	}
)

car.accelerate(10)
"${car.speedKmH} KMH" > \out
"${car.speedToMilesPerHour()} MPH" > \out
```

###### Static struct functions @candidate

```ruby
Car (
    speed Real

    # non-static
    self accelerate() {
        self.speed +< 2
    }
    
    # static
    accelerate(car Car) {
        car.speed +< 2
    }
)

c Car
c.accelerate()
Car.accelerate(c)
```

#### Structs inheritance

A struct can inherit the fields from another struct.
It can define new fields and override the default value of an inherited field.

```ruby
Vehicle (
	paint Color
	wheelCount Natural
)

Vehicle : Car (
	wheelCount Natural _ 4
	licensePlate Text
)

Vehicle : Bike (
	wheelCount Natural _ 2
	tireType Text
)

Bike : MotorBike (
	isOffroad Bool
)
```

##### Nested structs definition inheritance @candidate

Nested definition are "static" and are not inherited.

```ruby
Vehicle (
	engine Engine (
		horsePower Real
	)
	wheelsCount Int
)
Vehicle : Car (
	wheelsCount Int _ 4
	plate Text _ "xxx"
	# secondaryEngine Engine
	#                 ^^^^^^ Error! Engine not defined
)
```

But you can use the dot notation

```ruby
Vehicle (
	engine Engine (
		horsePower Real
	)
	wheelsCount Int
)
Vehicle : Car (
	wheelsCount Int _ 4
	plate Text _ "xxx"
	secondaryEngine Vehicle.Engine
)
```

or you can also specialize the nested struct

```ruby
Vehicle (
	engine Engine (
		horsePower Real
	)
	wheelsCount Int
)
Vehicle : Car (
	wheelsCount Int _ 4
	plate Text _ "xxx"
	Vehicle.Engine : Engine (
		fuelType Text
	)
	secondaryEngine Engine
	#               ^^^^^^ Car.Engine, which inherits from Vehicle.Engine
)
```

# Constants

Constants are read-only; its value is defined at declaration and cannot change.

```ruby
# constant <VARIABLE_NAME> <type> <value>
constant LIGHT_SPEED Natural 299792458
constant EARTH_GRAVITY Real 9.81
constant BEST_LANGUAGE Text "Giovi"
constant ORIGIN Vector .(0 0 0)

constant RED Color .(
	255
	0
	0
)

constant NAME_LIST [Text] [
	"Simone"
	"Luca"
	"Alessio"
	"Giada"
	"Francesca"
	"Paolo"
]
```

# Default value

The `_` (underscore) symbol represent the default value of a type

```ruby
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

It is also possible to overwrite a variable default value
```ruby
69 > number Natural _ 420
69.69 > someOtherNumber Real _ 4.20
"This is a text" > someText Text _ "default text"
false > someBoolean Bool _ true

_ > number            # This will set number to 420
_ > someOtherNumber   # This will set someOtherNumber to 4.20
_ > someText          # This will set someText to "default text"
_ > someBoolean       # This will set someBoolean to true
```

## Struct default value

Struct default value is a struct with all its fields set to their respective
default value

```ruby
someColor Color
.(255 255 0) > someColor  # Setting someColor to (255 255 0)
_ > someColor             # This will set someColor to (0 0 0)
```

```ruby
# Color with overridden defaults
Color (
	red Natural _ 255
	green Natural _ 255
	blue Natural _ 255
)

.(0 255 0) > someColor Color
_ > someColor                  # Set someColor to default (255 255 255)
```

If the default is not defined, the type default will be used
```ruby
Person (
	Car (
		model Text
		paint Color _ .(40 40 40) 
	)
	name Text _ "No name"
	surname Text _ "No surname"
	age Natural
	favoriteColor Color _ .(255 0 0)
	favoriteCar Car 
	ownedCar Car
)

somebody Person

# somebody.name is "No name"
# somebody.surname is "No surname"
# somebody.age is 0 (zero, Natural default)
# somebody.favoriteColor is (255 0 0)
# somebody.favoriteCar is ("" (40 40 40))
# somebody.ownedCar is ("" (40 40 40))

.("Fiat 600" .(10 100 20)) > somebody.ownedCar
# somebody.ownedCar is now ("Fiat 600" (10 100 20))

_ > somebody.ownedCar
# somebody.ownedCar is now ("" (40 40 40))


.("Ferrari" .(255 255 255)) > somebody.favoriteCar
# somebody.favoriteCar is now ("Ferrari" (255 255 255))

_ > somebody.favoriteCar.paint
# somebody.favoriteCar is now ("Ferrari" (40 40 40 ))
```

A default value of a specific attribute can be accessed with the struct name @candidate

```ruby
Person.name > defaultPersonName Text              # defaultPersonName will be "No name"
Person.favoriteColor > defaultFavoriteColor Color # defaultFavoriteColor will be (255 0 0)
```



# Control structure

## if

```
# Curly braces around condition are optional
if <condition> do {
	<true body>
}

if <condition> do {
	<true body>
} else {
	<false body>
}
```

Example:

```ruby
1 > x Int
69 > y Int

if x > y do {
	# x is greater than y
} else {
	# y is greater or equal to x
}

if x > y & x > 10 do {
	# x is greater than y AND greater than 10
}
```

Curly braces are used to optionally wrap conditions. The followings will evaluate the same conditions

```ruby
if x < 0 & x > 10 do {}
if {x < 0 & x > 10} do {}
if {x < 0} & {x > 10} do {}
if {{x < 0} & {x > 10}} do {}
```



## Multiple if (switch)

```
if <variable> {
	<condition> do {
		<condition body>
	}

	<condition 2> do {
		<condition 2 body>
	}

} else {
	# no conditions have been met
	<else body>
}
```

Example:

```ruby
69 > x Int

if x {
	# x is equal 1
	= 1 do {
		# body
	}

	# x is equal 2 or equal 3
	= 2 | = 3 do {
		# body
	}

	# x is between 3 and 8 exclusive and not equal to 5
	{> 3 & < 8} & != 5 do {
		# body
	}

	# x is greater or equal to 10
	>= 10 do {
		# body
	}

	# when x is equal to its type default value (zero)
	= _ do {
		# body
	}
} else {
	# no conditions have been met
}

"Simone" > name Text
if name {
	= _ do {}                # name is empty string
	= "Simone" do {}         # name is Simone
	= "Alessio" do {}        # name is Alessio
	= "Paolo" do {}          # name is Paolo
	= "Gian Carlo" do {}     # name is Gian Carlo
}
```


Comparing struct
```ruby
FullName (
	name Text
	surname Text
)

myFullName FullName
adminName FullName

.("Simone" "Vicinanza") > myFullName
myFullName > adminName

if myFullName do {
	# myFullName is default FullName value
	= _ do {}

	# myFullName is ("Max" "Power")
	= .("Max" "Power") do {}

	# myFullName is ("Gian Carlo" "Esposito")
	= .("Gian Carlo" "Esposito") do {}

	# myFullName is ("Simone" "Vicinanza") or ("Alessio" "Vicinanza")
	= .("Simone" "Vicinanza") | = .("Alessio" "Vicinanza") do {}

	# myFullName is adminName or ("Paolo" adminName.surname)
	= adminName
	| = .("Paolo" adminName.surname) do {}

}
```


# Range

You can quickly define a range by specifying a `start`, a `end` and optionally
a `step`<br>
A range can be used in for loops or put in a list, where its values will be
expanded.

## Syntax

```ruby
# <start>..<end>
# <start>..<end>..<step>
[0..5] > fromZeroToFive [Int]         # List of Integer equal to [0 1 2 3 4 5]
[3..5] > fromThreeToFiveReal [Real]   # List of Real equal to [3.0 4.0 5.0]
["a".."d"] > fromAtoZ [Text]          # List of Text equal to [a b c d]
```

Descending ranges can be defined

```ruby
[5..0] > fromZeroToFive [Int]         # List of Integer equal to [5 4 3 2 1]
[5..3] > fromThreeToFiveReal [Real]   # List of Real equal to [5.0 4.0 3.0]
["d".."a"] > fromAtoZ [Text]          # List of Text equal to [d c b a]
```

A step value can also be used

```ruby
[0..10..2] > evenNumbers [Int]        # List of Integer equal to [0 2 4 6 8 10]
[0..1..0.1] > fromZeroToOne [Real]    # List of Real equal to [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
["a".."g"..2] > listOfLetters [Text]  # List of Text equal to [a c e g]
```

Variables can be used

```ruby
0 > start Int
10 > end Int
2 > step Int
[start..end..step] > list [Int]   # List of Integer equal to [0 2 4 6 8 10]
```

# Loops

A loop is block of code that will be repeated (looped)


## Loop control

### break

The break keyword will break the loop

### skip

The skip keyword will skip the current iteration, and continue with the next

## repeat keyword

```ruby
repeat {
	<body> # the body will be repeated for an undefined amount of time
}

repeat if <condition> {
	<body>  # the body will be repeated if the condition is true
}
```

A do-while loop can be achieved like so
```ruby
repeat {
	<body>  # the body will be executed once and repeated if the condition is false
	if <condition> do break
}
```


## for loop

The for loop is used to iterate over lists, maps or ranges

```
# <variable> type will be inferred from the List type
for <variable> in <list|map|range> do {
	<body>
}

# Single statement can be used
for <variable> in <list|map|range> do <statement>
```

```ruby
for number in [1 2 3 4] do {}
for name in ["Simone" "Luca" "Paolo"] do {}
for key value in ["Simone":69 "Luca":420 "Paolo":10] do {}
for i in 0..10 do {}

# Iterating list over indeces
for i in 0..names@{%} do {}
```

Iterating over list of struct

```ruby
[.(0 255 0) .(55 0 255) .(255 255 255)] > colors [Color]
for color in colors do {}
```

The for loop also tries to deconstruct the struct if the variables are the same of the struct

```ruby
[.(0 255 0) .(55 0 255) .(255 255 255)] > colors [Color]
for red green blue in colors do {}
```

# Content redirection

`content` > `destination`

## Standard content

| Destination     | Symbol |
| --------------- | ------ |
| Standard input  | \in    |

## Standard destinations

| Destination     | Symbol |
| --------------- | ------ |
| Standard output | \out   |
| Standard error  | \error |


### Standard output

Print to standard output

```ruby
"Hello world" > \out

"I'm going to print the lorem ipsum" > \out

"{
Qui odit molestias commodi omnis magni sunt. Et et et dolorem mollitia eum repellendus fuga qui. Numquam sint numquam sed delectus. Necessitatibus pariatur voluptatem ad ut eos in eos quo. Cupiditate et ut fuga. Aut enim aut amet non.

Pariatur nam nobis placeat. Consequuntur laborum consequatur accusantium totam occaecati possimus illo repellat. In fuga earum ea modi ut perspiciatis iusto. Iste voluptate qui at. Eos eaque cumque quisquam non nemo tenetur quo fugit.
"} > \out
```


### Standard error

Print to standard error

```ruby
"Some error happened" > \error

"I'm going to print some details:" > \error

"{
This program has crashed
because you tried to perform a
division by zero.
"} > \error
```

### Reverse redirection @candidate

```ruby
x Int < 69
x Point < (1 2 3)
x < (1 2 3)
x Point < (
    1
    2
    3
)
x +< 1
x -< 1
x *< 1
x /< 2
```

### Cascade redirection @candidate
Multiple redirection can be achieved like so

`content` > `destination` > `destination2`

# Functions

Functions are special types of code block

```
<function name>(<param name> <param type> <default value>, <other params>) => <return type> {
	<body>
	=> <return value>
}
```

```ruby
printHelloWorld() {
	"Hello World" > \out
}

greetPerson(name Text, surname Text) {
	"Greetings $name, $surname" > \out
}

getBestLanguage() => Text {
	=> "Giovi"
}

sum(x Int, y Int) => Int {
	=> x + y
}

division(x Real, y Real) => Real {
	=> x / y
}

intToBool(x Int) => Bool {
	if x <= 0 do {
		=> false
	}
	=> true
}

fibonacci(maxCount Natural) => Natural {
	sum Natural
	for i in [0..maxCount] do {
		i >+ sum
	}
	=> sum
}
```

```ruby
printHelloWorld()
greetPerson()
sum(2, 2) > sumResult Int
division(10, 3) > divisionResult Real
```

To return a value, you can alternatively use the return keyword @candidate

```ruby
sum(x Int, y Int) => Int {
	return x + y
}
```

Function parameters can also have default values

```ruby
# if num is not specified when calling the
# function, num will be 10
count(num Natural _ 10) {
	for i in [0..num] {
		i > \out
	}
}

# if name is not specified when calling the function
# its type default value will be used
greet(name Text __ ){
	if name = _ do {
		"Greetings everybody!" > \out
	} else {
		"Hello $name" > \out
	}
}

count()          # Will count to 10
count(69)        # Will count to 69
greet()
greet("Simone")
```

Functions parameters can be explicitly specified, so the order won't matter

```ruby
greet(name Text, age Natural) {
	"My name is $name" > \out
	"My age is $age" > \out
}

greet("Simone", 22)
greet(name:"Simone", age:22)
greet(age:22, name:"Simone")
```

Recursion can be used

```ruby
fibonacci(count Natural) => Natural {
	if {count = 0} | {count = 1} do {
		=> count
	}
	=> fibonacci(count - 1) + fibonacci(count - 2)
}

factorial(n Natural) {
	if n = 0 do {
		=> 1
	}
	=> n * factorial(n-1)
}
```

### Statement functions @candidate

Functions can have a single statement instead of a body; in case the function
returns a value, its return type can be omitted as it will be inferred

```ruby
sum(x Int, y Int) => x + y
isEven(x Int) => x % 2 = 0
greet(name Text) name > \out
```

# Code examples

## Book store

```ruby
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

printShelfStandard(shelf [Book]) {
	for book in shelf do {
		"{
		Title:        ${book.title}
		Description:  ${book.description }
		Price:        ${book.price}
		Page count:   ${book.pageCount}
		Author:       ${book.author}
			Name:       ${book.author.name}
			Surname:    ${book.author.surname}
			Age:        ${book.author.age}
		"} > \out
	}
}

printShelfTableHTML(shelf [Book]) {
	table Text
	"{
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
	"} > table

	for book in shelf do {
		"${toRowHTML(book)}" >+ table
	}

	"{
		</tbody>
	</table>
	"} >+ table

	table > \out
}

toRowHTML(book Book) => Text {
	=> "{
	<tr>
		<td>${book.name}</td>
		<td>${book.description}</td>
		<td>${book.price}</td>
		<td>${book.pageCount}</td>
		<td>${book.author}</td>
	</tr>
	"}
}



.("Simone" "Vicinanza" 22) > author1 Author
.("Mario" "Rossi" 35) > author2 Author

[
	.(
		title: "Giovi for dummies"
		description: "A book describing very easily the Giovi"
		author: author1
		price: 0.0
		pageCount: 69
	)
	.(
		title: "How to make a new Language"
		description: "{
		    A step by step guide on how to build a new language from scratch
		    It even has pictures!!!
		    "}
		author: author2
		price: 6.9
		pageCount: 420
	)
	.(
		title: "How to make a new Language | 2 edition"
		description: "{
		    A step by step guide on how to build a new language from scratch
		    It even has pictures!!!
		    Revisioned edition
		    "}
		author: author2
		price: 4.2
		pageCount: 690
	)
	.(
		title: "Story of a bored programmer"
		description: "Biography of a bored programmer"
		author: .(
		        name:"Luigi"
		        surname: "Bianchi"
		        age: 55
		)
		price: 10.5
		pageCount: 120
	)
] > shelf [Book]

printShelfStandard(shelf)
printShelfTableHTML(shelf)
```

## Find min value in a list

```ruby
findMinElement(list [Text]) => Text {
	if list@{%} < 1 do {
		"list is empty" > \error
		=> ""
	}
	list@0 > min Text
	for element in list do {
		if element < min do {
			element > min
		}
	}
	=> min
}

findMinElementIndex(list [Text]) => Int {
	if list@{%} < 1 do {
		"list is empty" > \out
		=> -1
	}
	0 > min Int
	for index in list@{@} do {
		if list@{index} < list@{min} do {
			index > min
		}
	}
	=> min
}

["z" "s" "a" "h" "j" "h" "w" "f"] > letters [Text]
findMinElement(letters)> minElement Text
findMinElementIndex(letters) > minElementIdx Int

"{
List: $letters
	         min value: $minElement
	min value position: $minElementIdx
"} > \out

#{
# 	output:
# 
# List: ["z" "s" "a" "h" "j" "h" "w" "f"]
# 	         min value: a
# 	min value position: 2
#}
```

# Module system @candidate

```ruby
import some.fully.qualified.module
import [
	some.fully.qualified.module
	someother.fully.qualified.module
]
```

# Launch entry point (args) @candidate

```shell
giovi myFile.giovi -s --long --long_attr=69 -abc
```

```ruby
# main() {}
# main() => Int {}
# main(args Args) {}
main(args Args) => Int {
	args.s > shortFlag Bool
	args.long > longFlag Bool
	args.long_attr > longAttrOption Text
	args.a > aFlag Bool
	args.b > bFlag Bool
	args.c > cFlag Bool
}
```

# Files @candidate

```bash
# /<path>
# ./<path>
# ../<path>

"hello" > ./somefile.txt
"hello" > ./somedir/somefile.txt
"hello" > /somefileInRoot.txt
"hello" > ../somefile.txt
"hello" > ./somedir/$dirname/somefile_$date.txt

"appended" >+ ./somefile.txt

./somefile.txt > fileContent Txt

# or just use structs and funcs
.("somefile.txt") > f File
for line in f.lines() do line > \out
```

# Regex @candidate

```ruby
# /<pattern>/
if "cpu temp: 69C" =~ /^[a-zA-Z]+:\s*([0-9]+).*$/ do {}
# What about groups?
```

```ruby
Regex."^[a-zA-Z]+:\s*([0-9]+).*$" > regex Text.Regex
# What about groups?
```

```ruby
.("^[a-zA-Z]+:\s*([0-9]+).*$") > regex Regex
if regex.matches("cpu temp: 69C") do {
    regex.groups@0 > \out
}
```

```ruby
Regex.replace("my text 69 lol", "^my (.*)", "something $1")
Regex.replace("my text 69 lol", "/^my (.*)/something $1/g")
```
# default keyword @candidate
```ruby
x Int default 69
420 > x
default > x
if x = default do { }
if x = 69 | x = default do { }
if x {
    = 69 do { }
    = default do { }
}

greet(name Text, times Int default 69, present Text default _)  { }
Person (
    name Text default "aw"
    age Int default 69
    car Car (
        color Color default (0 0 0)
        plate Text
    )
)
```

# Struct syntax @candidate
```ruby
Person {
    name Text default "aw"
    age Int default 69
    car Car {
        color Color default {0 0 0}
        plate Text
    }
}

Person.{} > \out
.{} > p Person
.{"simone" 69} > p
.{name: "simone"; age: 69;} > p
.{
    name: "awfwf"
    car: {
        color: {1 2 3}
        plate: "awaw"
    }
} > p

greet(p Person default .{}) => Greetings {
    if true do return .{
        name: p.name
        times: 69
    }
    return .{}
}

greet(.{"simone"})
greet(.{name: "simone"})
greet(Person.{"simone"})
greet(Person.{name: "simone"})

if {p = .{} & p.car = .{engine: .{}}} | p = default do {
    => .{ }
}
```

# Parallel programming @candidate
```ruby
fork(::fetchData) > result Text.Json
fork(::(){doSomethingBlocking()})
join()
```
```ruby
fork ::fetchData > result Text.Json
fork ::{doSomethingBlocking()}
fork ::{
    "yeah" > \out
    doSomethingBlocking();
}
join
```

# Explicit casting @candidate

```ruby
x Int < 69
x as Real > \out
p3d Point3D
p3d as Point > p Point
Point.{} as Point3D > p3d
```

# Advanced number definitions @candidate

```ruby
### Explicit type suffix
0n > natural Natural
0i > int Int
0r > real Real

### Numbers in non-10 base
0b10011010 > int Int # base 2
0o1234567 > int Int # base 8
0xfa84 > int Int # base 16

### Use underscore as spaces
100_000_000 > money Int

### Exponent
1e-8
1e+8
```

# Unicode escapes @candidate

```ruby
"\u4269" > \out
```

# Better text block syntax @candidate

```ruby
""{}"" > \out
""{
hello
}"" > \out

""{it's "cool"}"" > \out

''{
hello 
}'' > \out

##{
hello 
}##
```

# Aliasing @candidate

Alias a type, function or struct

```ruby
AVeryVerboseAndLongStructName ( i Int ) 
alias AVeryVerboseAndLongStructName as SomeStruct
SomeStruct.() > \out

aVeryLonglyNamedFunction() => Text {
    => "hello world"
}

alias aVeryLonglyNamedFunction as f
f() > \out
```
