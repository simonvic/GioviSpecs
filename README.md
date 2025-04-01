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
#		sum(1, 2) -> _out
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

| Operation | Symbol | Example           |
| --------- | ------ | ----------------- |
| And       | &      | 10 > 2 & 10 > 5   |
|           | and    | 10 > 2 and 10 > 5 |
| Or        | \|     | 10 > 2 \| 5 > 2   |
|           | or     | 10 > 2 or 5 > 2   |
| Not       | !      | !{2 > 10}         |
|           | not    | not {2 > 10}      |

## @candidate Bitwise operators

| Operation            | Symbol  | Example             |
| -------------------- | ------- | ------------------- |
| Not                  | !!      | !!0b001             |
| And                  | &&      | 0b001 && 0b001      |
| Or                   | \|\|    | 0b001 \|\| 0b010    |
| Xor                  | \|\|\|  | 0b001 \|\|\| 0b010  |
| Left shift           | <<      | 1 << 5              |
| Signed right shift   | >>      | 1 >> 5              |
| Unsigned right shift | >>>     | 32 >>> 5            |

## Redirection (assignment)

| Operation             | Symbol | Example                  |
| --------------------- | ------ | ------------------------ |
| Content redirection   | ->     | "Hello world" -> message |
| Add and redirect      | ->+    | 10 ->+ count             |
| Subtract and redirect | ->-    | 10 ->- count             |
| Multiply and redirect | ->*    | 10 ->* count             |
| Divide and redirect   | ->/    | 10 ->/ count             |

### Inverse redirection

| Operation           | Symbol | Example                  |
| ------------------- | ------ | ------------------------ |
| Content redirection | <-     | message <- "Hello world" |
| Increment by value  | +<-    | count +<- 10             |
| Decrement by value  | -<-    | count -<- 10             |
| Multiply by value   | *<-    | count *<- 10             |
| Divide by value     | /<-    | count /<- 10             |

Note that the `->+`,`+<-` and alike are only a shorthand for the relative
operator; so doing `1 ->+ x` or `x +<- 1` is the same of doing `x + 1 -> x` or
`x <- x + 1`.

Keep it in mind when using non-commutative operators.

## Containment operator

| Operation     | Symbol | Example                    |
| ------------- | ------ | -------------------------- |
| Contains      | =~     | "Hello world" =~ "lo worl" |
| Contained     | ~=     | "lo worl" ~= "Hello world" |
|               | in     | "lo worl" in "Hello world" |

The containment operator is used to check if a value is contained in another.

To avoid confusion about the direction of the containment operator, remember
about its "hamburger notation":<br>
the hamburger `=` contains the lettuce `~` `hamburger =~ lettuce`<br>
the lettuce `~` is contained in the hamburger `=` `lettuce ~= hamburger`

The containment operators (`in`, `=~`, `~=`) can be negated with the `not`
operator

```ruby
if "someValue" not in someList do "Not contained" -> _out
```

### @candidate Range containment

```ruby
69 ~= 0..420
-5..5 =~ 0
6.9 ~= 6.0 .. 8.0

"b" ~= "a".."d"

3 ~= 0..10..2 # false
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
"hello world" -> _out     # Printing
counter +<- 1             # Increasing counter by one
acceleration ->+ velocity # Increasing velocity by "acceleration"
```

## Standard destinations

| Destination     | Symbol |
| --------------- | ------ |
| Standard output | _out   |
| Standard error  | _err   |

### Standard output

Print to standard output

```ruby
"Hello world" -> _out

"I'm going to print the lorem ipsum" -> _out

"{
Qui odit molestias commodi omnis magni sunt. Et et et dolorem mollitia eum
repellendus fuga qui. Numquam sint numquam sed delectus. Necessitatibus
pariatur voluptatem ad ut eos in eos quo. Cupiditate et ut fuga. Aut enim aut
amet non.

Pariatur nam nobis placeat. Consequuntur laborum consequatur accusantium totam
occaecati possimus illo repellat. In fuga earum ea modi ut perspiciatis iusto.
Iste voluptate qui at. Eos eaque cumque quisquam non nemo tenetur quo fugit.
}" -> _out
```

The redirect operator (`->`) will automatically append a new line; if you don't
want that, you can use the "append redirector" operator (`->+`)

```ruby
"Hello " ->+ _out
"world" -> _out
# Hello world\n
```

### Standard error

Print to standard error

```ruby
"Some error happened" -> _err

"I'm going to print some details:" -> _err

"{
This program has crashed
because you tried to perform a
division by zero.
}" -> _err
```

## Standard content

| Destination     | Symbol |
| --------------- | ------ |
| Standard input  | _in    |

Reading from standard content is a blocking operation that will read from stdin.<br>
Can be used to read input from the user

```ruby
"Insert your username: " ->+ _out
_in -> username Text
"Hello $username" -> _out
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
    - when
    - for
    - not
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

## Declaration

To declare a variable, you have to specify a name and a type

```
<name> <Type>
```

and you can optionally override its default value.<br>
See [Default value](#default-value)

```
<name> <Type> default <default value>
```

## Scopes and variables lifetime

<!-- TODO: clarify passing as by reference of by value (e.g. a list to a function) -->

Once you declare a variable, its **lifetime** (the time in which you can read
or write from/to the variable) is bound to the **scope** in which it has been
defined.<br>
You can access variables (and any other definition) in the current or any
parent scope

```ruby
# global scope
"hello world" -> aVariable Text
aVariable -> _out
if true do {
	# "true" scope
	aVariable -> _out
	69 -> anotherVariable Int
	anotherVariable -> _out
} else {
	# "false" scope
	aVariable -> _out
	anotherVariable -> _out
	# ERROR: anotherVariable not defined
}
```

You usually enter a new scope when you encounter a "code block" (curly braces)
and you exit when it ends

```ruby
# global scope

if true do {
	# new scope
} else {
	# new scope
}

if someVariable {
	= 69 do {
		# new scope
	}

	= 420 do {
		# new scope
	}
}

repeat {
	# new scope
}

for i in 0..10 do {
	# new scope
}

someFunction() {
	# new scope
}
```

<!-- TODO: mention variable shadowing -->

# Data types

## Primitive Types

| Type name | Possible values                  | Default value |
| --------- | -------------------------------- | ------------- |
| Natural   | 0 .. +2,147,483,647              | 0             |
| Int       | -2,147,483,648 .. +2,147,483,647 | 0             |
| Real      | up to 16 decimal digits          | 0.0           |
| Bool      | false / true                     | false         |
| Text      |                                  | (empty text)  |

@candidate

| Type name | Possible values  | Default value |
| --------- | ---------------- | ------------- |
| Type      | Any type         | Void          |
| Range     | Any range        | 0..0..1       |
| Tuple     | Any tuple        | <>            |
| Record    | Any record       | <>            |
| Struct    | Any struct       | <>            |

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
| Repeat                         | ^      | "o" ^ 4                    | "oooo"                     |
| Append to variable             | ->+    | "hello world" ->+ someText | "$someText hello world"    |
| Remove substring from variable | ->-    | "substring" ->- someText   | someText without substring |
| Contains                       | =~     | "hello world" =~ "lo worl" | true                       |
| Is contained                   | ~=     | "lo worl" ~= "hello world" | true                       |

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

#### Text block

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
t Text
t <- "{this is "fine" but...}"
t <- "{
	...this is preferred
	}"
```

A new line will be automatically be appended at the last line. If you don't
want that, put the closing tag on the previous line

```ruby
t Text <- "{
	hello world}"
```

#### Text interpolation

Double quotes will interpolate variables and expressions (dollar sign will need
escaping)<br>
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
"Sum is ${x + y}" -> _out
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

#### Escapes

Certain characters can be escaped with `\\` (backslash)

```ruby
"Backslash: (\\)" -> _out
"Space: (\s)" -> _out
"New line: (\n)" -> _out
"Tab: (\t)" -> _out
"Formfeed: (\f)" -> _out
"Backspace: (\b)" -> _out
"Return: (\r)" -> _out
"Dollar \$sign" -> _out
"Braces \{\}" -> _out
```

##### Unicode escapes

Text can also contain Unicode escapes, which will be interpolated with the
character at the specified codepoint.

```ruby
"\u0068\u0065\u006c\u006c\u006f\u0020\u0077\u006f\u0072\u006c\u0064" -> _out
# hello world
```

#### @candidate Text types

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

##### @candidate Custom text type processors

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

A list is a collection of homogeneous values indexed by an integer value.<br>
The indexes are 0-based

#### Operators

| Operation     | Symbol  | Example         |
| ------------- | ------- | --------------- |
| Redirection   | ->      | list <- [1 2 3] |
| Concatenate   | ->+     | list +<- [4 5]  |
|               |         | list +<- 4      |
| Remove all    | ->-     | list -<- [2 3]  |
| Remove        |         | list -<- 3      |

@candidate

| Operation     | Symbol  | Example               | Output          |
| ------------- | ------- | --------------------- | --------------- |
| Split         | /       | [1 1 0 0 1 1] / [1 0] | [[1 1] [1 1]]   |
|               |         | [1 1 1 0 1 1] / 0     | [[1 1 1] [1 1]] |

<!-- TODO: what about a function!!!
	list / ::(value) => value%2=0
	Or maybe just add it as method
	list.split(::(value) => value % 2 = 0)
-->

##### Relational

| Operation    | Symbol | Example           |
| ------------ | ------ | ----------------- |
| Equal        | =      | [1 2 3] = [1 2 3] |
| Contains     | =~     | list =~ 2         |
|              |        | list =~ [1 2]     |
| Is contained | ~=     | 2 ~= list         |
|              |        | [1 2] ~= list     |

#### Syntax

```
<identifier> [<ElementType>]
```

```ruby
listOfNames [Text]

["Simone" "Giada"] -> listOfNames

# Add "Francesca"
"Francesca" ->+ listOfNames

# Add "Alessio" and "Luca"
["Alessio" "Luca"] ->+ listOfNames

# Remove "Giada"
"Giada" ->- listOfNames
```

List entries can be optionally separated by a comma (trailing comma is allowed)

```ruby
[1, 2, 3, 4,]
```

Default value can be used

```ruby
default -> someList # set someList to its default value
default ->+ someList # add default entry to someList
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

@candidate Out-of-bound access will not throw an error, but rather return a
default entry value.

```ruby
numbers [Int] <- [1 2 3]
numbers@69 -> _out
# will print 0 (Int default)
```

Note that it does not mean a value is automatically added.

```ruby
numbers [Int] <- [1 2 3]
numbers@69 -> _out
numbers@% -> _out
# will print 3 (entries count)
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

#### @candidate Multidimensional lists access

```ruby
cube [[[Int]]]
cube@1@2@3 -> _out
cube@{1, 2, 3} -> _out
```

### @candidate Set

A set is an unordered collection of homogeneous values that doesn't allow
duplicate elements.

```ruby
[()]
[( 1 2 3 4 )]

(||)
(| 1 2 3 4 |)

[||]
[| 1 2 3 4 |]
```

### Map

A map (aka associative list or dictionary) is a collection of homogeneous
key-value pairs.<br>
A key is unique, meaning that it can only appear in one key-value pair.<br>
A key and value pair may also be called a map entry.

#### Operators

| Operation    | Symbol  | Example                         |
| ------------ | ------- | ------------------------------- |
| Redirection  | ->      | map <- ["a":1 "b":2 "c":3]      |
| Put          | ->+     | map +<- ["b":69 "c":420]        |
| Remove pairs | ->-     | map -<- ["a":1 "c":3]           |
| Remove keys  | ->-     | map -<- ["a" "c"]               |

@candidate

| Operation       | Symbol  | Example                    |
| --------------- | ------- | -------------------------- |
| Put pair        | ->+     | map +<- "c":3              |
| Remove pair     | ->-     | map -<- "c"                |
| Remove pairs    | ->-     | map -<- ["a":_ "c":_]      |
| Remove pairs    | ->-     | map -<- [_:1 _:3]          |


##### Relational

| Operation      | Symbol | Example                              |
| -------------- | ------ | ------------------------------------ |
| Equal          | =      | ["a":1 "b":2] = ["a":1 "b":2]        |
| Contains key   | =~     | ["a":1 "b":2] =~ "a"                 |
| Contains pairs | =~     | ["a":1 "b":2 "c":3] =~ ["b":2 "c":_] |
| Contains keys  | =~     | ["a":1 "b":2 "c":3] =~ ["b" "c"]     |

#### Syntax

```
<identifier> [<KeyType> : <ElementType>]
```

```ruby
carCount [Text : Int]
[ "Audi" : 1 ] ->+ carCount  # Insert new key "Audi" with value 1
[ "Audi" : 5 ] ->+ carCount  # Set "Audi" key value to 5

carCount +<- [ # Insert/Put key-value pairs
		"Mercedes" : 10
		"Audi" : 7
		"BMW" : 15
		"Ferrari" : 20
	]

carCount@{"Ferrari"} <- 26   # Set "Ferrari" value to 26
```

To avoid ambuigity with the syntax of an empty list, an empty map can be
defined as follows:

```ruby
[:] -> carCount
```

<!-- TODO: if immutability is considered
"Ferrari" : 26 -> carCount
should be used instead of
26 -> carCount@"Ferrari"
-->

Map entries can optionally be separated by a comma (trailing comma is allowed)

```ruby
[
	"Mercedes" : 10,
	"Audi" : 7,
	"BMW" : 15,
	"Ferrari" : 20,
]
```

Default values can be used

```ruby
[ "Fiat" : default ] ->+ carCount
default -> carCount@{"Fiat"}
```

@candidate Default entry value can be overridden (but not keys)

```ruby
carCount [Text : Int default 69]
default -> carCount@"Ferrari"
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

@candidate A map maps all possible values of its domain, so accessing a
"non-existing" key will not throw an error, but rather return a default value.

```ruby
carCount [Text : Int]
carCount@"UnkownModel" -> _out
# will print 0
```

This does not mean the entry is automatically added; using the containment
operator will still return false

```ruby
carCount [Text : Int]
carCount@"UnkownModel" -> _out
carCount =~ "UnkownModel" -> _out # false
```

Examples

```ruby
bank [Text : Real] <- [
		"Simone" : 69.0
		"Alessio" : 15.50
		"Francesco" : 125.15
	]

for name : money in bank do {
	"$name has $money € in his wallet" -> _out
}

"List of names: " -> _out
for name in bank@{@} do {
	"- $name" -> _out
}

sum Real
for money in bank@{*} do {
	money ->+ sum
}
"The bank has a total of $sum €" -> _out
```

## Product types

### Tuples

A Tuple is an ordered collection of heterogeneous values.

```ruby
# Tuple with a Text, Bool and Real fields
<"a" true 420.69> -> _out
```

#### Tuple Access

| key   | output                                       |
|-------|----------------------------------------------|
| Int   | field value at the index                     |
| Range | Subset tuple with fields within the range    |
| %     | fields count                                 |
| @     | Range 0 to fields count - 1                  |

#### @candidate Tuple type

```ruby
t Tuple <- <true "Hello world" 6.9 420>
function(x Int, args Tuple) {
	for i in args@@ do {
		if args@i {
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

#### @candidate Tuple fields override

```ruby
Tuple -> struct # assign all fields, default for non specified
Tuple ->+ struct # assign only to specified fields
```

### Records

A Record is an unordered collection of named (labeled) heterogeneous values.

Can be seen as a specialization of Tuples

```ruby
_out <- <
	field1: "a"
	field2: true
	field3: 420.69
>
```

#### Record Access

| key   | output                                       |
|-------|----------------------------------------------|
| Int   | field value at the index                     |
| Range | Subset record with fields within the range   |
| %     | fields count                                 |
| @     | Range 0 to fields count - 1                  |
| *     | List of fields names                         |

#### @candidate Record type

```ruby
t Record <- <
	a: true
	b: "Hello world"
	c: 6.9
	d: 420
>
function(x Int, args Record) {
	for i in args@* do {
		if argsi {
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

### Struct

A Struct is a structured data type that you can define; more formally, an
unordered collection of named (labeled) heterogeneous fields, with a typename
associated to it.

Under the hood, Structs are just Records with a typename associated to it; they
do have some differences though (e.g. casting).

#### Syntax

```
<Typename> <   <fields>   >
```

The typename must start with an Uppercase letter and can contain letters, digits
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

The creation (or instantiation) of a struct can be done with the typename,
followed by a dot, followed by a tuple with the fields

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

The same syntax of records can be also be used. (note that order doesn't matter
when using record syntax)

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
Note that this is not possible when using the tuple syntax.

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
Color.<> -> _out
```

When defining or creating a struct, the fields can optionally be separated by
a comma (trailing comma is allowed)

```ruby
Color <r Int, g Int, b Int,>
Color.<1, 2, 3,> -> c Color
```

Tuples and Records can be redirected to Structs, [as long as they can be widened](#tuples%2C-records-and-structs).

```ruby
color Color
color <- <255 255 255>
color <- <r:255 g:255 b:255>
color <- <255> # ERROR <Int> cannot be widened to Color
```

#### Struct Access

| key   | output                                       |
|-------|----------------------------------------------|
| Int   | field value at the index                     |
| Range | Subset record with fields within the range   |
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

# Negative indexes can be used to access last fields
color@{-1}   # Last field
color@{-2}   # Second-last field
color@{-3}   # Third-last field

color@0..2  # Record <red: 255, green: 100>

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

color.red -> _out
color.blue <- 255  # setting blue channel to 255
```

#### @candidate Nested struct

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

#### @candidate Recursive struct

You can define recursive struct (struct defined with itself)

```ruby
Node <
	data Text
	nextNode Node
>
```

In Giovi all values are initialized at declaration, but in these case a lazy
approach is used and the `nextNode` is initialized when accessed for the first
time

```ruby
root Node
root.nextNode.nextNode -> _out
```

#### Constant fields

Constants can be defined within structs and will be associated to its typename.

```ruby
Person <
	constant ADULT_AGE Int <- 18
>

Color <
	constant RED Color <- <255 0 0>
>

Person.ADULT_AGE -> _out
Color.RED -> _out
```

#### Struct functions

Functions can be defined within structs and will be associated to the type.
Beware that these are, by definition, NOT methods; it can be seen as simple
syntax sugar to better organize code using types as "namespaces" for these
functions. *In Java-land, we could compare them to "static methods".*

```ruby
Vehicle <
	speed Int
	
	accelerate(v Vehicle, amount Int) {
		amount ->+ v.speed
	}
	
	brake(v Vehicle) {
		v.speed -<- 1
	}

	speedToMilesPerHour(v Vehicle) => Int {
		=> v.speed / 1.6093
	}
>

car Vehicle
Vehicle.accelerate(car, 10)
"${car.speed} KMH" -> _out
"${Vehicle.speedToMilesPerHour(car)} MPH" -> _out
```

Note that, although functions can be invoked from an instance of a struct,
they're still only related to the type; the syntax is allowed because of the
`self` keyword.

`self` can be prefixed to the function and it's a shortcut for defining a
function that takes as a first argument an instance of the struct in which the
function is defined

<!--NOTE: since parameters are passed by value, to make this work properly,
either treat self parameter as special, or more generally pass product types as
value but the fields by reference -->

```ruby
Car <
	speed Real

	self accelerate() {
		self.speed +<- 2
	}

	# the function above is a shortcut for this function
	# accelerate(car Car) {
	#	car.speed +<- 2
	# }
>
```

The function can now be invoked from an instance

```ruby
c Car
c.accelerate()
# which, again, is syntax sugar for `Car.accelarate(c)`
```

##### Self return

A struct function can also specify `self` as return type, to avoid repeating
the typename.<br>
This comes very handy when you want to make "chainable" functions.

```ruby
Color <
	r Int
	g Int
	b Int

	rgb(r Int, g Int, b Int) => self {
		=> Color.<r g b>
	}

	self brigthen() => self {
		self.r *<- 0.5
		self.g *<- 0.5
		self.b *<- 0.5
		=> self
	}

	self saturate() => self {
		# however you do it
		=> self
	}
>

Color.rgb(5, 20, 512)
	.brigthen()
	.saturate()
	.brighten()
```

#### Structs inheritance

A struct can inherit the fields from another struct, but beware that the term
"inheritance" is used loosely here, since we are not talking about "true
inheritance" like in other object oriented languages; it's just syntax sugar to
avoid repeating the same fields in multiple structs.

It can define new fields and redefine inherited ones.

TODO: clarify about overridden fields. Should the type be equal? Wider?

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

##### @candidate Nested structs definition inheritance

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

## @candidate Enums

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
	= Result.OK.<> do "Welcome" -> _out
	= Result.ERROR.<reason:_> do "Can't enter because $reason" -> _out
}
```

You can omit struct types, but beware of the matching order

```ruby
if enterClub(69) {
	= <reason: "underage"> do "Too young, boy!" -> _out
	= <reason: _> do "Can't enter because $reason" -> _out
	= <> do "Welcome" -> _out
}

```

# Data widening, narrowing and explicit casting

Often we need to work with different data types toghether and we may need
to transform data from one type to another (casting).

There are two kinds of casting:
- **widening**: lossless casting from a "narrower" type to a "wider" one.
  Some examples:
    - `Natural` to `Int`
    - `Int` to `Real`
    - `[Natural]` to `[Real]`
    - `[Natural : [Int]]` to `[Int : [Real]]` *A map with `Natural` keys and
    values of list of `Int` to a map with `Int` keys and values of list of
    `Real`*
- **narrowing**: lossy casting from a "wider" type to a "narrower" one
(lossy). Same examples as above, but inverted. This operation can lead to
possible data loss

Widening happens automatically when necessary (e.g. redirections)

```ruby
69 -> r Real # Int widened to Real
[1 2 3] -> l [Real] # list of Int widened to list of Real
```

Narrowing, given its lossy nature, can be only achieved with explicit casting.
For example narrowing a `Real` of value 6.9 to `Int` would yield a value of 6

## Explicit casting

It's possible to explicitly casting a variable to another type (if supported).

Widening or narrowing will be performed accordingly.

### Syntax

```
<value> as <Type>
```

```ruby
69 as Real -> r Real # widening
6.9 as Int -> i Int # narrowing
"420.69" as Real -> r # "narrowing"
Point.<x:1 y:2> as Point3D -> p3d Point3D # widening
Point3D.<x:1 y:2 z:3> as Point -> p Point # narrowing
```

@candidate alternative syntax

```ruby
Real.of(69n)
Point3D.of(Point.<>)
```

## Type conversion table

| Symbol | Meaning                                     |
| ------ | ------------------------------------------- |
| =      | Identity                                    |
| w      | Wideneable                                  |
| n      | Narrowable                                  |
| W      | Wideneable if its components are wideneable |
| N      | Narrowable if its components are narrowable |
| !      | Operation needs explicit cast               |


| from \\ to | Void | Type | Bool | Natural | Int | Real | Text |
|:----------:|:----:|:----:|:----:|:-------:|:---:|:----:|:----:|
|   Void     |   =  |   w  |   w  |    w    |  w  |   w  |  w   |
|   Type     |      |   =  |      |         |     |      |      |
|   Bool     |      |      |   =  |         |     |      |      |
|  Natural   |      |      |      |    =    |  w  |   w  |      |
|    Int     |      |      |      |    n!   |  =  |   w  |      |
|   Real     |      |      |      |    n!   |  n! |   =  |      |
|   Text     |      |      |      |         |     |      |   =  |

| from \\ to | Void | List | Map  | Function | Tuple | Record | Struct |
|:----------:|:----:|:----:|:----:|:--------:|:-----:|:------:|:------:|
|   Void     |  =   |  w   |  w   |    w     |   w   |   w    |   w    |
|   List     |      | N! W |      |          |       |        |        |
|    Map     |      |      | N! W |          |       |        |        |
| Function   |      |      |      |   N! W   |       |        |        |
|   Tuple    |      |      |      |          |  N! W |   W    |   W    |
|  Record    |      |      |      |          |   N!  |  N! W  |   W    |
|  Struct    |      |      |      |          |   N!  |   N!   | N! W!  |

## Tuples, Records and Structs

Since the widening/narrowing is crucial for type inference, Tuples, Records and
Structs require some additional attention as they have some differences.

In order to quickly understand why they behave the way they do, ask yourself:
*what information does this data carry?*

- `<1 2 3 "foo">` is a tuple with tree Int and a Text

  ```ruby
  <1 2 3 "foo"> = <1 2 3 "foo"> -> _out # are equal
  <1 2 3 "foo"> != <"foo" 1 2 3> -> _out # are NOT equal
  ```

- `<a:1, b:2, c:3, foo:"foo">` is a record with tree Int fields named a, b, c
respectively and one Text field named foo

  ```ruby
  <a:1 b:2 b:3 foo:"foo"> = <a:1 b:2 c:3 foo:"foo"> -> _out # are equal
  <a:1 b:2 b:3 foo:"foo"> = <foo:"foo" b:2 a:1 c:3> -> _out # are also equal
  
  <a:1 b:2 b:3> != <x:1 y:2 z:3> -> _out # are NOT equal
  ```

- `Color.<r:1, g:2, b:3, foo:"foo">` is a struct Color which has a Int field
for the red, green and blue channels named r, g, b respectively, and one Text
field named foo *(eventually representing the name of the color)*<br>

  ```ruby
  Color.<r:1 g:2 b:3 foo:"foo"> = Color.<r:1 g:2 b:3 foo:"foo"> -> _out # equal
  Color.<1 2 3 "foo"> = Color.<foo:"foo" r:1 g:2 b:3> -> _out # equal
  
  Color.<1 2 3 "foo"> = <r:1 g:2 b:3 foo:"foo"> -> _out # equal
  Color.<1 2 3 "foo"> = <foo:"foo" r:1 g:2 b:3> -> _out # equal
  Color.<1 2 3 "foo"> != <x:1 y:2 z:3 foo:"foo"> -> _out # NOT equal
  
  Color.<1 2 3 "foo"> = <1 2 3 "foo"> -> _out # equal
  Color.<1 2 3 "foo"> != <"foo" 1 2 3> -> _out # NOT equal
  ```

- `Color.<r:1, g:2, b:3, foo:"foo">` is a struct Color which has a Int field
for each red, green and blue channel a field representing the common name of
the color<br>
  `Rgb.<r:1, g:2, b:3, foo:"foo">` is a struct Rgb which has a Int field
for each red, green and blue channel a field representing the common name of
the color<br>
  `Point.<x:1, y:2, z:3, foo:"foo">` is a struct Point which has a tree Int
field for each dimension and a label

  ```ruby
  Color.<> != Point.<> -> _out # NOT equal
  Color.<1 2 3 "foo"> != Point.<1 2 3 "foo"> -> _out # NOT equal

  Color.<> != Rgb.<> -> _out # NOT equal
  Color.<1 2 3 "foo"> != Rgb.<1 2 3 "foo"> -> _out # NOT equal (despite having equal fields)

  Color.<> = Rgb.<> as Color -> _out # equal
  Color.<> = Point.<> as Color -> _out # equal
  ```

Let's get back to widening.

### Tuples

If a tuple is a subset of another tuple, record or struct, then it can be
safely widened to it, with "subset" meaning that **it has less or equal amount
of fields of narrower or equal type in the same order**.
- `<69 true "foo">` can be widened to a tuple, record or struct with signature
`<a Real, b Boolean, c Text, d Int>`
- `<true 69 "foo">` canNOT be widened to a tuple, record or struct with
signature `<a Real, b Boolean, c Text>`

### Records

If a record is a subset of another record or struct, then it can be
safely widened to it, with "subset" meaning that **it has less or equal amount of
equally named fields of narrower or equal type**.<br>
- `<b:true a:69 c:"foo">` can be widened to a record or struct with signature
`<a Real, b Boolean, c Text, d Int>`

### Struct

Structs can only be (losslessly) widened to structs of the same type (e.g. a
`Color` can only be widened to a `Color`)

This is a unique case of lossy widening.<br>
Let's define two structs `Color` and `Point` (with poorly named fields for the
sake of the example)

```ruby
Color<a Int, b Int, c Int>
Point<a Int, b Int, c Int>
```

Despite having the same fields with the same types, one cannot be widened to
the other without losing information: what the struct itself represents.<br>
In the example, one represents a color, the other a position in a 3D coordinate
system; a list `[Color.<1 1 1>, Point.<1 1 1>]` wouldn't make sense.

If you're ok with losing such information, widening between different structs
can still be achieved via explicit casting

```ruby
Color<r Int, g Int, b Int>
Rgb<r Int, g Int, b Int>

Color.<> as Rgb -> _out
Rgb.<> as Color -> _out
```

# Type inference

In certain scenarios the type of a value is not known, so it's necessary to
infer it. Giovi relies on types widening information to infer the correct type.

Unlike other object oriented languages where a list of a `Natural`, `Integer`
and `Real` may be inferred to be a list of `Number`, Giovi will infer the
widest type. Let's create a list as an example.

```ruby
_out <- [69n 420 6.9]
```

Here we have a list of a `Natural`, a `Int` and a `Real`, so the list entry
type will be `Real` since it's the widest among the entries.<br>
All other entries will be widened accordingly to ensure type safety.
So the list will finally be equal to `[69.0 420.0 6.9]`

The same applies to other complex scenarios.

```ruby
Person <name Text, age Natural>
Account <money Real, isLocked Bool>

# Each person can have multiple accounts
bankAccounts [Person : [Account]] <- [
	Person.<"Simon" 24n> : [Account.<6.9 false> Account.<420000 true>]
	<name:"Jake" age:19n> : [<money:20.5>]
	<"Joe" 69n> : [<100_000, false>]
]
```

## @candidate Constants type inference

```ruby
constant LIGHT_SPEED 299792458n
constant EARTH_GRAVITY 9.81
constant BEST_LANGUAGE "Giovi"
constant RED Color.<255 0 0>
constant NAME_LIST ["Simone" "Alessio" "Giada" "Francesca"]
```

## @candidate List type inference

```ruby
listOfInteger [] <- [-1 0 4 5]     # [Int]
listOfReal [] <- [1n 2 3.14]       # [Real]
listOfText [] <- ["Luca" "Paolo"]  # [Text]
listOfBool [] <- [true false true] # [Bool]
listOfColor [] <- [ # [Color]
	<2 2 2>
	Color.<1 1 1>
	<r:3 g:3 b:3>
]
```

# Type checking

It's possible to check the type of a value

## Syntax

```
<value> is <Type>
```

```ruby
if someVariable is Int do {
	"someVariable is an integer with value ${someVariable}" -> _out
}
if someVariable {
	is Int do "It's integer" -> _out
	is Real do "It's real" -> _out
	is [Int] do "It's a list of integer" -> _out
}
```

The operator can be negated with the `not` keyword

```ruby
if someVariable is not Int do {
	"It's not an integer" -> _out
}
```

which is the same but should be preferred to this

```ruby
if not {someVariable is Int} do {
	"It's not an integer" -> _out
}
```

### @candidate Check type and cast

When checking variable type, it's often needed to cast it

```ruby
if color {
	is RGB do {
		color as RGB -> c RGB
		"${c.r} ${c.g} ${c.b}" -> _out
	}
	is ARGB do {
		color as ARGB -> c ARGB
		"${c.r} ${c.g} ${c.b} ${c.a}" -> _out
	}
}
```

It's possible to use variable declaration syntax to improve readability

```ruby
if color {
	is c RGB do "${c.r} ${c.g} ${c.b}" -> _out
	is c RGBA do "${c.r} ${c.g} ${c.b} ${c.a}" -> _out
}
```

Note that it's not possible when the `is` operator is negated

@candidate The lifetime of the variable is limited to the true branch scope

```ruby
color RGB
if color is c RGB {
	c.r -> _out
} else {
	# variable c not defined here
}

if ! color is c RGB {
	# variable c not defined here
} else {
	c.r -> _out
}
```

@candidate The `is` operator can also be used for deconstruction of a struct

```ruby
if color {
	is <r Int, g Int, b Int> do "Do something with $r $g and $b" -> _out
	is <r Int, b Int> do "I only need $r and $b" -> _out
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
constant LIGHT_SPEED Natural <- 299792458n
constant EARTH_GRAVITY Real <- 9.81
constant BEST_LANGUAGE Text <- "Giovi"
constant RED Color <- <255 0 0>
constant NAME_LIST [Text] <- ["Simone" "Alessio" "Giada" "Francesca"]
```

# Default value

TODO: this is rather important lol Expand this section

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

A variable's default value (but only at declaration)

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

You can also get a variable default value using the dot notation

```ruby
someNumber Int default 69
someText Text default "default text"
someBoolean Bool default true

someNumber.default -> _out  # 69
someText.default -> _out    # "default text"
someBoolean.default -> _out # true
```

Doing the same on a Type will instead return the default value of a variable of
that type, which might be useful to check wether or not a variable's default
has been overridden

```ruby
Natural.default -> _out # 0n
Int.default -> _out     # 0i
Real.default -> _out    # 0r
Text.default -> _out    # "" (empty string)
Bool.default -> _out    # false

someNumber Int default 69
if someNumber.default != Int.default do {
	"someNumber's default has been overriden" -> _out
}
```

<!-- TODO: combine this with the .type candidate
if someVariable.default != someVariable.type.default do {}
-->

## Struct default value

Struct default value is a struct with all its fields set to their respective
default value

```ruby
someColor Color
<255 255 0> -> someColor
default -> someColor  # This will set someColor to <0 0 0>
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

A default value of a specific attribute can be accessed via the struct type

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
name Text
if name {

	= "Simone" do "hey it's Simone!" -> _out

	= "Mario" do {
		"heyo Mario" -> _out
		"where is Luigi?" -> _out
	}

	= "Luigi" do -> "heyo green Mario!" -> _out

} else {
	"greetings $name" -> _out
}
```

You can also use common boolean operators to check for multiple conditions.<br>
(Line breaks and whitespaces don't matter)

```ruby
number Int
if number {

	# if equal to 69 or 420
	= 69
	| = 420
	do "Nice!" -> _out

	# if greater than 100 and less than 999
	> 100
	& < 999
	do "big boi" -> _out

}
```

Textual boolean operators are allowed

```ruby
number Int
if number {

	= 69 or = 420 do "Nice!" -> _out

	> 100 and < 999 do "big boi" -> _out

}
```

Exhaustivenes and branch precedence are not considered, so be mindful of the
branch order, since they're evaluated in the same order as they're declared and
some branch may become unreachable if it's dominated by a previous one

```ruby
someNumber Int <- 69
if someNumber {
	< 50 do {}

	# NOTE: unreachable branch
	= 69 do {}
}
```

You can also "guard" a branch with a boolean expression.

```ruby
list [Int] <- [ 1 2 3 4 ]

if list {

	# if contains 69 but only when elements count is less than 100
	=~ 69 when list@% < 100 do {}

	# if contains 69 but only when someFunction() returns 420
	=~ 69 when someFunction() = 420 do {}

	# if contains 69
	=~ 69 do {}

}
```

Let's see some more complex examples of the if statement

```ruby
list [Int] <- [ 1 2 3 4 ]

if list {

	# if equal to numbers' default (empty list)
	= default do {}

	# if equal to [1 2 3]
	= [1 2 3] do {}

	# if equal to [1 2 3 4]
	# or equal to [4 5 6 7]
	= [1 2 3 4]
	| = [4 5 6 7]
	do {}

	# if equal to [1 2 3 4]
	# or if contains 69
	# or if contains 420
	# but only when someOtherVariable = 69
	= [1 2 3 4]
	| =~ 69
	| =~ 420
	when someOtherVariable = 69
	do {}

	# if equal to [1 2 3 4]
	# or if contains 69
	# or if contains 420
	= [1 2 3 4]
	| =~ 69
	| =~ 420
	do {}

	# if equal to [1 2 3 4] or if contains both 69 and 420
	= [1 2 3 4] or { =~ 69 and =~ 420 } do {}
	
	# if contains 69 and contains either 6 or 9
	=~ 69 and { =~ 6 or =~ 9} do {}

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
	= default do "it's black" -> _out
	= red do "it's red" -> _out
	= <240 10 10> do "it's redish" -> _out
	= <255 default 69> do "255, default green, 69" -> _out
	= white | = <200 200 200> do "it's white or grey" -> _out
	= <_ _ 69> do "any red, any green, blue of 69" -> _out
	= <_ _ _ _> do "It has at least 4 fields" -> _out
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

It's like a usual for-each loop, but on steroids; when you iterate over a map,
you can provide two identifiers: one for the key and one for the value.

```
for <key iterator> : <value iterator> in <map> do <statement>
```

```ruby
for key : value in ["Simone":69 "Luca":420 "Paolo":10] do {}
```

Nested maps can also be iterated with a single for statement.

```ruby
graph [Text : [Text : Int]] <- [
	"a" : ["b":5 "e":3]
	"b" : ["a":5 "c":1 "d":9 "f":2]
	"c" : ["b":1 "e":6]
	"d" : ["b":9 "e":7]
	"e" : ["a":3 "c":6 "d":7 "f":8]
	"f" : ["b":2 "e":8]
]
for nodeA : [nodeB : edgeCost] do {
	"$nodeA ---$edgeCost---> $nodeB" -> _out
}
```

This would be the same of doing two nested for loops

```ruby
for nodeA : edges in graph do {
	for nodeB : edgeCost in edges do {
		"$nodeA ---$edgeCost---> $nodeB" -> _out
	}
}
```

A placeholder (underscore `_`) can be used in case an iterator is not needed

```ruby
for _ in list do {}
for _ : value in map do {}
for key : _ in map do {}
```

The for loop is also capable of deconstructing structs and tuples.

```
for < <field iterator> > in <list of struct> do <statement>
for <struct iterator> < <field iterator> > in <list of struct> do <statement>
```

```ruby
Color <red Int, green Int, blue Int>
colors [Color] <- [<0 255 0> <55 0 255> <255 255 255>]  

for <red green blue> in colors do {
	"The color is made of $red $green $blue" -> _out
}

for color <red green blue> in colors do {
	"The color $color is made of $red $green $blue" -> _out
}
```

Nested structs can also be deconstructed

```ruby
Foo<a Int, b Int, c Int>
Bar<x Int, y Int, z Foo>
listOfNestedStruct [Bar] <- [
	Bar.<1, 1, Foo.<1, 1, 1>>,
	Bar.<2, 2, Foo.<2, 2, 2>>,
	Bar.<3, 3, Foo.<3, 3, 3>>
]
for <x, y, z <a b c>> in listOfNestedStruct do {
	"{
	Bar is made of:
		- $x
		- $y
		- $z which is made of:
			- $a
			- $b
			- $c
	}" -> _out
}
```

Deconstructing can also occur in a map iteration as a value (or eventually as a
key too, or both)

```ruby
mapOfFoo [Text : Foo]

for key : <a b c> in mapOfFoo do {
	"The key $key is mapped to <$a $b $c>" -> _out
}
```

Deconstructing is done via field names, so a subset of the fields
can also be used; the order doesn't matter.

```ruby
Color <red Int, green Int, blue Int>
colors [Color]

for <blue red> in colors do {}
```

@candidate Explicit deconstructing method

positional deconstructing

```ruby
for <red _ blue> in colors do {}
```

named fields deconstructing

```ruby
for <.blue .red> in colors do {}
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
	"Hello World" -> _out
}

greetPerson(name Text, surname Text) {
	"Greetings $name, $surname" -> _out
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
	"My name is $name" -> _out
	"My age is $age" -> _out
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
# it's equivalent of writing "name Text default Text.default"

greet()
greet("Simone")
```

Required parameters have to be specified.<br>
It's possible to mix optional and required parameters in the signature

```ruby
processPizzaOrder(
  type Text default "Margherita",
  tableNumber Int,
  withPineapple Bool default false,
  ) {
  	if withPineapple do return
	makePizza(type) -> pizza Pizza
	serve(pizza, tableNumber)
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
processPizzaOrder(_, 69, true) # "Margherita" with pineapple to table 69
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

## Function invocation labels

Sometimes you have to decide whether to name a parameter to either favor
readability in the function body...

```ruby
processPizzaOrder(
	type Text,
	table Int,
	hasPineapple Bool,
) {
	if hasPineapple do return
	makePizza(type) -> pizza Pizza
	serve(pizza, table)
}

processPizzaOrder(
	type: "Diavola",
	tableNumber: 69,
	hasPineapple: false
)
```

... or at invocation

```ruby
processPizzaOrder(
	ofType Text
	atTableNumber Int,
	withPineapple Bool,
) {
	if withPineapple do return
	makePizza(ofType) -> pizza Pizza
	serve(pizza, atTableNumber)
}

processPizzaOrder(
	ofType: "Diavola",
	atTableNumber: 69,
	withPineapple: false
)
```

To improve readability, function formal parameters can "override" the label, so
that a nicer signature is exposed at invocation, while still being readable in
the implementation body

```ruby
processPizzaOrder(
	ofType: type Text,
	atTable: tableNumber Int,
	withPineapple: hasPineapple Bool,
) {
	if hasPineapple do return
	makePizza(type) -> pizza Pizza
	serve(pizza, tableNumber)
}

processPizzaOrder(
	ofType: "Diavola",
	atTable: 69,
	withPineapple: false
)
```

## @candidate Overloading

Function overloading is possible, as long as all required parameters are
different (different name and different type)

```ruby
makePizza(type Text) { }
makePizza(type Text, withPineapple Bool) { }
makePizza(ingredients [Text]) { }

# ERROR makePizza(type Text) already defined
makePizza(type Text, withPineapple Bool default false) { }
```

## @candidate Statement functions

Functions can have a single statement instead of a body; in case the function
returns a value, its return type can be omitted as it will be inferred

```ruby
getName() => "Simone"
sum(x Int, y Int) => x + y
isEven(x Int) => x % 2 = 0
greet(name Text) name -> _out
```

# Functions reference

The reference of a function is used to refer to the function itself.<br>
You can get a reference of a function with the `::` (double colon).

```ruby
sum(x Int, y Int) => Int {
	=> x + y
}

::sum -> _out # will print sum(x Int, y Int) => Int
```

It can be stored in variables and struct, and can be passed as a parameter to
other functions as well, just like any other type.<br>
It can be invoked like a normal function

```ruby
sum(x Int, y Int) => Int { => x + y }
sub(x Int, y Int) => Int { => x + y }
mul(x Int, y Int) => Int { => x * y }
div(x Int, y Int) => Int { => x / y }

someOperation ::(Int, Int) => Int

::sum -> someOperation
someOperation(5, 2) -> _out # 5 + 2

::sub -> someOperation
someOperation(5, 2) -> _out # 5 - 2

::mul -> someOperation
someOperation(5, 2) -> _out # 5 * 2

::div -> someOperation
someOperation(5, 2) -> _out # 5 / 2
```

To ensure type safety, the function signatures must be compatible (i.e. equal
or narrower)

```ruby
sum(x Int, y Int) => Int { => x + y }
div(x Real, y Real) => Real { => x + y }
greet(someone Text) { "hello $someone" -> _out }

# a ref of a function that takes two Real parameters and return a Real
someFunctionRef ::(Real, Real) => Real

::div -> someFunctionRef
someFunctionRef(690.0, 10.0) -> _out # 690 / 10

::sum -> someFunctionRef
# OK: sum signature can be widened to someFunctionRef signature
someFunctionRef(49, 10) -> _out # 49 + 10

::greet -> someFunctionRef
# ERROR: incompatible function signatures
```

Anonymous function references can also be defined

```
::{<statements>}
::() {<statements>} 
::(<parameters>) {<statements>} 
::(<parameters>) => <return type> {<statements>}
```

```ruby
someFunctionRef ::()

# Assign an anonymous function reference to someFunctionRef
someFunctionRef <- ::{
	"hello world" -> _out
}

# I can now invoke someFunctionRef
someFunctionRef()
```

Like other data types, a function reference can have a default value (a default
implementation in this case)

```ruby
someFunctionRef ::(txt Text) default ::(txt Text) {
	txt -> _out
}
```

## Signature conversion

Like any other type, a function reference type can be widened/narrowed/casted
where possible; they behave very similarily to [product types](#product-types):
a function reference can be converted if its parameters and return type can be
converted

```ruby
someFunctionRef    ::(x Real,    y [Real]) => Real
someFunctionRef <- ::(x Natural, y [Int])  => Int { => 69 }
```

In this example, `x` will be widened from `Natural` to `Real`, `y` from `[Int]`
to `[Real]` and the return type from `Int` to `Real`.

Some more examples

```ruby
someFunctionRef    ::(x Real,    y [Real]) => Real

someFunctionRef <- ::(x Natural, y [Int])  => Int { => 69 }
someFunctionRef <- ::(x Natural) => Int { => 69 }
someFunctionRef <- ::(y [Natural]) => Natural { => 69n }
someFunctionRef <- ::(x Real) { => 69n }
someFunctionRef <- ::{ => 69 }
```

TODO: clarify about parameters optionality and labels
Note that an optional parameter cannot be widened to a non-optional parameter;
the opposite is possible.

```ruby
greet ::(someone Text) => Text
goodMorning(someone Text) => Text {
	=> "Good morning $someone"
}
goodNight(someone Text default "") => Text {
	if someone = default do => "Good night everybody!"
	=> "Good night $someone"
}
greet <- ::goodMorning # OK!
greet <- ::goodNight # ERROR!
```

```ruby
greet ::(someone Text default "")
greet <- ::goodMorning # OK!
greet <- ::goodNight # OK!
```

A function reference with many parameters, a return type and a default
implementation could be very verbose and cluttered

```ruby
# A verbose definition of a function reference which takes a Int, return an Int,
# with a default implementation which returns the sum of the parameters

# identifier    ::(params)       => return         ::(params)       => return
someFunctionRef ::(x Int, y Int) => Int    default ::(x Int, y Int) => Int {
	=> x + y
}
```

so leveraging type widening, the declaration can be much more concise

```ruby
someFunctionRef ::(x Int, y Int) => Int default ::{
	=> x + y
}
```

## Default value of a function ref

The default value of a function ref will be an "empty" function with no body.<br>
If the signatures has a return value, its default will be returned instead

```ruby
Color <
	r Int default 69
	g Int
	b Int
>
someFunctionRef ::() => Color
someFunctionRef() -> _out # will print Color.<69 0 0>
```

# @candidate Other

## @candidate Infinity and NaN

```ruby
inf -> _out
-inf -> _out
nan -> _out
```

## @candidate Module system

A module is a container for code; each file is implicitly a module, whose name
is the filename containing it.

```ruby
# Foo.giovi
"hello from Foo module" -> _out
constant SOME_CONSTANT Real <- 3.14
someFunction() => Int {
	"hello from Foo.someFunction" -> _out
	=> 69
}
```

Nested modules can be defined with the `module` keyword.

```ruby
# someDir/Bar.giovi
"hello from Bar module" -> _out
SomeStruct <x Int, y Int>
module SomeModule {
	someBazFunction() {}
}
```

### Importing a module

Before using a module you will have to import it with the `import` statement.

```ruby
import Foo
```

You can also import multiple modules using the list syntax

```ruby
import [
	Foo
	someDir.Bar
	someDir.Bar.SomeModule
]
```

You can now access the module components (e.g. functions, constants, variables
etc.) using the dot notation.

```ruby
Foo.PI -> _out
someStruct someDir.Bar.SomeStruct
```

A module can be aliased as a "typename" for easier access

```ruby
import giovi.lang.Random as Random
Random.real() -> _out
Random.integer() -> _out

import [
	someDir.Bar as Bar
	someDir.Bar.SomeModule as SomeModule
]
```

#### Module lifetime

The `import` statement can be performed anywhere just like any other statement.
The imported module lifetime, like for variables and other definitions, will be
bound to the scope in which the import statement has been invoked. This allows
you to defer the import of a module as late as you wish:

```ruby
# Main.giovi
import giovi.lang.Random as Random
# Random is imported as soon as Main.giovi is executed
Random.float() -> probability Real
if probability > 0.5 do {
	import giovi.lang.Math as Math
	# Math is now loaded and available to use
	Math.floor(6.9) -> _out
}
# Math is no longer available
```

### Cycling	imports 

The import statement will throw an error when a cycle is detected

```ruby
# A.giovi
import B
```

```ruby
# B.giovi
import A
```

```ruby
# Main.giovi
import A # ERROR: cycle detected
```

## @candidate Launch entry point (args)

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

## @candidate Files

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
for line in f.lines() do line -> _out
```

## @candidate Regex

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
	regex.groups@0 -> _out
}
```

```ruby
Regex.replace("my text 69 lol", "^my (.*)", "something $1")
Regex.replace("my text 69 lol", "/^my (.*)/something $1/g")
```

## @candidate Parallel programming

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
	"yeah" > _out
	doSomethingBlocking();
}
join
```

## @candidate Aliasing

Alias a type, function or struct

```ruby
AVeryVerboseAndLongStructName <i Int>
alias AVeryVerboseAndLongStructName as SomeStruct
SomeStruct.() -> _out

aVeryLonglyNamedFunction() => Text { => "hello world" }
alias aVeryLonglyNamedFunction as f
f() -> _out

aVeryLonglyNamedVariable Int
alias aVeryLonglyNamedVariable as i
i -> _out
```

### @candidate Strict aliasing

loose (default)

```ruby
alias Int as SomeFlag
someFunction(f someFlag) {}
someFunction(0b1)
0b1 -> i Int
someFunction(i) # OK
```

strict

```ruby
strict alias Int as SomeFlag
someFunction(f someFlag) {}
someFunction(0b1)
0b1 -> i Int
someFunction(i) # ERROR or WARN
```

## @candidate Generics

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
		_out <- "${person.name} has ${person.money} and likes ${person.favoriteColor}"
	}
}

printFavColor(persons [Person{_}]) {
	for person in persons do {
		"${person.name} likes " ->+ _out
		if person {
			is p Person{Int} do p.favoriteColor > _out
			is p Person{RGB} do "${p.favoriteColor.r} ${p.favoriteColor.g} ${p.favoriteColor.b}" -> _out
		}
	}
}
```

```ruby
Optional{T} <value T>

doSomething(optional Optional{_}) {
	if optional {
		is opt Optional{Text} do opt.value -> _out
		is opt Optional{Int} do opt.value -> _out
	}
}
```

### @candidate Generics inheritance

```ruby
Box{T} <color Text, something T>
Box{Car} : CarBox < >
Box{T} : MagicChest{T} < >

cardboardBox Box{Book} <- <"brown" Book.<"Moby Dick">>
shelf Box{[Book]} <- <"black" [Book.<"Moby Dick"> Book.<"Metro 2033">]>
garage CarBox <- <"grey" Car.<"Ferrari">>
chest MagicChest{Gift} <- <"blue" Gift.<"socks">>
```

### @candidate Generics upper and lower bounds

```ruby
Color <name Text>
Color : RGB <r Int, g Int, b Int>
Color : CMYK <c Int, m Int, y Int, k Int>
# Upper bounded by color
Box{Color : T} <something T>

# Lower bounded by Color
Box{T : Color} <something T>
```

## @candidate If expression (ternary operator like)

Has to be exhaustive

```ruby
x Int <- if true yield 69 else 420
x Int <- if something {
	= "awf" yield 69
	= "awawfwf" yield 420
} else 69420
```

## @candidate Formatter directives

Special comment `#!` will be parsed by the formatter; uses the same syntax of
the language.

```ruby
#!disable()
"this will not be formatted" -> _out
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

## @candidate 1-based array indexing

### Accessing via index (1-based) vs accessing via offset (0-based)

```ruby
list [GioviText] <- "abcdefgh"@*

# INDEX
list@1 # "a"
list@8 # "g"
list@{-1} # "g"
list@{-8} # "a"
list@{list@{%}} # "g"
for i in 1..8 do list@i
for i in list@@ do list@i

# OFFSET
list.0 # "a"
list.7 # "g"

## the following are invalid
list.{-1} # would cause confusion with index
list.{-7} # makes no sense
list.{list@%} # syntax 

## what about a field called 'i'?
for i in 0..7 do list.i
```

## @candidate Struct querying

Something like xpath or jq? Or maybe language syntax itself?

## @candidate Product types destructuring

Destructuring done via narrowing

```ruby
Color <red Int, green Int, blue Int>
c Color
if true do {
	c -> <red blue>
	"$red $blue" -> _out
}
if true do {
	c -> <red Int, blue Int>
	"$red $blue" -> _out
}

if c {
	is <red blue> do "$red $blue" -> _out
	is <red Int, blue Int> do "$red $blue" -> _out
}
```

```ruby
getRecord() => <x Int, y Int, z Int> {
	=> <x: 69, y: 420, z: 42>
}
getRecord() -> <x y z>
getRecord() -> <x Int, y Int, z Int>
if getRecord() {
	is <x y z> do "$x $y $z" -> _out
	is <x z> do "$x $z" -> _out
	is <x _ z> do "$x $z" -> _out
	is <x Int, z Int> do "$x $z" -> _out
}
```

```ruby
getTuple() => <Int, Int, Int> {
	=> <69, 420, 42>
}
getTuple() -> <x y z>
getTuple() -> <x Int, y Int, z Int>
if getTuple() {
	is <x y z> do "$x $y $z" -> _out
	is <x Int, y Int, z Int> do "$x $y $z" -> _out
	is <x Int, _, z Int> do "$x $z" -> _out
}
```

## @candidate Emoji handling in Text

```ruby
"💩" -> _out
"💩"@% -> _out # should be 1
"💩"@0 -> _out # should be :poop:
"💩".0 -> _out # should be single char
"💩".1 -> _out # should be single char
```

## @candidate Forward declaration

Structs and functions in a scope will be visited first, so we can use them
before defining them

```ruby
someColor Color <- <255 255 255>
print(someColor)

print(c Color) {
	"{
	red: ${c.red}
	green: ${c.green}
	blue: ${c.blue}
	}" -> _out
}

Color <red Int, green Int, blue Int>
```

## @candidate Raw text

No interpolation and no escapes

```ruby
windowsPath Text <- `C:\some\path\to\some\file`
_out <- `{
	Writing \n will print the \ character and the n character
	}`
```

It can be used as an identifier for variables, functions, and types

```ruby
69 -> `the expected value` Int

`test that the + operator sums two numbers`() {
	assertThat(59 + 10).isEqualTo(`the expected value`) # is this Text or variable identifier?
}

`Some struct` <
	foo Int
	bar Int
>
```

## @candidate Condensed nested fields label

```ruby
Person <
	name Fullname <
		first Text
		second Text
	>
	prefs Preferences <
		color Color
		car Car <
			model Text
			paint Color
		>
	>
>

p Person <- <
	name.first: "Foo"
	name.second: "Foo"
	prefs.color: <255 0 0>
	prefs.car.model: "Ferrari"
	prefs.car.paint: <255 0 0>
>

# <
# 	name: <
# 		first: "Foo"
# 		second: "Foo"
# 	>
# 	prefs: <
# 		color: <255 0 0>
# 		car: <
# 			model: "Ferrari"
# 			paint: <255 0 0>
# 		>
# 	>
# >
```

## @candidate Union type

```ruby
x Int|Text
x <- 69
x <- "hello world"

someFun(x Int|Text) => Int|Text {
}

if x {
	is not y Int|Text do => "$y is neither Int nor Text" -> _out
}
```

## @candidate Error handling

### @candidate Exceptions

Exceptions are used to handle unexpected bad code paths. All code related to
exception handling should be "foreign code", extraneous to the business logic.

```
try <statement or block>

try <statement or block> if catch <identifier> <Type> do {}

try <statement or block>
if catch <identifier> <Type> do {}
else if catch <identifier> <Type> do {}
else {}

try <statement or block> if catch <identifier> {
	is <Type> do {}
	is <Type> do {}
} else {}
```

```
~> Exception
throw Exception
```

```ruby
writeToFile(message Text, filepath Text) ~> LogException {
	if message =~ F_WORD do throw <message: "No swearing!">
	try open(filepath) -> file File if catch ex {
		is NoFile do throw <message: "File doesn't exists">
		is FileLocked do throw <message: "Can't open file", cause: ex>
		# if SomeOtherIOException do throw <cause: ex>
	}
	std.fs.echo(message, file)
}

try writeToFile("hello world", "somefile.log")
if catch ex LogException do {
	ex.message -> _out
	ex.cause.message -> _out
}
```

The catch expression can be non-exhaustive. The uncaught exceptions will be
wrapped as a cause and re-thrown

### @candidate Errors

Errors are instead used for expected good/bad code paths, and they are part of
the business logic

_APIs design still to be defined_

```ruby
Optional{T} <value T, found Bool>
fetch() => Optional{Int} { => Optional.<69, true> }
if fetch() = <value: _, found: true> do "A value $value has been found" -> _out
```

à la Rust

```ruby
Result{T, E} <
	Ok <value T>
	Err <error E>
>
parseDate(text Text) => Result{Date, ParsingError} {
	if text = "" do => Err{ParsingError}.<"Input is empty">
	parsedDate Date # blah blah blah
	=> Ok{Date}.<parsedDate>
}
if parseDate("69/69/69") {
	= <value:_> do value -> _out
	= <error:_> do error -> _err
}
```

à la Go

```ruby
parseDate(text Text) => <value Date, err ParsingError> {
	if text = "" do => <err: <"Can't parse empty string">>
	parsedDate Date # blah blah blah
	=> <value: parsedDate>
}
parseDate("69/69/69") -> <value, err>
if err != default {
	err -> _err
}
```

union types

```ruby
parseDate(text Text) => Date|ParsingError {
	if text = "" do => ParsingError.<"Can't parse empty string">
	parsedDate Date # blah blah blah
	=> parsedDate
}
if parseDate("69/69/69") {
	is err ParsingError do err -> _err
	is date Date do date -> _out
}
```

## @candidate Deferring

```ruby
someFunc() => Int {
	someFile File.<"some/path/to/file">
	defer someFile.close()
	# ...
	=> 69
	# someFile.close() will be invoked
}
```

## @candidate Interfaces and implicit implementation

```ruby
interface Vec <
	self magnitude() => Real
	self normalize() => Vec
	self distance(to Vec) => Real
>

Vec2 <
	x Real
	y Real

	self magnitude() => Real {
		=> {x^2 + y^2}^{1/2}
	}

	self normalize() => Vec {
		mag Real <- magnitude()
		=> Vec2.<x/mag y/mag>
	}

	self distance(to Vec) => Real {
		=> {{self.x - to.x}^2 + {self.y - to.y}^2}^{1/2}
	}
>

v Vec <- Vec2.<69 420>
v.magnitude() -> _out
```


## @candidate Multiple inheritance

```ruby
Car <
	licensePlate Text
	fuelTankSize Int
	wheels Int default 4
>
Bike <
	licensePlate Text
	wheels Int default 2
>

Car,Bike : ApeCar <
	wheels Int default 3 # NOTE: default is mandatory since we don't know which one to inherit
>
```


```ruby
Color1 <r Int, g Int, b Int>
Color2 <r Natural, g Natural, b Natural>
Color1,Color2 : Rgb <
	# all Int
>
```

```ruby
Food <calories Int>
Edible <calories Text>

Food,Edible : Apple <>
# ERROR: can't inherit both calories
```

## @candidate Unified loop keyword

```ruby
loop {
	"hello world" -> _out
}
loop "hello world" -> _out
loop someFunction -> _out
loop i in 0..10 do "hello world $i" -> _out
loop entry in list do "hello world $i" -> _out
loop key : value in map do "hello world $key : $value" -> _out
loop <r g b> in colors do "hello world <$r $g $b>" -> _out
loop color<r g b> in colors do "hello world <$r $g $b>" -> _out
```

## @candidate Casting custom implementation

```ruby
SomeStruct <
	someField Bool
>

MyStruct <
	myField Int

	$as(SomeStruct) => SomeStruct {
		=> SomeStruct.<someField: myField >= 1>
	}

>
```

## @candidate Operators override

```ruby
Vector <
	x Real
	y Real
	z Real

	self $plus(rhs Vector) => Vector {
		=> Vector.<
			x: self.x + rhs.x
			y: self.y + rhs.y
			z: self.z + rhs.z
		>
	}

	self $minus(rhs Vector) => Vector {
		=> Vector.<
			x: self.x - rhs.x
			y: self.y - rhs.y
			z: self.z - rhs.z
		>
	}

	self $multiply(rhs Real) => Vector {
		=> Vector.<
			x: self.x * rhs
			y: self.y * rhs
			z: self.z * rhs
		>
	}

>

<69 1 420> -> v1 Vector
<0 1 0> -> v2 Vector

v1 + (v2 * 2) -> _out
```

## @candidate Function arguments as a record

Like in math, invoking a function with multiple arguments it's like saying it
has a domain of a Cartesian product (a record).
This would allow using the same symbols for functions and record

```ruby
# f : (IxN) --> R
#     (i,n) |-> r
f(i Int, n Natural) => Real {}

# f : (Ix(NxN)) --> R
#     (i,(n,m)) |-> r
f(i Int, record <n Natural, m Natural>) => Real {}
f(i Int, record (n Natural, m Natural)) => Real {}
f(i Int, record Record) => Real {}
```

## @candidate Build/Packaging (and eventually compile) tool

```ruby
import [
	giovi.build
	giovi.build.licenses
	giovi.build.versioning
	giovi.build.packaging.formats
]

build() => Build {
	=> <
		group: "it.simonvic"
		name: "MyApplication"
		version: <0,1,0>
		description: "{
			A sample application that does nothing.
			Pretty interesting, right?
			}"
		url: "simonvic.it"
		author: "simonvic"
		license: MIT
		main: "main.giovi"
		dependencies: [
			"test" : [
				<id: "org.gunit.gupiter" version: <1,69,0>>
			]
			"compile" : [
				<id: "it.simonvic.MyLibrary" version: <4,2,0>>
				<id: "org.some.useful.Library" version: <"2024.exp">>
			]
		]
		onBuild: ::{
			"I'm building MyApplication!" -> _out
		}
	>
}

package() => Package {
	=> <
		format: JAR
		include: ["*.*"]
		exclude: [".git" ".gitignore"]
		onPackage: ::(package File) {
			"Package complete" -> _out
			"Publishing the package" -> _out
			publish(package, "https://some.website.com")
			"Done" -> _out
		}
	>
}
```

## @candidate Function documentation alternatives

default

```ruby
#? Sum two numbers
#? @param x Int
#? @param y Int
#? @return sum of x and y
sum(x Int, y Int) => Int {
	=> x + y
}
```

inside body

```ruby
sum(x Int, y Int) => Int {
	#? Sum two numbers
	#? @param x Int
	#? @param y Int
	#? @return sum of x and y
	=> x + y
}
```

inline

```ruby
sum(#? Sum two integer numbers
	x Int, #? Some random value
	y Int, #? Some other random value
) => Int #? Returns the sum of x and y
{
	=> x + y
}
```

## @candidate Pipe operator

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


## @candidate ref keyword

```ruby
ref {}
ref (){}
ref ()
ref () {} 
ref () => Int {}


f ref() <- ref {}

foo(){}
ref foo -> _out
```

```ruby
foo(ref x Int) => Int { }
x Int
foo(ref x)
```

## @candidate super abstract types

```ruby
n Number
n <- 69n
n <- 69i
n <- 69r

a Any
a <- 69
a <- "hello"
a <- [1 2 3]
a <- <"hello" 69 true>
```

## @candidate Range return

```ruby
probability() => 0r..1r {
	=> 0.69 # OK
	=> 2.69 # ERROR: not in range
}
```

This candidate would collide with Range type candidate

```ruby
probability() => 0r..1r {
	=> 0.69 # ERROR: expecting Range<Int> but real returned
}
```


## @candidate self support in function refs

```ruby
Foo <
	i Int

	foo ::(self) => self default ::(self) => self {
		=> self.i
	}
>
```

<!-- 
vim: noet
-->
