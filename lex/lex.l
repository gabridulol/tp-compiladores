%{
#include <stdio.h>
#include <string.h> 
#include "../yacc/yacc.tab.h"
%}



%option noyywrap

delim               [ \t\n]
ws                  {delim}+

letter              [a-zA-Z_]
digit               [0-9]
positive_digit      \+?[0-9]+
negative_digit      -[0-9]+
positive_real       \+?[0-9]+\.[0-9]+
negative_real       -[0-9]+\.[0-9]+
character_literal   \'([^\\\n]|(\\.))\'
string_literal      \"([^\\\n]|(\\.))*\"

comment_line        §§.*
comment_block       §([^§]*\n?)*§

identifier          {letter}({letter}|{digit})*

%%

{ws}                    

{comment_line}        { /* Ignorar comentários de linha */ }
{comment_block}       { /* Ignorar comentários de bloco */ }         

"axiom"                 { return KW_AXIOM; }
"aut"                   { return KW_AUT; }
"casus"                 { return KW_CASUS; }
"continuum"             { return KW_CONTINUUM; }
"designare"             { return KW_DESIGNARE; }
"Enumerare"             { return KW_ENUMERARE; }
"et"                    { return KW_ET; }
"formula"               { return KW_FORMULA; }
"homunculus"            { return KW_HOMUNCULUS; }
"iterare"               { return KW_ITERARE; }
"lectura"               { return KW_LECTURA; }
"magnitudo"             { return KW_MAGNITUDO; }
"mol"                   { return KW_MOL; }
"ne"                    { return KW_NE; }
"non"                   { return KW_NON; }
"persisto"              { return KW_PERSISTO; }
"redire"                { return KW_REDIRE; }
"revelare"              { return KW_REVELARE; }
"ruptio"                { return KW_RUPTIO; }
"si"                    { return KW_SI; }
"vel"                   { return KW_VEL; }
"vertere"               { return KW_VERTERE; }

"atomus"                { return TYPE_ATOMUS; }
"fractio"               { return TYPE_FRACTIO; }
"fragmentum"            { return TYPE_FRAGMENTUM; }
"magnus"                { return TYPE_MAGNUS; }
"minimus"               { return TYPE_MINIMUS; }
"quantum"               { return TYPE_QUANTUM; }
"scriptum"              { return TYPE_SCRIPTUM; }
"symbolum"              { return TYPE_SYMBOLUM; }
"vacuum"                { return TYPE_VACUUM; }

"Factum"                { return LIT_FACTUM; }
"Fictum"                { return LIT_FICTUM; }
{positive_real}         { yylval.val_float = atof(yytext); return LIT_FLOAT; }
{negative_real}         { yylval.val_float = atof(yytext); return LIT_FLOAT; }
{positive_digit}        { yylval.val_int = atoi(yytext); return LIT_INT; }
{negative_digit}        { yylval.val_int = atoi(yytext); return LIT_INT; }
{character_literal}     { yylval.str = strdup(yytext); return LIT_CHAR; } 
{string_literal}        { yylval.str = strdup(yytext); return LIT_STRING; } 

"-->"                   { return OP_ARROW_ASSIGN; } 
"**"                    { return OP_EXP; } 
"*"                     { return OP_MULTIPLY; }
"+"                     { return OP_ADD; }
"-"                     { return OP_SUBTRACT; }
"."                     { return OP_ACCESS_MEMBER; } 
"/"                     { return OP_DIVIDE; }
"//"                    { return OP_INTEGER_DIVIDE; }
"%"                     { return OP_MODULUS; }
"=="                    { return OP_EQUAL; }
"!="                    { return OP_NOT_EQUAL; }
">"                     { return OP_GREATER_THAN; }
">="                    { return OP_GREATER_EQUAL; }
">>"                    { return OP_RSHIFT_ARRAY; } 
"<"                     { return OP_LESS_THAN; }
"<="                    { return OP_LESS_EQUAL; }
"<<"                    { return OP_LSHIFT_ARRAY; } 
"==>"                   { return OP_ACCESS_POINTER; } 
"!"                     { return OP_LOGICAL_NOT; }
"&&"                    { return OP_LOGICAL_AND; }
"||"                    { return OP_LOGICAL_OR; }
"^"                     { return OP_LOGICAL_XOR; }
"£"                     { return OP_ADDR_OF; }
"°"                     { return OP_DEREF_POINTER; } 

"("                     { return LPAREN; }
")"                     { return RPAREN; }
";"                     { return SEMICOLON; }
"{"                     { return LBRACE; }
"}"                     { return RBRACE; }
"|"                     { return PIPE; }
"->"                    { return COLON; }

{identifier}            { yylval.str = strdup(yytext); return IDENTIFIER; } 

.                        {
                            printf("\033[1;31mERRO LÉXICO: Token não reconhecido: '%s'\nNumero da Linha: %d\033[0m\n", yytext, yylineno);
                            // return TOKEN_ERROR; // Retorna um token de erro para o Yacc
                        }
%%