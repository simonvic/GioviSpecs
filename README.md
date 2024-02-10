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
}#

#{ this is an inline comment block }#
```

## Documentation

```ruby
x Int #? Some number that means something

#? Some other number
y Int

#?{
#	@brief Sum two values
#	@param x
#		@pre x has some precodition
#		@post x has some postcondition
#	@param y
#		@pre y has some precodition
#		@post y has some postcondition
#	@return x + y
#
#	@code
#		sum(1, 2) -> \out
#
#	@see Math
}#
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

## Relational

| Operation        | Symbol | Example |
| ---------------- | ------ | ------- |
| Greater than     | >      | 10 > 2  |
| Less than        | <      | 2 < 10  |
| Greater or equal | >=     | 10 >= 2 |
| Less or equal    | <=     | 2 <= 10 |
| Equal            | =      | 10 = 10 |
| Not equal        | !=     | 10 != 2 |

## Logical operators

| Operation | Symbol | Example         |
| --------- | ------ | --------------- |
| And       | &      | 10 > 2 & 10 > 5 |
| Or        | \|     | 10 > 2 \| 5 > 2 |
| Not       | !      | !{2 > 10}       |

### Logical operators alternatives

| Operation | Symbol | Example           |
| --------- | ------ | ----------------- |
| And       | and    | 10 > 2 and 10 > 5 |
| Or        | or     | 10 > 2 or 5 > 2   |
| Not       | not    | not {2 > 10}      |

## Redirection (assignment)

| Operation           | Symbol | Example                       |
| ------------------- | ------ | ----------------------------- |
| Content redirection | ->     | "Hello world" -> message Text |
| Increment by value  | ->+    | 10 ->+ count                  |
| Decrement by value  | ->-    | 10 ->- count                  |
| Multiply by value   | ->*    | 10 ->* count                  |
| Divide by value     | ->/    | 10 ->/ count                  |

### Inverse redirection

| Operation           | Symbol | Example                       |
| ------------------- | ------ | ----------------------------- |
| Content redirection | <-     | message Text <- "Hello world" |
| Increment by value  | +<-    | count +<- 10                   |
| Decrement by value  | -<-    | count -<- 10                   |
| Multiply by value   | *<-    | count *<- 10                   |
| Divide by value     | /<-    | count /<- 10                   |

## Containment operator

| Operation     | Symbol | Example                    |
| ------------- | ------ | -------------------------- |
| Contains      | =~     | "Hello world" =~ "lo worl" |
| Is contained  | ~=     | "lo worl" ~= "Hello world" |

The containment operator is used to check if a value is contained in another.

To avoid confusion about the direction of the containment operator, remember
about its "hamburger notation":<br>
the hamburger (=) contains the lettuce (\~) `hamburger =~ lettuce`<br>
the lettuce (\~) is contained in the hamburger (=) `lettuce ~= hamburger`

### Range containment @candidate

```ruby
69 ~= 0..420
-5..5 =~ 0
6.9 ~= 6.0 .. 8.0

"b" ~= "a".."d"
```

## Access operator

The access operator `@` is used to access special properties of variable/type.<br>
The "key" used for access can be a special symbol, a literal (e.g. `Int`) or a variable

```
<accessed>@<key>
```

A key can also be an expression, but it must be enclosed in braces

```
<accessed>@{<key>}
```

The output of the access depends on the "key" and to what type you're accessing.<br>
> See:
> - [Text access](#text-access)
> - [List access](#list-access)
> - [Map access](#map-access)
> - [Struct access](#struct-access)

### Accessing default value @candidate

```ruby
420 -> x Int default 69
x -> \out # 420
x@value -> \out # 420
x@default -> \out # 69

if x@default != Int@default do {
	"x default value has been overridden!" -> \out
}
```

# Redirection

Giovi "moves" data (content) to destinations; this is done through
redirection.<br>
It can be done left to right...

```
<content>   ->   <destination>
```

```ruby
69 -> index
22 -> age
1.70 -> height
"Simone" -> name
true -> isAuthor
```

...or right to left

```
<destination>   <-   <content>
```

```ruby
index <- 69
age <- 22
height <- 1.79
name <- "Simone"
isAuthor <- true
```

There is no difference between the two directions, except for readability.
Sometimes it's just better to use one instead of the other

```ruby
"hello world" -> \out     # Printing
counter +<- 1             # Increasing counter by one
acceleration ->+ velocity # Increasing velocity by "acceleration"
```

## Standard destinations

| Destination     | Symbol |
| --------------- | ------ |
| Standard output | \out   |
| Standard error  | \error |

### Standard output

Print to standard output

```ruby
"Hello world" -> \out

"I'm going to print the lorem ipsum" -> \out

"{
Qui odit molestias commodi omnis magni sunt. Et et et dolorem mollitia eum
repellendus fuga qui. Numquam sint numquam sed delectus. Necessitatibus
pariatur voluptatem ad ut eos in eos quo. Cupiditate et ut fuga. Aut enim aut
amet non.

Pariatur nam nobis placeat. Consequuntur laborum consequatur accusantium totam
occaecati possimus illo repellat. In fuga earum ea modi ut perspiciatis iusto.
Iste voluptate qui at. Eos eaque cumque quisquam non nemo tenetur quo fugit.
}" -> \out
```

The redirect operator (`->`) will automatically append a new line; if you don't
want that, you can use the "append redirector" operator (`->+`)

```ruby
"Hello world" ->+ \out
```

### Standard error

Print to standard error

```ruby
"Some error happened" -> \error

"I'm going to print some details:" -> \error

"{
This program has crashed
because you tried to perform a
division by zero.
}" -> \error
```

## Standard content

| Destination     | Symbol |
| --------------- | ------ |
| Standard input  | \in    |

Reading from standard content is a blocking operation that will read from stdin.<br>
Can be used to read input from the user

```ruby
"Insert your username: " ->+ \out
\in -> username Text
"Hello $username" -> \out
```

# Variables

A variable is identified by a unique name, and it is of a specific type

## Variable naming rules

The general rules for naming variables are:
  - Names must be unique
  - Names must begin with a lower case letter
  - Names can contain letters, digits and underscores
  - Names cannot contain whitespace
  - Names are case-sensitive ("myVar" and "myvar" are different variables)
  - Type (primitive and struct) names cannot be used
  - Reserved words cannot be used
    - if
    - do
    - else
    - for
    - in
    - repeat
    - break
    - skip
    - constant
    - null
    - return
    - import
    - default
    - alias
    - as
    - is
    - self

<!-- TODO: mention variables lifetime and scopes -->

# Data types

## Primitive Types

| Type name | Possible values                  | Default value |
| --------- | -------------------------------- | ------------- |
| Natural   | 0 .. +2,147,483,647              | 0             |
| Int       | -2,147,483,648 .. +2,147,483,647 | 0             |
| Real      | up to 16 decimal digits          | 0.0           |
| Bool      | false / true                     | false         |
| Text      |                                  | (empty text)  |

### Declaration

```
<identifier> <Type>
```

```ruby
index Int
age Natural
height Real
name Text
```

### Numbers

Numbers type (i.e. Natural, Int, Real) can be defined in more advanced ways.<br>
You can add a type suffix

```ruby
0n # Natural
0i # Int
0r # Real
```

You can specify in which base they're represented

```ruby
0b01000101 # Base 2 (binary)
0o105      # Base 8 (octal)
0x10F2C    # Base 16 (hexadecimal)
```

You can use underscores to separate digits groups for readability

```ruby
1_000_000_000 # a billion
0b1000_0110_0010_1100
```

You can use the exponent notation

```ruby
1e+8 # 1 * 10^8
1e-8 # 1 * 10^-8
```

### Text type

#### Operators

| Operation                      | Symbol | Example                    | Output                     |
| ------------------------------ | ------ | -------------------------- | -------------------------- |
| Concatenation                  | +      | "hello" + " " + "world"    | "hello world"              |
| Intersection                   | -      | "hello world" - "o"        | "hell wrld"                |
| Split                          | /      | "hello:world" / ":"        | ["hello" "world"]          |
| Repeat                         | *      | "o" * 4                    | "oooo"                     |
| Append to variable             | ->+    | "hello world" ->+ someText | "$someText hello world"    |
| Remove substring from variable | ->-    | "substring" ->- someText   | someText without substring |
| Text contains                  | =~     | "hello world" =~ "lo worl" | true                       |
| Text is contained              | ~=     | "lo worl" ~= "hello world" | true                       |

#### Text Access

| key   | output                     |
|-------|----------------------------|
| Int   | char at that index         |
| Range | substring                  |
| %     | length                     |
| *     | List of chars (Text)       |
| @     | Range from 0 to length - 1 |

```ruby
"hello world" -> text Text
text@0         # "h"
text@1         # "e"

# Negative indexes can be used to access last characters
text@{-1}   # "d" last character
text@{-2}   # "l" second-last character
text@{-3}   # "r" third-last character
text@{-11}  # "h" 11 from last character

# A range can be used to access substring (indexes are inclusive)
text@1..6               # "ello w" from 1 to 6
text@0..10..2           # "hlowrd" from 0 to 10 every 2
text@10..0              # "dlrow olleh" from 10 to 0
text@{text@% - 1 .. 0}  # "dlrow olleh" from text length - 1  to 0

text@%         # 11 (length)
text@@         # 0..10 (range)
text@*         # [ "h" "e" "l" "l" "o" " " "w" "o" "r" "l" "d" ]
```

### Text block

Text blocks can span over multiple lines, without having to worry about
escaping quotes or other characters.<br>

```
"{
<text>
}"
```

```ruby
loremIpsum Text <- "{
	Aut quod excepturi officia tempore.
	  Quia non molestiae non aut.
		Sit quos saepe exercitationem dolor voluptatem.
	  Et culpa voluptatem quos eligendi.
	}"
```

White spaces (spaces, newlines, tabs) will be kept, unless they're "incidental".
Incidental white spaces are those needed for code indentation. <br>
The amount of "incidental" whitespaces is defined by the line that has less of
them.<br>
Only one type of white space can be used; in case of mixed types, it will be
used the type of the first incidental whitespace of the first line (excluding
the line with the opening text block tag).<br>
So be consistent with formatting to avoid ambiguities and undesired side
effects.

```ruby
aFunction() {
    if true do {
        html Text <- "{
            <html>
                <head></head>
                <body>
                    <p>Hello world</p>
                <body>
            </html>
            }"
#^^^^^^^^^^^
# these are "incidental" whitespaces
# and won't be counted
    }
}
```

Even though it's possible to open and close a text block on the same line, it's
recommended to immediately go on a new line after the opening text block tag,
followed by a 1-level deep indent; this is to avoid any possible ambiguities.

```ruby
t Text <- "{these are some fancy quotes: """"""}"
t Text <- "{
	but this is preferred
	}"
```

A new line will be automatically be appended at the last line. If you don't
want that, put the closing tag on the previous line

```ruby
t Text <- "{
	hello world}"
```

#### Text interpolation

Double quotes will interpolate variables (dollar sign will need escaping)<br>
Single quotes will not.

```
$<identifier>
${<expression>}
```

```ruby
name Text <- "Simone"
surname Text <- "Vicinanza"

fullName Text
fullName <- "$name $surname"   # Simone Vicinanza
fullName <- '$name $surname'   # $name $surname
fullName <- "$name \$surname"  # Simone $surname
```

If you need to have something immediately after the variable, without a space,
you can wrap the variable name in curly braces

```ruby
name Text <- "Mario"
surname Text <- "Rossi"
fullName Text <- "${name}_${surname}"

# Writing this would have been an error
fullName Text <- "$name_$surname"
          # ERROR ^^^^^ the name_ variable doesn't exists
          # (the underscore is a valid character for a variable name)
```

Text can also interpolate expressions

```ruby
x Int <- 59
y Int <- 10
"Sum is ${x + y}" -> \out
# Sum is 69

getName() => Text { => "simonvic" }

helloWorld Text <- "{
	Hello world
	I am ${getName()}
	}"
# Hello world
# I am simonvic
```

If you don't want variables/code to be interpolated, use single quotes (`'`)

```ruby
'{
Hello,
I have 69 $USD in my wallet
}'
```

#### Unicode escapes

Text can also contain Unicode escapes, which will be interpolated with the
character at the specified codepoint.

```ruby
"\u0068\u0065\u006c\u006c\u006f\u0020\u0077\u006f\u0072\u006c\u0064" -> \out
# hello world
```

#### Text types @candidate

```ruby
Raw."hello how are you?"
Sql."{
	SELECT * 
	FROM table
		FILTER BY name
	}"
Sql."SELECT * FROM table"

Json."{{"field": "value"}}"
Json."{
	{
		"field": "value",
		"field2": "value2"
	}
	}"

Xml."<test attr='true'>yeah</test>"
Xml."{
	<test attr="true">
		yeah
	</test>
	}"

fetchData(query Text.Sql) => Text.Json {}
```

##### Custom text type processors @candidate

```ruby
Text : Yaml (
	format() => Text {}
	isValid() => Bool {}
)
Yaml."{
	something:
	  - awfawf
	  - awfaw
	}"
```

## Composite types

### List

A list is a collection of variables that can be accessed via the index.<br>
The indexes are 0-based

#### Operators

| Operation  | Symbol  | Example         |
| ---------- | ------- | --------------- |
| Assignment | ->      | [1 2 3] -> list |
| Insert     | ->+     | 4 ->+ list      |
| Remove     | ->-     | 4 ->- list      |

##### @Candidate

| Operation     | Symbol  | Example         | Output    |
| ------------- | ------- | --------------- | --------- |
| Concatenate   | +       | [1 2 3] + [4]   | [1 2 3 4] |
| Intersection  | -       | [1 2 3] - [3 4] | [1 2]     |

##### Relational

| Operation    | Symbol | Example           |
| ------------ | ------ | ----------------- |
| Equal        | =      | [1 2 3] = [1 2 3] |
| Contains     | =~     | list =~ 2         |
| Is contained | ~=     | 2 ~= list         |

#### Syntax

```
<identifier> [<ElementType>]
```

```ruby
listOfNames [Text]

# Assignment
["Simone" "Giada"] -> listOfNames

# Insertion
"Francesca" ->+ listOfNames
"Alessio" ->+ listOfNames
"Giovanna" ->+ listOfNames
```

List entries can be optionally separated by a comma (trailing comma is allowed)

```ruby
[1, 2, 3, 4,]
```

##### List type inference @candidate

```ruby
# List type can be omitted when declaring and initializing
# It will be inferred from the first element inserted
listOfInteger [] <- [-1 0 4 5]     # [Int]
listOfReal [] <- [1.0 0.5 2.5]     # [Real]
listOfText [] <- ["Luca" "Paolo"]  # [Text]
listOfBool [] <- [true false true] # [Bool]

# When creating list of Struct, the type must be declared
listOfColors [Color] <- [ <62 65 10> <0 64 0> <12 50 255> ]
listOfFullNames [FullName] <- [
		<"Simone" "Vicinanza">
		<"Mario" "Rossi">
		<"Luigi" "Bianchi">
	]
```

#### List Initialization shorthand

It is possible to initialize a list with a defined amount of values.<br>
The amount has to be a Natural number or an expression evaluating to it.

```
<identifier> [ <Type> ** <number> ]
<identifier> [ <Type> ** <expression> ]
```

```ruby
x [Int ** 5] # [0 0 0 0 0]

size Int <- 3
y [Bool ** size] # [false false false]
```

#### List Access

| key   | output                     |
|-------|----------------------------|
| Int   | element at that index      |
| Range | "slice" of list            |
| %     | elements count             |
| @     | Range from 0 to length - 1 |

```ruby
letters [Text] <- ["a" "b" "c" "d" "e" "f" "g" "h" "i" "j"]

letters@0  # "a"

# Negative indexes can be used to access last elements
letters@{-1}   # "d" last character
letters@{-2}   # "l" second-last character
letters@{-3}   # "r" third-last character
letters@{-11}  # "h" 11 from last character

# A range can be used to access a slice (indexes are inclusive)
letters@2..5                # ["c" "d" "e" "f"]
letters@0..10..2            # ["a" "c" "e" "g" "i"]
letters@10..0               # ["j" "i" "h" "g" "f" "e" "d" "e" "c" "b" "a"] aka the drunk test :)
letters@{letters@% - 1..0}  # ["j" "i" "h" "g" "f" "e" "d" "e" "c" "b" "a"] aka the drunk test :)

letters@%  # 10 (elements count)
letters@@  # 0..9 (range) useful when you need to iterate a list with indexes
```

Comparing Lists

```ruby
numbers [Int] <- [ 1 2 3 4 ]

if numbers = default do {
	# if list is equal to List default (empty list)
}

if numbers {
	# if equal to a list of [1 2 3]
	= [1 2 3] do {}
	
	# if equal to a list of [1 2 3 4] or [4 5 6 7]
	= [1 2 3 4]
	| = [4 5 6 7] do {}
	
	# if equal to a list of [1 2 3 4] or elements count equal to 10
	= [1 2 3 4] | numbers@% = 10 do {}
	
	# if empty list or elements count less then 3
	= default | numbers@% < 3 do {}
	
	# if empty list and first element equal to 6
	= default & numbers@0 = 6 do {}

	# if contains 69
	=~ 69 do {}
	
}
```

##### Multidimensional list (matrix)

A multidimensional list (matrix) can be defined as follows

```ruby
# A list of list of real
identityMatrix [[Real]] <- [
		[1 0 0]
		[0 1 0]
		[0 0 1]
	]
```

Values can be accessed as normal lists

`nameOfList@row@column`

```ruby
# Example of a Rubik cube multidimensional list
# for simplicity, we're storing color name instead of a Color struct
rubikCube [[[Text]]] <- [
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
	]

rubikCube@2@1@1   # will refer to the central tile of green face
```

#### Multidimensional lists access @candidate

```ruby
cube [[[Int]]]
cube@1@2@3 -> \out
cube@{1, 2, 3} -> \out
```

### Set @candidate

A set is an unordered collection in which duplicates element are not allowed

### Map

A map contains values on the basis of key, i.e. key and value pair.<br>
Each key and value pair is known as an entry.<br>
Map keys are unique.

#### Operators

| Operation  | Symbol  | Example                     |
| ---------- | ------- | --------------------------- |
| Assignment | ->      | ["a":1 "b":2 "c":3] -> map  |
| Put        | ->+     | ["d":4] ->+ map             |
| Remove     | ->-     | "d" ->- map                 |
| Remove all | ->-     | ["a" "b"] ->- map           |
| Remove all | ->-     | ["a":1 "b":2] ->- map       |

@candidate

| Operation     | Symbol  | Example                       | Output              |
| ------------- | ------- | ----------------------------- | ------------------- |
| Concatenate   | +       | ["a":1 "b":2] + ["c":3]       | ["a":1 "b":2 "c":3] |
| Intersection  | -       | ["a":1 "b":2 "c":3] - ["c":3] | ["a":1 "b":2]       |
|               |         | ["a":1 "b":2 "c":3] - "c"     | ["a":1 "b":2]       |

##### Relational

| Operation    | Symbol | Example                       |
| ------------ | ------ | ----------------------------- |
| Equal        | =      | ["a":1 "b":2] = ["a":1 "b":2] |
| Contains key | =~     | ["a":1 "b":2] =~ "a"          |
| Is contained | ~=     | "a" ~= map                    |

@candidate

| Operation       | Symbol | Example                              |
| --------------- | ------ | ------------------------------------ |
| Contains subset | =~     | ["a":1 "b":2 "c":3] =~ ["b":2 "c":3] |


#### Syntax

```
<identifier> [<KeyType> : <ElementType>]
```

```ruby
carCount [Text : Int]
[ "Audi" : 1 ] ->+ carCount  # Insert new key "Audi" with value 1
[ "Audi" : 5 ] ->+ carCount  # Set "Audi" key value to 5

carCount +<- [               # Insert/Set new key value pair
		"Mercedes" : 10
		"Audi" : 7
		"BMW" : 15
		"Ferrari" : 20
	]

carCount@{"Ferrari"} <- 26   # Set "Ferrari" value to 26
```

Default values can be used

```ruby
[ "Fiat" : default ] ->+ carCount
default -> carCount@{"Fiat"}
```

Map entries can be optionally separated by a comma (trailing comma is allowed)

```ruby
[
	"Mercedes" : 10,
	"Audi" : 7,
	"BMW" : 15,
	"Ferrari" : 20,
]
```

#### Map Access

| key           | output                     |
|---------------|----------------------------|
| map key value | element mapped to that key |
| %             | entries count              |
| @             | List of map keys           |
| *             | List of map elements       |

```ruby
carCount [Text : Int] <- [
		"Mercedes" : 10
		"Audi" : 7
		"BMW" : 15
		"Ferrari" : 20
	]

carCount@"Audi"  # 7
carCount@%       # 4
carCount@@       # ["Mercedes" "Audi" "BMW" "Ferrari"]
carCount@*       # [10 7 15 20]
```

Examples

```ruby
bank [Text : Real] <- [
		"Simone" : 69.0
		"Alessio" : 15.50
		"Francesco" : 125.15
	]

for name money in bank do {
	"$name has $money € in his wallet" -> \out
}

"List of names: " -> \out
for name in bank@{@} do {
	"- $name" -> \out
}

sum Real
for money in bank@{*} do {
	money ->+ sum
}
"The bank has a total of $sum €" -> \out
```

### Struct

<!-- TODO: Tuple and Struct(typed tuple) -->

A Struct is a structured data type that you can define; it can contain
heterogeneous types (primitive or composite)

#### Syntax

```
<name> <   <fields>   >
```

The name must start with an Uppercase letter and can contain letters, digits
and underscores.<br>
Primitive types cannot be used as name.

```ruby
Color <
	red Natural
	green Natural
	blue Natural
>

Car <
	model Text
	paint Color
>

Person <
	name Text
	surname Text
	age Natural
	favoriteColor Color
	favoriteCar Car
	ownedCar Car
>
```

##### Creation

```ruby
red Color <- Color.<255 0 0>
me Person <- Person.<
		"Simon"
		"Vic"
		22
		red
		Car.<"Ferrari" red>
		Car.<"Fiat600" Color.<0 0 255>>
	>
```

When creating a struct, you can name the fields to improve readability.
By doing so, the order of the fields won't matter

```ruby
me Person <- Person.<
		age: 22
		surname: "Vic"
		name: "Simon"
		favoriteColor: Color.<
			red: 255
			green: 69
			blue: 42
		>
		favoriteCar: Car.<
			model: "Ferrari"
			paint: red
		>
	>
```

You can also specify a subset of the fields; unspecified fields will be
initialized with their default value.
Note that this is not possible when the field names are not specified.

```ruby
me Person <- Person.<
		age: 23
		favoriteCar: Car.<
			model: "Ferrari"
		>
	>
```

Creating a struct with a type but no fields, will create a default struct of
that type

```ruby
Color.<> -> \out
```

When defining or creating a struct, the fields can optionally be separated by
a comma

```ruby
Color <r Int, g Int, b Int>
Color.<1, 2, 3> -> c Color
```

###### Anonymous structs (tuples)

When creating a struct the type can be omitted, hence creating an anonymous
struct (aka tuple)

Tuples can be named (fields are indexed by names) or unnamed (fields are
indexed by a 0-based index)

```ruby
# Tuple with three named fields
<
	field1: "a"
	field2: true
	field3: 420.69
>

# Tuple with three unnamed fields
<"a" true 420.69>
```

Tuples can be assigned to structs, as long as they're compatible.<br>
Named tuples are compatible to all structs of which the fields are a superset
of the tuple; in this case only the fields in the subset will change in the
assigned struct

```ruby
me Person <- <
		name: "Simon"
		age: 23
		favoriteCar: <
			model: "Ferrari"
		>
	>
```

When assigning with an unnamed tuple, all fields must be specified for the
tuple to be compatible

```ruby
color Color
color <- <255 255 255>
color <- <255>  # ERROR Incompatible structs
color <- <red: 255>  # Ok!
```

This allows for a less verbose variable declaration

```ruby
# From most verbose to less verbose
c Color <- Color.<
		red: 255
		blue: 255
		green: 255
	>

c Color <- <
	red: 255
	blue: 255
	green: 255
>

c Color <- <255 255 255>
```

#### Struct Access

| key   | output                                       |
|-------|----------------------------------------------|
| Int   | field value at the index                     |
| Range | Subset tuple with fields within the range    |
| %     | fields count                                 |
| @     | Range 0 to fields count - 1                  |
| *     | list of field names                          |

```ruby
Color <
	red Natural
	green Natural
	blue Natural
>

color Color <- <255 100 50>

color@0  # 255

# Negative indexes can be used to access last elements
color@{-1}   # 50 last character
color@{-2}   # 100 second-last character
color@{-3}   # 255 third-last character

color@0..2  # Tuple <red: 255, green: 100>

color@%  # 3 (fields count)

color@*  # ["red" "green" "blue"] (list of field names)

color@@  # 0..3 (range)
```

You can access fields by their name with the dot notation

```ruby
Color <
	red Natural
	green Natural
	blue Natural
>
color Color <- <255 100 50>

color.red -> \out
color.blue <- 255  # setting blue channel to 255
```

##### Nested struct @candidate

You can define struct within struct.

```ruby
Car <
	Engine <
		horsePower Real
		isElectric Bool
	>
	model Text
	primaryEngine Engine
	secondaryEngine Engine
>
Person <
	name Text
	favoriteCar Car
>
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
Person <
	name Text
	age Natural
	# someColor Color
	#           ^^^^^ ERROR Color not defined
	favoriteColor Color <
		red Natural
		green Natural
		blue Natural
	>
>
```

##### Recursive struct @candidate

You can define recursive struct (struct defined with itself)

```ruby
Node <
	data Text
	nextNode Node default null
>
```

##### Struct functions @candidate

```ruby
Vehicle <
	speedKmH Int
	
	accelerate(amount Int) {
		amount ->+ speed
	}
	
	brake() {
		speed -<- 1
	}

	speedToMilesPerHour() => Int {
		=> speed / 1.6093
	}
>

car.accelerate(10)
"${car.speedKmH} KMH" -> \out
"${car.speedToMilesPerHour()} MPH" -> \out
```

###### Static struct functions @candidate

```ruby
Car <
	speed Real

	# non-static
	self accelerate() {
		self.speed +<- 2
	}

	# static
	accelerate(car Car) {
		car.speed +<- 2
	}
>

c Car
c.accelerate()
Car.accelerate(c)
```

###### Self return @candidate

A struct function can also return the struct itself, without having to
explicitly return.<br>
This comes very handy when you want to make "chainable" functions.

```ruby
Color <
	r Natural
	g Natural
	b Natural

	rgb(r Natural, g Natural, b Natural) => self {
		self.r = r
		self.g = g
		self.b = b
	}

	brigthen() => self {
		self.r *<- 0.5
		self.g *<- 0.5
		self.b *<- 0.5
	}

	saturate() => self {
		# however you do it
	}
>

c Color <- <5 20 512>

c.rgb(5, 20, 512)
	.brigthen()
	.saturate()
	.brighten()
```

#### Structs inheritance

A struct can inherit the fields from another struct.
It can define new fields and override the default value of an inherited field.

```ruby
Vehicle <
	paint Color
	wheelCount Natural
>

Vehicle : Car <
	wheelCount Natural default 4
	licensePlate Text
>

Vehicle : Bike <
	wheelCount Natural default 2
	tireType Text
>

Bike : MotorBike <
	isOffroad Bool
>
```

##### Nested structs definition inheritance @candidate

Nested definition are "static" and are not inherited.

```ruby
Vehicle <
	engine Engine <
		horsePower Real
	>
	wheelsCount Int
>
Vehicle : Car <
	wheelsCount Int default 4
	plate Text default "xxx"
	# secondaryEngine Engine
	#                 ^^^^^^ ERROR Engine not defined
>
```

But you can use the dot notation...

```ruby
Vehicle <
	engine Engine <
		horsePower Real
	>
	wheelsCount Int
>
Vehicle : Car <
	wheelsCount Int default 4
	plate Text default "xxx"
	secondaryEngine Vehicle.Engine
>
```

... or you can also specialize the nested struct

```ruby
Vehicle <
	engine Engine <
		horsePower Real
	>
	wheelsCount Int
>
Vehicle : Car <
	wheelsCount Int default 4
	plate Text default "xxx"
	Vehicle.Engine : Engine <
		fuelType Text
	>
	secondaryEngine Engine
	#               ^^^^^^ Car.Engine, which inherits from Vehicle.Engine
>
```

### Enums @candidate

They can be simple enums...

```ruby
enum PizzaStatus <
	ORDERED <>
	READY <>
	DELIVERED <>
>
```

... or have values

```ruby
enum Color <
	RGB <r Natural, g Natural, b Natural>
	RGBA <r Natural, g Natural, b Natural, a Natural>
	ARGB <a Natural, r Natural, g Natural, b Natural>
	HSL <hue Real, saturation Real, lightness Real>
	HEX <hex Text>
>
```

... or both, which can be quite handy along the if statement

```ruby
enum Result <
	OK <>
	ERROR <reason Text>
>

enterClub(age Int) => Result {
	if age < 18 do
		=> Result.ERROR.<"user is underage">
	=> Result.OK.<>
}

if enterClub(69) {
	= Result.OK.<> do "Welcome" -> \out
	= Result.ERROR.<reason:_> do "Can't enter because $reason" -> \out
}
```

You can omit struct types, but beware of the matching order

```ruby
if enterClub(69) {
	= <reason: "underage"> do "Too young, boy!" -> \out
	= <reason: _> do "Can't enter because $reason" -> \out
	= <> do "Welcome" -> \out
}

```

# Explicit casting

It's possible to explicitly casting a variable to another type (if supported).

## Syntax

```
<variable> as <Type>
```

```ruby
69 -> i Int
i as Real -> \out

"420.69" -> t Text
t as Real -> \out

p3d Point3D
p3d as Point -> p Point

Point.<> as Point3D -> p3d

```

# Type checking

It's possible to check the type of a variable

## Syntax

```
<variable> is <Type>
```

```ruby
if someVariable is Int do {
	"someVariable is an integer with value ${someVariable}" -> \out
}
if someVariable {
	is Int do "It's integer" -> \out
	is Real do "It's real" -> \out
	is [Int] do "It's a list of integer" -> \out
}
```

### Check type and cast @candidate

When checking variable type, it's often needed to cast it

```ruby
if color {
	is RGB do {
		color as RGB -> c RGB
		"${c.r} ${c.g} ${c.b}" -> \out
	}
	is ARGB do {
		color as ARGB -> c ARGB
		"${c.r} ${c.g} ${c.b} ${c.a}" -> \out
	}
}
```

It's possible to use variable declaration syntax to improve readability

```ruby
if color {
	is c RGB do "${c.r} ${c.g} ${c.b}" -> \out
	is c RGBA do "${c.r} ${c.g} ${c.b} ${c.a}" -> \out
}
```

The lifetime of the variable is limited to the true branch scope

```ruby
color RGB
if color is c RGB {
	c.r -> \out
} else {
	# variable c not defined here
}

if ! color is c RGB {
	# variable c not defined here
} else {
	c.r -> \out
}
```

# Constants

Constants are read-only; its value is defined at declaration and cannot change.

## Syntax

```
constant <CONSTANT_NAME> <Type> <value>
<CONSTANT_NAME> <Type> <value>
```

Constants name must be all UPPERCASE, must start with a letter and can contain
digits and underscores.

```ruby
constant LIGHT_SPEED Natural 299792458n
constant EARTH_GRAVITY Real 9.81
constant BEST_LANGUAGE Text "Giovi"
constant RED Color <255 0 0>
constant NAME_LIST [Text] ["Simone" "Alessio" "Giada" "Francesca"]
```

### Type inference @candidate

```ruby
constant LIGHT_SPEED 299792458n
constant EARTH_GRAVITY 9.81
constant BEST_LANGUAGE "Giovi"
constant RED Color.<255 0 0>
constant NAME_LIST ["Simone" "Alessio" "Giada" "Francesca"]
```

# Default value

The default keyword can be used in redirections and other statements

```ruby
number Natural <- 69  
anotherNumber Integer <- -420  
someOtherNumber Real <- 69.69  
someText Text <- "This is a text"  
someBoolean Bool <- true  

default -> number            # This will set number to 0
default -> anotherNumber     # This will set anotherNumber to 0
default -> someOtherNumber   # This will set someOtherNumber to 0.0
default -> someText          # This will set someText to empty string
default -> someBoolean       # This will set someBoolean to false
```

It is also possible to overwrite a variable default value

```ruby
number Natural default 420
someOtherNumber Real default 4.20
someText Text default "default text"
someBoolean Bool default true

69 -> number
6.9 -> someOtherNumber
"hello" -> someText
false -> someBoolean

default -> number            # This will set number to 420
default -> someOtherNumber   # This will set someOtherNumber to 4.20
default -> someText          # This will set someText to "default text"
default -> someBoolean       # This will set someBoolean to true
```

## Struct default value

Struct default value is a struct with all its fields set to their respective
default value

```ruby
someColor Color
someColor <- <255 255 0>
default -> someColor  # This will set someColor to (0 0 0)
```

```ruby
# Color with overridden defaults
Color <
	red Natural default 255
	green Natural default 255
	blue Natural default 255
>

someColor Color < <0 255 0>  
_ -> someColor  # Set someColor to default (255 255 255)
```

If the default is not defined, the type default will be used

```ruby
Person <
	Car <
		model Text
		paint Color default <40 40 40> 
	>
	name Text default "No name"
	surname Text default "No surname"
	age Natural
	favoriteColor Color default <255 0 0>
	favoriteCar Car 
	ownedCar Car
>

somebody Person

# somebody.name is "No name"
# somebody.surname is "No surname"
# somebody.age is 0 <zero, Natural default>
# somebody.favoriteColor is <255 0 0>
# somebody.favoriteCar is <"" <40 40 40>>
# somebody.ownedCar is <"" <40 40 40>>

somebody.ownedCar <- <"Fiat 600" <10 100 20>>  
# somebody.ownedCar is now <"Fiat 600" <10 100 20>>

default -> somebody.ownedCar
# somebody.ownedCar is now <"" <40 40 40>>


somebody.favoriteCar <- <"Ferrari" <255 255 255>>  
# somebody.favoriteCar is now <"Ferrari" <255 255 255>>

default -> somebody.favoriteCar.paint
# somebody.favoriteCar is now <"Ferrari" <40 40 40 >>
```

A default value of a specific attribute can be accessed with the struct name @candidate

```ruby
Person.name -> defaultPersonName Text # "No name"
Person.favoriteColor -> defaultFavoriteColor Color # <255 0 0>
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
x Int <- 1  
y Int <- 69  

if x > y do {
	# x is greater than y
} else {
	# y is greater or equal to x
}

if x > y & x > 10 do {
	# x is greater than y AND greater than 10
}
```

Curly braces are used to optionally wrap conditions. The followings will evaluate the same conditions...

```ruby
if x < 0 & x > 10 do {}
if {x < 0 & x > 10} do {}
if {x < 0} & {x > 10} do {}
if {{x < 0} & {x > 10}} do {}
```

... but these will be different

```ruby
if true & true | false do {}
if true & {true | false} do {}
```

## Multiple if (match)

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
x Int <- 69  

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
	= default do {
		# body
	}
} else {
	# no conditions have been met
}

name Text <- "Simone"  
if name {
	= default do {}      # empty string
	= "Simone" do {}
	= "Alessio" do {}
	= "Paolo" do {}
	= "Gian Carlo" do {}
}
```

Comparing struct

```ruby
ColorRGB <r Natural, g Natural, b Natural>
ColorARGB <a Natural, r Natural, g Natural, b Natural>

color ColorRGB <- <42 0 69>
white ColorRGB <- <255 255 255>
red ColorRGB <- <255 0 0>
transparent ColorARGB <- <0 0 0 0>

if color {
	= default do "it's black" -> \out
	= red do "it's red" > \out
	= <240 10 10> do "it's redish" -> \out
	= <255 default 69> do "255, default green, 69" -> \out
	= white | = <200 200 200> do "it's white or grey" -> \out
	= <_ _ 69> do "any red, any green, blue of 69" -> \out
	= <_ _ _ _> do "It has at least 4 fields" -> \out
}
```

It's also possible to deconstruct the struct by using named struct, so you can
access the fields

```ruby
if color {
	= <r:255 g:69 b:42> do "Something with $r $g and $b" -> \out
	= <r:_ g:_ b:_> do "Something with $r $g and $b" -> \out
	= <r:_ b:_> do "I only need $r and $b" -> \out
}
```

# Range

You can quickly define a range by specifying a `start`, a `end` and optionally
a `step`<br>
A range can be used in for loops or put in a list, where its values will be
expanded.

## Syntax

```
<start> .. <end>
<start> .. <end> .. <step>
```

```ruby
[0..5] -> fromZeroToFive [Int]         # [0 1 2 3 4 5]
[3..5] -> fromThreeToFiveReal [Real]   # [3.0 4.0 5.0]
["a".."d"] -> fromAtoZ [Text]          # [a b c d]
```

Descending ranges can be defined

```ruby
[5..0] -> fromZeroToFive [Int]         # [5 4 3 2 1]
[5..3] -> fromThreeToFiveReal [Real]   # [5.0 4.0 3.0]
["d".."a"] -> fromAtoZ [Text]          # [d c b a]
```

A step value can also be used

```ruby
[0..10..2] -> evenNumbers [Int]        # [0 2 4 6 8 10]
[0..1..0.1] -> fromZeroToOne [Real]    # [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
["a".."g"..2] -> listOfLetters [Text]  # [a c e g]
```

Variables can be used

```ruby
start Int <- 0
end Int <- 10
step Int <- 2
list [Int] <- [start..end..step]  # [0 2 4 6 8 10]
```

# Loops

A loop is block of code that will be repeated (looped)

## Loop control

### break

The break keyword will break the loop

### skip

The skip keyword will skip the current iteration, and continue with the next

## repeat keyword

```
repeat {
	<body> # the body will be repeated for an undefined amount of time
}

repeat if <condition> {
	<body>  # the body will be repeated if the condition is true
}
```

A do-while loop can be achieved like so

```
repeat {
	<body>  # body will be executed once and repeated if the condition is false
	if <condition> do break
}
```

## for loop

The for loop is used to iterate over lists, maps or ranges

```
for <iterator> in <list|map|range> do <statement>
for <iterator> in <list|map|range> do {
	<statements>
}
```

```ruby
for i in 0..10 do {}
for number in [1 2 3 4] do {}
for rgb in [<1 2 3>, <4 5 6>, <7 8 9>] do {}
for key in ["Simone":69 "Luca":420 "Paolo":10] do {}
```

When you iterate over a map, you can provide two identifiers for the key and value map entry.

```
for <key iterator> : <value iterator> in <map> do <statement>
```

```ruby
for key : value in ["Simone":69 "Luca":420 "Paolo":10] do {}
```

When iterating over list of structs, it's possible to deconstruct them

```
for < <field iterator> > in <list of struct> do <statement>
for <struct iterator> < <field iterator> > in <list of struct> do <statement>
```

```ruby
colors [Color] <- [<0 255 0> <55 0 255> <255 255 255>]  
for <red green blue> in colors do {}
for color <red green blue> in colors do {}
```

# Functions

Functions are special types of code block

<!-- TODO: rework functions to be more like structs and anonymous struct -->

```
<function name>(<param name> <Param type> <default value>, <other params>) => <Return type> {
	<body>
	=> <return value>
}
```

Functions names must start with a lower case letter, and can contain letters,
digits and underscores.

```ruby
printHelloWorld() {
	"Hello World" -> \out
}

greetPerson(name Text, surname Text) {
	"Greetings $name, $surname" -> \out
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
```

```ruby
printHelloWorld()
greetPerson()
sum(2, 2) -> sumResult Int
division(10, 3) -> divisionResult Real
```

To return a value, you can alternatively use the return keyword

```ruby
intToBool(i Int) => Bool {
	return i > 0
}
```

When invoking a function, you can use named parameters; the order won't matter

```ruby
greet(name Text, age Natural) {
	"My name is $name" -> \out
	"My age is $age" -> \out
}

# positional parameters
greet("Simone", 22)

# named parameters
greet(name:"Simone", age:22)
greet(age:22, name:"Simone")
```

Function parameters can also have default values.<br>
We'll refer to them as "optional parameters", while we'll call "required
parameters" those which do not have a default value.

```ruby
count(num Natural default 10) { }
# if num is not specified when calling the
# function, num will be 10

count()
count(69)

greet(name Text default _ ) { }
# if name is not specified when calling the function
# its type default value will be used

greet()
greet("Simone")
```

Required parameters have to be specified.<br>
It's possible to mix optional and required parameters in the signature

```ruby
processPizzaOrder(
  type Text default "Margherita",
  tableNumber Int,
  withAnanas Bool default false,
  ) {
  	if withAnanas do return;
	makePizza(type)
	bringPizzaTo(tableNumber)
}
```

but when invoking the function with positional parameters, only terminal
optional parameters can be omitted.<br>
Using the placeholder symbol `_` (underscore) will pass the default value of
parameter type, or eventually the default parameter value if specified

```ruby
processPizzaOrder("Diavola", 69) # "Diavola" to table 69
processPizzaOrder(_, 69) # "Margherita" to table 69
processPizzaOrder(_, _) # "Margherita" to table 0
processPizzaOrder(_, 69, true) # "Margherita" with ananas to table 69
processPizzaOrder(69) # ERROR: expecting pizza type, but got 69
```

When invoking the function with named parameters, all required parameters value
have to be specified.<br>
Also, as long as all required parameters have been specified, remaining
optional parameters can be omitted, even if they are not terminal

```ruby
processPizzaOrder(type:"Diavola", tableNumber: 69)
processPizzaOrder(type:_, tableNumber: 69)
processPizzaOrder(tableNumber: 69)
```

### Overloading @candidate

Function overloading is possible, as long as all required parameters are
different (different name and different type)

```ruby
makePizza(type Text) { }
makePizza(type Text, withAnanas Bool) { }
makePizza(ingredients [Text]) { }

# ERROR makePizza(type Text) already defined
makePizza(type Text, withAnanas Bool default false) { }
```

### Statement functions @candidate

Functions can have a single statement instead of a body; in case the function
returns a value, its return type can be omitted as it will be inferred

```ruby
getName() => "Simone"
sum(x Int, y Int) => x + y
isEven(x Int) => x % 2 = 0
greet(name Text) name -> \out
```

### Function reference @candidate

The reference of a function is used to refer to the function itself.<br>
It is represented with `::` (double colon).

```
::()
::(<parameters>)
::(<parameters>) => <return type>
```

It can be stored in variables and struct, and can be passed as a parameter to
other functions as well, just like any other type.

```ruby
printSomething(txt Text) { txt -> \out }
::printSomething -> functionRef ::(Text)
# functionRef is now a reference to printSomething function
functionRef("hello world") # will print "hello world"
```

Anonymous function references can also be defined

```
::{<code block>}
::() <statement> 
::() {<statements>} 
::(<parameters>) <statement> 
::(<parameters>) {<statements>} 
::(<parameters>) => <return type> <statement>
::(<parameters>) => <return type> {<statements>}
```

```ruby
functionRef ::()

# Assign an anonymous function reference to functionRef
functionRef <- ::{
		"hello world" -> \out
	}

# I can now invoke functionRef
functionRef()
```

When the function has parameters, their names can be omitted in the signature;
but naming the parameters is advised for better readability

```ruby
# both are valid definitions of a function reference with a signature of (Text,Int) => Bool
stringContainsNumber1 ::(myText Text, myNumber Int) => Bool
stringContainsNumber2 ::(Text, Int) => Bool
```

Like other data types, a function reference can have a default value (a default
implementation in this case)

```ruby
functionRef ::(Text) default ::(txt Text) {
	txt -> \out
}
```

A function reference with many parameters, a return type and a default
implementation could be very verbose and cluttered

```ruby
# A verbose definition of a function reference which takes a Int, return an Int,
# with a default implementation which returns the sum of the parameters

# <variable> ::(<params>)     => <return> default ::(<params>)     => <return> <statement
myFunction   ::(x Int, y Int) => Int      default ::(x Int, y Int) => Int      => x + y
```

But the default implementation signature can be inferred

```ruby
myFunction ::(x Int, y Int) => Int default ::{=> x + y}
```

Alternatively, if you don't specify parameters names in the signature, you'll
have to specify them in the default implementation signature

```ruby
myFunction ::(Int, Int) => Int default ::(x, y) => x + y
```

### Pipe operator @candidate

```ruby
reverse(t Text) => Text {}
split(t Text, separator Text) => [Text] {}
countLetters(a [Text]) => [Int] {}
sum(a [Int]) => Int {}

"Hello world my name is Simone"
>> reverse(_)
>> split(_, " ")
>> countLetters(_)
>> sum(_)

"Hello world" >> reverse(_) >> split(_) >> countLetters(_) >> sum(_)
```

```ruby
# textual alternative
"Hello world my name is Simone"
then reverse(_)
then split(_)
then filter(_, ::(i) => i =~ "aeiou")
then map(_, ::(i) => "($i)")
then countLetters(_)
then sum(_)

"Hello world" then reverse(_) then split(_) then countLetters(_) then sum(_)
```

```ruby
filter(a [Text], f ::(Text) => Bool) => [Text] {}
map(a [Text], f ::(Text) => Text) => [Text] {}

"Hello world my name is Simone"
>> reverse(_)
>> split(_)
>> filter(_, ::(i) => i =~ "aeiou")
>> map(_, ::(i) => "($i)")
>> countLetters(_)
>> sum(_)
```

# Code examples

## Book store

```ruby
Author <
	name Text
	surname Text
	age Natural
>

Book <
	title Text
	description Text
	author Author
	price Real
	pagesCount Natural
>

#?{
#	@brief Convert a list of book to text
#	@param shelf - list of book
#	@return list of text
}#
shelfToText(shelf [Book]) => [Text] {
	books [Text]
	for book in shelf do {
		books +<- "{
		Title:        ${book.title}
		Description:  ${book.description }
		Price:        ${book.price}
		Page count:   ${book.pageCount}
		Author:       ${book.author}
			Name:       ${book.author.name}
			Surname:    ${book.author.surname}
			Age:        ${book.author.age}
		}"
	}
	=> books
}

#?{
#	@brief Convert a list of book to a HTML table
#	@param shelf - list of book
#	@return text - html table
}#
shelfToHTML(shelf [Book]) => [Text] {
	table Text <- "{
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
		}"

	for book in shelf do {
		"${toRowHTML(book)}" ->+ table
	}

	table +<- "{
			</tbody>
		</table>
		}"

	table -> \out
}

#?{
#	@brief Convert Book to a HTML table row
#	@param book
#	@return html table row
}#
toRowHTML(book Book) => Text {
	=> "{
		<tr>
			<td>${book.name}</td>
			<td>${book.description}</td>
			<td>${book.price}</td>
			<td>${book.pageCount}</td>
			<td>${book.author}</td>
		</tr>
		}"
}



author1 Author <- <"Simone" "Vicinanza" 22>
author2 Author <- <"Mario" "Rossi" 35>

shelf [Book] <- [
		<
			title: "Giovi for dummies"
			description: "A book describing very easily the Giovi"
			author: author1
			price: 0.0
			pageCount: 69
		>
		<
			title: "How to make a new Language"
			description: "{
				A step by step guide on how to build a new language from scratch
				It even has pictures!!!
				}"
			author: author2
			price: 6.9
			pageCount: 420
		>
		<
			title: "How to make a new Language | 2 edition"
			description: "{
				A step by step guide on how to build a new language from scratch
				It even has pictures!!!
				Revisioned edition
				}"
			author: author2
			price: 4.2
			pageCount: 690
		>
		<
			title: "Story of a bored programmer"
			description: "Biography of a bored programmer"
			author: <
				name:"Luigi"
				surname: "Bianchi"
				age: 55
			>
			price: 10.5
			pageCount: 120
		>
	]

shelfToText(shelf) -> \out
shelfToHTML(shelf) -> \out
```

## Find min value in a list

```ruby
findMinElement(list [Text]) => Text {
	if list@% < 1 do {
		"list is empty" -> \err
		=> ""
	}
	list@0 > min Text
	for element in list do {
		if element < min do {
			element -> min
		}
	}
	=> min
}

findMinElementIndex(list [Text]) => Int {
	if list@% < 1 do {
		"list is empty" -> \out
		=> -1
	}
	0 -> min Int
	for index in list@@ do {
		if list@{index} < list@{min} do {
			index -> min
		}
	}
	=> min
}

["z" "s" "a" "h" "j" "h" "w" "f"] -> letters [Text]
findMinElement(letters) -> minElement Text
findMinElementIndex(letters) -> minElementIdx Int

"{
List: $letters
	         min value: $minElement
	min value position: $minElementIdx
}" -> \out

#{
# 	output:
# 
# List: ["z" "s" "a" "h" "j" "h" "w" "f"]
# 	         min value: a
# 	min value position: 2
}#
```

## Fibonacci

```ruby
#?{
# @brief Recursive fibonacci. T(n) = O(2^n)
# @param n = value of fibonacci to find
# @return fibonacci sequence at n
}#
fibonacci(n Int) => Int {
	if n <= 2 do => 1
	=> fibonacci(n - 1) + fibonacci(n - 2)
}

#?{
# @brief Iterative bottom-up fibonacci T(n) = O(n)
# @param n = value of fibonacci to find
# @return fibonacci of sequence at n
}#
fibonacciBottomUp(n Int) => Int {
	if n = 0 | n = 1 do => n
	cache [Int] <- [1 1]
	for i in 2..n do {
		cache@{i - 2} + cache@{i - 1} ->+ cache
	}
	=> cache@{n - 1}
}

#?{
# @brief Iterative fibonacci with memoization via associative array
#	T(n) = O(n)
#	S(n) = O(n)
# @param n = value of fibonacci to find
# @return fibonacci sequence at n
}#
fibonacciAssociativeMemoIter(n Int) => Int {
	cache [Int : Int] <- [ 1:1 2:1 ]
	for i in 3..n do {
		cache +<- [ i : cache@{i - 1} + cache@{i - 2} ]
	}
	=> cache@n;
}

#?{
# @brief Iterative fibonacci with memoization via array
#	T(n) = O(n)
#	S(n) = O(n)
# @param n = value of fibonacci to find
# @return fibonacci sequence at n
}#
fibonacciMemoIter(n Int) => Int {
	cache [Int] <- [1 1]
	# NOTE: arrays indexes are 0-based
	for i in 2..n-1 do {
		cache +<- cache@{i - 1} + cache@{i - 2}
	}
	=> cache@{n - 1};
}

"Insert iteration count: " ->+ \out
\in as Int -> n Int
"Fibonacci of $n will be computed" -> \out
algorithm Text
repeat {
	"{
	Select algorithm:
		0) to exit
		1) recursive
		2) iterative (bottom-up)
		3) iterative (memoization via associative array)
		4) iterative (memoization via array)
	> }" ->+ \out
	\in -> algorithm
	if algorithm {
		= "0" do break;
		= "1" do "fibonacci($n) => ${fibonacci(n)}" -> \out
		= "2" do "fibonacciBottomUp($n) => ${fibonacciBottomUp(n)}" -> \out
		= "3" do "fibonacciAssociativeMemoIter($n) => ${fibonacciAssociativeMemoIter(n)}"  -> \out
		= "4" do "fibonacciMemoIter($n) => ${fibonacciMemoIter(n)}" -> \out
	} else default -> algorithm 
	if algorithm = default 
		do "Invalid algorithm" -> \out
		else break
}
```

# Module system @candidate

```ruby
import some.fully.qualified.module
import [
	some.fully.qualified.module
	someother.fully.qualified.module
]

module MyModule {
	someFunction() {}
	someValue SomeType
}
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
	args.s -> shortFlag Bool
	args.long -> longFlag Bool
	args.long_attr -> longAttrOption Text
	args.a -> aFlag Bool
	args.b -> bFlag Bool
	args.c -> cFlag Bool
}
```

# Files @candidate

```ruby
# /<path>
# ./<path>
# ../<path>

"hello" -> ./somefile.txt
"hello" -> ./somedir/somefile.txt
"hello" -> /somefileInRoot.txt
"hello" -> ../somefile.txt
"hello" -> ./somedir/$dirname/somefile_$date.txt

"appended" ->+ ./somefile.txt

./somefile.txt -> fileContent Txt

# or just use structs and funcs
<"somefile.txt"> -> f File
for line in f.lines() do line -> \out
```

# Regex @candidate

```ruby
# /<pattern>/
if "cpu temp: 69C" =~ /^[a-zA-Z]+:\s*([0-9]+).*$/ do {}
# What about groups?
```

```ruby
Regex."^[a-zA-Z]+:\s*([0-9]+).*$" -> regex Text.Regex
# What about groups?
```

```ruby
<"^[a-zA-Z]+:\s*([0-9]+).*$"> -> regex Regex
if regex.matches("cpu temp: 69C") do {
	regex.groups@0 -> \out
}
```

```ruby
Regex.replace("my text 69 lol", "^my (.*)", "something $1")
Regex.replace("my text 69 lol", "/^my (.*)/something $1/g")
```

# Parallel programming @candidate

```ruby
fork(::fetchData) -> result Text.Json
fork(::(){doSomethingBlocking()})
fork(::doSomethingBlocking)
join()
```

```ruby
fork ::fetchData > result Text.Json
fork ::{doSomethingBlocking()}
fork ::doSomethingBlocking
fork ::{
	"yeah" > \out
	doSomethingBlocking();
}
join
```

# Aliasing @candidate

Alias a type, function or struct

```ruby
AVeryVerboseAndLongStructName <i Int>
alias AVeryVerboseAndLongStructName as SomeStruct
SomeStruct.() -> \out

aVeryLonglyNamedFunction() => Text {
	=> "hello world"
}

alias aVeryLonglyNamedFunction as f
f() -> \out
```

# Generics @candidate

```ruby
Person {T} <
	name Text
	money Real
	favoriteColor T
>

Person{RGB}.<"simone" 69 <1 2 3>>
Person{Text}.<"simone" 69 "red">
Person{Int}.<"simone" 69 0xff0000>
```

```ruby
me Person{Int} <- <"simone" 69 0xff0000>
iColor Int <- me.favoriteColor
```

```ruby
me Person{_} <- <"simone" 69 0xff0000>
color Int <- me.favoriteColor # ERROR
iColor Int <- me.favoriteColor as Int

printPersons(persons [Person{_}]) {
	for person in persons do {
		\out <- "${person.name} has ${person.money} and likes ${person.favoriteColor}"
	}
}

printFavColor(persons [Person{_}]) {
	for person in persons do {
		"${person.name} likes " ->+ \out
		if person {
			is p Person{Int} do p.favoriteColor > \out
			is p Person{RGB} do "${p.favoriteColor.r} ${p.favoriteColor.g} ${p.favoriteColor.b}" -> \out
		}
	}
}
```

```ruby
Optional{T} <value T>

doSomething(optional Optional{_}) {
	if optional {
		is opt Optional{Text} do opt.value -> \out
		is opt Optional{Int} do opt.value -> \out
	}
}
```

## Generics inheritance @candidate

```ruby
Box{T} <color Text, something T>
Box{Car} : CarBox < >
Box{T} : MagicChest{T} < >

cardboardBox Box{Book} <- <"brown" Book.<"Moby Dick">>
shelf Box{[Book]} <- <"black" [Book.<"Moby Dick"> Book.<"Metro 2033">]>
garage CarBox <- <"grey" Car.<"Ferrari">>
chest MagicChest{Gift} <- <"blue" Gift.<"socks">>
```

# If expression (ternary operator like) @candidate

Has to be exhaustive

```ruby
x Int <- if true do yield 69 else yield 420
x Int <- if something {
	= "awf" do yield 69
	= "awawfwf" do yield 420
} else do yield 69420

x Int <- if true 69 else 420
x Int <- if something {
	= "awf" ~> 69
	= "aaawfwf" ~> 420
} else ~> 69420

x Int <- if true do ~> 69 else ~> 420
x Int <- if something {
	= "awf" do ~> 69
	= "awawfwf" do ~> 420
} else do ~> 69420
```

# Error handling @candidate

```ruby
Result{T, E} <
	value T
	error E
>

Result{T, Void} : Ok{T} < >
Result{Void, E} : Err{E} < >

parseDate(text Text) => Result{Date, ParsingErro} {
	if text = "" do => Err{ParsingError}.<"Input is empty">
	# blah blah blah
	parsedDate Date
	=> Ok{Date}.<parsedDate>
}
```

# Tuple type @candidate

```ruby
t Tuple <- <true "Hello world" 6.9 420>
function(x Int, args Tuple) {
	for arg in 0..args@%-1 do {
		if arg {
			is a Int do {}
			is a Text do {}
			is a Bool do {}
			is a Real do {}
		}
	}
}

function(69, t)
function(69, <"hello world" 69>)
```

# Tuple fields override @candidate

```ruby
Tuple -> struct # assign all fields, default for non specified
Tuple ->+ struct # assign only to specified fields
```

# Formatter directives @candidate

Special comment `#!` will be parsed by the formatter; uses the same syntax of
the language.

```ruby
#!disable()
"this will not be formatted" -> \out
#!enable()

#!align:true
[
	[0 0.0 0]
	[0 0   0]
]
#!align:false

#!minimize:true
someFunction(x Int,y Int)=>Int{=>x+y}
#!minimize:false

#!align:true, minimize:true
#!minimize:false
```

<!-- 
vim: noet
-->
