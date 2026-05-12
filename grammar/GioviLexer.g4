lexer grammar GioviLexer
    ;

PLUS:                           '+';
MINUS:                          '-';
MULTIPLICATION:                 '*';
DIVISION:                       '/';
MODULO:                         '%';
EXPONENTIAL:                    '^';
REDIRECTION:                    '->';
REDIRECTION_PLUS:               '->+';
REDIRECTION_MINUS:              '->-';
REDIRECTION_MULTIPLICATION:     '->*';
REDIRECTION_DIVISION:           '->/';
REDIRECTION_RTL:                '<-';
REDIRECTION_PLUS_RTL:           '+<-';
REDIRECTION_MINUS_RTL:          '-<-';
REDIRECTION_MULTIPLICATION_RTL: '*<-';
REDIRECTION_DIVISION_RTL:       '/<-';
EQUAL:                          '=';
NOT_EQUAL:                      '!=';
TILDE:                          '~';
EQUAL_TILDE:                    '=~';
TILDE_EQUAL:                    '~=';
GREATER_EQUAL:                  '>=';
LESS_EQUAL:                     '<=';
RETURN_SYM:                     '=>';
RETURN:                         'return';
NOT_SYM:                        '!';
AND_SYM:                        '&';
OR_SYM:                         '|';
NOT:                            'not';
AND:                            'and';
OR:                             'or';
BIT_NOT:                        '!!';
BIT_AND:                        '&&';
BIT_OR:                         '||';
BIT_XOR:                        '|||';
BIT_LSHIFT:                     '{<}';
BIT_RSHIFT:                     '{>}';
BIT_RUSHIFT:                    '{>>}';
BRACKET_ROUND_OPEN:             '(';
BRACKET_ROUND_CLOSE:            ')';
BRACKET_SQUARE_OPEN:            '[';
BRACKET_SQUARE_CLOSE:           ']';
BRACKET_CURLY_OPEN:             '{';
BRACKET_CURLY_CLOSE:            '}';
BRACKET_ANGULAR_OPEN:           '<';
BRACKET_ANGULAR_CLOSE:          '>';
DOT:                            '.';
RANGE:                          '..';
COMMA:                          ',';
UNDERSCORE:                     '_';
BACKSLASH:                      '\\';
COLON:                          ':';
REF:                            '::';
SEMICOLON:                      ';';
HASHTAG:                        '#';
AT:                             '@';
IF:                             'if';
DO:                             'do';
ELSE:                           'else';
WHEN:                           'when';
FOR:                            'for';
IN:                             'in';
REPEAT:                         'repeat';
BREAK:                          'break';
CONTINUE:                       'skip';
CONST:                          'const';
IMPORT:                         'import';
MODULE:                         'module';
DEFAULT:                        'default';
ALIAS:                          'alias';
AS:                             'as';
IS:                             'is';
SELF:                           'self';
FUNCTION:                       'function';
TUPLE:                          'tuple';
RECORD:                         'record';
STRUCT:                         'struct';
TYPE:                           'type';
// reserved
DEF:                            'def';

WS:            [ \t\r\n]+ -> skip;
COMMENT_BLOCK: '#{' .*? ('}#' | EOF) -> channel(HIDDEN);
COMMENT:       '#' (~[{\r\n] ~[\r\n]*)? ([\r\n] | EOF) -> channel(HIDDEN);

BOOL_LITERAL: 'true' | 'false';

IDENTIFIER:              [a-z] LetterOrDigitOrUnderscore*;
ALLUPPERCASE_IDENTIFIER: [A-Z] ([A-Z] | Digit | '_')*;
UPPERCASE_IDENTIFIER:    [A-Z] LetterOrDigitOrUnderscore*;
RESERVERD_IDENTIFIER:    '_' LetterOrDigitOrUnderscore+;

fragment Letter:                    [a-zA-Z];
fragment LetterOrDigit:             Letter | Digit;
fragment LetterOrDigitOrUnderscore: LetterOrDigit | '_';

TEXT_BLOCK_LITERAL:       '"{' (. | EscapeSequence)*? '}"';
TEXT_LITERAL:             '"' (~["\\\r\n] | EscapeSequence)* '"';
EXACT_TEXT_BLOCK_LITERAL: '\'{' (. | EscapeSequence)*? '}\'';
EXACT_TEXT_LITERAL:       '\'' (~['\\\r\n] | EscapeSequence)* '\'';

fragment EscapeSequence:  CharacterEscape | UnicodeEscape ;
fragment CharacterEscape: '\\' [btnfrs"'\\${}] ;
fragment UnicodeEscape:   '\\' 'u'+ HexDigit HexDigit HexDigit HexDigit ;

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

fragment Digits:               Digit (DigitsAndUnderscores? Digit)?;
fragment Digit:                '0' | NonZeroDigit;
fragment NonZeroDigit:         [1-9];
fragment DigitsAndUnderscores: DigitOrUnderscore+;
fragment DigitOrUnderscore:    Digit | '_';
fragment Underscores:          '_'+;

fragment NumeralDecimal:             '0' | NonZeroDigit (Digits? | Underscores Digits);
fragment NumeralHex:                 '0' 'x' HexDigits;
fragment HexDigits:                  HexDigit (HexDigitsAndUnderscores? HexDigit)?;
fragment HexDigit:                   [0-9a-fA-F];
fragment HexDigitsAndUnderscores:    HexDigitOrUnderscore+;
fragment HexDigitOrUnderscore:       HexDigit | '_';
fragment NumeralOctal:               '0' 'o' OctalDigits;
fragment OctalDigits:                OctalDigit (OctalDigitsAndUnderscores? OctalDigit)?;
fragment OctalDigit:                 [0-7];
fragment OctalDigitsAndUnderscores:  OctalDigitOrUnderscore+;
fragment OctalDigitOrUnderscore:     OctalDigit | '_';
fragment NumeralBinary:              '0' 'b' BinaryDigits;
fragment BinaryDigits:               BinaryDigit (BinaryDigitsAndUnderscores? BinaryDigit)?;
fragment BinaryDigit:                [01];
fragment BinaryDigitsAndUnderscores: BinaryDigitOrUnderscore+;
fragment BinaryDigitOrUnderscore:    BinaryDigit | '_';

REAL_LITERAL
    : DecimalFloatingPointLiteral
    | HexadecimalFloatingPointLiteral
    | NumeralHex RealSuffix
    | NumeralOctal RealSuffix
    | NumeralBinary RealSuffix
    ;

fragment RealSuffix: 'r';

fragment DecimalFloatingPointLiteral
    : Digits '.' Digits ExponentPart? RealSuffix?
    | Digits ExponentPart RealSuffix?
    | Digits RealSuffix
    ;

fragment ExponentPart:                    ExponentIndicator SignedInteger;
fragment ExponentIndicator:               [eE];
fragment SignedInteger:                   Sign? Digits;
fragment Sign:                            [+-];
fragment HexadecimalFloatingPointLiteral: HexSignificand BinaryExponent RealSuffix?;
fragment HexSignificand:                  NumeralHex '.'? | '0' 'x' HexDigits? '.' HexDigits;
fragment BinaryExponent:                  BinaryExponentIndicator SignedInteger;
fragment BinaryExponentIndicator:         'p';

// TODO: do variable interpolation here

// vim: ft=antlr
