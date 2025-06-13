// new yacc.y

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

%token KW_IF KW_ELSE KW_FOR KW_WHILE KW_SWITCH KW_CASE KW_DEFAULT
%token KW_BREAK KW_CONTINUE KW_RETURN KW_CONST KW_STRUCT KW_ENUM
%token KW_TYPEDEF KW_FUNC KW_PRINT KW_SCAN KW_SIZEOF
%token KW_AND KW_OR KW_NOT KW_XOR

%token TYPE_VOID TYPE_INT TYPE_DOUBLE TYPE_FLOAT TYPE_BOOL
%token TYPE_LONG TYPE_SHORT TYPE_CHAR TYPE_STRING

%token LIT_TRUE LIT_FALSE

%token ASSIGN_PTR
%token DEREF_PTR
%token ADDR_OF
%token LBRACK RBRACK
%token DOT PTR_ACCESS
%token EXPONENT DIV_INT
%token ADD SUB MUL DIV MOD
%token EQ NE LT GT LE GE
%token LOG_AND LOG_OR LOG_NOT LOG_XOR
%token LBRACE RBRACE SEMICOLON LPAREN RPAREN PIPE ARROW

%start program

%right ASSIGN_PTR
%left KW_OR LOG_OR
%left KW_AND LOG_AND
%left KW_XOR LOG_XOR
%nonassoc EQ NE LT GT LE GE
%left ADD SUB
%left MUL DIV MOD DIV_INT
%right EXPONENT
%right PREC_UNARY
%precedence LOG_NOT KW_NOT DEREF_PTR UNARY_MINUS

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
    | KW_CONST IDENTIFIER type SEMICOLON
    | IDENTIFIER type ASSIGN_PTR expression SEMICOLON
    | KW_CONST IDENTIFIER type ASSIGN_PTR expression SEMICOLON
    ;

type_decl:
      IDENTIFIER LBRACE struct_body RBRACE KW_STRUCT SEMICOLON
    | IDENTIFIER LBRACE enum_list RBRACE KW_ENUM SEMICOLON
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
      type IDENTIFIER KW_TYPEDEF SEMICOLON
    ;

func_decl:
      KW_FUNC LPAREN param_list_opt RPAREN IDENTIFIER ASSIGN_PTR type LBRACE program RBRACE
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
    | type DEREF_PTR
    | type LBRACK expression_opt RBRACK
    ;

base_type:
      TYPE_VOID
    | TYPE_INT
    | TYPE_DOUBLE
    | TYPE_FLOAT
    | TYPE_BOOL
    | TYPE_LONG
    | TYPE_SHORT
    | TYPE_CHAR
    | TYPE_STRING
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
      expression ASSIGN_PTR expression
    ;

if_command:
      LPAREN expression RPAREN KW_IF command else_part_opt
    ;

else_part_opt:
      /* empty */
    | KW_ELSE command
    ;

while_command:
      LPAREN expression RPAREN KW_WHILE command
    ;

for_command:
      LPAREN assign_command_opt SEMICOLON expression_opt SEMICOLON expression_opt RPAREN KW_FOR command
    ;

assign_command_opt:
      /* empty */
    | assign_command
    ;

switch_command:
      LPAREN expression RPAREN KW_SWITCH LBRACE case_list default_case_opt RBRACE
    ;

case_list:
      /* empty */
    | case_list case_entry
    ;

case_entry:
      KW_CASE expression ARROW block
    ;

default_case_opt:
      /* empty */
    | KW_DEFAULT ARROW block
    ;

return_command:
      expression_opt KW_RETURN
    ;

break_command:
      KW_BREAK SEMICOLON
    ;

continue_command:
      KW_CONTINUE SEMICOLON
    ;

scan_command:
      LPAREN expression RPAREN KW_SCAN SEMICOLON
    ;

print_command:
      LPAREN expression RPAREN KW_PRINT SEMICOLON
    ;

block:
      LBRACE program RBRACE
    ;

expression:
      expression KW_OR expression
    | expression LOG_OR expression
    | expression KW_AND expression
    | expression LOG_AND expression
    | expression KW_XOR expression
    | expression LOG_XOR expression
    | expression EQ expression
    | expression NE expression
    | expression LT expression
    | expression GT expression
    | expression LE expression
    | expression GE expression
    | expression ADD expression
    | expression SUB expression
    | expression MUL expression
    | expression DIV expression
    | expression MOD expression
    | expression DIV_INT expression
    | expression EXPONENT expression
    | unary_expr
    ;

unary_expr:
      primary
    | SUB unary_expr %prec UNARY_MINUS
    | LOG_NOT unary_expr %prec PREC_UNARY
    | KW_NOT unary_expr %prec PREC_UNARY
    | DEREF_PTR unary_expr %prec PREC_UNARY
    | LPAREN type RPAREN unary_expr %prec PREC_UNARY
    ;

primary:
      IDENTIFIER
    | LIT_INT
    | LIT_FLOAT
    | LIT_STRING
    | LIT_CHAR
    | LIT_TRUE
    | LIT_FALSE
    | LPAREN expression RPAREN
    | func_call
    | sizeof_expr
    ;

sizeof_expr:
      KW_SIZEOF LPAREN type RPAREN
    | KW_SIZEOF LPAREN expression RPAREN
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
