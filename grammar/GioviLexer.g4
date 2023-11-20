lexer grammar GioviLexer
	;

PLUS:							'+';
MINUS:							'-';
MULTIPLICATION:					'*';
DIVISION:						'/';
MODULO:							'%';
EXPONENTIAL:					'^';
REDIRECTION_PLUS:				'>+';
REDIRECTION_MINUS:				'>-';
REDIRECTION_MULTIPLICATION:		'>*';
REDIRECTION_DIVISION:			'>/';
REDIRECTION_PLUS_RTL:			'+<';
REDIRECTION_MINUS_RTL:			'-<';
REDIRECTION_MULTIPLICATION_RTL:	'*<';
REDIRECTION_DIVISION_RTL:		'/<';
EQUAL:							'=';
NOT_EQUAL:						'!=';
TILDE:							'~';
EQUAL_TILDE:					'=~';
TILDE_EQUAL:					'~=';
GREATER_EQUAL:					'>=';
LESS_EQUAL:						'<=';
RETURN_ARROW:					'=>';
NOT_SYM:						'!';
AND_SYM:						'&';
OR_SYM:							'|';
NOT:							'not';
AND:							'and';
OR:								'or';
BRACKET_ROUND_OPEN:				'(';
BRACKET_ROUND_CLOSE:			')';
BRACKET_SQUARE_OPEN:			'[';
BRACKET_SQUARE_CLOSE:			']';
BRACKET_CURLY_OPEN:				'{';
BRACKET_CURLY_CLOSE:			'}';
BRACKET_ANGULAR_OPEN:			'<';
BRACKET_ANGULAR_CLOSE:			'>';
DOT:							'.';
RANGE:							'..';
COMMA:							',';
UNDERSCORE:						'_';
BACKSLASH:						'\\';
COLON:							':';
SEMICOLON:						';';
HASHTAG:						'#';
AT:								'@';
IF:								'if';
DO:								'do';
ELSE:							'else';
FOR:							'for';
IN:								'in';
REPEAT:							'repeat';
BREAK:							'break';
CONTINUE:						'skip';
CONSTANT:						'constant';
NULL:							'null';
RETURN:							'return';
IMPORT:							'import';
DEFAULT:						'default';
ALIAS:							'alias';
AS:								'as';
SELF:							'self';

WS:				[ \t\r\n\u000C]+ -> skip;
COMMENT_BLOCK:	('#{' | '#?{') .*? ('}#' | EOF) -> channel(HIDDEN);
COMMENT:		'#' ~[{?\r\n]? ~[\r\n]* '\n'? -> channel(HIDDEN);

BOOL_LITERAL: 'true' | 'false';

IDENTIFIER:					[a-z] LetterOrDigitOrUnderscore*;
UPPERCASE_IDENTIFIER:		[A-Z] LetterOrDigitOrUnderscore*;
ALLUPPERCASE_IDENTIFIER:	[A-Z] ([A-Z] | Digit | '_')*;

fragment Letter:					[a-zA-Z];
fragment LetterOrDigit:				Letter | Digit;
fragment LetterOrDigitOrUnderscore:	LetterOrDigit | '_';

TEXT_BLOCK_LITERAL:			'"{' (. | EscapeSequence)*? '}"';
TEXT_LITERAL:				'"' (~["\\\r\n] | EscapeSequence)* '"';
EXACT_TEXT_BLOCK_LITERAL:	'\'{' (. | EscapeSequence)*? '}\'';
EXACT_TEXT_LITERAL:			'\'' (~['\\\r\n] | EscapeSequence)* '\'';

fragment EscapeSequence: '\\' [btnfr"'\\$] | OctalEscape | UnicodeEscape;
fragment OctalEscape
	: '\\' OctalDigit
	| '\\' OctalDigit OctalDigit
	| '\\' ZeroToThree OctalDigit OctalDigit
	;
fragment ZeroToThree:	[0-3];
fragment UnicodeEscape:	'\\' 'u'+ HexDigit HexDigit HexDigit HexDigit;

INTEGER_LITERAL
	: NumeralDecimal IntegerSuffix?
	| NumeralHex IntegerSuffix?
	| NumeralOctal IntegerSuffix?
	| NumeralBinary IntegerSuffix?
	;

fragment IntegerSuffix: 'i';

NATURAL_LITERAL
	: NumeralDecimal NaturalSuffix?
	| NumeralHex NaturalSuffix?
	| NumeralOctal NaturalSuffix?
	| NumeralBinary NaturalSuffix?
	;

fragment NaturalSuffix: 'n';

fragment Digits:				Digit (DigitsAndUnderscores? Digit)?;
fragment Digit:					'0' | NonZeroDigit;
fragment NonZeroDigit:			[1-9];
fragment DigitsAndUnderscores:	DigitOrUnderscore+;
fragment DigitOrUnderscore:		Digit | '_';
fragment Underscores:			'_'+;

fragment NumeralDecimal:				'0' | NonZeroDigit (Digits? | Underscores Digits);
fragment NumeralHex:					'0' 'x' HexDigits;
fragment HexDigits:						HexDigit (HexDigitsAndUnderscores? HexDigit)?;
fragment HexDigit:						[0-9a-fA-F];
fragment HexDigitsAndUnderscores:		HexDigitOrUnderscore+;
fragment HexDigitOrUnderscore:			HexDigit | '_';
fragment NumeralOctal:					'0' 'o' OctalDigits;
fragment OctalDigits:					OctalDigit (OctalDigitsAndUnderscores? OctalDigit)?;
fragment OctalDigit:					[0-7];
fragment OctalDigitsAndUnderscores:		OctalDigitOrUnderscore+;
fragment OctalDigitOrUnderscore:		OctalDigit | '_';
fragment NumeralBinary:					'0' 'b' BinaryDigits;
fragment BinaryDigits:					BinaryDigit (BinaryDigitsAndUnderscores? BinaryDigit)?;
fragment BinaryDigit:					[01];
fragment BinaryDigitsAndUnderscores:	BinaryDigitOrUnderscore+;
fragment BinaryDigitOrUnderscore:		BinaryDigit | '_';

REAL_LITERAL: DecimalFloatingPointLiteral | HexadecimalFloatingPointLiteral;

fragment RealSuffix: 'r';

fragment DecimalFloatingPointLiteral
	: Digits '.' Digits ExponentPart? RealSuffix?
	| Digits ExponentPart RealSuffix?
	| Digits RealSuffix
	;

fragment ExponentPart:						ExponentIndicator SignedInteger;
fragment ExponentIndicator:					[eE];
fragment SignedInteger:						Sign? Digits;
fragment Sign:								[+-];
fragment HexadecimalFloatingPointLiteral:	HexSignificand BinaryExponent RealSuffix?;
fragment HexSignificand:					NumeralHex '.'? | '0' 'x' HexDigits? '.' HexDigits;
fragment BinaryExponent:					BinaryExponentIndicator SignedInteger;
fragment BinaryExponentIndicator:			'p';

// TODO: do variable interpolation here
