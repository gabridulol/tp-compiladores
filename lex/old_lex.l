/* Código antigo do analisador léxico, implementado na primeira versão do projeto. */

%{
#include <stdio.h>
%}

%option noyywrap

/* ===== ESPAÇOS E DELIMITADORES ===== */
delim               [ \t\n]
ws                  {delim}+

/* ===== LITERAIS ===== */
letter              [a-zA-Z_]
digit               [0-9]
positive_digit      \+?[0-9]+
negative_digit      -[0-9]+
positive_real       \+?[0-9]+\.[0-9]+
negative_real       -[0-9]+\.[0-9]+
character_literal   \'([^\\\n]|(\\.))\'
string_literal      \"([^\\\n]|(\\.))*\"

/* ===== COMENTÁRIOS ===== */
comment_line        §§.*
comment_block       §([^§]*\n?)*§

/* ===== DELIMITADORES ===== */
lbrace              \{
rbrace              \}
semicolon           \;
colon               \-\>
lparen              \(
pipe                \|
rparen              \)
lbracket            \[
rbracket            \]
lshift              \<\<
rshift              \>\>

/* ===== OPERADORES ===== */
/* Ponteiros e Referências */
reference           \=\=\>
dereference         \£
pointer             \°
access              \.


/* Aritméticos */
exponentiation      \*\*
increment           \+\+
decrement           \-\-
integer_divide      \/\/
add                 \+
subtract            \-
multiply            \*
divide              \/
modulus             \%
assign              \-\-\>

/* Relacionais */
greater_equal       \>=
less_equal          \<=
equal               \==
not_equal           \!=
greater_than        \>
less_than           \<

/* Lógicos */
logical_and         (\&\&|et)
logical_or          (\|\||vel)
logical_not         (!|ne)
logical_xor         (\^|aut)

/* ===== PALAVRAS-CHAVE ===== */
/* Tipos Primitivos */
true                factum
false               fictum
null                nulo
void                vacuum
long_int            magnus[ ]atomus
short_int           minimus[ ]atomus
int                 atomus
float               fractio
double              fragmentum
char                symbolum
string              scriptum
bool                quantum

/* Tipos de Dados */
struct              homunculus
enum                enumerare

/* Estruturas de Controle */
else_if             non[ ]si
else                non
if                  si
for                 iterare
while               persisto
switch              vertere
case                casus
default             axiom
break               ruptio
continue            continuum
return              redire

/* Funções */
function            formula
output              revelare
input               lectura

/* Outros */
import              evocare
typedef             designare
const               mol
size_of             magnitudo

/* ===== IDENTIFICADORES ===== */
identifier          {letter}({letter}|{digit})*

%%

{ws}                    { /* ignora espaços */ }

{comment_line}          { /* ignora comentário de uma linha */ }
{comment_block}         { /* ignora comentário de bloco */ }

{true}                  { printf("TRUE: %s\n", yytext); }
{false}                 { printf("FALSE: %s\n", yytext); }
{null}                  { printf("NULL: %s\n", yytext); }
{void}                  { printf("VOID: %s\n", yytext); }
{long_int}              { printf("LONG_INT: %s\n", yytext); }
{short_int}             { printf("SHORT_INT: %s\n", yytext); }
{int}                   { printf("INT: %s\n", yytext); }
{float}                 { printf("FLOAT: %s\n", yytext); }
{double}                { printf("DOUBLE: %s\n", yytext); }
{char}                  { printf("CHAR: %s\n", yytext); }
{string}                { printf("STRING: %s\n", yytext); }
{bool}                  { printf("BOOL: %s\n", yytext); }
{struct}                { printf("STRUCT: %s\n", yytext); }
{enum}                  { printf("ENUM: %s\n", yytext); }
{else_if}               { printf("ELSE_IF: %s\n", yytext); }
{else}                  { printf("ELSE: %s\n", yytext); }
{if}                    { printf("IF: %s\n", yytext); }
{for}                   { printf("FOR: %s\n", yytext); }
{while}                 { printf("WHILE: %s\n", yytext); }
{switch}                { printf("SWITCH: %s\n", yytext); }
{case}                  { printf("CASE: %s\n", yytext); }
{default}               { printf("DEFAULT: %s\n", yytext); }
{break}                 { printf("BREAK: %s\n", yytext); }
{continue}              { printf("CONTINUE: %s\n", yytext); }
{return}                { printf("RETURN: %s\n", yytext); }
{function}              { printf("FUNCTION: %s\n", yytext); }
{output}                { printf("OUTPUT: %s\n", yytext); }
{input}                 { printf("INPUT: %s\n", yytext); }
{import}                { printf("IMPORT: %s\n", yytext); }
{typedef}               { printf("TYPEDEF: %s\n", yytext); }
{const}                 { printf("CONST: %s\n", yytext); }
{size_of}               { printf("SIZE_OF: %s\n", yytext); }

{lbrace}                { printf("LBRACE: %s\n", yytext); }
{rbrace}                { printf("RBRACE: %s\n", yytext); }
{semicolon}             { printf("SEMICOLON: %s\n", yytext); }
{colon}                 { printf("COLON: %s\n", yytext); }
{lparen}                { printf("LPAREN: %s\n", yytext); }
{pipe}                  { printf("PIPE: %s\n", yytext); }
{rparen}                { printf("RPAREN: %s\n", yytext); }
{lbracket}              { printf("LBRACKET: %s\n", yytext); }
{rbracket}              { printf("RBRACKET: %s\n", yytext); }
{lshift}                { printf("LSHIFT: %s\n", yytext); }
{rshift}                { printf("RSHIFT: %s\n", yytext); }

{positive_real}         { printf("POSITIVE_REAL: %s\n", yytext); }
{negative_real}         { printf("NEGATIVE_REAL: %s\n", yytext); }
{positive_digit}        { printf("POSITIVE_INTEGER: %s\n", yytext); }
{negative_digit}        { printf("NEGATIVE_INTEGER: %s\n", yytext); }
{character_literal}     { printf("CHARACTER_LITERAL: %s\n", yytext); }
{string_literal}        { printf("STRING_LITERAL: %s\n", yytext); }

{identifier}            { printf("IDENTIFIER: %s\n", yytext); }

{reference}             { printf("REFERENCE: %s\n", yytext); }
{dereference}           { printf("DEREFERENCE: %s\n", yytext); }
{pointer}               { printf("POINTER: %s\n", yytext); }
{access}                { printf("ACCESS: %s\n", yytext); }
{assign}                { printf("ASSIGN: %s\n", yytext); }
{add}                   { printf("ADD: %s\n", yytext); }
{subtract}              { printf("SUBTRACT: %s\n", yytext); }
{multiply}              { printf("MULTIPLY: %s\n", yytext); }
{divide}                { printf("DIVIDE: %s\n", yytext); }
{integer_divide}        { printf("INTEGER_DIVIDE: %s\n", yytext); }
{modulus}               { printf("MODULUS: %s\n", yytext); }
{increment}             { printf("INCREMENT: %s\n", yytext); }
{decrement}             { printf("DECREMENT: %s\n", yytext); }
{exponentiation}        { printf("EXPONENTIATION: %s\n", yytext); }
{greater_than}          { printf("GREATER_THAN: %s\n", yytext); }
{less_than}             { printf("LESS_THAN: %s\n", yytext); }
{greater_equal}         { printf("GREATER_EQUAL: %s\n", yytext); }
{less_equal}            { printf("LESS_EQUAL: %s\n", yytext); }
{equal}                 { printf("EQUAL: %s\n", yytext); }
{not_equal}             { printf("NOT_EQUAL: %s\n", yytext); }
{logical_and}           { printf("LOGICAL_AND: %s\n", yytext); }
{logical_or}            { printf("LOGICAL_OR: %s\n", yytext); }
{logical_not}           { printf("LOGICAL_NOT: %s\n", yytext); }
{logical_xor}           { printf("LOGICAL_XOR: %s\n", yytext); }

.                       { printf("UNDEFINED TOKEN: %s\n", yytext); }

%%

int main(void)
{
    yylex();
    return 0;
}