lexer grammar GioviLexer;

PLUS:						'+';
MINUS:						'-';
MULTIPLICATION:				'*';
DIVISION:					'/';
MODULO:						'%';
EXPONENTIAL:				'^';
REDIRECTION_PLUS:			'>+';
REDIRECTION_MINUS:			'>-';
REDIRECTION_MULTIPLICATION:	'>*';
REDIRECTION_DIVISION:		'>/';
EQUAL:						'=';
NOT_EQUAL:					'!=';
TILDE:						'~';
EQUAL_TILDE:				'=~';
TILDE_EQUAL:				'~=';
GREATER_EQUAL:				'>=';
LESS_EQUAL:					'<=';
NOT:						'!';
AND:						'&';
OR:							'|';
BRACKET_ROUND_OPEN:			'(';
BRACKET_ROUND_CLOSE:		')';
BRACKET_SQUARE_OPEN:		'[';
BRACKET_SQUARE_CLOSE:		']';
BRACKET_CURLY_OPEN:			'{';
BRACKET_CURLY_CLOSE:		'}';
BRACKET_ANGULAR_OPEN:		'<';
BRACKET_ANGULAR_CLOSE:		'>';
DOT:						'.';
SEQUENCE:					'..';
COMMA:						',';
UNDERSCORE:					'_';
BACKSLASH:					'\\';
COLON:						':';
HASHTAG:					'#';
AT:							'@';

IF:			'if';
DO:			'do';
ELSE:		'else';
FOR:		'for';
IN:			'in';
REPEAT:		'repeat';
BREAK:		'break';
CONTINUE:	'continue';
CONSTANT:	'constant';

NULL:	'null';
RETURN:	'=>';

WS:				[ \t\r\n\u000C]+ -> skip;
COMMENT:		'#' ~[\r\n]* -> skip;
COMMENT_BLOCK:	'#{' .*? '#}' -> skip;

INTEGER_LITERAL:	DecimalIntegerLiteral;
NATURAL_LITERAL:	DecimalIntegerLiteral;

REAL_LITERAL:							DecimalFloatingPointLiteral;
fragment DecimalFloatingPointLiteral:	Digit+ '.' Digit+;

BOOL_LITERAL: 'true' | 'false';

TEXT_BLOCK_LITERAL:	'"{' [ \t]* [\r\n]* (. | EscapeSequence)*? '"}';
TEXT_LITERAL:		'"' (~["\\\r\n] | EscapeSequence)* '"';

EXACT_TEXT_BLOCK_LITERAL:	'\'{' [ \t]* [\r\n]* (. | EscapeSequence)*? '\'}';
EXACT_TEXT_LITERAL:			'\'' (~['\\\r\n] | EscapeSequence)* '\'';

IDENTIFIER: Letter LetterOrDigitOrUnderscore*;

fragment EscapeSequence
	: '\\' [btnfr"'\\]
	| '\\' ([0-3]? [0-7])? [0-7]
	| '\\' 'u'+ HexDigit HexDigit HexDigit HexDigit
	| '\\$'
	;
fragment HexDigit:					[0-9a-fA-F];
fragment DecimalIntegerLiteral:		DecimalNumeral;
fragment DecimalNumeral:			Digit+;
fragment Digit:						[0-9];
fragment Letter:					[a-zA-Z];
fragment LetterOrDigit:				Letter | Digit;
fragment LetterOrDigitOrUnderscore:	LetterOrDigit | '_';
