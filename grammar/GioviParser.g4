parser grammar GioviParser
	;

options {
	tokenVocab=GioviLexer;
}

/*
 @header { package it.simonvic.giovi; }
 */

begin: program EOF;

program: statement*;

block: '{' statement* '}';

statement
	: statement SEMICOLON
	| ifStatement
	| switchStatement
	| repeatStatement
	| forStatement
	| breakStatement
	| skipStatement
	| redirection
	| redirectionRTL
	| structDefinition
	| constantDeclaration
	| varDeclaration
	| functionDeclaration
	| returnStatement
	| expression
	;

statementOrBlock: statement | block;

repeatStatement: REPEAT (IF expression)? statementOrBlock;

rangeOrExpression: range | expression;

forStatement: FOR iterators IN rangeOrExpression DO statementOrBlock;

iterators: identifier (',' identifier)*;

returnStatement: (RETURN | RETURN_ARROW) expression?;

breakStatement: BREAK;

skipStatement: CONTINUE;

redirection
	: redirectionContent bop='>' varDeclaration				# redirectionToVarDeclaration
	| redirectionContent bop='>' primitiveDestination		# redirectionToPrimitiveDestination
	| redirectionContent bop=redirectionOperator identifier	# redirectionToIdentifier
	| redirectionContent bop=redirectionOperator expression	# redirectionToExpression
	;

redirectionRTL
	: varDeclaration bop='<' redirectionContent					# redirectionToVarDeclarationRTL
	| primitiveDestination bop='<' redirectionContent			# redirectionToPrimitiveDestinationRTL
	| identifier bop=redirectionOperatorRTL redirectionContent	# redirectionToIdentifierRTL
	| expression bop=redirectionOperatorRTL redirectionContent	# redirectionToExpressionRTL
	;

redirectionContent: primitiveContent | expression;

redirectionOperator
	: '>'
	| REDIRECTION_DIVISION
	| REDIRECTION_MULTIPLICATION
	| REDIRECTION_PLUS
	| REDIRECTION_MINUS
	;

redirectionOperatorRTL
	: '<'
	| REDIRECTION_DIVISION_RTL
	| REDIRECTION_MULTIPLICATION_RTL
	| REDIRECTION_PLUS_RTL
	| REDIRECTION_MINUS_RTL
	;

constantDeclaration: CONSTANT identifier type expression;

varDeclaration: identifier type defaultDefinition?;

defaultDefinition: defaultLiteral expression;

////////////////////////////////////////////////
// STRUCT

structDefinition
	: (parentName=identifier ':')? structName=identifier '(' structBodyDefinition ')'
	;

structBodyDefinition: (structFieldDefinition | structDefinition | functionDeclaration)+;

structFieldDefinition: identifier type defaultDefinition? ';'?;

structCreation: structType=identifier? '.' '(' structFields? ')';

structFields: expression+ | namedStructField+;

namedStructField: identifier ':' expression;

// namedStructCreation: (structType=identifier '.')? '(' namedStructField+ ')' ';'?; namedStructField: identifier ':' expression ';'?;
// unnamedStructCreation: (structType=identifier '.')? '(' unnamedStructField+ ')' ';'?; unnamedStructField: expression ';'?;

////////////////////////////////////////////////
// FUNCTIONS

functionDeclaration: identifier '(' formalParameters? ')' (RETURN_ARROW type)? block;

formalParameters: formalParameterDefinition (',' formalParameterDefinition)*;

formalParameterDefinition: identifier type defaultDefinition?;

functionCall: identifier '(' functionParameterList? ')';

functionParameterList: functionParameter (',' functionParameter)*;

functionParameter: (identifier ':')? expression;

////////////////////////////////////////////////
// FLOW CONTROL

ifStatement: IF expression DO ifBody=statementOrBlock (ELSE elseBody=statementOrBlock)?;

switchStatement: IF expression switchBlock (ELSE elseBody=statementOrBlock)?;

switchBlock: '{' switchLabel+ '}';

switchLabel: caseMatch DO body=statementOrBlock;

caseMatch
	: '{' caseMatch '}'							# parenthesizedCaseMatch
	| op=('<=' | '>=' | '>' | '<') expression	# relationalCaseMatch
	| op=('&' | '|') expression					# booleanCaseMatch
	| op=('=' | '!=') expression				# equalityCaseMatch
	| op=('~=' | '=~') expression				# containmentCaseMatch
	| caseMatch bop=('&' | '|') caseMatch		# guardedCaseMatch
	;

////////////////////////////////////////////////
// EXPRESSIONS

//expressionList: expression (',' expression)*;

expression
	: '{' expression '}'									# parenthesizedExpression
	| expression bop='.' (identifier | functionCall)		# dotExpression
	| listCreation											# listCreationExpression
	| mapCreation											# mapCreationExpression
	| structCreation										# structCreationExpression
	| functionCall											# functionCallExpression
	| prefix=('+' | '-') expression							# prefixedExpression
	| prefix='!' expression									# notExpression
	| expression bop='@' accessKey							# accessExpression
	| expression bop='^' expression							# powerExpression
	| expression bop=('*' | '/' | '%') expression			# multiplicativeExpression
	| expression bop=('+' | '-') expression					# additiveExpression
	| expression bop=('<=' | '>=' | '>' | '<') expression	# relationalExpression
	| expression bop=('=' | '!=') expression				# equalityExpression
	| expression bop=('~=' | '=~') expression				# containmentExpression
	| expression bop=('&' | '|') expression					# boolExpression
	| primary												# primaryExpression
	;

primary: literal | identifier;

range: start=expression '..' end=expression ('..' step=expression)?;

primitiveContent: '\\' identifier;

primitiveDestination: '\\' identifier;

type: collectionType | identifier;

collectionType: listType | mapType;

////////////////////////////////////////////////
// COLLECTIONS

access: identifier '@' accessKey;
accessKey
	: '{' expression '}'	# parenthesizedAccessKey
	| key=('%' | '@' | '*')	# specialAccessKey
	| range					# rangeAccessKey
	| literal				# literalAccessKey
	;

listType:		'[' type ']';
listCreation:	'[' listEntries ']';
listEntries:	listEntry*;
listEntry:		expression | range;

mapType:		'[' mapKeyType=type ':' mapValueType=type ']';
mapCreation:	'[' mapEntries ']';
mapEntries:		mapEntry*;
mapEntry:		mapKey=expression ':' mapValue=expression;

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

identifier:				IDENTIFIER;
integerLiteral:			INTEGER_LITERAL;
naturalLiteral:			NATURAL_LITERAL;
realLiteral:			REAL_LITERAL;
boolLiteral:			BOOL_LITERAL;
textBlockLiteral:		(identifier '.')? TEXT_BLOCK_LITERAL;
textLiteral:			(identifier '.')? TEXT_LITERAL;
exactTextBlockLiteral:	(identifier '.')? EXACT_TEXT_BLOCK_LITERAL;
exactTextLiteral:		(identifier '.')? EXACT_TEXT_LITERAL;
nullLiteral:			NULL;
defaultLiteral:			DEFAULT;
placeholderLiteral:		UNDERSCORE;
