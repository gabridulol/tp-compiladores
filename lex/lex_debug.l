%{
#include <stdio.h>

#define RESET_COLOR     "\033[0m"      // Resetar cor
#define COLOR_LITERAL   "\033[1;94m"   // Azul (negrito, alta intensidade) - literais
#define COLOR_KEYWORD   "\033[1;93m"   // Amarelo (negrito, alta intensidade) - palavras-chave
#define COLOR_ID        "\033[1;92m"   // Verde (negrito, alta intensidade) - identificadores
#define COLOR_OPERATOR  "\033[1;91m"   // Vermelho (negrito, alta intensidade) - operadores
#define COLOR_DELIMITER "\033[1;95m"   // Magenta (negrito, alta intensidade) - delimitadores
#define COLOR_ERROR     "\033[1;91m\033[4m" // Vermelho (negrito, alta intensidade, sublinhado) - erros
#define COLOR_COMMENT   "\033[1;97m"   // Branco (negrito, alta intensidade) - comentários

%}

%option noyywrap

/* ===== ESPAÇOS E DELIMITADORES ===== */
/*delim               [ \t\n] */
/* ws                  {delim}+ */
whitespace          [ ]

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
dereference         \¢
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

{whitespace}            { printf(RESET_COLOR "%s" RESET_COLOR, yytext); }

{comment_line}          { printf(COLOR_COMMENT "%s" RESET_COLOR, yytext); }
{comment_block}         { printf(COLOR_COMMENT "%s" RESET_COLOR, yytext); }

{true}                  { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{false}                 { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{null}                  { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{void}                  { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{long_int}              { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{short_int}             { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{int}                   { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{float}                 { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{double}                { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{char}                  { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{string}                { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{bool}                  { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{struct}                { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{enum}                  { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{else_if}               { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{else}                  { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{if}                    { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{for}                   { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{while}                 { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{switch}                { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{case}                  { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{default}               { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{break}                 { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{continue}              { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{return}                { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{function}              { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{output}                { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{input}                 { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{import}                { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{typedef}               { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{const}                 { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }
{size_of}               { printf(COLOR_KEYWORD "%s" RESET_COLOR, yytext); }

{lbrace}                { printf(COLOR_DELIMITER "%s" RESET_COLOR, yytext); }
{rbrace}                { printf(COLOR_DELIMITER "%s" RESET_COLOR, yytext); }
{semicolon}             { printf(COLOR_DELIMITER "%s" RESET_COLOR, yytext); }
{colon}                 { printf(COLOR_DELIMITER "%s" RESET_COLOR, yytext); }
{lparen}                { printf(COLOR_DELIMITER "%s" RESET_COLOR, yytext); }
{pipe}                  { printf(COLOR_DELIMITER "%s" RESET_COLOR, yytext); }
{rparen}                { printf(COLOR_DELIMITER "%s" RESET_COLOR, yytext); }
{lbracket}              { printf(COLOR_DELIMITER "%s" RESET_COLOR, yytext); }
{rbracket}              { printf(COLOR_DELIMITER "%s" RESET_COLOR, yytext); }
{lshift}                { printf(COLOR_DELIMITER "%s" RESET_COLOR, yytext); }
{rshift}                { printf(COLOR_DELIMITER "%s" RESET_COLOR, yytext); }

{positive_real}         { printf(COLOR_LITERAL "%s" RESET_COLOR, yytext); }
{negative_real}         { printf(COLOR_LITERAL "%s" RESET_COLOR, yytext); }
{positive_digit}        { printf(COLOR_LITERAL "%s" RESET_COLOR, yytext); }
{negative_digit}        { printf(COLOR_LITERAL "%s" RESET_COLOR, yytext); }
{character_literal}     { printf(COLOR_LITERAL "%s" RESET_COLOR, yytext); }
{string_literal}        { printf(COLOR_LITERAL "%s" RESET_COLOR, yytext); }

{identifier}            { printf(COLOR_ID "%s" RESET_COLOR, yytext); }

{reference}             { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{dereference}           { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{pointer}               { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{access}                { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{assign}                { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{add}                   { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{subtract}              { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{multiply}              { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{divide}                { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{integer_divide}        { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{modulus}               { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{increment}             { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{decrement}             { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{exponentiation}        { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{greater_than}          { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{less_than}             { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{greater_equal}         { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{less_equal}            { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{equal}                 { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{not_equal}             { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{logical_and}           { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{logical_or}            { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{logical_not}           { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }
{logical_xor}           { printf(COLOR_OPERATOR "%s" RESET_COLOR, yytext); }

.                       { printf(COLOR_ERROR "%s" RESET_COLOR, yytext); }

%%

int main(void)
{
    yylex();
    return 0;
}