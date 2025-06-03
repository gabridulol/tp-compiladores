%{
#include <stdio.h>
#include <string.h> 
#include "y.tab.h"  
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

{comment_line}        
{comment_block}         

"si"                    { return KW_SI; }
"non"                   { return KW_NON; }
"iterare"               { return KW_ITERARE; }
"persisto"              { return KW_PERSISTO; }
"vertere"               { return KW_VERTERE; }
"casus"                 { return KW_CASUS; }
"axiom"                 { return KW_AXIOM; }
"ruptio"                { return KW_RUPTIO; }
"continuum"             { return KW_CONTINUUM; }
"redire"                { return KW_REDIRE; }
"mol"                   { return KW_MOL; }
"homunculus"            { return KW_HOMUNCULUS; }
"Enumerare"             { return KW_ENUMERARE; } 
"designare"             { return KW_DESIGNARE; }
"formula"               { return KW_FORMULA; }
"revelare"              { return KW_REVELARE; }
"lectura"               { return KW_LECTURA; }
"magnitudo"             { return KW_MAGNITUDO; }

"vacuum"                { return TYPE_VACUUM; }
"atomus"                { return TYPE_ATOMUS; }
"fragmentum"            { return TYPE_FRAGMENTUM; }
"fractio"               { return TYPE_FRACTIO; }
"quantum"               { return TYPE_QUANTUM; }
"magnus"                { return TYPE_MAGNUS; }
"minimus"               { return TYPE_MINIMUS; }
"symbolum"              { return TYPE_SYMBOLUM; }
"scriptum"              { return TYPE_SCRIPTUM; }

"Factum"                { return LIT_FACTUM; }
"Fictum"                { return LIT_FICTUM; }

"-->"                   { return OP_ARROW_ASSIGN; } 
"°"                     { return OP_DEREF_POINTER; } 
"£"                     { return OP_ADDR_OF; }
"<<"                    { return OP_LSHIFT_ARRAY; } 
">>"                    { return OP_RSHIFT_ARRAY; } 
"."                     { return OP_ACCESS_MEMBER; } 
"==>"                   { return OP_ACCESS_POINTER; } 
"**"                    { return OP_EXP; } 
"//"                    { return OP_INTEGER_DIVIDE; }
"+"                     { return OP_ADD; }
"-"                     { return OP_SUBTRACT; }
"*"                     { return OP_MULTIPLY; }
"/"                     { return OP_DIVIDE; }
"%"                     { return OP_MODULUS; }
"=="                    { return OP_EQUAL; }
"!="                    { return OP_NOT_EQUAL; }
">"                     { return OP_GREATER_THAN; }
"<"                     { return OP_LESS_THAN; }
">="                    { return OP_GREATER_EQUAL; }
"<="                    { return OP_LESS_EQUAL; }
"et"                    { return KW_ET; } 
"&&"                    { return OP_LOGICAL_AND; }
"vel"                   { return KW_VEL; }
"||"                    { return OP_LOGICAL_OR; }
"ne"                    { return KW_NE; }
"!"                     { return OP_LOGICAL_NOT; }
"aut"                   { return KW_AUT; }
"^"                     { return OP_LOGICAL_XOR; }

"{"                     { return LBRACE; }
"}"                     { return RBRACE; }
";"                     { return SEMICOLON; }
"("                     { return LPAREN; }
")"                     { return RPAREN; }
"|"                     { return PIPE; }
"->"                    { return OP_ARROW_CASE; } 

{positive_real}         { yylval.val_float = atof(yytext); return LIT_FLOAT; }
{negative_real}         { yylval.val_float = atof(yytext); return LIT_FLOAT; }
{positive_digit}        { yylval.val_int = atoi(yytext); return LIT_INT; }
{negative_digit}        { yylval.val_int = atoi(yytext); return LIT_INT; }
{character_literal}     { yylval.str = strdup(yytext); return LIT_CHAR; } 
{string_literal}        { yylval.str = strdup(yytext); return LIT_STRING; } 

{identifier}            { yylval.str = strdup(yytext); return IDENTIFIER; } 

.                       { printf("ERRO LÉXICO: Token não reconhecido: %s\n", yytext); }

%%

int yywrap()
{
    return 1;
}