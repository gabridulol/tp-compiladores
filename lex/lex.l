%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../yacc/yacc.tab.h"
#include "../src/source_printer.h"

extern int yylineno;
%}

%option noyywrap
%option yylineno

%x COMMENT_BLOCK

DELIM           [ \t\n\r]
WS              {DELIM}+
COMMENT_LINE    §§.*
DIGIT           [0-9]
LETTER          [a-zA-Z_]

INT             (\+|\-)?{DIGIT}+
REAL            (\+|\-)?{DIGIT}+\.{DIGIT}+
IDENTIFIER      {LETTER}({LETTER}|{DIGIT})*
CHAR            \'([^\\'\n]|\\.)\'
STRING          \"([^\\\"\n]|\\.)*\"
%%

{WS}                { /* ignora */ }
{COMMENT_LINE}      { token_printer(COLOR_COMMENT, yytext); }

§                   { BEGIN(COMMENT_BLOCK); }
<COMMENT_BLOCK>{
    \n              { yylineno++; }
    §               { BEGIN(INITIAL); token_printer(COLOR_COMMENT, "§...§"); }
    .               { /* ignora */ }
    <<EOF>>         { yyerror("unterminated comment block"); exit(1); }
}

"Alchemia"          { token_printer(COLOR_KEYWORD, yytext); return KW_MAIN; }

"axiom"             { token_printer(COLOR_KEYWORD, yytext); return KW_AXIOM; }
"aut"               { token_printer(COLOR_KEYWORD, yytext); return OP_LOGICAL_XOR; }
"casus"             { token_printer(COLOR_KEYWORD, yytext); return KW_CASUS; }
"continuum"         { token_printer(COLOR_KEYWORD, yytext); return KW_CONTINUUM; }
"designare"         { token_printer(COLOR_KEYWORD, yytext); return KW_DESIGNARE; }
"enumerare"         { token_printer(COLOR_KEYWORD, yytext); return KW_ENUMERARE; }
"et"                { token_printer(COLOR_KEYWORD, yytext); return OP_LOGICAL_AND; }
"evocare"           { token_printer(COLOR_KEYWORD, yytext); return KW_EVOCARE; }
"formula"           { token_printer(COLOR_KEYWORD, yytext); return KW_FORMULA; }
"homunculus"        { token_printer(COLOR_KEYWORD, yytext); return KW_HOMUNCULUS; }
"iterare"           { token_printer(COLOR_KEYWORD, yytext); return KW_ITERARE; }
"lectura"           { token_printer(COLOR_KEYWORD, yytext); return KW_LECTURA; }
"magnitudo"         { token_printer(COLOR_KEYWORD, yytext); return KW_MAGNITUDO; }
"mol"               { token_printer(COLOR_KEYWORD, yytext); return KW_MOL; }
"ne"                { token_printer(COLOR_KEYWORD, yytext); return OP_LOGICAL_NOT; }
"non si"            { token_printer(COLOR_KEYWORD, yytext); return KW_NON_SI; }
"non"               { token_printer(COLOR_KEYWORD, yytext); return KW_NON; }
"persisto"          { token_printer(COLOR_KEYWORD, yytext); return KW_PERSISTO; }
"redire"            { token_printer(COLOR_KEYWORD, yytext); return KW_REDIRE; }
"revelare"          { token_printer(COLOR_KEYWORD, yytext); return KW_REVELARE; }
"ruptio"            { token_printer(COLOR_KEYWORD, yytext); return KW_RUPTIO; }
"si"                { token_printer(COLOR_KEYWORD, yytext); return KW_SI; }
"vel"               { token_printer(COLOR_KEYWORD, yytext); return OP_LOGICAL_OR; }
"vertere"           { token_printer(COLOR_KEYWORD, yytext); return KW_VERTERE; }

"atomus"            { token_printer(COLOR_KEYWORD, yytext); return TYPE_ATOMUS; }
"fractio"           { token_printer(COLOR_KEYWORD, yytext); return TYPE_FRACTIO; }
"fragmentum"        { token_printer(COLOR_KEYWORD, yytext); return TYPE_FRAGMENTUM; }
"magnus"            { token_printer(COLOR_KEYWORD, yytext); return TYPE_MAGNUS; }
"minimus"           { token_printer(COLOR_KEYWORD, yytext); return TYPE_MINIMUS; }
"quantum"           { token_printer(COLOR_KEYWORD, yytext); return TYPE_QUANTUM; }
"scriptum"          { token_printer(COLOR_KEYWORD, yytext); return TYPE_SCRIPTUM; }
"symbolum"          { token_printer(COLOR_KEYWORD, yytext); return TYPE_SYMBOLUM; }
"vacuum"            { token_printer(COLOR_KEYWORD, yytext); return TYPE_VACUUM; }

"Factum"            { token_printer(COLOR_LITERAL, yytext); return LIT_FACTUM; }
"Fictum"            { token_printer(COLOR_LITERAL, yytext); return LIT_FICTUM; }
{REAL}              { token_printer(COLOR_LITERAL, yytext); yylval.val_float = atof(yytext); return LIT_FLOAT; }
{INT}               { token_printer(COLOR_LITERAL, yytext); yylval.val_int = atoi(yytext); return LIT_INT; }
{CHAR}              { token_printer(COLOR_LITERAL, yytext); yylval.str = strdup(yytext); return LIT_CHAR; }
{STRING}            { token_printer(COLOR_LITERAL, yytext); yylval.str = strdup(yytext); return LIT_STRING; }

"==>"               { token_printer(COLOR_OPERATOR, yytext); return OP_ACCESS_POINTER; }
"-->"               { token_printer(COLOR_OPERATOR, yytext); return OP_ASSIGN; }
">="                { token_printer(COLOR_OPERATOR, yytext); return OP_GREATER_EQUAL; }
"<="                { token_printer(COLOR_OPERATOR, yytext); return OP_LESS_EQUAL; }
"=="                { token_printer(COLOR_OPERATOR, yytext); return OP_EQUAL; }
"!="                { token_printer(COLOR_OPERATOR, yytext); return OP_NOT_EQUAL; }
"//"                { token_printer(COLOR_OPERATOR, yytext); return OP_INTEGER_DIVIDE; }
"**"                { token_printer(COLOR_OPERATOR, yytext); return OP_EXP; }
"&&"                { token_printer(COLOR_OPERATOR, yytext); return OP_LOGICAL_AND; }
"||"                { token_printer(COLOR_OPERATOR, yytext); return OP_LOGICAL_OR; }
"*"                 { token_printer(COLOR_OPERATOR, yytext); return OP_MULTIPLY; }
"+"                 { token_printer(COLOR_OPERATOR, yytext); return OP_ADD; }
"-"                 { token_printer(COLOR_OPERATOR, yytext); return OP_SUBTRACT; }
"/"                 { token_printer(COLOR_OPERATOR, yytext); return OP_DIVIDE; }
"%"                 { token_printer(COLOR_OPERATOR, yytext); return OP_MODULUS; }
"."                 { token_printer(COLOR_OPERATOR, yytext); return OP_ACCESS_MEMBER; }
"!"                 { token_printer(COLOR_OPERATOR, yytext); return OP_LOGICAL_NOT; }
">"                 { token_printer(COLOR_OPERATOR, yytext); return OP_GREATER_THAN; }
"<"                 { token_printer(COLOR_OPERATOR, yytext); return OP_LESS_THAN; }
"^"                 { token_printer(COLOR_OPERATOR, yytext); return OP_LOGICAL_XOR; }
"£"                 { token_printer(COLOR_OPERATOR, yytext); return OP_ADDR_OF; }
"°"                 { token_printer(COLOR_OPERATOR, yytext); return OP_DEREF_POINTER; }

"<<"                { token_printer(COLOR_DELIMITER, yytext); return LOARRAY; }
">>"                { token_printer(COLOR_DELIMITER, yytext); return ROARRAY; }
"->"                { token_printer(COLOR_DELIMITER, yytext); return COLON; }
"("                 { token_printer(COLOR_DELIMITER, yytext); return LPAREN; }
")"                 { token_printer(COLOR_DELIMITER, yytext); return RPAREN; }
"["                 { token_printer(COLOR_DELIMITER, yytext); return LBRACKET; }
"]"                 { token_printer(COLOR_DELIMITER, yytext); return RBRACKET; }
"{"                 { token_printer(COLOR_DELIMITER, yytext); indent_level++; return LBRACE; }
"}"                 { indent_level--; token_printer(COLOR_DELIMITER, yytext); return RBRACE; }
"|"                 { token_printer(COLOR_DELIMITER, yytext); return PIPE; }
";"                 { token_printer(COLOR_DELIMITER, yytext); return SEMICOLON; }

{IDENTIFIER}        { token_printer(COLOR_ID, yytext); yylval.str = strdup(yytext); return IDENTIFIER; }

.                   {
                        token_printer(LEX_COLOR_ERROR, yytext);
                        lexical_error(yytext);
                        return LEX_ERROR;
                    }

%%