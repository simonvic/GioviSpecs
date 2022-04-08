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
	| varDeclaration
	| functionDeclaration
	;

structDefinition
	: identifier '(' (
		structAttributeDefinition
		| nestedStructDefinition
	)+ ')'
	;

nestedStructDefinition: identifier structDefinition;

structAttributeDefinition: identifier type defaultDefinition?;

functionDeclaration
	: identifier '(' formalParameters? ')' (RETURN type)? block
	;

formalParameters
	: formalParameterDefinition (',' formalParameterDefinition)?
	;

formalParameterDefinition: identifier type defaultDefinition?;

defaultDefinition: defaultLiteral literal;

functionCall: identifier '(' expressionList? ')';

ifStatement
	: IF conditionalExpression DO block (ELSE block)?
	| IF expression switchBlock (ELSE block)?
	;

repeatStatement: REPEAT (IF conditionalExpression)? block;

forStatement: FOR identifier IN expression block;

switchBlock: '{' switchLabel+ '}';

returnStatement:	(expression | conditionalExpression) RETURN;
breakStatement:		BREAK;
continueStatement:	CONTINUE;

switchLabel: caseMatch DO block;

caseMatch
	: '{' caseMatch '}'
	| op = ('<=' | '>=' | '>' | '<') expression
	| op = '&' conditionalExpression
	| op = '|' conditionalExpression
	| op = ('=' | '!=') expression
	| op = '~=' expression
	| op = '=~' expression
	| caseMatch bop = ('&' | '|') (
		caseMatch
		| conditionalExpression
	)
	;

block: '{' program '}';

expressionList: expression (',' expression)*;

expression
	: primary
	| expression bop = '.' (identifier | functionCall)
	| functionCall
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

parenthesizedConditionalExpression
	: '{' conditionalExpression '}'
	;

redirection
	: (expression | parenthesizedConditionalExpression) BRACKET_ANGULAR_CLOSE varDeclaration
	| (expression | parenthesizedConditionalExpression) BRACKET_ANGULAR_CLOSE destinations
	| expression REDIRECTION_DIVISION identifier
	| expression REDIRECTION_MULTIPLICATION identifier
	| expression REDIRECTION_PLUS identifier
	| expression REDIRECTION_MINUS identifier
	;

destinations: identifier | primitiveDestination;

primitiveDestination: stdout | stderr;

stdout:	(DEST_STDOUT | BACKSLASH);
stderr:	DEST_STDERR;

varDeclaration: identifier type;

identifier: IDENTIFIER;

type: ( structType | primitiveType);

primitiveType
	: TYPE_INT
	| TYPE_NATURAL
	| TYPE_BOOL
	| TYPE_REAL
	| TYPE_TEXT
	;

structType: primitiveStructType | identifier;

primitiveStructType: list | map;

list: TYPE_LIST BRACKET_SQUARE_OPEN type BRACKET_SQUARE_CLOSE;

map
	: TYPE_MAP BRACKET_SQUARE_OPEN type type BRACKET_SQUARE_CLOSE
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

integerLiteral:			INTEGER_LITERAL;
naturalLiteral:			NATURAL_LITERAL;
realLiteral:			REAL_LITERAL;
boolLiteral:			BOOL_LITERAL;
textBlockLiteral:		TEXT_BLOCK_LITERAL;
textLiteral:			TEXT_LITERAL;
exactTextBlockLiteral:	EXACT_TEXT_BLOCK_LITERAL;
exactTextLiteral:		EXACT_TEXT_LITERAL;
nullLiteral:			NULL;
defaultLiteral:			UNDERSCORE;