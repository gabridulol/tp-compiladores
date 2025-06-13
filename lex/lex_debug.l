%{
#include <stdio.h>
#include <string.h>

int line_number = 1;
int last_line_reported = 0;

#define RESET_COLOR     "\033[0m"
#define COLOR_LITERAL   "\033[1;94m"
#define COLOR_KEYWORD   "\033[1;93m"
#define COLOR_ID        "\033[1;92m"
#define COLOR_OPERATOR  "\033[1;91m"
#define COLOR_DELIMITER "\033[1;95m"
#define COLOR_ERROR     "\033[1;91m\033[4m"
#define COLOR_COMMENT   "\033[1;97m"

void print_token(const char* color, const char* text) {
    if (line_number != last_line_reported) {
        printf("\n[%d] ", line_number);
        last_line_reported = line_number;
    }
    printf("%s%s%s ", color, text, RESET_COLOR);
}
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

{ws} {
    for (int i = 0; yytext[i] != '\0'; i++) {
        if (yytext[i] == '\n') line_number++;
    }
}

{comment_line}      { print_token(COLOR_COMMENT, yytext); }
{comment_block}     { print_token(COLOR_COMMENT, yytext); }

"axiom"                 { print_token(COLOR_KEYWORD, yytext); }
"aut"                   { print_token(COLOR_KEYWORD, yytext); }
"casus"                 { print_token(COLOR_KEYWORD, yytext); }
"continuum"             { print_token(COLOR_KEYWORD, yytext); }
"designare"             { print_token(COLOR_KEYWORD, yytext); }
"Enumerare"             { print_token(COLOR_KEYWORD, yytext); }
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
{positive_real}         { print_token(COLOR_LITERAL, yytext); }
{negative_real}         { print_token(COLOR_LITERAL, yytext); }
{positive_digit}        { print_token(COLOR_LITERAL, yytext); }
{negative_digit}        { print_token(COLOR_LITERAL, yytext); }
{character_literal}     { print_token(COLOR_LITERAL, yytext); } 
{string_literal}        { print_token(COLOR_LITERAL, yytext); } 

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

"("                     { print_token(COLOR_DELIMITER, yytext); }
")"                     { print_token(COLOR_DELIMITER, yytext); }
";"                     { print_token(COLOR_DELIMITER, yytext); }
"{"                     { print_token(COLOR_DELIMITER, yytext); }
"}"                     { print_token(COLOR_DELIMITER, yytext); }
"|"                     { print_token(COLOR_DELIMITER, yytext); }
"->"                    { print_token(COLOR_DELIMITER, yytext); }

{identifier}            { print_token(COLOR_ID, yytext); }

.                       { print_token(COLOR_ERROR, yytext); }


%%

int main(void) {
    yylex();
    printf("\n");
    return 0;
}