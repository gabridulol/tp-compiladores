%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../src/symbol_table.h"
#include "../src/scope.h"
#include "../src/source_printer.h"

extern int yylineno;

int yylex(void);

void yyerror(const char *s);
%}

%union {
    int val_int;
    double val_float;
    char *str;
    void *ptr;
}

%token KW_MAIN

%token KW_CASUS
%token KW_AXIOM
%token KW_CONTINUUM
%token KW_RUPTIO
%token KW_VERTERE
/* %token KW_AUT -> OP_LOGICAL_XOR */
/* %token KW_ET -> OP_LOGICAL_AND */
/* %token KW_NE -> OP_LOGICAL_NOT */
/* %token KW_VEL -> OP_LOGICAL_OR */
%token KW_DESIGNARE
%token KW_ENUMERARE
%token KW_EVOCARE
%token KW_FORMULA
%token KW_HOMUNCULUS
%token KW_ITERARE
%token KW_LECTURA
%token KW_MAGNITUDO
%token KW_MOL
%token KW_NON_SI // Deprecated, NON SI is token KW_NON and KW_SI
%token KW_NON
%token KW_PERSISTO
%token KW_REDIRE
%token KW_REVELARE
%token KW_SI

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

%token LANGLE
%token RANGLE
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

%token LEX_ERROR // Lexical error token, not used in grammar

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

%left OP_ACCESS_MEMBER

%left OP_ASSIGN

%left OP_ACCESS_POINTER
%start translation_unit

%type <str> type_specifier
%type <ptr> expression
%type <ptr> constant
%type <ptr> string
%type <ptr> primary_expression
%type <ptr> argument_list
%type <ptr> unary_expression
%type <str> access_list
%type <str> member_access_direct
%type <str> member_access_dereference
%type <str> member_access_pointer
%type <ptr> vector_access
%type <ptr> pointer_statement
%type <ptr> pointer_assignment
%type <ptr> pointer_dereference

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

block
    : LBRACE
        { scope_push(); }     /* cria novo escopo */
      statement_list
      RBRACE
        { scope_pop(); }      /* volta ao escopo pai */
    ;

alchemia_statement
    : IDENTIFIER LPAREN RPAREN KW_MAIN block
    ;

statement_list
    : /* vazio */
    | statement_list statement
    ;

//

statement
    : expression_statement
    | iteration_statement
    | io_functions 
    | declaration_statement
    | function_call_statement
    | conditional_statement
    | type_define_statement
    | vector_statement
    | jump_statement
    | causal_statement
    | enum_assignment
    | assignment_statement
    ;

//

assignment_statement
    : expression OP_ASSIGN IDENTIFIER SEMICOLON
      {
          Symbol *sym = scope_lookup($3);
          if (sym == NULL) {
              yyerror("Variável não declarada!");
          } else {
              if (sym->value) free(sym->value);
              sym->value = $1;
          }
          free($3);
      }
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
      {
        Symbol *s = scope_lookup($1);
        if (!s)
            fprintf(stderr,
                "Erro: identificador '%s' não declarado na linha %d\n",
                $1, yylineno);
        $$ = (void*)$1;
        /* guarde ou use 's' conforme sua AST */
      }
    | vector_access             
    | pointer_statement         
    | constant                  { $$ = $1; }
    | string                    { $$ = $1; }
    | LPAREN expression RPAREN  { $$ = $2; }
    ;

unary_expression
    : primary_expression                { $$ = $1; }
    | OP_LOGICAL_NOT unary_expression   { $$ = $2; }
    | OP_DEREF_POINTER unary_expression { $$ = $2; }
    | OP_ADDR_OF unary_expression       { $$ = $2; }
    | OP_SUBTRACT unary_expression      { $$ = $2; }
    ;

expression
    : unary_expression { $$ = $1; }
    | expression OP_ASSIGN assing_value { $$ = $1; }
    | expression OP_ACCESS_POINTER assing_value
    | expression OP_ACCESS_MEMBER assing_value

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
    : LIT_INT    { int *v = malloc(sizeof(int)); *v = $1; $$ = v; }
    | LIT_FLOAT  { double *v = malloc(sizeof(double)); *v = $1; $$ = v; }
    | LIT_FACTUM { int *v = malloc(sizeof(int)); *v = 1; $$ = v; }
    | LIT_FICTUM { int *v = malloc(sizeof(int)); *v = 0; $$ = v; }
    | LIT_CHAR   { $$ = $1; }
    ;

string
    : LIT_STRING { $$ = $1; }
    ;

//

assing_value
    : IDENTIFIER
    | vector_access
    | pointer_statement
    ;

declaration_statement
    : IDENTIFIER type_specifier opcional_constant SEMICOLON{
          if (scope_lookup($1) != NULL) {
            Symbol *sym = scope_lookup($1);
            if(sym->kind != SYM_VAR) {
                yyerror("Variável já declarada com outro tipo!");
            } else {
              sym->kind = SYM_VAR;
              sym->line_declared = yylineno;
            }
          } else {
              scope_insert($1, SYM_VAR, $2, yylineno, NULL);
          }
          free($1);
      }
    | expression OP_ASSIGN IDENTIFIER type_specifier opcional_constant SEMICOLON{
          if (scope_lookup($3) != NULL) {
              Symbol *sym = scope_lookup($3);
              if (sym->value) free(sym->value);
              sym->value = $1;
          } else {
              scope_insert($3, SYM_VAR, $4, yylineno, $1);
          }
          free($3);
      }
    | pointer_declaration
    ;

opcional_constant
    : KW_MOL
    | /* vazio */
    ;

list_declaration_statement
    : declaration_statement list_declaration_statement
    | declaration_statement
    ;

type_specifier
    : TYPE_ATOMUS               { $$ = strdup("atomus"); }
    | TYPE_FRACTIO              { $$ = strdup("fractio"); }
    | TYPE_FRAGMENTUM           { $$ = strdup("fragmentum"); }
    | TYPE_MAGNUS               { $$ = strdup("magnus"); }
    | TYPE_MINIMUS              { $$ = strdup("minimus"); }
    | TYPE_QUANTUM              { $$ = strdup("quantum"); }
    | TYPE_SCRIPTUM             { $$ = strdup("scriptum"); }
    | TYPE_SYMBOLUM             { $$ = strdup("symbolum"); }
    | TYPE_VACUUM               { $$ = strdup("vacuum"); }
    | IDENTIFIER KW_ENUMERARE   { $$ = strdup($1); }
    | OP_DEREF_POINTER type_specifier {}
    
    ;

//

function_declaration_statement
    : KW_FORMULA
      LPAREN
        { scope_push(); }
      parameter_list
    RPAREN
      IDENTIFIER
      OP_ASSIGN
      type_specifier
      {
        Scope *parent = scope_stack->prev;
        if (scope_lookup_current($6) != NULL) {
          yyerror("Função já declarada!");
        } else {
          scope_insert($6, SYM_FUNC, $8, yylineno, NULL);
        }
        free($6);
      }
      LBRACE
        statement_list
      RBRACE
        { scope_pop(); }
    ;

parameter_list
    : /* vazio */
    | parameter
    | parameter_list PIPE parameter
    ;

parameter
    : IDENTIFIER type_specifier
      {
        /* current_scope → escopo da função, logo insere corretamente */
        if (scope_lookup_current($1) != NULL) {
          yyerror("Parâmetro já declarado!");
        } else {
          scope_insert($1, SYM_VAR, $2, yylineno, NULL);
        }
        free($1);
      }
    ;

//

function_call_statement
    : LPAREN argument_list RPAREN IDENTIFIER SEMICOLON

argument_list
    : /* vazio */ { $$ = NULL; }
    | expression  { $$ = $1; }
    | argument_list PIPE expression { /* ... */ }
    ;

// Declarações de salto: continuum, ruptio e redire
jump_statement
    : KW_CONTINUUM SEMICOLON
    | KW_RUPTIO SEMICOLON
    | KW_REDIRE SEMICOLON
    | expression KW_REDIRE SEMICOLON
    ;

// IF ELSE SWITCH

conditional_statement
    : LPAREN expression RPAREN KW_SI block
    | LPAREN expression RPAREN KW_SI block conditional_non_statement
    | LPAREN expression RPAREN KW_VERTERE LBRACE causal_statement RBRACE
    ;

conditional_non_statement
    : KW_NON block
    | KW_NON conditional_statement
    ;

// Causas | Axiomas 
causal_statement
    : KW_CASUS expression COLON statement_list 
    | KW_AXIOM COLON statement_list 
    ;

//  Laços de repetição: while() e for(; ;), 

iteration_statement
	: LPAREN expression RPAREN KW_PERSISTO block
	| LPAREN expression_statement expression_statement RPAREN KW_ITERARE block
	| LPAREN expression_statement expression_statement expression RPAREN KW_ITERARE block
	| LPAREN declaration_statement expression_statement RPAREN KW_ITERARE  block
	| LPAREN declaration_statement expression_statement expression RPAREN KW_ITERARE block
	;

// Funções pontas (lectura / revelare / magnitudo)

io_functions 
    : function_input_output
    | function_magnitudo
    ;

function_input_output
    : identifier_langle_list
    | identifier_rangle_list
    ;

identifier_langle_list
    : IDENTIFIER LANGLE KW_LECTURA SEMICOLON
    | IDENTIFIER LANGLE identifier_langle_list
    ;

identifier_rangle_list
    : IDENTIFIER RANGLE KW_REVELARE SEMICOLON
    | IDENTIFIER RANGLE identifier_rangle_list
    ;

function_magnitudo
    : LPAREN type_expression RPAREN KW_MAGNITUDO SEMICOLON
    ;

type_expression
    : type_specifier
    ;

// Declarações de typedef | struct | enum

type_define_statement
    : KW_DESIGNARE type_specifier IDENTIFIER SEMICOLON
      {
        scope_insert($3, SYM_TYPE, $2, yylineno, NULL);
        free($3);
      }
    | IDENTIFIER  LBRACE list_declaration_statement RBRACE KW_DESIGNARE KW_HOMUNCULUS SEMICOLON
    | type_define_enum
    ;

type_define_enum
    : IDENTIFIER LBRACE enum_list RBRACE KW_ENUMERARE SEMICOLON
    ;

enum_assignment
    : IDENTIFIER OP_ASSIGN IDENTIFIER IDENTIFIER KW_ENUMERARE SEMICOLON
      {
            if (scope_lookup($1) != NULL) {
                yyerror("Enumeração já declarada!");
            } else {
                scope_insert($1, SYM_ENUM, $4, yylineno, NULL);
            }
            free($1);
      }
    ;

// Enumerações   COMUM    |   COMUM --> 1   |    COMUM --> 'b'
enum_list
    : IDENTIFIER
    | IDENTIFIER OP_ASSIGN LIT_INT
    | IDENTIFIER OP_ASSIGN LIT_CHAR
    | enum_list PIPE IDENTIFIER
    | enum_list PIPE IDENTIFIER OP_ASSIGN LIT_INT
    | enum_list PIPE IDENTIFIER OP_ASSIGN LIT_CHAR
    ;

// Vetor
vector
    : IDENTIFIER type_specifier LANGLE expression RANGLE SEMICOLON
    | IDENTIFIER SEMICOLON
    ;
    
vector_statement
    : IDENTIFIER type_specifier LANGLE expression RANGLE SEMICOLON
    | LBRACKET argument_list RBRACKET OP_ASSIGN vector
    | LBRACKET argument_list RBRACKET OP_ASSIGN IDENTIFIER type_specifier LANGLE RANGLE SEMICOLON
    ;

vector_access
    : IDENTIFIER LANGLE expression RANGLE { $$ = NULL; }
    ;


// Ponteiros
pointer_statement
    : pointer_assignment      { $$ = $1; }
    | pointer_dereference    { $$ = $1; }
    | member_access_direct   { $$ = $1; }
    | member_access_dereference { $$ = $1; }
    | member_access_pointer  { $$ = $1; }
    ;

pointer_declaration
    : IDENTIFIER OP_DEREF_POINTER type_specifier SEMICOLON
      {
          char tipo_ponteiro[MAX_NAME_LEN];
          snprintf(tipo_ponteiro, MAX_NAME_LEN, "%s*", $3);
          scope_insert($1, SYM_VAR, tipo_ponteiro, yylineno, NULL);
          free($1);
          free($3);
      }
    | expression OP_ASSIGN IDENTIFIER OP_DEREF_POINTER type_specifier SEMICOLON
      {
          char tipo_ponteiro[MAX_NAME_LEN];
          snprintf(tipo_ponteiro, MAX_NAME_LEN, "%s*", $5);
          scope_insert($3, SYM_VAR, tipo_ponteiro, yylineno, $1);
          free($3);
          free($5);
      }

pointer_assignment
    : IDENTIFIER OP_ADDR_OF { $$ = (void*)$1;}
    ;

pointer_dereference
    : OP_DEREF_POINTER IDENTIFIER { $$ = (void*)$2;}
    ;

access_list
    : IDENTIFIER
      {
          $$ = $1; // Retorna o identificador
      }
    | access_list OP_ACCESS_MEMBER IDENTIFIER
      {
          $$ = $3; // Retorna o último identificador
      }
    ;

member_access_direct
    : access_list
    ;

member_access_dereference
    : LPAREN OP_DEREF_POINTER IDENTIFIER RPAREN OP_ACCESS_MEMBER access_list
      {
          $$ = $6; // Retorna o último identificador
      }
    ;

member_access_pointer
    : IDENTIFIER OP_ACCESS_POINTER access_list
      {
          $$ = $3; // Retorna o último identificador
      }
    ;

%%