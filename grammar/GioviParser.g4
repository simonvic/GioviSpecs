parser grammar GioviParser
	;

options {
	tokenVocab = GioviLexer;
}

/*
 @header { package it.simonvic.giovi; }
*/

begin: program EOF;

program: statement*;

block: '{' program '}';

statement
	: ifStatement
	| repeatStatement
	| forStatement
	| returnStatement
	| breakStatement
	| continueStatement
	| redirection
	| expression
	| structDefinition
	| constantDeclaration
	| varDeclaration
	| functionDeclaration
	;

repeatStatement: REPEAT (IF conditionalExpression)? block;

forStatement: FOR identifier IN expression block;

returnStatement: (expression | conditionalExpression)? RETURN;

breakStatement: BREAK;

continueStatement: CONTINUE;

redirection
	: (expression | parenthesizedConditionalExpression) bop = BRACKET_ANGULAR_CLOSE destinations
	| expression bop =
	(
		REDIRECTION_DIVISION
		| REDIRECTION_MULTIPLICATION
		| REDIRECTION_PLUS
		| REDIRECTION_MINUS
	) identifier
	;


constantDeclaration: CONSTANT identifier type expression;

varDeclaration: identifier type;

defaultDefinition: defaultLiteral expression;

////////////////////////////////////////////////
// STRUCT

structDefinition
	: (identifier ':')? identifier '(' (structAttributeDefinition | nestedStructDefinition)+ ')'
	;

nestedStructDefinition: identifier structDefinition;

structAttributeDefinition: identifier type defaultDefinition?;

structCreation: '(' structAttribute+ ')';

structAttribute: (identifier ':')? expression;


////////////////////////////////////////////////
// FUNCTIONS

functionDeclaration: identifier '(' formalParameters? ')' (RETURN type)? block;

formalParameters: formalParameterDefinition (',' formalParameterDefinition)*;

formalParameterDefinition: identifier type defaultDefinition?;

functionCall: identifier '(' functionParameterList? ')';

functionParameterList: functionParameter (',' functionParameter)?;

functionParameter: (identifier ':')? expression;


////////////////////////////////////////////////
// FLOW CONTROL

ifStatement
	: IF conditionalExpression DO block (ELSE block)?
	| IF expression switchBlock (ELSE block)?
	;

switchBlock: '{' switchLabel+ '}';

switchLabel: caseMatch DO block;

caseMatch
	: '{' caseMatch '}'
	| op = ('<=' | '>=' | '>' | '<') expression
	| op = '&' conditionalExpression
	| op = '|' conditionalExpression
	| op = ('=' | '!=') expression
	| op = '~=' expression
	| op = '=~' expression
	| caseMatch bop = ('&' | '|') (caseMatch | conditionalExpression)
	;


////////////////////////////////////////////////
// EXPRESSIONS

expressionList: expression (',' expression)*;

expression
	: primary
	| functionCall
	| collectionAccess
	| listCreation
	| mapCreation
	| structCreation
	| expression bop = '.' (identifier | functionCall)
	| prefix = ('+' | '-') expression
	| prefix = ('~' | '!') expression
	| expression bop = '^' expression
	| expression bop = ('*' | '/' | '%') expression
	| expression bop = ('+' | '-') expression
	;

primary: parenthesizedExpression | literal | identifier;

parenthesizedExpression: '{' expression '}';

conditionalExpression
	: parenthesizedConditionalExpression
	| expression bop = ('<=' | '>=' | '>' | '<') expression
	| conditionalExpression bop = '&' conditionalExpression
	| conditionalExpression bop = '|' conditionalExpression
	| conditionalExpression bop = ('=' | '!=') conditionalExpression
	| expression bop = ('=' | '!=') expression
	| expression bop = '~=' expression
	| expression bop = '=~' expression
	| expression
	;

parenthesizedConditionalExpression: '{' conditionalExpression '}';

sequence: expression '..' expression ('..' expression)?;

////////////////////////////////////////////////
// DESTINATIONS

destinations
	: varDeclaration
	| identifier
	| primitiveDestination
	;

primitiveDestination
	: stdout
	| stderr
	;

stdout: (DEST_STDOUT | BACKSLASH);

stderr: DEST_STDERR;



type: (structType | primitiveType);

structType
	: primitiveStructType
	| identifier
	;

primitiveStructType
	: list
	| map
	;


////////////////////////////////////////////////
// COLLECTIONS

collectionAccess: identifier '[' collectionAccessor ']';
collectionAccessor
	: listAccessor
	| mapAccessor
	;


list: TYPE_LIST '[' type ']';
listCreation: '[' listEntries ']';
listEntries: listEntry*;
listEntry
	: expression
	| sequence
	;
listAccessor
	: '%'
	| '@'
	| expression
	;


map: TYPE_MAP '[' type ':' type ']';
mapCreation: '[' mapEntries ']';
mapEntries: mapEntry* ;
mapEntry: expression ':' expression;
mapAccessor
	: '%'
	| '@'
	| '*'
	| expression
	;



////////////////////////////////////////////////
// TYPES

primitiveType
	: TYPE_INT
	| TYPE_NATURAL
	| TYPE_BOOL
	| TYPE_REAL
	| TYPE_TEXT
	;

literal
	: integerLiteral
	| naturalLiteral
	| realLiteral
	| boolLiteral
	| textBlockLiteral
	| textLiteral
	| exactTextBlockLiteral
	| exactTextLiteral
	| nullLiteral
	| identifier
	| defaultLiteral
	;

identifier: IDENTIFIER;
integerLiteral: INTEGER_LITERAL;
naturalLiteral: NATURAL_LITERAL;
realLiteral: REAL_LITERAL;
boolLiteral: BOOL_LITERAL;
textBlockLiteral: TEXT_BLOCK_LITERAL;
textLiteral: TEXT_LITERAL;
exactTextBlockLiteral: EXACT_TEXT_BLOCK_LITERAL;
exactTextLiteral: EXACT_TEXT_LITERAL;
nullLiteral: NULL;
defaultLiteral: UNDERSCORE;