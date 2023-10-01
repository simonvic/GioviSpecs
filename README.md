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
#		sum(1, 2) > \out
#
#	@see Math
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

## Redirection (assignment)

| Operation           | Symbol | Example                      |
| ------------------- | ------ | ---------------------------- |
| Content redirection | >      | "Hello world" > message Text |
| Increment by value  | >+     | 10 >+ count                  |
| Decrement by value  | >-     | 10 >- count                  |
| Multiply by value   | >*     | 10 >* count                  |
| Divide by value     | >/     | 10 >/ count                  |

### Inverse redirection

| Operation           | Symbol | Example                      |
| ------------------- | ------ | ---------------------------- |
| Content redirection | <      | "Hello world" > message Text |
| Increment by value  | +<     | count +< 10                  |
| Decrement by value  | -<     | count -< 10                  |
| Multiply by value   | *<     | count *< 10                  |
| Divide by value     | /<     | count /< 10                  |

## Containment operator

| Operation     | Symbol | Example                    |
| ------------- | ------ | -------------------------- |
| Contains      | =~     | "Hello world" =~ "lo worl" |
| Is contained  | ~=     | "lo worl" ~= "Hello world" |

The containment operator is used to check if a value is contained in another.

To avoid confusion about the direction of the containment operator, remember
about its "hamburger notation":<br>
the hamburger (=) contains the lettuce (~) `hamburger =~ lettuce`
the lettuce (~) is contained in the hamburger (=) `lettuce ~= hamburger`

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

# Redirection

Giovi "moves" data (content) to destinations; this is done through
redirection.<br>
It can be done left to right...

```
<content>   >   <destination>
```

```ruby
69 > index
22 > age
1.70 > height
"Simone" > name
true > isAuthor
```

...or right to left

```
<destination>   <   <content>
```

```ruby
index < 69
age < 22
height < 1.79
name < "Simone"
isAuthor < true
```

There is no difference between the two directions, except for readability.
Sometimes it's just better to use one instead of the other

```ruby
"hello world" > \out     # Printing
counter +< 1             # Increasing counter by one
acceleration >+ velocity # Increasing velocity by "acceleration"
```

## Standard content @candidate

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
Qui odit molestias commodi omnis magni sunt. Et et et dolorem mollitia eum
repellendus fuga qui. Numquam sint numquam sed delectus. Necessitatibus
pariatur voluptatem ad ut eos in eos quo. Cupiditate et ut fuga. Aut enim aut
amet non.

Pariatur nam nobis placeat. Consequuntur laborum consequatur accusantium totam
occaecati possimus illo repellat. In fuga earum ea modi ut perspiciatis iusto.
Iste voluptate qui at. Eos eaque cumque quisquam non nemo tenetur quo fugit.
}" > \out
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
}" > \error
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
    - self

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
0x123AAFF  # Base 16 (hexadecimal)
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
| Concatenation                  | +      | "Hello" + " " + "World"    | "Hello World"              |
| Remove substring               | -      | "Hello world" - "world"    | "Hello "                   |
| Split                          | /      | "hello:world" / ":"        | ["hello" "world"]          |
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
text@0         # "h"
text@1         # "e"

# Out of bounds indexes can be used to "cycle" the chars.
# Bound checking is left to the business logic to do.
letters@12     # "e"
letters@{-2}   # "l"

text@1..6      # "ello w"
text@0..10..2  # "hlowrd"
text@10..0     # will print "dlrow olleh"

text@%         # 11 (chars count)
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
loremIpsum Text < "{
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
So please be consistent with formatting to avoid ambiguities and undesired side
effects.

```ruby
aFunction() {
    if true do {
        html Text < "{
            <html>
                <head></head>
                <body>
                    <p>Hello world</p>
                <body>
            </html>
            }"
#^^^^^^^^^^^ these are "incidental" whitespaces and won't be included in "html"
    }
}
```

Even though it's possible to open and close a text block on the same line, it's
recommended to immediately go on a new line after the opening text block tag,
followed by a 1-level deep indent; this is to avoid any possible ambiguities.

```ruby
t Text < "{these are some fancy quotes: """"""}"
t Text < "{
	but this is preferred
	}"
```

A new line will be automatically be appended at the last line. If you don't
want that, put the closing tag on the previous line

```ruby
t Text < "{
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
name Text < "Simone"  
surname Text < "Vicinanza"  

fullName Text
fullName < "$name $surname"   # Simone Vicinanza
fullName < '$name $surname'   # $name $surname
fullName < "$name \$surname"  # Simone $surname
```

If you need to have something immediately after the variable, without a space,
you can wrap the variable name in curly braces

```ruby
name Text < "Mario"  
surname Text < "Rossi"  
fullName Text < "${name}_${surname}"  

# Writing this would have been an error
fullName Text < "$name_$surname"  
          # ERROR ^^^^^ the name_ variable doesn't exists
          # (the underscore is a valid character for a variable name)
```

Text can also interpolate expressions

```ruby
x Int < 59
y Int < 10
"Sum is ${x + y}" > \out
# Sum is 69

getName() => Text { => "simonvic" }

helloWorld Text < "{
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
"\u0068\u0065\u006c\u006c\u006f\u0020\u0077\u006f\u0072\u006c\u0064" > \out
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

```
<identifier> [<ElementType>]
```

```ruby
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
listOfInteger [] < [-1 0 4 5]     # [Int]
listOfReal [] < [1.0 0.5 2.5]     # [Real]
listOfText [] < ["Luca" "Paolo"]  # [Text]
listOfBool [] < [true false true] # [Bool]

# When creating list of Struct, the type must be declared
listOfColors [Color] < [ .(62 65 10) .(0 64 0) .(12 50 255) ]  
listOfFullNames [FullName] < [
		.("Simone" "Vicinanza")
		.("Mario" "Rossi")
		.("Luigi" "Bianchi")
	]
```

#### List Access

| key   | output                     |
|-------|----------------------------|
| Int   | element at that index      |
| Range | "sub list"                 |
| %     | elements count             |
| @     | Range from 0 to length - 1 |

```ruby
letters [Text] < ["a" "b" "c" "d" "e" "f" "g" "h" "i" "j"]  

letters@0 > \out    # "a"

# Indexes out of bounds can be used to "cycle" the list.
# Bound checking is left to the business logic to do.
letters@15          # "f"
letters@{-2}        # "i"

letters@2..5        # ["c" "d" "e" "f"]
letters@0..10..2    # ["a" "c" "e" "g" "i"]
letters@10..0       # ["j" "i" "h" "g" "f" "e" "d" "e" "c" "b" "a"] aka the drunk test :)

letters@% > \out    # 10 (elements count)
letters@@ > \out    # 0..9 (range) useful when you need to iterate a list with indexes
```

Comparing Lists

```ruby
numbers [Int] < [ 1 2 3 4 ]  

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
	= [1 2 3 4] | numbers@{%} = 10 do {}
	
	# if empty list or elements count less then 3
	= default | numbers@{%} < 3 do {}
	
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
identityMatrix [[Real]] < [	
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
rubikCube [[[Text]]] < [
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


```
<identifier> [<KeyType> : <ElementType>]
```

```ruby
carCount [Text : Int]
[ "Audi" : 1 ] >+ carCount  # Insert new key "Audi" with value 1
[ "Audi" : 5 ] >+ carCount  # Set "Audi" key value to 5

carCount +< [               # Insert/Set new key value pair
		"Mercedes" : 10
		"Audi" : 7
		"BMW" : 15
		"Ferrari" : 20
	]

carCount@{"Ferrari"} < 26   # Set "Ferrari" value to 26
```

Default values can be used

```ruby
[ "Fiat" : default ] >+ carCount
default > carCount@{"Fiat"}
```

#### Map Access

| key           | output                     |
|---------------|----------------------------|
| map key value | element mapped to that key |
| %             | entries count              |
| @             | List of map keys           |
| *             | List of map elements       |

```ruby
carCount [Text : Int] < [
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
bank [Text : Real] < [
		"Simone" : 69.0
		"Alessio" : 15.50
		"Francesco" : 125.15
	]

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

```
<name> ( <fields> )
```

The name must start with an Uppercase letter and can contain letters, digits
and underscores.<br>
Primitive types cannot be used as name.

```ruby
Color (
	red Natural
	green Natural
	blue Natural
)

Car (
	model Text
	paint Color
)

Person (
	name Text
	surname Text
	age Natural
	favoriteColor Color
	favoriteCar Car
	ownedCar Car
)
```

##### Creation

```ruby
red Color < Color.(255 0 0)  
me Person < Person.(
		"Simon"
		"Vic"
		22
		red
		Car.("Ferrari" red)
		Car.("Fiat600" Color.(0 0 255))
	)
```

When creating a struct, you can name the fields to improve readability.
By doing so, the order of the fields won't matter

```ruby
me Person < Person.(
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
	)
```

You can also specify a subset of the fields; unspecified fields will be
initialized with their default value.
Note that this is not possible when the field names are not specified.

```ruby
me.Person < Person.(
		age: 23
		favoriteCar: Car.(model: "Ferrari")
	)
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
indexed by a 0-based index)

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
me Person < .(
		name: "Simon"
		age: 23
		favoriteCar: .(
			model: "Ferrari"
		)
	)
```

When assigning with an unnamed tuple, all fields must be specified for the
tuple to be compatible

```ruby
color Color
color < .(255 255 255)  
color < .(255)  # ERROR Incompatible structs
color < .(red: 255)  # Ok!
```

This allows for a less verbose variable declaration

```ruby
# From most verbose to less verbose
c Color < Color.(
		red: 255
		blue: 255
		green: 255
	)

c Color < .(
	red: 255
	blue: 255
	green: 255
)

c Color < .(255 255 255)
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

color Color < .(255 100 50)  

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
color Color < .(255 100 50)  

color.red > \out
color.blue < 255  # setting blue channel to 255
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
	#           ^^^^^ ERROR Color not defined
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
	nextNode Node default null
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
		speed -< 1
	}

	speedToMilesPerHour() => Int {
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

###### Self return @candidate

A struct function can also return the struct itself, without having to
explicitly return.<br>
This comes very handy when you want to make "chainable" functions.

```ruby
Color (
    r Natural
    g Natural
    b Natural

    rgb(r Natural, g Natural, b Natural) => self {
        self.r = r
        self.g = g
        self.b = b
    }

    brigthen() => self {
        self.r *< 0.5
        self.g *< 0.5
        self.b *< 0.5
    }

    saturate() => self {
        # however you do it
    }
)

c Color < .(5 20 512)

c.rgb(5, 20, 512)
    .brigthen()
    .saturate()
    .brighten()
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
	wheelCount Natural default 4
	licensePlate Text
)

Vehicle : Bike (
	wheelCount Natural default 2
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
	wheelsCount Int default 4
	plate Text default "xxx"
	# secondaryEngine Engine
	#                 ^^^^^^ ERROR Engine not defined
)
```

But you can use the dot notation...

```ruby
Vehicle (
	engine Engine (
		horsePower Real
	)
	wheelsCount Int
)
Vehicle : Car (
	wheelsCount Int default 4
	plate Text default "xxx"
	secondaryEngine Vehicle.Engine
)
```

... or you can also specialize the nested struct

```ruby
Vehicle (
	engine Engine (
		horsePower Real
	)
	wheelsCount Int
)
Vehicle : Car (
	wheelsCount Int default 4
	plate Text default "xxx"
	Vehicle.Engine : Engine (
		fuelType Text
	)
	secondaryEngine Engine
	#               ^^^^^^ Car.Engine, which inherits from Vehicle.Engine
)
```

### Enums @candidate

Enums like behaviour can be achieved with a nested struct.<br>
They can be simple enums...

```ruby
PizzaStatus (
	ORDERED ()
	READY ()
	DELIVERED ()	
)
```

... or have values

```ruby
Color (
	RGB (r Natural; g Natural; b Natural)
	RGBA (r Natural; g Natural; b Natural; a Natural)
	ARGB (a Natural; r Natural; g Natural; b Natural)
	HSL (hue Real; saturation Real; lightness Real)
	HEX (hex Text)
)
```

... or both, which can be quite handy along the if statement

```ruby
Result (
	OK ()
	ERROR (reason Text)
)

enterClub(age Int) => Result {
	if age < 18 do
		=> Result.ERROR.("user is underage")
	=> Result.OK.()
}

if enterClub(69) {
	= Result.OK.() do "Welcome" > \out
	= Result.ERROR.(reason:_) do "Can't enter because $reason" > \out
}
```

You can omit struct types, but beware of the matching order

```ruby
if enterClub(69) {
	= .(reason: "underage") do "Too young, boy!" > \out
	= .(reason: _) do "Can't enter because $reason" > \out
	= .() do "Welcome" > \out
}

```

# Explicit casting

It's possible to explicitly casting a variable to another type (if supported).

## Syntax

```
<variable> as <Type>
```

```ruby
69 > i Int
i as Real > \out

"420.69" > t Text
t as Real > \out

p3d Point3D
p3d as Point > p Point

Point.() as Point3D > p3d
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
constant LIGHT_SPEED Natural 299792458
constant EARTH_GRAVITY Real 9.81
constant BEST_LANGUAGE Text "Giovi"
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

The default keyword can be used in redirections and other statements

```ruby
number Natural < 69  
anotherNumber Integer < -420  
someOtherNumber Real < 69.69  
someText Text < "This is a text"  
someBoolean Bool < true  

default > number            # This will set number to 0
default > anotherNumber     # This will set anotherNumber to 0
default > someOtherNumber   # This will set someOtherNumber to 0.0
default > someText          # This will set someText to empty string
default > someBoolean       # This will set someBoolean to false
```

It is also possible to overwrite a variable default value

```ruby
number Natural default 420
someOtherNumber Real default 4.20
someText Text default "default text"
someBoolean Bool default true

69 > number
6.9 > someOtherNumber
"hello" > someText
false > someBoolean

default > number            # This will set number to 420
default > someOtherNumber   # This will set someOtherNumber to 4.20
default > someText          # This will set someText to "default text"
default > someBoolean       # This will set someBoolean to true
```

## Struct default value

Struct default value is a struct with all its fields set to their respective
default value

```ruby
someColor Color
someColor < .(255 255 0)  
default > someColor  # This will set someColor to (0 0 0)
```

```ruby
# Color with overridden defaults
Color (
	red Natural default 255
	green Natural default 255
	blue Natural default 255
)

someColor Color < .(0 255 0)  
_ > someColor  # Set someColor to default (255 255 255)
```

If the default is not defined, the type default will be used

```ruby
Person (
	Car (
		model Text
		paint Color default .(40 40 40) 
	)
	name Text default "No name"
	surname Text default "No surname"
	age Natural
	favoriteColor Color default .(255 0 0)
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

somebody.ownedCar < .("Fiat 600" .(10 100 20))  
# somebody.ownedCar is now ("Fiat 600" (10 100 20))

default > somebody.ownedCar
# somebody.ownedCar is now ("" (40 40 40))


somebody.favoriteCar < .("Ferrari" .(255 255 255))  
# somebody.favoriteCar is now ("Ferrari" (255 255 255))

default > somebody.favoriteCar.paint
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
x Int < 1  
y Int < 69  

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
x Int < 69  

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

name Text < "Simone"  
if name {
	= default do {}          # name is empty string
	= "Simone" do {}         # name is Simone
	= "Alessio" do {}        # name is Alessio
	= "Paolo" do {}          # name is Paolo
	= "Gian Carlo" do {}     # name is Gian Carlo
}
```

Comparing struct

```ruby
ColorRGB (r Natural; g Natural; b Natural)
ColorARGB (a natural; r Natural; g Natural; b Natural)

color ColorRGB < .(42 0 69)
white ColorRGB < .(255 255 255)
red ColorRGB < .(255 0 0)
transparent ColorARGB < .(0 0 0 0)

if color do {
	= default do "it's black" > \out

	= red do "it's red" > \out

	= .(240 10 10) do "it's redish" > \out

	= .(255 default 69) do "255 default green 69" > \out
	
	= white
	| = .(200 200 200)
	do "it's white or grey" > \out

	= .(_ _ 69) do "any red, any green, blue of 69" > \out

	= .(_ _ _ _) do "It has at least 4 fields" > \out
}
```

It's also possible to deconstruct the struct by using named struct, so you can
access the fields

```ruby
if color do {
	= .(r:255 g:69 b:42) do "Something with $r $g and $b" > \out

	= .(r:_ g:_ b:_) do "Something with $r $g and $b" > \out

	= .(r:_ b:_) do "I only need $r and $b" > \out
}
```

# Range

You can quickly define a range by specifying a `start`, a `end` and optionally
a `step`<br>
A range can be used in for loops or put in a list, where its values will be
expanded.

## Syntax

```
<start>..<end>
<start>..<end>..<step>
```

```ruby
[0..5] > fromZeroToFive [Int]         # [0 1 2 3 4 5]
[3..5] > fromThreeToFiveReal [Real]   # [3.0 4.0 5.0]
["a".."d"] > fromAtoZ [Text]          # [a b c d]
```

Descending ranges can be defined

```ruby
[5..0] > fromZeroToFive [Int]         # [5 4 3 2 1]
[5..3] > fromThreeToFiveReal [Real]   # [5.0 4.0 3.0]
["d".."a"] > fromAtoZ [Text]          # [d c b a]
```

A step value can also be used

```ruby
[0..10..2] > evenNumbers [Int]        # [0 2 4 6 8 10]
[0..1..0.1] > fromZeroToOne [Real]    # [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
["a".."g"..2] > listOfLetters [Text]  # [a c e g]
```

Variables can be used

```ruby
start Int < 0  
end Int < 10  
step Int < 2  
list [Int] < [start..end..step]  # [0 2 4 6 8 10]
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
colors [Color] < [.(0 255 0) .(55 0 255) .(255 255 255)]  
for color in colors do {}
```

The for loop also tries to deconstruct the struct if the variables are the same of the struct

```ruby
colors [Color] < [.(0 255 0) .(55 0 255) .(255 255 255)]  
for red green blue in colors do {}
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

To return a value, you can alternatively use the return keyword

```ruby
intToBool(i Int) => Bool {
    return i > 0
}
```

Function parameters can also have default values

<!-- TODO change this once the placeholder symbol (_) has been defined -->

```ruby
count(num Natural default 10) { }
# if num is not specified when calling the
# function, num will be 10

greet(name Text default default ) { }
# if name is not specified when calling the function
# its type default value will be used

count()
count(69)
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
	if count = 0 | count = 1 do {
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
printSomething(txt Text) {
	txt > \out
}

functionRef ::(Text) < ::printSomething

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
functionRef < ::{
		"hello world" > \out
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
	txt > \out
}
```

A function reference with many parameters, a return type and a default
implementation could be very verbose and cluttered

```ruby
# A verbose definition of a function reference which takes a Int and return an Int
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

#?{
#	@brief Convert a list of book to text
#	@param shelf - list of book
#	@return list of text
}#
shelfToText(shelf [Book]) => [Text] {
	books [Text]
	for book in shelf do {
		books +< "{
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
	table Text < "{
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
		"${toRowHTML(book)}" >+ table
	}

	table +< "{
			</tbody>
		</table>
		}"

	table > \out
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



author1 Author < .("Simone" "Vicinanza" 22)  
author2 Author < .("Mario" "Rossi" 35)  

shelf [Book] < [
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
	]

shelfToText(shelf) > \out
shelfToHTML(shelf) > \out
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
