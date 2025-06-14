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

%union {
    int val_int;
    double val_float;
    char *str;
}

%token KW_AXIOM
%token KW_AUT
%token KW_CASUS
%token KW_CONTINUUM
%token KW_DESIGNARE
%token KW_ENUMERARE
%token KW_ET
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
    : statement_list
    ;

statement_list
    : statement
    | statement_list statement
    ;

statement
    : expression SEMICOLON {
        printf("%s[SINTATICAMENTE CORRETO]%s\n", YACC_COLOR_CORRECT, YACC_RESET_COLOR);
    }
    ;

/* === Constantes === */
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

/* === Expressão primária: unidades atômicas === */
primary_expression
    : IDENTIFIER
    | constant
    | string
    | LPAREN expression RPAREN
    ;

/* === Expressão unária: operadores que precedem === */
unary_expression
    : primary_expression
    | OP_LOGICAL_NOT unary_expression
    | OP_DEREF_POINTER unary_expression
    | OP_ADDR_OF unary_expression
    | OP_SUBTRACT unary_expression   // unário
    ;

/* === Expressão composta: operadores binários ===
     * Sem precedência: tudo é analisado da esquerda p/ direita
     * Parênteses forçam precedência */
expression
    : unary_expression
    | expression OP_ADD unary_expression
    | expression OP_SUBTRACT unary_expression
    | expression OP_MULTIPLY unary_expression
    | expression OP_DIVIDE unary_expression
    | expression OP_MODULUS unary_expression
    | expression OP_EXP unary_expression
    | expression OP_INTEGER_DIVIDE unary_expression

    | expression OP_EQUAL unary_expression
    | expression OP_NOT_EQUAL unary_expression
    | expression OP_LESS_THAN unary_expression
    | expression OP_GREATER_THAN unary_expression
    | expression OP_LESS_EQUAL unary_expression
    | expression OP_GREATER_EQUAL unary_expression

    | expression OP_LOGICAL_AND unary_expression
    | expression OP_LOGICAL_OR unary_expression
    | expression OP_LOGICAL_XOR unary_expression
    | expression OP_LOGICAL_NOT unary_expression

    | expression OP_ACCESS_MEMBER IDENTIFIER
    | expression OP_ACCESS_POINTER IDENTIFIER

    | expression OP_ASSIGN IDENTIFIER   // ex: valor --> x;
    ;

%%

void yyerror(const char *s) {
    printf("%s[ERRO SINTÁTICO] %s na linha %d%s\n", YACC_COLOR_ERROR, s, yylineno, YACC_RESET_COLOR);
}