%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../yacc/yacc.tab.h"

#define LEX_COLOR_ERROR     "\033[1;91m\033[4m"
#define LEX_RESET_COLOR     "\033[0m"

%}

%option noyywrap
%option yylineno

DELIM           [ \t\n]
WS              {DELIM}+
COMMENT_LINE    §§.*
COMMENT_BLOCK   §([^§]*\n?)*§
DIGIT           [0-9]
LETTER          [a-zA-Z_]

INT             (\+|\-)?{DIGIT}+
REAL            (\+|\-)?{DIGIT}+\.{DIGIT}+
IDENTIFIER      {LETTER}({LETTER}|{DIGIT})*
CHAR            \'([^\\'\n]|\\.)\'
STRING          \"([^\\\"\n]|\\.)*\"

%%

{WS}                { /* ignora espaços e quebras */ }
{COMMENT_LINE}      { /* ignora comentário de linha */ }
{COMMENT_BLOCK}     { /* ignora bloco de comentário */ }

"Alchemia"          { return KW_MAIN; }

"axiom"             { return KW_AXIOM; }
"aut"               { return OP_LOGICAL_XOR; }
"casus"             { return KW_CASUS; }
"continuum"         { return KW_CONTINUUM; }
"designare"         { return KW_DESIGNARE; }
"enumerare"         { return KW_ENUMERARE; }
"et"                { return OP_LOGICAL_AND; }
"evocare"           { return KW_EVOCARE; }
"formula"           { return KW_FORMULA; }
"homunculus"        { return KW_HOMUNCULUS; }
"iterare"           { return KW_ITERARE; }
"lectura"           { return KW_LECTURA; }
"magnitudo"         { return KW_MAGNITUDO; }
"mol"               { return KW_MOL; }
"ne"                { return OP_LOGICAL_NOT; }
"non si"            { return KW_NON_SI; }
"non"               { return KW_NON; }
"persisto"          { return KW_PERSISTO; }
"redire"            { return KW_REDIRE; }
"revelare"          { return KW_REVELARE; }
"ruptio"            { return KW_RUPTIO; }
"si"                { return KW_SI; }
"vel"               { return OP_LOGICAL_OR; }
"vertere"           { return KW_VERTERE; }

"atomus"            { return TYPE_ATOMUS; }
"fractio"           { return TYPE_FRACTIO; }
"fragmentum"        { return TYPE_FRAGMENTUM; }
"magnus"            { return TYPE_MAGNUS; }
"minimus"           { return TYPE_MINIMUS; }
"quantum"           { return TYPE_QUANTUM; }
"scriptum"          { return TYPE_SCRIPTUM; }
"symbolum"          { return TYPE_SYMBOLUM; }
"vacuum"            { return TYPE_VACUUM; }

"Factum"            { return LIT_FACTUM; }
"Fictum"            { return LIT_FICTUM; }
{REAL}              { yylval.val_float = atof(yytext); return LIT_FLOAT; }
{INT}               { yylval.val_int = atoi(yytext); return LIT_INT; }
{CHAR}              { yylval.str = strdup(yytext); return LIT_CHAR; }
{STRING}            { yylval.str = strdup(yytext); return LIT_STRING; }

"==>"               { return OP_ACCESS_POINTER; }
"-->"               { return OP_ASSIGN; }
">="                { return OP_GREATER_EQUAL; }
"<="                { return OP_LESS_EQUAL; }
"=="                { return OP_EQUAL; }
"!="                { return OP_NOT_EQUAL; }
"//"                { return OP_INTEGER_DIVIDE; }
"**"                { return OP_EXP; }
"&&"                { return OP_LOGICAL_AND; }
"||"                { return OP_LOGICAL_OR; }
"*"                 { return OP_MULTIPLY; }
"+"                 { return OP_ADD; }
"-"                 { return OP_SUBTRACT; }
"/"                 { return OP_DIVIDE; }
"%"                 { return OP_MODULUS; }
"."                 { return OP_ACCESS_MEMBER; }
"!"                 { return OP_LOGICAL_NOT; }
">"                 { return OP_GREATER_THAN; }
"<"                 { return OP_LESS_THAN; }
"^"                 { return OP_LOGICAL_XOR; }
"£"                 { return OP_ADDR_OF; }
"°"                 { return OP_DEREF_POINTER; }

"<<"                { return LOARRAY; }
">>"                { return ROARRAY; }
"->"                { return COLON; }
"("                 { return LPAREN; }
")"                 { return RPAREN; }
"["                 { return LBRACKET; }
"]"                 { return RBRACKET; }
"{"                 { return LBRACE; }
"}"                 { return RBRACE; }
"|"                 { return PIPE; }
";"                 { return SEMICOLON; }

{IDENTIFIER}        { yylval.str = strdup(yytext); return IDENTIFIER; }

.                   { printf("%s[ERRO LÉXICO] Token '%s' não reconhecido na linha %d%s\n", LEX_COLOR_ERROR, yytext, yylineno, LEX_RESET_COLOR); }

%%