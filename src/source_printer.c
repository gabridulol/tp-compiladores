#include "source_printer.h"

int ll_reported = 0;
int indent_level = 0;

extern int yylineno;

void token_printer(const char* color, const char* text) {
    if (yylineno != ll_reported) {
        if (ll_reported != 0)
            printf("\n");
        printf("[%4d] ", yylineno);
        for (int i = 0; i < indent_level; i++)
            printf("    ");
        ll_reported = yylineno;
    }

    printf("%s%s%s ", color, text, RESET_COLOR);
}

void lexical_error(const char* text) {
    printf("\n%s[ERRO SINTÁTICO] Token inválido '%s' na linha %d%s",
           LEX_COLOR_ERROR, text, yylineno, RESET_COLOR);
}

void semantic_error(const char *msg) {
    printf("\n%s[ERRO SEMÂNTICO] %s na linha %d%s",
           SEMANTIC_COLOR_ERROR, msg, yylineno, RESET_COLOR);
}

// void syntactic_error() {
void yyerror(const char *s) {
    extern char *yytext; // Token atual fornecido pelo Flex
    printf("\n\n%s[ERRO SINTÁTICO] %s na linha %d: token inesperado '%s'%s", 
           YACC_COLOR_ERROR, s, yylineno, yytext, RESET_COLOR);
}
// }

void correct_program() {
    printf("\n%s[PROGRAMA SINTATICAMENTE CORRETO]%s", COLOR_PROGRAM_CORRECT, RESET_COLOR);
}

void incorrect_program() {
    printf("\n%s[PROGRAMA SINTATICAMENTE INCORRETO]%s", COLOR_PROGRAM_INCORRECT, RESET_COLOR);
}