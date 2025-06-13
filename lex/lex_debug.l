%{
#include <stdio.h>
#include <string.h>

#define RESET_COLOR     "\033[0m"
#define COLOR_LITERAL   "\033[1;94m"
#define COLOR_KEYWORD   "\033[1;93m"
#define COLOR_ID        "\033[1;92m"
#define COLOR_OPERATOR  "\033[1;91m"
#define COLOR_DELIMITER "\033[1;95m"
#define COLOR_ERROR     "\033[1;91m\033[4m"
#define COLOR_COMMENT   "\033[1;97m"

int last_line_reported = 0;
int indent_level = 0;

int line_number = 1;
int column_number = 1;

void print_token(const char* color, const char* text) {
    if (line_number != last_line_reported) {
        printf("\n[%d] ", line_number);
        for (int i = 0; i < indent_level; i++) {
            printf("    ");
        }
        last_line_reported = line_number;
    }
    printf("%s%s%s ", color, text, RESET_COLOR);
}
%}

%option noyywrap

DELIM               [ \t\n]
WS                  {DELIM}+

COMMENT_LINE        §§.*
COMMENT_BLOCK       §([^§]*\n?)*§

DIGIT       [0-9]
LETTER      [a-zA-Z_]

INT         (\+|\-)?{DIGIT}+
REAL        (\+|\-)?{DIGIT}+\.{DIGIT}+
ID          {LETTER}({LETTER}|{DIGIT})*
CHAR        '\\?.'
STRING      "([^\"\\n]|(\\.))*"

%%

{WS}                    { for (int i = 0; yytext[i] != '\0'; i++) { if (yytext[i] == '\n') line_number++, column_number = 1; else column_number++; } }

{COMMENT_LINE}          { print_token(COLOR_COMMENT, yytext); }
{COMMENT_BLOCK}         { print_token(COLOR_COMMENT, yytext); }

"axiom"                 { print_token(COLOR_KEYWORD, yytext); }
"aut"                   { print_token(COLOR_KEYWORD, yytext); }
"casus"                 { print_token(COLOR_KEYWORD, yytext); }
"continuum"             { print_token(COLOR_KEYWORD, yytext); }
"designare"             { print_token(COLOR_KEYWORD, yytext); }
"enumerare"             { print_token(COLOR_KEYWORD, yytext); }
"et"                    { print_token(COLOR_KEYWORD, yytext); }
"formula"               { print_token(COLOR_KEYWORD, yytext); }
"homunculus"            { print_token(COLOR_KEYWORD, yytext); }
"iterare"               { print_token(COLOR_KEYWORD, yytext); }
"lectura"               { print_token(COLOR_KEYWORD, yytext); }
"magnitudo"             { print_token(COLOR_KEYWORD, yytext); }
"mol"                   { print_token(COLOR_KEYWORD, yytext); }
"ne"                    { print_token(COLOR_KEYWORD, yytext); }
"non"                   { print_token(COLOR_KEYWORD, yytext); }
"persisto"              { print_token(COLOR_KEYWORD, yytext); }
"redire"                { print_token(COLOR_KEYWORD, yytext); }
"revelare"              { print_token(COLOR_KEYWORD, yytext); }
"ruptio"                { print_token(COLOR_KEYWORD, yytext); }
"si"                    { print_token(COLOR_KEYWORD, yytext); }
"vel"                   { print_token(COLOR_KEYWORD, yytext); }
"vertere"               { print_token(COLOR_KEYWORD, yytext); }

"atomus"                { print_token(COLOR_KEYWORD, yytext); }
"fractio"               { print_token(COLOR_KEYWORD, yytext); }
"fragmentum"            { print_token(COLOR_KEYWORD, yytext); }
"magnus"                { print_token(COLOR_KEYWORD, yytext); }
"minimus"               { print_token(COLOR_KEYWORD, yytext); }
"quantum"               { print_token(COLOR_KEYWORD, yytext); }
"scriptum"              { print_token(COLOR_KEYWORD, yytext); }
"symbolum"              { print_token(COLOR_KEYWORD, yytext); }
"vacuum"                { print_token(COLOR_KEYWORD, yytext); }

"Factum"                { print_token(COLOR_LITERAL, yytext); }
"Fictum"                { print_token(COLOR_LITERAL, yytext); }
{INT}                   { print_token(COLOR_LITERAL, yytext); }
{REAL}                  { print_token(COLOR_LITERAL, yytext); }
{CHAR}                  { print_token(COLOR_LITERAL, yytext); }
{STRING}                { print_token(COLOR_LITERAL, yytext); }

"-->"                   { print_token(COLOR_OPERATOR, yytext); } 
"**"                    { print_token(COLOR_OPERATOR, yytext); } 
"*"                     { print_token(COLOR_OPERATOR, yytext); }
"+"                     { print_token(COLOR_OPERATOR, yytext); }
"-"                     { print_token(COLOR_OPERATOR, yytext); }
"."                     { print_token(COLOR_OPERATOR, yytext); } 
"/"                     { print_token(COLOR_OPERATOR, yytext); }
"//"                    { print_token(COLOR_OPERATOR, yytext); }
"%"                     { print_token(COLOR_OPERATOR, yytext); }
"=="                    { print_token(COLOR_OPERATOR, yytext); }
"!="                    { print_token(COLOR_OPERATOR, yytext); }
">"                     { print_token(COLOR_OPERATOR, yytext); }
">="                    { print_token(COLOR_OPERATOR, yytext); }
">>"                    { print_token(COLOR_OPERATOR, yytext); } 
"<"                     { print_token(COLOR_OPERATOR, yytext); }
"<="                    { print_token(COLOR_OPERATOR, yytext); }
"<<"                    { print_token(COLOR_OPERATOR, yytext); } 
"==>"                   { print_token(COLOR_OPERATOR, yytext); } 
"!"                     { print_token(COLOR_OPERATOR, yytext); }
"&&"                    { print_token(COLOR_OPERATOR, yytext); }
"||"                    { print_token(COLOR_OPERATOR, yytext); }
"^"                     { print_token(COLOR_OPERATOR, yytext); }
"£"                     { print_token(COLOR_OPERATOR, yytext); }
"°"                     { print_token(COLOR_OPERATOR, yytext); } 

"{"                     { indent_level++; print_token(COLOR_DELIMITER, yytext); }
"}"                     { indent_level--; print_token(COLOR_DELIMITER, yytext); }
"("                     { print_token(COLOR_DELIMITER, yytext); }
")"                     { print_token(COLOR_DELIMITER, yytext); }
";"                     { print_token(COLOR_DELIMITER, yytext); }
"|"                     { print_token(COLOR_DELIMITER, yytext); }
"->"                    { print_token(COLOR_DELIMITER, yytext); }

{ID}                    { print_token(COLOR_ID, yytext); }

.                       { print_token(COLOR_ERROR, yytext); }

%%

int main(void) {
    yylex();
    printf("\n\n");
    return 0;
}