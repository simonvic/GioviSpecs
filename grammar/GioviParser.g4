parser grammar GioviParser;

options {
	tokenVocab = GioviLexer;
}

/*
 @header { package it.simonvic.giovi; }
*/

begin: program EOF;

program: statement*;

block: '{' statement* '}';

statement
	: ifStatement
	| switchStatement
	| repeatStatement
	| forStatement
	| returnStatement
	| breakStatement
	| continueStatement
	| redirection
	| structDefinition
	| constantDeclaration
	| varDeclaration
	| functionDeclaration
	| expression
	;

repeatStatement: REPEAT (IF expression)? block;

forStatement: FOR identifier+ IN collection=expression DO block;

returnStatement: expression? RETURN;

breakStatement: BREAK;

continueStatement: CONTINUE;

redirection
	: expression bop = '>' varDeclaration         #redirectionToVarDeclaration
	| expression bop = '>' primitiveDestination   #redirectionToPrimitiveDestination
	| expression bop = (
			'>'
			| REDIRECTION_DIVISION
			| REDIRECTION_MULTIPLICATION
			| REDIRECTION_PLUS
			| REDIRECTION_MINUS
		) identifier                              #redirectionToIdentifier
	;

constantDeclaration: CONSTANT identifier type expression;

varDeclaration: identifier type;

defaultDefinition: defaultLiteral expression;

////////////////////////////////////////////////
// STRUCT

structDefinition
	: (parentName=identifier ':')? structName=identifier '(' (structAttributeDefinition | nestedStructDefinition)+ ')'
	;

nestedStructDefinition: identifier structDefinition;

structAttributeDefinition: identifier type defaultDefinition?;

structCreation: (identifier ':')? '(' structAttribute+ ')';

structAttribute: (identifier ':')? expression;


////////////////////////////////////////////////
// FUNCTIONS

functionDeclaration: identifier '(' formalParameters? ')' (RETURN type)? block;

formalParameters: formalParameterDefinition (',' formalParameterDefinition)*;

formalParameterDefinition: identifier type defaultDefinition?;

functionCall: identifier '(' functionParameterList? ')';

functionParameterList: functionParameter (',' functionParameter)*;

functionParameter: (identifier ':')? expression;


////////////////////////////////////////////////
// FLOW CONTROL

ifStatement: IF expression DO ifBody=block (ELSE elseBody=block)? ;
	
switchStatement: IF expression switchBlock (ELSE elseBody=block)? ;

switchBlock: '{' switchLabel+ '}';

switchLabel: caseMatch DO block;

caseMatch
	: '{' caseMatch '}'                                     #parenthesizedCaseMatch
	| op = ('<=' | '>=' | '>' | '<') expression             #relationalCaseMatch
	| op = ('&' | '|') expression                           #booleanCaseMatch
	| op = ('=' | '!=') expression                          #equalityCaseMatch
	| op = ('~=' | '=~') expression                         #containmentCaseMatch
	| caseMatch bop = ('&' | '|') (caseMatch | expression )  #guardedCaseMatch
	;


////////////////////////////////////////////////
// EXPRESSIONS

//expressionList: expression (',' expression)*;

expression
	: '{' expression '}'                                     #parenthesizedExpression
	| expression bop = '.' (identifier | functionCall)       #dotExpression
	| collectionAccess                                       #collectionAccessExpression
	| listCreation                                           #listCreationExpression
	| mapCreation                                            #mapCreationExpression
	| structCreation                                         #structCreationExpression
	| functionCall                                           #functionCallExpression
	| prefix = ('+' | '-') expression                        #prefixedExpression
	| prefix = '!' expression                                #notExpression
	| expression bop = '^' expression                        #powerExpression
	| expression bop = ('*' | '/' | '%') expression          #multiplicativeExpression
	| expression bop = ('+' | '-') expression                #additiveExpression
	| expression bop = ('<=' | '>=' | '>' | '<') expression  #relationalExpression
	| expression bop = ('=' | '!=') expression               #equalityExpression
	| expression bop = ('~=' | '=~') expression              #containmentExpression
	| expression bop = ('&' | '|' ) expression               #boolExpression
	| primary                                                #primaryExpression
	;

primary: literal | identifier;

sequence: start=expression '..' end=expression ('..' step=expression)?;


primitiveDestination: '\\' identifier?;


type
	: collectionType
	| identifier
	;

collectionType
	: list
	| map
	;


////////////////////////////////////////////////
// COLLECTIONS

collectionAccess: identifier '[' collectionAccessor ']';
collectionAccessor
	: ('%' | '@' | '*')   #specialAccessor
	| expression          #expressionAccessor
	;


list: '[' type ']';
listCreation: '[' listEntries ']';
listEntries: listEntry*;
listEntry
	: expression
	| sequence
	;


map: '[' mapKeyType=type ':' mapValueType=type ']';
mapCreation: '[' mapEntries ']';
mapEntries: mapEntry* ;
mapEntry: mapKey=expression ':' mapValue=expression;



////////////////////////////////////////////////
// TYPES

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