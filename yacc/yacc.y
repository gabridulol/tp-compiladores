%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define YACC_COLOR_ERROR     "\033[1;95m\033[4m"
#define YACC_COLOR_CORRECT   "\033[1;92m"
#define YACC_RESET_COLOR     "\033[0m"

extern int yylineno;

int yylex(void);
void yyerror(const char *s);
%}

%debug

%union {
    int val_int;
    double val_float;
    char *str;
}

%token KW_MAIN

%token KW_AXIOM
%token KW_AUT
%token KW_CASUS
%token KW_CONTINUUM
%token KW_DESIGNARE
%token KW_ENUMERARE
%token KW_ET
%token KW_EVOCARE
%token KW_FORMULA
%token KW_HOMUNCULUS
%token KW_ITERARE
%token KW_LECTURA
%token KW_MAGNITUDO
%token KW_MOL
%token KW_NE
%token KW_NON_SI
%token KW_NON
%token KW_PERSISTO
%token KW_REDIRE
%token KW_REVELARE
%token KW_RUPTIO
%token KW_SI
%token KW_VEL
%token KW_VERTERE

%token TYPE_ATOMUS
%token TYPE_FRACTIO
%token TYPE_FRAGMENTUM
%token TYPE_MAGNUS
%token TYPE_MINIMUS
%token TYPE_QUANTUM
%token TYPE_SCRIPTUM
%token TYPE_SYMBOLUM
%token TYPE_VACUUM

%token LIT_FACTUM
%token LIT_FICTUM
%token <val_float> LIT_FLOAT
%token <val_int> LIT_INT
%token <str> LIT_CHAR
%token <str> LIT_STRING

%token OP_ACCESS_POINTER
%token OP_ASSIGN
%token OP_GREATER_EQUAL
%token OP_LESS_EQUAL
%token OP_EQUAL
%token OP_NOT_EQUAL
%token OP_INTEGER_DIVIDE
%token OP_EXP
%token OP_LOGICAL_AND
%token OP_LOGICAL_OR
%token OP_MULTIPLY
%token OP_ADD
%token OP_SUBTRACT
%token OP_DIVIDE
%token OP_MODULUS
%token OP_ACCESS_MEMBER
%token OP_LOGICAL_NOT
%token OP_GREATER_THAN
%token OP_LESS_THAN
%token OP_LOGICAL_XOR
%token OP_ADDR_OF
%token OP_DEREF_POINTER

%token LOARRAY
%token ROARRAY
%token COLON
%token LPAREN
%token RPAREN
%token LBRACKET
%token RBRACKET
%token LBRACE
%token RBRACE
%token PIPE
%token SEMICOLON

%token <str> IDENTIFIER

%left OP_ADD
%left OP_SUBTRACT
%left OP_MULTIPLY
%left OP_DIVIDE
%left OP_MODULUS
%left OP_EXP
%left OP_INTEGER_DIVIDE

%left OP_EQUAL
%left OP_NOT_EQUAL
%left OP_LESS_THAN
%left OP_GREATER_THAN
%left OP_LESS_EQUAL
%left OP_GREATER_EQUAL

%left KW_ET
%left KW_VEL
%left KW_AUT

%left OP_ACCESS_MEMBER
%left OP_ACCESS_POINTER

%left OP_ASSIGN

%start translation_unit

%%

translation_unit
    : global_statement_list alchemia_statement
    ;

//

global_statement_list
    : /* vazio */
    | global_statement_list global_statement
    ;

global_statement
    : import_statement
    | declaration_statement
    | function_declaration_statement
    ;

//

alchemia_statement
    : IDENTIFIER LPAREN RPAREN KW_MAIN LBRACE statement_list RBRACE
    ;

statement_list
    : statement
    | statement_list statement
    ;

//

statement
    : expression_statement
    | declaration_statement
    | function_call_statement
    | return_statement
    ;

import_statement
    : IDENTIFIER KW_EVOCARE SEMICOLON 
    ;

//

expression_statement
    : expression SEMICOLON
    ;

primary_expression
    : IDENTIFIER
    | constant
    | string
    | LPAREN expression RPAREN
    ;

unary_expression
    : primary_expression
    | OP_LOGICAL_NOT unary_expression
    | OP_DEREF_POINTER unary_expression
    | OP_ADDR_OF unary_expression
    | OP_SUBTRACT unary_expression
    ;

expression
    : unary_expression
    | expression OP_ASSIGN IDENTIFIER
    | expression OP_ACCESS_POINTER IDENTIFIER
    | expression OP_ACCESS_MEMBER IDENTIFIER

    | expression OP_LOGICAL_XOR unary_expression
    | expression OP_LOGICAL_OR unary_expression
    | expression OP_LOGICAL_AND unary_expression

    | expression OP_EQUAL unary_expression
    | expression OP_NOT_EQUAL unary_expression
    | expression OP_LESS_THAN unary_expression
    | expression OP_GREATER_THAN unary_expression
    | expression OP_LESS_EQUAL unary_expression
    | expression OP_GREATER_EQUAL unary_expression

    | expression OP_ADD unary_expression
    | expression OP_SUBTRACT unary_expression
    | expression OP_MULTIPLY unary_expression
    | expression OP_DIVIDE unary_expression
    | expression OP_MODULUS unary_expression
    | expression OP_EXP unary_expression
    | expression OP_INTEGER_DIVIDE unary_expression
    ;

constant
    : LIT_INT
    | LIT_FLOAT
    | LIT_FACTUM
    | LIT_FICTUM
    | LIT_CHAR
    ;

string
    : LIT_STRING
    ;

//

declaration_statement
    : IDENTIFIER type_specifier SEMICOLON
    | expression OP_ASSIGN IDENTIFIER type_specifier SEMICOLON
    ;

type_specifier
    : TYPE_ATOMUS
    | TYPE_FRACTIO
    | TYPE_FRAGMENTUM
    | TYPE_MAGNUS
    | TYPE_MINIMUS
    | TYPE_QUANTUM
    | TYPE_SCRIPTUM
    | TYPE_SYMBOLUM
    | TYPE_VACUUM
    ;

//

function_declaration_statement
    : KW_FORMULA LPAREN parameter_list RPAREN IDENTIFIER OP_ASSIGN type_specifier LBRACE statement_list RBRACE

parameter_list
    : /* vazio */
    | parameter
    | parameter_list PIPE parameter
    ;

parameter
    : IDENTIFIER type_specifier
    ;

//

function_call_statement
    : LPAREN argument_list RPAREN IDENTIFIER SEMICOLON

argument_list
    : /* vazio */
    | expression
    | argument_list PIPE expression
    ;

//

return_statement
    : expression KW_REDIRE SEMICOLON
    ;


%%

void yyerror(const char *s) {
    printf("%s[ERRO SINTÁTICO] %s na linha %d%s\n", YACC_COLOR_ERROR, s, yylineno, YACC_RESET_COLOR);
}