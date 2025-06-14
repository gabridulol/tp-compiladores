#ifndef SOURCE_PRINTER_H
#define SOURCE_PRINTER_H

#include <stdio.h>

// Cores ANSI
#define RESET_COLOR "\033[0m"
#define COLOR_LITERAL "\033[1;94m"
#define COLOR_KEYWORD "\033[1;93m"
#define COLOR_ID "\033[1;92m"
#define COLOR_OPERATOR "\033[1;91m"
#define COLOR_DELIMITER "\033[1;95m"
#define LEX_COLOR_ERROR "\033[1;91m\033[4m"
#define YACC_COLOR_ERROR "\033[1;95m\033[4m"
#define COLOR_COMMENT "\033[1;97m"

#define COLOR_PROGRAM_CORRECT "\033[1;92m"
#define COLOR_PROGRAM_INCORRECT "\033[1;31m"

extern int ll_reported;
extern int indent_level;

void token_printer(const char* color, const char* text);
void lexical_error(const char* text);
// void syntactic_error();
void yyerror(const char *s);
void correct_program();
void incorrect_program();

#endif // SOURCE_PRINTER_H