%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"

extern int yylex();
extern int line_num;

void yyerror(const char* s);
%}

%union {
    int val_int;
    float val_float;
    char* str;
}

%token <val_int> LIT_INT
%token <val_float> LIT_FLOAT
%token <str> LIT_STRING LIT_CHAR IDENTIFIER

%token KW_SI KW_NON KW_ITERARE KW_PERSISTO KW_VERTERE KW_CASUS KW_AXIOM
%token KW_RUPTIO KW_CONTINUUM KW_REDIRE KW_MOL KW_HOMUNCULUS KW_ENUMERARE
%token KW_DESIGNARE KW_FORMULA KW_REVELARE KW_LECTURA KW_MAGNITUDO

%token TYPE_VACUUM TYPE_ATOMUS TYPE_FRACTIO TYPE_FRAGMENTUM TYPE_QUANTUM
%token TYPE_MAGNUS TYPE_MINIMUS TYPE_SYMBOLUM TYPE_SCRIPTUM

%token LIT_FACTUM LIT_FICTUM

%token OP_ARROW_ASSIGN OP_ARROW_CASE OP_DEREF_POINTER OP_ADDR_OF
%token OP_LSHIFT_ARRAY OP_RSHIFT_ARRAY OP_ACCESS_MEMBER OP_ACCESS_POINTER
%token OP_EXP OP_INTEGER_DIVIDE OP_ADD OP_SUBTRACT OP_MULTIPLY OP_DIVIDE
%token OP_MODULUS OP_EQUAL OP_NOT_EQUAL OP_GREATER_THAN OP_LESS_THAN
%token OP_GREATER_EQUAL OP_LESS_EQUAL OP_LOGICAL_AND OP_LOGICAL_OR
%token OP_LOGICAL_NOT OP_LOGICAL_XOR

%token LBRACE RBRACE SEMICOLON LPAREN RPAREN PIPE

%left OP_LOGICAL_OR KW_VEL
%left OP_LOGICAL_AND KW_ET
%left OP_EQUAL OP_NOT_EQUAL
%left OP_LESS_THAN OP_LESS_EQUAL OP_GREATER_THAN OP_GREATER_EQUAL
%left OP_ADD OP_SUBTRACT
%left OP_MULTIPLY OP_DIVIDE OP_MODULUS OP_INTEGER_DIVIDE OP_EXP
%right OP_LOGICAL_NOT KW_NE
%nonassoc LOWER_THAN_ELSE
%nonassoc KW_NON

%%

programa:
    comandos {
        printf("\nPrograma sintaticamente correto\n");
    }
;

comandos:
    comandos comando
    | comando
;

comando:
    atribuicao SEMICOLON
    | declaracao SEMICOLON
    | condicional
    | repeticao
    | bloco
;

bloco:
    LBRACE comandos RBRACE
;

atribuicao:
    expressao OP_ARROW_ASSIGN IDENTIFIER {
        // pode fazer verificação ou inserção na tabela
    }
;

declaracao:
    IDENTIFIER tipo {
        add_symbol($1, $2);
    }
    | expressao OP_ARROW_ASSIGN IDENTIFIER tipo {
        add_symbol($3, $4);
    }
;

tipo:
    TYPE_ATOMUS     { $$ = "atomus"; }
    | TYPE_FRACTIO  { $$ = "fractio"; }
    | TYPE_FRAGMENTUM { $$ = "fragmentum"; }
    | TYPE_QUANTUM  { $$ = "quantum"; }
    | TYPE_MAGNUS   { $$ = "magnus"; }
    | TYPE_MINIMUS  { $$ = "minimus"; }
    | TYPE_SYMBOLUM { $$ = "symbolum"; }
    | TYPE_SCRIPTUM { $$ = "scriptum"; }
    | TYPE_VACUUM   { $$ = "vacuum"; }
;

condicional:
    LPAREN expressao RPAREN KW_SI bloco
    | KW_NON bloco
    | KW_NON LPAREN expressao RPAREN KW_SI bloco
;

repeticao:
    LPAREN atribuicao SEMICOLON expressao SEMICOLON atribuicao RPAREN KW_ITERARE bloco
    | LPAREN expressao RPAREN KW_PERSISTO bloco
;

expressao:
    LIT_INT
    | LIT_FLOAT
    | LIT_STRING
    | LIT_CHAR
    | IDENTIFIER
    | LPAREN expressao RPAREN
    | expressao OP_ADD expressao
    | expressao OP_SUBTRACT expressao
    | expressao OP_MULTIPLY expressao
    | expressao OP_DIVIDE expressao
    | expressao OP_MODULUS expressao
    | expressao OP_EXP expressao
    | expressao OP_EQUAL expressao
    | expressao OP_NOT_EQUAL expressao
    | expressao OP_GREATER_THAN expressao
    | expressao OP_LESS_THAN expressao
    | expressao OP_GREATER_EQUAL expressao
    | expressao OP_LESS_EQUAL expressao
    | expressao OP_LOGICAL_AND expressao
    | expressao OP_LOGICAL_OR expressao
    | OP_LOGICAL_NOT expressao
;

%%

void yyerror(const char* s) {
    fprintf(stderr, "Erro sintático na linha %d: %s\n", line_num, s);
    exit(1);
}
