parser grammar GioviParser;

options {
    tokenVocab=GioviLexer;
}

begin: program EOF;

program: statement*;

block: '{' statement* '}';

//////////////////////////////////////////////////////////////////////////////// STATEMENTS

statement
    : importStatement
    | ifStatement
    | switchStatement
    | repeatStatement
    | forStatement
    | breakStatement
    | skipStatement
    | redirection
    | redirectionRTL
    | moduleDeclaration
    | structDefinition
    | constantDeclaration
    | varDeclaration
    | functionDeclaration
    | returnStatement
    | invocationStatement
    ;

statementOrBlock: statement | block;

importStatement
	: IMPORT importEntry
	| IMPORT '[' (importEntry ','?)+ ']'
	;

importEntry: (identifier '.')* identifier (AS alias=identifier)? ;

repeatStatement: REPEAT (IF expression)? statementOrBlock;

iterable: range | expression;

forStatement: FOR iterator IN iterable DO statementOrBlock;

iterator
	: key=iterator ':' value=iterator                               # iteratorMap
	| '[' key=iterator ':' value=iterator ']'                       # iteratorMap
	| whole=unaryIterator? '<' iterator (',' iterator )* ','? '>'   # iteratorAggregate
	| unaryIterator                                                 # iteratorUnary
	| literalPlaceholder                                            # iteratorPlaceholder
	;

unaryIterator: identifier type? ;

returnStatement: (RETURN | RETURN_SYM) expression? ';'?;

breakStatement: BREAK ';'?;

skipStatement: CONTINUE ';'?;

// TODO: remove redirection to identifier/constantIdentifier (already present in primary expression)
// actually no, probably is needed to avoid ambiguity with expression

redirection
    : content=expression bop=REDIRECTION dest=varDeclaration                    # redirectionToVarDeclaration
    | content=expression bop=redirectionOperator dest=reservedIdentifier ';'?   # redirectionToReservedIdentifier
    | content=expression bop=redirectionOperator dest=identifier ';'?           # redirectionToIdentifier
    | content=expression bop=redirectionOperator dest=expression ';'?           # redirectionToExpression
    ;

redirectionRTL
    : dest=varDeclaration bop=REDIRECTION_RTL content=expression                   # redirectionToVarDeclarationRTL
    | dest=reservedIdentifier bop=redirectionOperatorRTL content=expression ';'?   # redirectionToReservedIdentifierRTL
    | dest=identifier bop=redirectionOperatorRTL content=expression ';'?           # redirectionToIdentifierRTL
    | dest=expression bop=redirectionOperatorRTL content=expression ';'?           # redirectionToExpressionRTL
    ;

redirectionOperator
    : REDIRECTION
    | REDIRECTION_DIVISION
    | REDIRECTION_MULTIPLICATION
    | REDIRECTION_PLUS
    | REDIRECTION_MINUS
    ;

redirectionOperatorRTL
    : REDIRECTION_RTL
    | REDIRECTION_DIVISION_RTL
    | REDIRECTION_MULTIPLICATION_RTL
    | REDIRECTION_PLUS_RTL
    | REDIRECTION_MINUS_RTL
    ;

constantDeclaration: CONSTANT name=identifier type REDIRECTION_RTL value=expression ';'?;

varDeclaration: name=identifier type defaultDefinition? ';'?;

defaultDefinition: literalDefault expression;

moduleDeclaration: MODULE identifier body=block ;

/////////////////////////////////////////////////////////////////////////////// STRUCTS

structDefinition
	: (parentTypename=identifier ':')? typename=identifier body=structBodyDefinition ';'?
	;

structBodyDefinition
	: '<'
	( constantDeclaration
	| structFieldDefinition
	| structDefinition
	| functionDeclaration
	| selfFunctionDeclaration
	)*
	'>'
	;

structFieldDefinition: identifier type defaultDefinition? ','?;

selfFunctionDeclaration: selfFunctionSignature body=block ;

selfFunctionSignature: self=SELF? name=identifier formalParameters (RETURN_SYM (returnType=type | returnSelf=SELF))? ;

structCreation: (typeQualified | identifier) '.' (recordCreation | tupleCreation) ;

tupleCreation: '<' (expression ','?)* '>' ;

recordCreation: '<' (recordEntry ','?)+ '>' ;

recordEntry: identifier ':' expression ;

//////////////////////////////////////////////////////////////////////////////// FUNCTIONS

functionDeclaration: functionSignature body=block ;

functionSignature: name=identifier anonFunctionSignature ;

anonFunctionSignature: formalParameters (RETURN_SYM returnType=type)? ;

formalParameters: '(' (formalParameter (',' formalParameter)* ','?)? ')';

formalParameter: (label=identifier ':')? name=identifier type defaultDefinition?;

invocationStatement
	: (expression '.')? invocation # invocationStatementSimple
	| expression actualParameters  # invocationStatementOfExpression
	;

invocation: identifier actualParameters ;

actualParameters: '(' (actualParameter (',' actualParameter)* ','?)? ')';

actualParameter: (label=identifier ':')? value=expression;

//////////////////////////////////////////////////////////////////////////////// FLOW CONTROL

ifStatement: IF expression DO ifBody=statementOrBlock (ELSE elseBody=statementOrBlock)?;

switchStatement: IF expression switchBlock (ELSE elseBody=statementOrBlock)?;

switchBlock: '{' switchLabel+ '}';

switchLabel: caseMatch (WHEN guard=expression)? DO body=statementOrBlock;

caseMatch
    : '{' caseMatch '}'                                     # caseMatchParenthesized
    | caseMatch bop=(AND | AND_SYM | OR | OR_SYM) caseMatch # caseMatchCascade
    | op=('<=' | '>=' | '>' | '<') expression               # caseMatchRelational
    | op=(AND | AND_SYM | OR | OR_SYM) expression           # caseMatchBoolean
    | op=('=' | '!=') expression                            # caseMatchEquality
    | NOT? op=(IN | '~=' | '=~') expression                 # caseMatchContainment
    | op=IS (NOT | identifier)? type                        # caseMatchTypeCheck
    ;

//////////////////////////////////////////////////////////////////////////////// EXPRESSIONS

// FIXME(ambiguity): [<1 2 3> <4 5 6> <7 8 9>]

expression
    : '{' expression '}'                                      # expressionParenthesized
    | expression AS type                                      # expressionCast

    // TODO: add IS tupleDeconstruction
    | expression IS (NOT | identifier)? type                  # expressionTypeCheck
    | expression '.' (invocation | identifier | 'default')    # expressionDot
    | listCreation                                            # expressionListCreation
    | mapCreation                                             # expressionMapCreation
    | tupleCreation                                           # expressionTupleCreation
    | structCreation                                          # expressionStructCreation
    | recordCreation                                          # expressionRecordCreation
    | '::' referenceable                                      # expressionRef
    | expression actualParameters                             # expressionInvocation
    | invocation                                              # expressionInvocationSimple
    | prefix=('+' | '-') expression                           # expressionPrefixed
    | prefix=(NOT | NOT_SYM) expression                       # expressionNot
    | expression bop='@' accessKey                            # expressionAccess
    | expression bop='^' expression                           # expressionPower
    | expression bop=('*' | '/' | '%') expression             # expressionMultiplicative
    | expression bop=('+' | '-') expression                   # expressionAdditive
    | expression bop=('<=' | '>=' | '>' | '<') expression     # expressionRelational
    | expression bop=('=' | '!=') expression                  # expressionEquality
    | expression NOT? bop=(IN | '~=' | '=~') expression       # expressionContainment
    | expression bop=(AND | AND_SYM | OR | OR_SYM) expression # expressionBool
    | primary                                                 # expressionPrimary
    ;

primary: literal | identifier | reservedIdentifier ;

range: start=expression '..' end=expression ('..' step=expression)?;

type: typeComposite | typeFunctionRef | identifier | typeQualified ;

typeComposite: typeList | typeMap;

typeQualified: (identifier '.')+ typename=identifier ;

//////////////////////////////////////////////////////////////////////////////// COMPOSITE TYPES

accessKey
    : '{' (accessKey | expression) '}' # accessKeyParenthesized
    | key=('%' | '@' | '*')            # accessKeySpecial
    | range                            # accessKeyRange
    | literal                          # accessKeyLiteral
    | identifier                    # accessKeyIdentifier
    ;

typeList:     '[' type ('*' '*' initSize=expression)? ']';
listCreation: '[' listEntries ']';
listEntries:  (listEntry ','?)*;
listEntry:    expression | range;
// TODO: listEntries ->+ list

typeMap:     '[' mapKeyType=type ':' mapValueType=type ']';
mapCreation: '[' (':' | mapEntries) ']';
mapEntries:  (mapEntry ','?)+;
mapEntry:    mapKey=expression ':' mapValue=expression;
// TODO: mapEntries ->+ map

//////////////////////////////////////////////////////////////////////////////// FUNCTION REFS

referenceable
	: (expression '.')? identifier
	| anonFunction
	;

anonFunction: anonFunctionSignature? body=block ;

typeFunctionRef: '::' anonFunctionSignature ;

//////////////////////////////////////////////////////////////////////////////// LITERALS
literal
    : literalInteger
    | literalNatural
    | literalReal
    | literalBool
    | literalTextBlock
    | literalText
    | literalExactTextBlock
    | literalExactText
    | literalDefault
    | literalPlaceholder
    | literalSelf
    ;

identifier:            IDENTIFIER | ALLUPPERCASE_IDENTIFIER | UPPERCASE_IDENTIFIER ;
reservedIdentifier:    RESERVERD_IDENTIFIER;

literalInteger:        INTEGER_LITERAL;
literalNatural:        NATURAL_LITERAL;
literalReal:           REAL_LITERAL;
literalBool:           BOOL_LITERAL;
literalTextBlock:      (identifier '.')? TEXT_BLOCK_LITERAL;
literalText:           (identifier '.')? TEXT_LITERAL;
literalExactTextBlock: (identifier '.')? EXACT_TEXT_BLOCK_LITERAL;
literalExactText:      (identifier '.')? EXACT_TEXT_LITERAL;
literalDefault:        DEFAULT;
literalSelf:           SELF;
literalPlaceholder:    UNDERSCORE;

// vim: ft=antlr
