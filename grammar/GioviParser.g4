parser grammar GioviParser;

options {
    tokenVocab=GioviLexer;
}

begin: program EOF;

program: statement*;

block: '{' statement* '}';

//////////////////////////////////////////////////////////////////////////////// STATEMENTS

statement
    : ifStatement
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
    | functionCall
    ;

statementOrBlock: statement | block;

repeatStatement: REPEAT (IF expression)? statementOrBlock;

iterable: range | expression;

forStatement: FOR iterator IN iterable DO statementOrBlock;

iterator
	// TODO: check if it's possible to use prec.right so we can parse k : v : w
	: key=iterator ':' value=iterator                 # iteratorMap
	| '[' key=iterator ':' value=iterator ']'         # iteratorMap
	| whole=unaryIterator? '<' (iterator ','?)+ '>'   # iteratorAggregate
	| unaryIterator                                   # iteratorUnary
	| literalPlaceholder                              # iteratorPlaceholder
	;

unaryIterator: identifier type? ;

returnStatement: (RETURN | RETURN_SYM) expression? ';'?;

breakStatement: BREAK ';'?;

skipStatement: CONTINUE ';'?;

// TODO: remove redirection to identifier/constantIdentifier (already present in primary expression)
// actually no, probably is needed to avoid ambiguity with expression

redirection
    : redirectionContent bop=REDIRECTION varDeclaration                    # redirectionToVarDeclaration
    | redirectionContent bop=redirectionOperator primitiveDestination ';'? # redirectionToPrimitiveDestination
    | redirectionContent bop=redirectionOperator identifier ';'?           # redirectionToIdentifier
    | redirectionContent bop=redirectionOperator constantIdentifier ';'?   # redirectionToConstantIdentifier
    | redirectionContent bop=redirectionOperator expression ';'?           # redirectionToExpression
    ;

redirectionRTL
    : varDeclaration bop=REDIRECTION_RTL redirectionContent                   # redirectionToVarDeclarationRTL
    | primitiveDestination bop=redirectionOperatorRTL redirectionContent ';'? # redirectionToPrimitiveDestinationRTL
    | identifier bop=redirectionOperatorRTL redirectionContent ';'?           # redirectionToIdentifierRTL
    | expression bop=redirectionOperatorRTL redirectionContent ';'?           # redirectionToExpressionRTL
    ;

redirectionContent: primitiveContent | expression;

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

constantDeclaration: CONSTANT constantIdentifier type REDIRECTION_RTL expression ';'?;

varDeclaration: identifier type defaultDefinition? ';'?;

defaultDefinition: literalDefault expression;

/////////////////////////////////////////////////////////////////////////////// STRUCTS

structDefinition
    : (parentName=typeIdentifier ':')? structName=typeIdentifier '<' structBodyDefinition '>' ';'?
    ;

structBodyDefinition: (constantDeclaration | structFieldDefinition | structDefinition | functionDeclaration)*;

structFieldDefinition: identifier type defaultDefinition? ','?;

structCreation: (structType=typeIdentifier '.')? '<' structFields? '>';

structFields: (expression ','?)+ | (namedStructField ','?)+;

namedStructField: identifier ':' expression;

//////////////////////////////////////////////////////////////////////////////// FUNCTIONS

functionDeclaration: identifier '(' formalParameters? ')' (RETURN_SYM returnType=type)? body=block;

formalParameters: formalParameter (',' formalParameter)* ','?;

formalParameter: identifier type defaultDefinition?;

functionCall: expression '(' functionCallParameters? ')';

functionCallParameters: functionCallParameter (',' functionCallParameter)* ','?;

functionCallParameter: (identifier ':')? expression;

//////////////////////////////////////////////////////////////////////////////// FLOW CONTROL

ifStatement: IF expression DO ifBody=statementOrBlock (ELSE elseBody=statementOrBlock)?;

switchStatement: IF expression switchBlock (ELSE elseBody=statementOrBlock)?;

switchBlock: '{' switchLabel+ '}';

switchLabel: caseMatch (WHEN guard=expression)? DO body=statementOrBlock;

// TODO: move cascade case match to switch label
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
    | expression '.' (anyIdentifier | 'default')              # expressionDot
    | listCreation                                            # expressionListCreation
    | mapCreation                                             # expressionMapCreation
    | structCreation                                          # expressionStructCreation
    | '::' referenceable                                      # expressionRef
    | expression '(' functionCallParameters? ')'              # expressionFunctionCall
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

// TODO: remove anyIdentifier from literal
primary: literal | anyIdentifier | primitiveContent;

range: start=expression '..' end=expression ('..' step=expression)?;

primitiveContent: '\\' 'in';

primitiveDestination: '\\' identifier;

type: typeComposite | typeFunctionRef | typeIdentifier;

typeComposite: typeList | typeMap;

//////////////////////////////////////////////////////////////////////////////// COMPOSITE TYPES

accessKey
    : '{' (accessKey | expression) '}' # accessKeyParenthesized
    | key=('%' | '@' | '*')            # accessKeySpecial
    | range                            # accessKeyRange
    | literal                          # accessKeyLiteral
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

// TODO: make parenthesis mandatory if specifying return type
referenceable
	: identifier
	| ('(' formalParameters? ')')? (RETURN_SYM returnType=type)? body=block
	;

typeFunctionRef: '::' '(' formalParameters? ')' (RETURN_SYM returnType=type)? ;

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
    | anyIdentifier
    ;

// TODO: this is so retarded... why tf did I do this?
anyIdentifier:         identifier | constantIdentifier | typeIdentifier;
identifier:            IDENTIFIER;
constantIdentifier:    ALLUPPERCASE_IDENTIFIER;
typeIdentifier:        UPPERCASE_IDENTIFIER | ALLUPPERCASE_IDENTIFIER;

literalInteger:        INTEGER_LITERAL;
literalNatural:        NATURAL_LITERAL;
literalReal:           REAL_LITERAL;
literalBool:           BOOL_LITERAL;
literalTextBlock:      (typeIdentifier '.')? TEXT_BLOCK_LITERAL;
literalText:           (typeIdentifier '.')? TEXT_LITERAL;
literalExactTextBlock: (typeIdentifier '.')? EXACT_TEXT_BLOCK_LITERAL;
literalExactText:      (typeIdentifier '.')? EXACT_TEXT_LITERAL;
literalDefault:        DEFAULT;
literalPlaceholder:    UNDERSCORE;

// vim: ft=antlr
