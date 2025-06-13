%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;
extern int yylex(void);
extern int yylineno;

void yyerror(const char *s);
%}

%union {
    int val_int;
    double val_float;
    char *str;
}

%token <str> IDENTIFIER LIT_STRING LIT_CHAR
%token <val_int> LIT_INT
%token <val_float> LIT_FLOAT

%type <str> primary expression

%token KW_SI KW_NON KW_ITERARE KW_PERSISTO KW_VERTERE KW_CASUS KW_AXIOM
%token KW_RUPTIO KW_CONTINUUM KW_REDIRE KW_MOL KW_HOMUNCULUS KW_ENUMERARE
%token KW_DESIGNARE KW_FORMULA KW_REVELARE KW_LECTURA KW_MAGNITUDO
%token KW_ET KW_VEL KW_NE KW_AUT

%token TYPE_VACUUM TYPE_ATOMUS TYPE_FRAGMENTUM TYPE_FRACTIO TYPE_QUANTUM
%token TYPE_MAGNUS TYPE_MINIMUS TYPE_SYMBOLUM TYPE_SCRIPTUM

%token LIT_FACTUM LIT_FICTUM

%token OP_ARROW_ASSIGN
%token OP_DEREF_POINTER
%token OP_ADDR_OF
%token OP_LSHIFT_ARRAY OP_RSHIFT_ARRAY
%token OP_ACCESS_MEMBER OP_ACCESS_POINTER
%token OP_EXP OP_INTEGER_DIVIDE
%token OP_ADD OP_SUBTRACT OP_MULTIPLY OP_DIVIDE OP_MODULUS
%token OP_EQUAL OP_NOT_EQUAL OP_LESS_THAN OP_GREATER_THAN OP_LESS_EQUAL OP_GREATER_EQUAL
%token OP_LOGICAL_AND OP_LOGICAL_OR OP_LOGICAL_NOT OP_LOGICAL_XOR
%token LBRACE RBRACE SEMICOLON LPAREN RPAREN PIPE COLON

%start program

%right OP_ARROW_ASSIGN
%left KW_VEL OP_LOGICAL_OR
%left KW_ET OP_LOGICAL_AND
%left KW_AUT OP_LOGICAL_XOR
%nonassoc OP_EQUAL OP_NOT_EQUAL OP_LESS_THAN OP_GREATER_THAN OP_LESS_EQUAL OP_GREATER_EQUAL
%left OP_ADD OP_SUBTRACT
%left OP_MULTIPLY OP_DIVIDE OP_MODULUS OP_INTEGER_DIVIDE
%right OP_EXP
%right PREC_UNARY
%precedence OP_LOGICAL_NOT KW_NE OP_DEREF_POINTER UNARY_MINUS

%%
program:
      /* empty */
    | program statement
    ;

statement:
      declaration { printf("[OK] Declaration\n"); }
    | command     { printf("[OK] Command\n"); }
    ;

declaration:
      var_decl
    | func_decl
    | type_decl
    | typedef_decl
    ;

var_decl:
      IDENTIFIER type SEMICOLON
    | KW_MOL IDENTIFIER type SEMICOLON
    | IDENTIFIER type OP_ARROW_ASSIGN expression SEMICOLON
    | KW_MOL IDENTIFIER type OP_ARROW_ASSIGN expression SEMICOLON
    ;

type_decl:
      IDENTIFIER LBRACE struct_body RBRACE KW_HOMUNCULUS SEMICOLON
    | IDENTIFIER LBRACE enum_list RBRACE KW_ENUMERARE SEMICOLON
    ;

struct_body:
      /* empty */
    | struct_body var_decl
    ;

enum_list:
      IDENTIFIER
    | enum_list PIPE IDENTIFIER
    ;

typedef_decl:
      type IDENTIFIER KW_DESIGNARE SEMICOLON
    ;

func_decl:
      KW_FORMULA LPAREN param_list_opt RPAREN IDENTIFIER OP_ARROW_ASSIGN type LBRACE program RBRACE
    ;

param_list_opt:
      /* empty */
    | param_list
    ;

param_list:
      param
    | param_list PIPE param
    ;

param:
      IDENTIFIER type
    ;

type:
      base_type
    | type OP_DEREF_POINTER
    | type OP_LSHIFT_ARRAY expression_opt OP_RSHIFT_ARRAY
    ;

base_type:
      TYPE_VACUUM
    | TYPE_ATOMUS
    | TYPE_FRAGMENTUM
    | TYPE_FRACTIO
    | TYPE_QUANTUM
    | TYPE_MAGNUS
    | TYPE_MINIMUS
    | TYPE_SYMBOLUM
    | TYPE_SCRIPTUM
    | IDENTIFIER
    ;

expression_opt:
      /* empty */
    | expression
    ;

command:
      if_command
    | while_command
    | for_command
    | switch_command
    | return_command SEMICOLON
    | assign_command SEMICOLON
    | func_call SEMICOLON
    | break_command
    | continue_command
    | scan_command
    | print_command
    | block
    | SEMICOLON
    ;

assign_command:
      expression OP_ARROW_ASSIGN expression
    ;

if_command:
      LPAREN expression RPAREN KW_SI command else_part_opt
    ;

else_part_opt:
      /* empty */
    | KW_NON command
    ;

while_command:
      LPAREN expression RPAREN KW_PERSISTO command
    ;

for_command:
      LPAREN assign_command_opt SEMICOLON expression_opt SEMICOLON expression_opt RPAREN KW_ITERARE command
    ;

assign_command_opt:
      /* empty */
    | assign_command
    ;

switch_command:
      LPAREN expression RPAREN KW_VERTERE LBRACE case_list default_case_opt RBRACE
    ;

case_list:
      /* empty */
    | case_list case_entry
    ;

case_entry:
      KW_CASUS expression COLON block
    ;

default_case_opt:
      /* empty */
    | KW_AXIOM COLON block
    ;

return_command:
      expression_opt KW_REDIRE
    ;

break_command:
      KW_RUPTIO SEMICOLON
    ;

continue_command:
      KW_CONTINUUM SEMICOLON
    ;

scan_command:
      LPAREN expression RPAREN KW_LECTURA SEMICOLON
    ;

print_command:
      LPAREN expression RPAREN KW_REVELARE SEMICOLON
    ;

block:
      LBRACE program RBRACE
    ;

expression:
      expression KW_VEL expression
    | expression OP_LOGICAL_OR expression
    | expression KW_ET expression
    | expression OP_LOGICAL_AND expression
    | expression KW_AUT expression
    | expression OP_LOGICAL_XOR expression
    | expression OP_EQUAL expression
    | expression OP_NOT_EQUAL expression
    | expression OP_LESS_THAN expression
    | expression OP_GREATER_THAN expression
    | expression OP_LESS_EQUAL expression
    | expression OP_GREATER_EQUAL expression
    | expression OP_ADD expression
    | expression OP_SUBTRACT expression
    | expression OP_MULTIPLY expression
    | expression OP_DIVIDE expression
    | expression OP_MODULUS expression
    | expression OP_INTEGER_DIVIDE expression
    | expression OP_EXP expression
    | unary_expr
    ;

unary_expr:
      primary
    | OP_SUBTRACT unary_expr %prec UNARY_MINUS
    | OP_LOGICAL_NOT unary_expr %prec PREC_UNARY
    | KW_NE unary_expr %prec PREC_UNARY
    | OP_DEREF_POINTER unary_expr %prec PREC_UNARY
    | LPAREN type RPAREN unary_expr %prec PREC_UNARY
    ;

primary:
      IDENTIFIER
    | LIT_INT
    | LIT_FLOAT
    | LIT_STRING
    | LIT_CHAR
    | LIT_FACTUM
    | LIT_FICTUM
    | LPAREN expression RPAREN
    | func_call
    | sizeof_expr
    ;

sizeof_expr:
      KW_MAGNITUDO LPAREN type RPAREN
    | KW_MAGNITUDO LPAREN expression RPAREN
    ;

func_call:
      LPAREN arg_list_opt RPAREN IDENTIFIER
    ;

arg_list_opt:
      /* empty */
    | arg_list
    ;

arg_list:
      expression
    | arg_list PIPE expression
    ;

%%

int main(int argc, char *argv[]) {
    if (argc > 1) {
        FILE *inputFile = fopen(argv[1], "r");
        if (!inputFile) {
            perror(argv[1]);
            return 1;
        }
        yyin = inputFile;
    } else {
        printf("Reading from stdin (Ctrl+D to finish):\n");
        yyin = stdin;
    }

    printf("--- Parsing Started ---\n");
    int result = yyparse();

    if (result == 0)
        printf("--- Parsing Successful ---\n");
    else
        printf("--- Syntax Error ---\n");

    if (argc > 1 && yyin != stdin)
        fclose(yyin);

    return result;
}

void yyerror(const char *s) {
    fprintf(stderr, "[Syntax Error] Line %d: %s\n", yylineno, s);
}