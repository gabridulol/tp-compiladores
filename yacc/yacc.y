%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../src/symbol_table.h"
#include "../src/scope.h"
#include "../src/source_printer.h"
#include "../src/expression.h"
#include "../src/loops.h"
#include "../src/three_address_code.h"
#define MAX_LABEL_STACK 1024
static char *label_else_stack[MAX_LABEL_STACK];
static char *label_end_stack[MAX_LABEL_STACK];
static int  label_stack_top = 0;

static void push_labels(char *l_else, char *l_end) {
    label_else_stack[label_stack_top] = l_else;
    label_end_stack[label_stack_top] = l_end;
    label_stack_top++;
}
static char *top_label_else() { return label_else_stack[label_stack_top-1]; }
static char *top_label_end()  { return label_end_stack[label_stack_top-1];  }
static void pop_labels()      { label_stack_top--; }

  #define MAX_REL_STACK 1024
  static char *rel_label_stack[MAX_REL_STACK];
  static int   rel_label_top = 0;
  static void  push_rel_label(char *L) { rel_label_stack[rel_label_top++] = L; }
  static char* top_rel_label()        { return rel_label_stack[rel_label_top-1]; }
  static char* pop_rel_label()        { return rel_label_stack[--rel_label_top]; }

  extern int yylineno;
  int yylex(void);
  void yyerror(const char *s);

extern int yylineno;

typedef struct ArgNode {
    void* value;          // Ponteiro para o valor do argumento
    struct ArgNode* next; // Ponteiro para o próximo argumento na lista
} ArgNode;


FieldTable *current_struct_fields = NULL;

int yylex(void);

void yyerror(const char *s);

static bool in_loop_cond = false;

static void emit_rel(const char *op, const char *l, const char *r, const char *t) {
  if (!in_loop_cond)      // só emite no parsing normal
    emit(op, l, r, t);
}
%}

%debug

%union {
    int val_int;
    double val_float;
    char *str;
    void* ptr;
    // void *ptr; Substituido
    struct ArgNode* arg_list; // ----> ADICIONE ESTA LINHA À SUA UNION <----
    struct Expression* expr;
    struct Symbol* sym_ptr;
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
/* %token KW_NON_SI // Deprecated, NON SI is token KW_NON and KW_SI */
%token KW_NON
%token KW_PERSISTO
%token KW_REDIRE
%token KW_REVELARE
%token KW_SI

%token KW_TYPE_ATOMUS
%token KW_TYPE_FRACTIO
%token KW_TYPE_FRAGMENTUM
%token KW_TYPE_MAGNUS
%token KW_TYPE_MINIMUS
%token KW_TYPE_QUANTUM
%token KW_TYPE_SCRIPTUM
%token KW_TYPE_SYMBOLUM
%token KW_TYPE_VACUUM

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

%left OP_ADD OP_SUBTRACT OP_MULTIPLY OP_DIVIDE OP_MODULUS OP_EXP OP_INTEGER_DIVIDE
%left OP_EQUAL OP_NOT_EQUAL OP_LESS_THAN OP_GREATER_THAN OP_LESS_EQUAL OP_GREATER_EQUAL
%left OP_LOGICAL_AND OP_LOGICAL_OR OP_LOGICAL_XOR



%left OP_ASSIGN
%left SEMICOLON
%left OP_ACCESS_MEMBER


%left OP_ACCESS_POINTER
%start translation_unit

%type <str> type_specifier
%type <expr> expression expression_statement
%type <expr> constant
%type <expr> string
%type <expr> primary_expression

%type <expr> unary_expression
%type <expr> member_access_direct  
%type <expr> member_access_dereference
%type <expr> member_access_pointer
%type <expr> vector_access
%type <expr> pointer_statement
%type <expr> pointer_assignment
%type <expr> pointer_dereference
%type <expr> conditional_statement
%type <expr> conditional_non_statement
%type <expr> assignment_statement
/* %type <expr> import_statement
%type <expr> alchemia_statement */


%type <arg_list> argument_list

%type <ptr> block
%type <ptr> struct_member_lvalue
%type <ptr> declaration_statement


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
    | type_define_statement
    ;

//


block
  : LBRACE
    statement_list
    RBRACE
      {
        /* Se você quisesse retornar um “ponteiro” para o bloco,
           usaria algo como $$ = $2; aqui. */
        $$ = NULL;        

        /* Desempilha o escopo que criamos no início */
        scope_pop();    
      }
  ;


alchemia_statement
    : IDENTIFIER LPAREN RPAREN KW_MAIN 
    {
        scope_insert($1, SYM_FUNC, "void", yylineno, NULL);
        scope_push_formula(BLOCK_FUNCTION, "void"); 
        init_tac_generator(); emit("label", "", "", "main");
    } 
    block 
    {
        finish_tac_generator();
    }
    ;


statement_list
    : /* vazio */
    | statement_list statement
    ;

//

statement
    : conditional_statement 
    | expression_statement 
    | iteration_statement 
    | io_functions 
    | declaration_statement 
    | function_call_statement 
    | type_define_statement
    | vector_statement 
    | jump_statement 
    | causal_statement 
    | assignment_statement 
    | print_statement 
    ;

//

struct_member_lvalue
    : IDENTIFIER OP_ACCESS_MEMBER IDENTIFIER
      {
          Symbol* var = scope_lookup($3);
          if (!var || !var->instance_fields) {
              char err[128];
              snprintf(err, sizeof(err), "Variável de struct '%s' não declarada ou não é struct", $3);
              semantic_error(err);
              $$ = NULL;
          } else {
              Symbol* campo = st_lookup(var->instance_fields, $1);
              if (!campo) {
                  char err[128];
                  snprintf(err, sizeof(err), "Campo '%s' não existe na instância da struct '%s'", $1, $3);
                  semantic_error(err);
                  $$ = NULL;
              } else {
                  $$ = campo;
              }
          }
          free($1);
          free($3);
      }
    ;

assignment_statement
    :  expression OP_ASSIGN struct_member_lvalue SEMICOLON
      {
          Symbol* campo = $3;
          if (!campo) {
              semantic_error("Campo de struct não encontrado!");
          } else {
              DataType campo_type = string_to_type(campo->type);
              if (campo_type != $1->type) {
                  semantic_error("Tipo incompatível na atribuição ao campo da struct!");
              }
          }
          emit("=", get_temp_name($1), "", $3);
      }
    | expression OP_ASSIGN IDENTIFIER SEMICOLON {
          Expression* val = $1;
          char* var_name = $3;
          Symbol* sym = scope_lookup(var_name);
          DataType declared = string_to_type(sym->type);
          DataType given    = val->type;

        if (!sym) {
            char err_msg[128];
            sprintf(err_msg, "Erro semântico: variável '%s' não declarada.", var_name);
            semantic_error(err_msg);
        }
        if (!sym) {
            yyerror("Variável não declarada.");
        }
        else if (given == declared) {
            // caso normal
            emit("=", val->tac_name, "", var_name);
        }
        else if (given == TYPE_ATOMUS && declared == TYPE_FRACTIO) {
            // promoção int → float
            char* tcast = new_temp();
            // gera um TAC que converte int pra float
            emit("intToFloat", "", val->tac_name, tcast);
            // depois atribui ao destino
            emit("=", tcast, "", var_name);
        }
        else {
            char err_msg[256];
            sprintf(err_msg, "Erro de tipo: impossível atribuir valor à variável '%s'.", var_name);
            semantic_error(err_msg);
        }
        $$ = NULL;
      }
    | expression OP_ASSIGN IDENTIFIER LANGLE expression RANGLE SEMICOLON // Atribuição a um elemento de um vetor
      {
          Expression* value_expr = $1;
          Expression* index_expr = $5;
          char* vec_name = $3;
          Symbol* sym = scope_lookup(vec_name);

          // 1. Validar se o símbolo existe e é um vetor
          if (!sym || sym->kind != SYM_VECTOR) {
              char err_msg[128];
              sprintf(err_msg, "Erro semântico: identificador '%s' não é um vetor declarado.", vec_name);
              semantic_error(err_msg);
          } else {
              // 2. Checar os tipos da expressão de índice e do valor
              DataType element_type = string_to_type(sym->type);
              if (index_expr->type != TYPE_ATOMUS) {
                  semantic_error("Erro de tipo: o índice de um vetor deve ser um inteiro (atomus).");
              } else if (value_expr->type != element_type) {
                  semantic_error("Erro de tipo: o valor a ser atribuído é incompatível com o tipo do vetor.");
              } else {
                  // 3. Realizar a atribuição
                  int index = *(int*)(index_expr->value); // Extrai o valor do índice

                  // Verificação de limites (bounds checking)
                  if (index < 0 || index >= sym->data.vector_info.size) {
                      char err_msg[128];
                      sprintf(err_msg, "Erro: Índice '%d' fora dos limites do vetor '%s'.", index, vec_name);
                      semantic_error(err_msg);
                  } 
              }
          }

          // 4. Limpeza da memória
          free_expression(value_expr);
          free_expression(index_expr);
          free(vec_name);
      }
    | IDENTIFIER OP_ADDR_OF OP_ASSIGN IDENTIFIER SEMICOLON
      {
          // Exemplo: a£ --> b;
          // $1 = a, $4 = b
          Symbol* var = scope_lookup($1);
          Symbol* ptr = scope_lookup($4);

          if (!var) {
              char err[128];
              snprintf(err, sizeof(err), "Variável '%s' não declarada.", $1);
              semantic_error(err);
          } else if (!ptr || !strstr(ptr->type, "*")) {
              char err[128];
              snprintf(err, sizeof(err), "Variável '%s' não é um ponteiro.", $4);
              semantic_error(err);
          } else {
              char base_type[MAX_NAME_LEN];
              get_base_type_from_pointer(ptr->type, base_type);
              if (strcmp(var->type, base_type) != 0) {
                  semantic_error("Tipo do ponteiro incompatível com o endereço atribuído.");
              } else {
                if (ptr->data.value) free(ptr->data.value);
                void** endereco = malloc(sizeof(void*));
                *endereco = var; // Armazena o ponteiro para o símbolo da struct
                ptr->data.value = endereco;
            }
          }
          free($1);
          free($4);
      }
    | OP_DEREF_POINTER IDENTIFIER OP_ASSIGN IDENTIFIER SEMICOLON
      {
          // Exemplo: °a --> x;
          // $2 = a, $4 = x
          Symbol* ptr = scope_lookup($2);
          Symbol* dest = scope_lookup($4);

          if (!ptr || !strstr(ptr->type, "*")) {
              char err[128];
              snprintf(err, sizeof(err), "Variável '%s' não é um ponteiro.", $2);
              semantic_error(err);
          } else if (!dest) {
              char err[128];
              snprintf(err, sizeof(err), "Variável '%s' não declarada.", $4);
              semantic_error(err);
          } else {
              char base_type[MAX_NAME_LEN];
              get_base_type_from_pointer(ptr->type, base_type);
              if (strcmp(dest->type, base_type) != 0) {
                  semantic_error("Tipo incompatível na atribuição do valor desreferenciado.");
              } else {
                  void* endereco = ptr->data.value ? *((void**)ptr->data.value) : NULL;
                  if (!endereco) {
                      semantic_error("Ponteiro nulo ao desreferenciar.");
                  } else {
                      size_t sz = get_size_from_type(dest->type);
                      if (dest->data.value) free(dest->data.value);
                      dest->data.value = malloc(sz);
                      memcpy(dest->data.value, endereco, sz);
                  }
              }
          }
          free($2);
          free($4);
      }
    
    ;

import_statement
    : IDENTIFIER KW_EVOCARE SEMICOLON 
   ;

//

print_statement
  : KW_REVELARE LPAREN IDENTIFIER RPAREN SEMICOLON
    {
        Symbol* s = scope_lookup($3);
        if (s) {
            // Checa se o ponteiro para o dado existe, indicando inicialização
            if (s->data.value) {
                // Converte o tipo do símbolo de string para um enum para o switch
                DataType type = string_to_type(s->type);

                switch(type) {
                    case TYPE_ATOMUS:
                        printf("» %s = %d\n", s->name, *(int*)s->data.value);
                        break;
                    case TYPE_FRACTIO:
                        printf("» %s = %f\n", s->name, *(double*)s->data.value);
                        break;
                    case TYPE_SCRIPTUM:
                        printf("» %s = \"%s\"\n", s->name, (char*)s->data.value);
                        break;
                    case TYPE_SYMBOLUM:
                        printf("» %s = '%c'\n", s->name, *(char*)s->data.value);
                        break;
                    case TYPE_QUANTUM:
                        // Imprime 'factum' para verdadeiro (1) e 'fictum' para falso (0)
                        printf("» %s = %s\n", s->name, *(int*)s->data.value ? "factum" : "fictum");
                        break;
                    default:
                        printf("» '%s' é de um tipo não imprimível.\n", s->name);
                        break;
                }
            } else {
                printf("» variavel '%s' nao inicializada\n", $3);
            }
        } else {
            char err_msg[128];
            sprintf(err_msg, "Erro semântico: variável '%s' não declarada.", $3);
            yyerror(err_msg);
        }
        free($3); // Libera a string do identificador
    }
  ;


expression_statement
    : expression SEMICOLON
      {
          // $1 é o Expression* final da expressão
          $$ = $1;

          if ($1) {
              if ($1->type == TYPE_ATOMUS && $1->value) {
                  printf(">> Resultado Final (atomus): %d\n", *(int*)$1->value);
              } else if ($1->type == TYPE_FRACTIO && $1->value) {
                  printf(">> Resultado Final (fractio): %f\n", *(double*)$1->value);
              }
            //   free_expression($1); // Libera a expressão final
          }
      }
    ;

primary_expression
    : IDENTIFIER
      {
          Symbol *s = scope_lookup($1);
          if (!s) {
              char err[128];
              snprintf(err, sizeof(err), "Identificador '%s' não declarado", $1);
              semantic_error(err);
              $$ = NULL;
          } else {
              DataType type = string_to_type(s->type);
              fprintf(stderr, "[DEBUG] símbolo '%s', tipo string = '%s', tipo enum = %d\n", $1, s->type, type);
              size_t value_size = get_size_from_type(s->type);
              void* value_copy = malloc(value_size);
              if (s->data.value) { 
                  memcpy(value_copy, s->data.value, value_size);
              } else {
                  free(value_copy);
                  value_copy = NULL;
              }
              $$ = create_expression(type, value_copy, strdup($1));
          }
          free($1);
      }
    | constant
      {
          $$ = $1;
      }
    | string
      {
          $$ = $1;
      }
    | LPAREN expression RPAREN
      {
          $$ = $2;
      }
    | vector_access
      {
        $$ = $1;
      }
    /* | member_access_direct
      {
          $$ = $1;
      } */
    | pointer_statement
      {
          $$ = $1;
      }

unary_expression
    : primary_expression                { $$ = $1; }
    | OP_LOGICAL_NOT unary_expression   { $$ = $2; }
    | OP_DEREF_POINTER unary_expression { $$ = $2; }
    | OP_ADDR_OF unary_expression       { $$ = $2; }
    | OP_SUBTRACT unary_expression      { $$ = $2; }
    ;

expression
    : unary_expression
      {
          // O caso base: propaga a expressão unária, que já é um Expression*.
          $$ = $1;
      }

    /* --- Operadores Aritméticos --- */

    | expression OP_ADD unary_expression
      {
        Expression *L = $1, *R = $3;
        char *t = new_temp();
        emit("+", L->tac_name, R->tac_name, t);
        $$ = create_expression(L->type, NULL, t);
        free(L); free(R);
        $$->tac_name = t;}
    | expression OP_SUBTRACT unary_expression
      {
          if (!$1 || !$3) {
              semantic_error("Expressão inválida.");
              $$ = NULL;
          } else if ($1->type == TYPE_UNDEFINED || $3->type == TYPE_UNDEFINED) {
              semantic_error("Operação com tipo indefinido.");
              $$ = NULL;
          } else if (!(($1->type == TYPE_ATOMUS && $3->type == TYPE_ATOMUS) ||
                       ($1->type == TYPE_FRACTIO && $3->type == TYPE_FRACTIO))) {
              semantic_error("Subtração só pode ser feita entre atomus ou fractio.");
              $$ = NULL;
          } else {
              Expression *L = $1, *R = $3;
            char *t = new_temp();
            emit("-", L->tac_name, R->tac_name, t);
            $$ = create_expression(L->type, NULL, t);
            free(L); free(R);
            $$->tac_name = t;}
          }
    | expression OP_MULTIPLY unary_expression
      {
          if (!$1 || !$3) {
              semantic_error("Expressão inválida.");
              $$ = NULL;
          } else if ($1->type == TYPE_UNDEFINED || $3->type == TYPE_UNDEFINED) {
              semantic_error("Operação com tipo indefinido.");
              $$ = NULL;
          } else if (!(($1->type == TYPE_ATOMUS && $3->type == TYPE_ATOMUS) ||
                       ($1->type == TYPE_FRACTIO && $3->type == TYPE_FRACTIO))) {
              semantic_error("Multiplicação só pode ser feita entre atomus ou fractio.");
              $$ = NULL;
          } else {
              Expression *L = $1, *R = $3;
            char *t = new_temp();
            emit("*", L->tac_name, R->tac_name, t);
            $$ = create_expression(L->type, NULL, t);
            free(L); free(R);
            $$->tac_name = t;}
        }
    | expression OP_DIVIDE unary_expression
      {
          if (!$1 || !$3) {
              semantic_error("Expressão inválida.");
              $$ = NULL;
          } else if ($1->type == TYPE_UNDEFINED || $3->type == TYPE_UNDEFINED) {
              semantic_error("Operação com tipo indefinido.");
              $$ = NULL;
          } else if (!(($1->type == TYPE_ATOMUS && $3->type == TYPE_ATOMUS) ||
                       ($1->type == TYPE_FRACTIO && $3->type == TYPE_FRACTIO))) {
              semantic_error("Divisão só pode ser feita entre atomus ou fractio.");
              $$ = NULL;
          } else if (
              ($3->type == TYPE_ATOMUS && $3->value && *(int*)$3->value == 0) ||
              ($3->type == TYPE_FRACTIO && $3->value && *(double*)$3->value == 0.0)
          ) {
              semantic_error("Divisão por zero.");
              $$ = NULL;
          } else {
              Expression *L = $1, *R = $3;
            char *t = new_temp();
            emit("/", L->tac_name, R->tac_name, t);
            $$ = create_expression(L->type, NULL, t);
            free(L); free(R);
            $$->tac_name = t;
          }
      }
    | expression OP_MODULUS unary_expression
      {
          if (!$1 || !$3) {
              semantic_error("Expressão inválida.");
              $$ = NULL;
          } else if ($1->type == TYPE_UNDEFINED || $3->type == TYPE_UNDEFINED) {
              semantic_error("Operação com tipo indefinido.");
              $$ = NULL;
          } else if (!($1->type == TYPE_ATOMUS && $3->type == TYPE_ATOMUS)) {
              semantic_error("Módulo só pode ser feito entre atomus.");
              $$ = NULL;
          } else if ($3->value && *(int*)$3->value == 0) {
              semantic_error("Módulo por zero.");
              $$ = NULL;
          } else {
              Expression *L = $1, *R = $3;
            char *t = new_temp();
            emit("%", L->tac_name, R->tac_name, t);
            $$ = create_expression(L->type, NULL, t);
            free(L); free(R);
            $$->tac_name = t;
          }
      }
    | expression OP_EXP unary_expression
      {
          if (!$1 || !$3) {
              semantic_error("Expressão inválida.");
              $$ = NULL;
          } else if ($1->type == TYPE_UNDEFINED || $3->type == TYPE_UNDEFINED) {
              semantic_error("Operação com tipo indefinido.");
              $$ = NULL;
          } else if (!(($1->type == TYPE_ATOMUS && $3->type == TYPE_ATOMUS) ||
                       ($1->type == TYPE_FRACTIO && $3->type == TYPE_FRACTIO))) {
              semantic_error("Exponenciação só pode ser feita entre atomus ou fractio.");
              $$ = NULL;
          } else {
              $$ = evaluate_binary_expression($1, OP_EXP, $3);
          }
      }
    | expression OP_INTEGER_DIVIDE unary_expression
      {
          if (!$1 || !$3) {
              semantic_error("Expressão inválida.");
              $$ = NULL;
          } else if ($1->type == TYPE_UNDEFINED || $3->type == TYPE_UNDEFINED) {
              semantic_error("Operação com tipo indefinido.");
              $$ = NULL;
          } else if (!($1->type == TYPE_ATOMUS && $3->type == TYPE_ATOMUS)) {
              semantic_error("Divisão inteira só pode ser feita entre atomus.");
              $$ = NULL;
          } else if ($3->value && *(int*)$3->value == 0) {
              semantic_error("Divisão inteira por zero.");
              $$ = NULL;
          } else {
              $$ = evaluate_binary_expression($1, OP_INTEGER_DIVIDE, $3);
          }
      }


       /* --- Operadores Relacionais (de Comparação) --- */
    | expression OP_EQUAL unary_expression
      {
          if (!$1 || !$3) {
              semantic_error("Expressão inválida.");
              $$ = NULL;
          } else if ($1->type == TYPE_UNDEFINED || $3->type == TYPE_UNDEFINED) {
              semantic_error("Operação de comparação com tipo indefinido.");
              $$ = NULL;
          } else if ($1->type != $3->type) {
              semantic_error("Comparação só pode ser feita entre tipos iguais.");
              $$ = NULL;
          } else {
              Expression *L = $1, *R = $3;
                char *t = new_temp();

                char *Lcmp = new_label();
                emit("label", "", "", Lcmp);
                push_rel_label(Lcmp);
                emit_rel("==", L->tac_name, R->tac_name, t);
                $$ = create_expression(L->type, NULL, t);
                free(L); free(R);
                $$->tac_name = t;
          }
      }
    | expression OP_NOT_EQUAL unary_expression
      {
          if (!$1 || !$3) {
              semantic_error("Expressão inválida.");
              $$ = NULL;
          } else if ($1->type == TYPE_UNDEFINED || $3->type == TYPE_UNDEFINED) {
              semantic_error("Operação de comparação com tipo indefinido.");
              $$ = NULL;
          } else if ($1->type != $3->type) {
              semantic_error("Comparação só pode ser feita entre tipos iguais.");
              $$ = NULL;
          } else {
              Expression *L = $1, *R = $3;
            char *t = new_temp();

            char *Lcmp = new_label();
            emit("label", "", "", Lcmp);
            push_rel_label(Lcmp);
            emit_rel("!=", L->tac_name, R->tac_name, t);
            $$ = create_expression(L->type, NULL, t);
            free(L); free(R);
            $$->tac_name = t;
          }
      }
    | expression OP_LESS_THAN unary_expression
      {
          if (!$1 || !$3) {
              semantic_error("Expressão inválida.");
              $$ = NULL;
          } else if ($1->type == TYPE_UNDEFINED || $3->type == TYPE_UNDEFINED) {
              semantic_error("Operação de comparação com tipo indefinido.");
              $$ = NULL;
          } else if (!(
                ($1->type == TYPE_ATOMUS && $3->type == TYPE_ATOMUS) ||
                ($1->type == TYPE_FRACTIO && $3->type == TYPE_FRACTIO)
          )) {
              semantic_error("Comparação relacional só pode ser feita entre atomus ou fractio.");
              $$ = NULL;
          } else { Expression *L = $1, *R = $3;
            char *t = new_temp();

            char *Lcmp = new_label();
            emit("label", "", "", Lcmp);
            push_rel_label(Lcmp);

            emit("<", L->tac_name, R->tac_name, t);
            $$ = create_expression(L->type, NULL, t);
            free(L); free(R);
            $$->tac_name = t;
      }}
    | expression OP_GREATER_THAN unary_expression
      {
          if (!$1 || !$3) {
              semantic_error("Expressão inválida.");
              $$ = NULL;
          } else if ($1->type == TYPE_UNDEFINED || $3->type == TYPE_UNDEFINED) {
              semantic_error("Operação de comparação com tipo indefinido.");
              $$ = NULL;
          } else if (!(
                ($1->type == TYPE_ATOMUS && $3->type == TYPE_ATOMUS) ||
                ($1->type == TYPE_FRACTIO && $3->type == TYPE_FRACTIO)
          )) {
              semantic_error("Comparação relacional só pode ser feita entre atomus ou fractio.");
              $$ = NULL;
          } else {
            Expression *L = $1, *R = $3;
            char *t = new_temp();

            char *Lcmp = new_label();
            emit("label", "", "", Lcmp);
            push_rel_label(Lcmp);

            emit(">", L->tac_name, R->tac_name, t);
            $$ = create_expression(L->type, NULL, t);
            free(L); free(R);
            $$->tac_name = t;
          }
      }
    | expression OP_LESS_EQUAL unary_expression
      {
          if (!$1 || !$3) {
              semantic_error("Expressão inválida.");
              $$ = NULL;
          } else if ($1->type == TYPE_UNDEFINED || $3->type == TYPE_UNDEFINED) {
              semantic_error("Operação de comparação com tipo indefinido.");
              $$ = NULL;
          } else if (!(
                ($1->type == TYPE_ATOMUS && $3->type == TYPE_ATOMUS) ||
                ($1->type == TYPE_FRACTIO && $3->type == TYPE_FRACTIO)
          )) {
              semantic_error("Comparação relacional só pode ser feita entre atomus ou fractio.");
              $$ = NULL;
          } else {
              Expression *L = $1, *R = $3;
            char *t = new_temp();

            char *Lcmp = new_label();
            emit("label", "", "", Lcmp);
            push_rel_label(Lcmp);

            emit_rel("<=", L->tac_name, R->tac_name, t);
            $$ = create_expression(L->type, NULL, t);
            free(L); free(R);
            $$->tac_name = t;
          }
      }
    | expression OP_GREATER_EQUAL unary_expression
      {
          if (!$1 || !$3) {
              semantic_error("Expressão inválida.");
              $$ = NULL;
          } else if ($1->type == TYPE_UNDEFINED || $3->type == TYPE_UNDEFINED) {
              semantic_error("Operação de comparação com tipo indefinido.");
              $$ = NULL;
          } else if (!(
                ($1->type == TYPE_ATOMUS && $3->type == TYPE_ATOMUS) ||
                ($1->type == TYPE_FRACTIO && $3->type == TYPE_FRACTIO)
          )) {
              semantic_error("Comparação relacional só pode ser feita entre atomus ou fractio.");
              $$ = NULL;
          } else {
              Expression *L = $1, *R = $3;
            char *t = new_temp();

            char *Lcmp = new_label();
            emit("label", "", "", Lcmp);
            push_rel_label(Lcmp);
            emit_rel(">=", L->tac_name, R->tac_name, t);
            $$ = create_expression(L->type, NULL, t);
            free(L); free(R);
            $$->tac_name = t;
          }
      }

    /* --- Operadores Lógicos --- */
    | expression OP_LOGICAL_AND unary_expression
      {
          if (!$1 || !$3) {
              semantic_error("Expressão lógica inválida.");
              $$ = NULL;
          } else if ($1->type != TYPE_QUANTUM || $3->type != TYPE_QUANTUM) {
              semantic_error("Operação lógica só pode ser feita entre quantum.");
              $$ = NULL;
          } else {
              $$ = evaluate_binary_expression($1, OP_LOGICAL_AND, $3);
          }
      }
    | expression OP_LOGICAL_OR unary_expression
      {
          if (!$1 || !$3) {
              semantic_error("Expressão lógica inválida.");
              $$ = NULL;
          } else if ($1->type != TYPE_QUANTUM || $3->type != TYPE_QUANTUM) {
              semantic_error("Operação lógica só pode ser feita entre quantum.");
              $$ = NULL;
          } else {
              $$ = evaluate_binary_expression($1, OP_LOGICAL_OR, $3);
          }
      }
    | expression OP_LOGICAL_XOR unary_expression
      {
          if (!$1 || !$3) {
              semantic_error("Expressão lógica inválida.");
              $$ = NULL;
          } else if ($1->type != TYPE_QUANTUM || $3->type != TYPE_QUANTUM) {
              semantic_error("Operação lógica só pode ser feita entre quantum.");
              $$ = NULL;
          } else {
              $$ = evaluate_binary_expression($1, OP_LOGICAL_XOR, $3);
          }
      }

    /* --- Operadores de Atribuição e Acesso (se forem expressões) --- */
    // Nota: A atribuição como expressão (ex: a = b = 5) é mais complexa.
    // A regra abaixo funciona se 'evaluate_binary_expression' for adaptada
    // para modificar o símbolo e retornar o valor.
    | expression OP_ASSIGN IDENTIFIER  %prec OP_ASSIGN
      {
        Expression *val = $1;
        char *dst = $3;
        Symbol *sym = scope_lookup(dst);
        DataType decl = sym ? string_to_type(sym->type) : TYPE_UNDEFINED;

        if (!sym) {
          yyerror("Variável não declarada.");
        } else if (val->type == decl) {
          if (val->type == TYPE_ATOMUS && decl == TYPE_FRACTIO) {
            char *tc = new_temp();
            emit("intToFloat", "", val->tac_name, tc);
            emit("=", tc, "", dst);
          } else {
            emit("=", val->tac_name, "", dst);
          }
        } else {
          yyerror("Erro de tipo na atribuição como expressão.");
        }

        /* devolve um expr “dummy” cujo tac_name é o dst */
        $$ = create_expression(decl, NULL, strdup(dst));
        free_expression(val);
        free(dst);
      }
    | LPAREN type_specifier RPAREN KW_MAGNITUDO
    {
        size_t sz = get_size_from_type($2);
        int* val = malloc(sizeof(int));
        *val = (int)sz;
        $$ = create_expression(TYPE_ATOMUS, val, new_temp());
        free($2);
    }

| LPAREN IDENTIFIER RPAREN KW_MAGNITUDO
    {
        Symbol* sym = scope_lookup($2);
        if (!sym) {
            semantic_error("Identificador não declarado para magnitudo.");
            $$ = create_expression(TYPE_UNDEFINED, NULL, new_temp());
        } else {
            size_t sz = get_size_from_type(sym->type);
            int* val = malloc(sizeof(int));
            *val = (int)sz;
            $$ = create_expression(TYPE_ATOMUS, val, new_temp());
        }
        free($2);
    }

| LPAREN type_specifier OP_MULTIPLY IDENTIFIER RPAREN KW_MAGNITUDO
    {
        // Exemplo: (atomus * n)magnitudo;
        Symbol* sym = scope_lookup($4);
        if (!sym) {
            semantic_error("Identificador não declarado para magnitudo.");
            $$ = create_expression(TYPE_UNDEFINED, NULL, new_temp());
        } else {
            size_t sz = get_size_from_type($2);
            int n = 0;
            if (string_to_type(sym->type) == TYPE_ATOMUS && sym->data.value) {
                n = *(int*)sym->data.value;
            } else {
                semantic_error("Multiplicador de magnitudo deve ser inteiro (atomus).");
            }
            int* val = malloc(sizeof(int));
            *val = (int)(sz * n);
            $$ = create_expression(TYPE_ATOMUS, val, new_temp());
        }
        free($2);
        free($4);
    }


| LPAREN type_specifier OP_MULTIPLY LIT_INT RPAREN KW_MAGNITUDO
    {
        // Exemplo: (atomus * 10)magnitudo;
        size_t sz = get_size_from_type($2);
        int* val = malloc(sizeof(int));
        *val = (int)(sz * $4);
        $$ = create_expression(TYPE_ATOMUS, val, new_temp());
        free($2);
    }
    ;

constant
    : LIT_INT
       {
            int *v = malloc(sizeof(int));
            *v = $1;
            char buf[32];
        snprintf(buf, sizeof(buf), "%d", *v);

            $$ = create_expression(TYPE_ATOMUS, v, strdup(buf));
        }
    | LIT_FLOAT
      {
        double *val = malloc(sizeof(double));
        *val = $1;
          // CORREÇÃO: Usar o nome do ENUM (este já estava certo)
        char buf[64];
        snprintf(buf, sizeof(buf), "%g", *val);
        $$ = create_expression(TYPE_FRACTIO, val, strdup(buf));
      }
    | LIT_FACTUM
      {
          int *val = malloc(sizeof(int));
          *val = 1; // 1 para verdadeiro
          // CORREÇÃO: Usar o nome do ENUM
        char buf[64];
        snprintf(buf, sizeof(buf), "%d", *val);
        $$ = create_expression(TYPE_QUANTUM, val, buf);
      }
    | LIT_FICTUM
      {
          int *val = malloc(sizeof(int));
          *val = 0; // 0 para falso
          // CORREÇÃO: Usar o nome do ENUM
          char buf[12];
        sprintf(buf, "%d", *val);
          $$ = create_expression(TYPE_QUANTUM, val, buf);
      }
    | LIT_CHAR
      {
          // CORREÇÃO: Usar o nome do ENUM
          $$ = create_expression(TYPE_SYMBOLUM, strdup($1), strdup($1)); 
      }
    ;

string
    : LIT_STRING
      {
        $$ = create_expression(TYPE_SCRIPTUM, strdup($1), strdup($1));
      }
    ;

//

assing_value
    : IDENTIFIER 
    | vector_access
    | pointer_statement
    | struct_member_lvalue  
    ;

declaration_statement
    : IDENTIFIER type_specifier opcional_constant SEMICOLON
      {
        if (scope_lookup_current($1)) {
              char err[128];
              snprintf(err, sizeof(err), "Variável '%s' já declarada neste escopo", $1);
              semantic_error(err);
          } else {
          char* var_name = $1;
          char* var_type = $2;

          /* DEBUG: início da declaração */
          printf("[DEBUG] DECLARATION_START: name='%s', type='%s', current_struct_fields=%p\n",
                 var_name, var_type, (void*)current_struct_fields);

          if (current_struct_fields) {
              /* DEBUG: dentro de definição de struct */
              printf("[DEBUG] STRUCT CONTEXT: inserindo campo '%s' de tipo '%s'\n",
                     var_name, var_type);
              st_insert(&current_struct_fields->fields,
                        var_name, SYM_VAR, var_type, yylineno, NULL);
          } else {
              /* DEBUG: contexto normal, buscando símbolo existente */
              printf("[DEBUG] NORMAL CONTEXT: scope_lookup('%s')...\n", var_name);
              Symbol *existing = scope_lookup(var_name);
              printf("[DEBUG] scope_lookup returned %p\n", (void*)existing);

              if (existing) {
                  printf("[DEBUG] Símbolo existente: kind=%d (SYM_VAR=%d)\n",
                         existing->kind, SYM_VAR);
                  if (existing->kind != SYM_VAR) {
                      semantic_error("Variável já declarada com outro tipo!");
                  } else {
                      existing->kind = SYM_VAR;
                      existing->line_declared = yylineno;
                      printf("[DEBUG] Atualizado existing->kind para SYM_VAR\n");
                  }
              } else {
                  /* DEBUG: inserindo nova variável */
                  printf("[DEBUG] Inserindo '%s' do tipo '%s'\n",
                         var_name, var_type);
                  Symbol *type_sym = scope_lookup(var_type);
                  printf("[DEBUG] scope_lookup(type '%s') -> %p\n",
                         var_type, (void*)type_sym);

                  Symbol *var_sym = scope_insert(var_name, SYM_VAR, var_type,
                                                 yylineno, NULL);
                  printf("[DEBUG] scope_insert returned %p\n", (void*)var_sym);

                  /* DEBUG: informações do type_sym */
                  if (type_sym) {
                      printf("[DEBUG] type_sym->kind=%d, field_table=%p\n",
                             type_sym->kind, (void*)type_sym->field_table);
                  }

                  if (type_sym && type_sym->kind == SYM_TYPE
                      && type_sym->field_table) {
                      /* DEBUG: criando instance_fields */
                      printf("[DEBUG] Criando instance_fields para '%s'\n", var_name);
                      var_sym->instance_fields =
                          malloc(sizeof(SymbolTable));
                      st_init(var_sym->instance_fields);

                      for (int i = 0; i < HASH_SIZE; i++) {
                          Symbol *field =
                              type_sym->field_table->fields.table[i];
                          while (field) {
                              printf("[DEBUG] adicionando campo '%s' tipo '%s'\n",
                                     field->name, field->type);
                              st_insert(var_sym->instance_fields,
                                        field->name,
                                        SYM_VAR,
                                        field->type,
                                        yylineno,
                                        NULL);
                              field = field->next;
                          }
                      }
                  }
              }
          }
        free(var_name);
      }
       // free($1);
      }

    | expression OP_ASSIGN IDENTIFIER type_specifier opcional_constant SEMICOLON
      {
          // Esta é a regra atualizada para declaração com inicialização.
          Expression* initial_value_expr = $1;
          char* var_name = $3;
          char* type_name = $4;

          // 1. VERIFICAÇÃO DE TIPO
          DataType declared_type = string_to_type(type_name);
          if (initial_value_expr->type != declared_type && declared_type != TYPE_UNDEFINED) {
              semantic_error("Erro de tipo: O valor da expressão é incompatível com o tipo da variável declarada.");
              free_expression(initial_value_expr);
          } else {
              // A lógica original permitia "redeclaração" para atualizar um valor,
              // o que é incomum. Uma abordagem mais estrita é recomendada.
              Symbol* existing_sym = scope_lookup_current(var_name);
              if (existing_sym != NULL) {
                  semantic_error("Erro: Variável já declarada neste escopo.");
                  free_expression(initial_value_expr);
              } else {
                  // 2. EXTRAÇÃO DO VALOR E INSERÇÃO NO ESCOPO
                  // A tabela de símbolos agora recebe o ponteiro para o valor.
                  scope_insert(var_name, SYM_VAR, type_name, yylineno, initial_value_expr->value); 

                  // 3. GERENCIAMENTO DE MEMÓRIA
                  // Impedimos que a memória do valor seja liberada junto com o "invólucro" da expressão,
                  // pois ela agora pertence à tabela de símbolos.
                  emit("=", initial_value_expr->tac_name, "", var_name);
                  free_expression(initial_value_expr);
                  $$ = NULL;
              }
          }
          if (initial_value_expr->type == declared_type) {
              /* tipos iguais */
              scope_insert(var_name, SYM_VAR, type_name, yylineno, initial_value_expr->value);
              emit("=", initial_value_expr->tac_name, "", var_name);
          }
          else if (initial_value_expr->type == TYPE_ATOMUS && declared_type == TYPE_FRACTIO) {
              /* promoção int → float */
              char* tmp = new_temp();
              emit("intToFloat", "", initial_value_expr->tac_name, tmp);
              scope_insert(var_name, SYM_VAR, type_name, yylineno, initial_value_expr->value);
              emit("=", tmp, "", var_name);
          }
          else {
              semantic_error("Erro de tipo: impossível atribuir à variável.");
          }
          $$ = NULL;
          free(var_name);
          // free(type_name); // Descomente se type_specifier alocar memória.
      }
    | pointer_declaration
      {
          // Esta regra precisará de ajustes similares se envolver inicialização.
      }
    ;

opcional_constant
    : KW_MOL
    | /* vazio */
    ;

list_declaration_statement
    : // vazio
    | declaration_statement list_declaration_statement
    ;

type_specifier
    : KW_TYPE_ATOMUS               { $$ = strdup("atomus"); }
    | KW_TYPE_FRACTIO              { $$ = strdup("fractio"); }
    | KW_TYPE_FRAGMENTUM           { $$ = strdup("fragmentum"); }
    | KW_TYPE_MAGNUS               { $$ = strdup("magnus"); }
    | KW_TYPE_MINIMUS              { $$ = strdup("minimus"); }
    | KW_TYPE_QUANTUM              { $$ = strdup("quantum"); }
    | KW_TYPE_SCRIPTUM             { $$ = strdup("scriptum"); }
    | KW_TYPE_SYMBOLUM             { $$ = strdup("symbolum"); }
    | KW_TYPE_VACUUM               { $$ = strdup("vacuum"); }
    | IDENTIFIER {           
        Symbol *type_sym = scope_lookup($1);
          if (!type_sym || type_sym->kind != SYM_TYPE) {
              char err[128];
              snprintf(err, sizeof(err), "Tipo '%s' não declarado", $1);
              semantic_error(err);
          }
          $$ = strdup($1);
          free($1);}
    | IDENTIFIER KW_ENUMERARE   { $$ = strdup($1); }
    | OP_DEREF_POINTER type_specifier {}
    
   ;

//

function_declaration_statement
    : KW_FORMULA
      LPAREN
      parameter_list
    RPAREN
      IDENTIFIER
      OP_ASSIGN
      type_specifier
      {
        // Insere a função no escopo global
        if (scope_lookup($5) != NULL) {
          semantic_error("Função já declarada!");
        } else {
          scope_insert($5, SYM_FUNC, $7, yylineno, NULL);
          scope_push_formula(BLOCK_FUNCTION, $7);
        }
        free($5);
      }
      LBRACE
        statement_list
      RBRACE
        { scope_pop(); } // Remove o escopo da função após o bloco
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
          semantic_error("Parâmetro já declarado!");
        } else {
          scope_insert($1, SYM_VAR, $2, yylineno, NULL);
        }
        free($1);
      }
    ;

//

function_call_statement
   : LPAREN RPAREN IDENTIFIER SEMICOLON        /* zero argumentos */
   | LPAREN argument_list RPAREN IDENTIFIER SEMICOLON  /* um ou mais args */

// Um único item na lista: cria o primeiro nó.
argument_list
    : expression
      {
          $$ = (ArgNode*)malloc(sizeof(ArgNode));
          $$->value = $1;
          $$->next = NULL;
      }
    // Item recursivo: anexa um novo nó ao final da lista existente.
    | argument_list PIPE expression
      {
          // Cria um novo nó para o valor atual ($3)
          ArgNode* newNode = (ArgNode*)malloc(sizeof(ArgNode));
          newNode->value = $3;
          newNode->next = NULL;

          // Encontra o final da lista existente ($1)
          ArgNode* current = $1;
          while (current->next != NULL) {
              current = current->next;
          }
          // Anexa o novo nó
          current->next = newNode;

          // Retorna o início da lista original
          $$ = $1;
      }
    ;

/* 

Declarações de salto: continuum, ruptio e redire */
jump_statement
    : KW_CONTINUUM SEMICOLON  /* break */
      {
          BlockType allowed[] = { BLOCK_LOOP, BLOCK_CONDITIONAL };
          if (!scope_allowed(allowed, 2, "void")) semantic_error("Construção não permitida para o escopo atual.");
      }
    | KW_RUPTIO SEMICOLON     /* continue */
      {
          BlockType allowed[] = { BLOCK_LOOP, BLOCK_CONDITIONAL };
          if (!scope_allowed(allowed, 2, "void")) semantic_error("Construção não permitida para o escopo atual.");
      }
    | KW_REDIRE SEMICOLON     /* return */
      {
          BlockType allowed[] = { BLOCK_FUNCTION };
          if (!scope_allowed(allowed, 1, "void")) semantic_error("Construção não permitida para o escopo atual.");
      }
    | expression KW_REDIRE SEMICOLON  /* return com valor */
      {
        BlockType allowed[] = { BLOCK_FUNCTION };
    
        Expression* expr = $1;

        const char* type_redite;

          switch (expr->type) {
              case TYPE_ATOMUS:  type_redite = "atomus";   break;
              case TYPE_FRACTIO: type_redite = "fractio";  break;
              case TYPE_SYMBOLUM:type_redite = "symbolum"; break;
              case TYPE_SCRIPTUM:type_redite = "scriptum"; break;
              case TYPE_QUANTUM: type_redite = "quantum";  break;
              default:           type_redite = NULL;       break;
          }

        if (!scope_allowed(allowed, 1, type_redite)) semantic_error("Construção não permitida para o escopo atual.");
      }
;


conditional_statement
    : LPAREN expression RPAREN KW_SI
    { scope_push(BLOCK_CONDITIONAL);
        char *L_else = new_label();
        char *L_end  = new_label();
        push_labels(L_else, L_end);
        emit("ifFalse",   $2->tac_name,   "",             L_else);
      }
    block {
        emit("goto",  "", "",       top_label_end());
        emit("label", "", "",       top_label_else());
      } conditional_non_statement {
        emit("label", "", "",       top_label_end());
        pop_labels();
        $$ = NULL;
      }
    | LPAREN expression RPAREN KW_VERTERE LBRACE { scope_push(BLOCK_CONDITIONAL); } causal_statement RBRACE { scope_pop(); }
    ;

conditional_non_statement
    : {$$ = NULL; }
    | KW_NON { scope_push(BLOCK_CONDITIONAL); } block {   $$ = NULL; }
    | KW_NON conditional_statement {$$ = NULL; }
    ;

causal_statement
    : KW_CASUS expression COLON statement_list 
    | KW_AXIOM COLON statement_list 
    ;

    
iteration_statement
    : LPAREN expression RPAREN KW_PERSISTO {
        /* 1) entra no escopo de loop */
        scope_push(BLOCK_LOOP);

        /* 2) cria labels e empilha */
        char *L_begin = new_label();
        char *L_end   = new_label();
        push_labels(L_begin, L_end);

        /* 3) marca início do loop */
        emit("label", "", "", L_begin);

        char *cond = $2->tac_name;
        if (cond[0] != 't') {
          char *tmp = new_temp();
          emit("=", cond, "", tmp);
          cond = tmp;
        }

        emit("ifFalse", cond, "", L_end);
        
      } block {

        emit("goto", "", "", top_rel_label());
        pop_rel_label();

        emit("label", "", "", top_label_end());
        pop_labels();
        scope_pop();
      }

    | LPAREN expression_statement expression_statement expression RPAREN KW_ITERARE { scope_push(BLOCK_LOOP); } block

    | LPAREN expression_statement expression_statement RPAREN KW_ITERARE { scope_push(BLOCK_LOOP); } block

    | LPAREN declaration_statement expression_statement expression RPAREN KW_ITERARE { scope_push(BLOCK_LOOP); } block

    | LPAREN declaration_statement expression_statement RPAREN KW_ITERARE { scope_push(BLOCK_LOOP); } block
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
     {
          Symbol* sym = scope_lookup($1);
          if (!sym) {
              semantic_error("Variável não declarada para lectura.");
          } else {
              DataType type = string_to_type(sym->type);
              if (type == TYPE_ATOMUS) {
                  int val;
                  printf("» %s = ", sym->name);
                  scanf("%d", &val);
                  if (sym->data.value == NULL) sym->data.value = malloc(sizeof(int));
                  *(int*)sym->data.value = val;
              } else if (type == TYPE_FRACTIO) {
                  double val;
                  printf("» %s = ", sym->name);
                  scanf("%lf", &val);
                  if (sym->data.value == NULL) sym->data.value = malloc(sizeof(double));
                  *(double*)sym->data.value = val;
              } else if (type == TYPE_SCRIPTUM) {
                  char buffer[256];
                  printf("» %s = ", sym->name);
                  scanf("%255s", buffer);
                  if (sym->data.value) free(sym->data.value);
                  sym->data.value = strdup(buffer);
              } else if (type == TYPE_SYMBOLUM) {
                  char c;
                  printf("» %s = ", sym->name);
                  scanf(" %c", &c);
                  if (sym->data.value == NULL) sym->data.value = malloc(sizeof(char));
                  *(char*)sym->data.value = c;
              } else {
                  semantic_error("Tipo não suportado para lectura.");
              }
          }
          free($1);
      }
    | IDENTIFIER LANGLE identifier_langle_list
    {
          Symbol* sym = scope_lookup($1);
          if (!sym) {
              semantic_error("Variável não declarada para lectura.");
          } else {
              DataType type = string_to_type(sym->type);
              if (type == TYPE_ATOMUS) {
                  int val;
                  printf("» %s = ", sym->name);
                  scanf("%d", &val);
                  if (sym->data.value == NULL) sym->data.value = malloc(sizeof(int));
                  *(int*)sym->data.value = val;
              } else if (type == TYPE_FRACTIO) {
                  double val;
                  printf("» %s = ", sym->name);
                  scanf("%lf", &val);
                  if (sym->data.value == NULL) sym->data.value = malloc(sizeof(double));
                  *(double*)sym->data.value = val;
              } else if (type == TYPE_SCRIPTUM) {
                  char buffer[256];
                  printf("» %s = ", sym->name);
                  scanf("%255s", buffer);
                  if (sym->data.value) free(sym->data.value);
                  sym->data.value = strdup(buffer);
              } else if (type == TYPE_SYMBOLUM) {
                  char c;
                  printf("» %s = ", sym->name);
                  scanf(" %c", &c);
                  if (sym->data.value == NULL) sym->data.value = malloc(sizeof(char));
                  *(char*)sym->data.value = c;
              } else {
                  semantic_error("Tipo não suportado para lectura.");
              }
          }
          free($1);
      }
      ;
    ;

identifier_rangle_list
    : IDENTIFIER RANGLE KW_REVELARE SEMICOLON
    | IDENTIFIER RANGLE identifier_rangle_list
    ;

function_magnitudo
    : LPAREN type_specifier RPAREN KW_MAGNITUDO SEMICOLON
    ;


type_define_statement
    : KW_DESIGNARE type_specifier IDENTIFIER SEMICOLON
      {
        // Esta parte implementa 'typedef'.
        // Ex: designare atomus meu_inteiro;
        scope_insert($3, SYM_TYPE, $2, yylineno, NULL); 
        free($3);
      }
    | type_define_struct
    | type_define_enum
      {
        // Mantém a capacidade de definir enumerações.
      }
    ;

type_define_struct
    : KW_DESIGNARE IDENTIFIER LBRACE
        {
            // Crie uma nova tabela de campos para a struct
            FieldTable *ft = malloc(sizeof(FieldTable));
            st_init(&ft->fields);
            // Salve o ponteiro em uma variável global/externa temporária
            current_struct_fields = ft;
        }
      list_declaration_statement
      RBRACE KW_HOMUNCULUS SEMICOLON
      {
        // Insere o nome da struct como tipo no escopo global, com a tabela de campos
        Symbol *sym = scope_insert($2, SYM_TYPE, "homunculus", yylineno, NULL);
        if (sym) sym->field_table = current_struct_fields;
        current_struct_fields = NULL;
        free($2);
      }

type_define_enum
    : IDENTIFIER LBRACE enum_list RBRACE KW_ENUMERARE SEMICOLON
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

/* vector
    : IDENTIFIER type_specifier LANGLE expression RANGLE SEMICOLON
    | IDENTIFIER SEMICOLON
    ; */
    
// Declaração de um vetor (ex: vetor1 atomus << 10 >>;)
vector_statement
    : IDENTIFIER type_specifier LANGLE expression RANGLE SEMICOLON
      {
          char* vec_name = $1;
          char* type_name = $2;
          Expression* size_expr = $4;

          // 1. Validar a expressão de tamanho
          if (!size_expr) {
              semantic_error("Expressão de tamanho do vetor é inválida.");
          } else if (size_expr->type != TYPE_ATOMUS) {
              semantic_error("Erro de tipo: o tamanho de um vetor deve ser um inteiro (atomus).");
          } else {
              int vector_size = *(int*)(size_expr->value); // Extração correta do valor

              if (vector_size <= 0) {
                  semantic_error("O tamanho do vetor deve ser um número positivo.");
              } else {
                  // 2. Inserir o símbolo do vetor na tabela de escopo
                  Symbol* sym = scope_insert(vec_name, SYM_VECTOR, type_name, yylineno, NULL);
                  if (sym) {
                      // 3. Alocar memória e preencher informações do vetor
                      sym->data.vector_info.size = (size_t)vector_size;
                      size_t element_size = get_size_from_type(type_name);
                      sym->data.vector_info.data_ptr = calloc(vector_size, element_size); // Usar calloc para zerar a memória

                      if (!sym->data.vector_info.data_ptr) {
                          yyerror("Falha ao alocar memória para o vetor.");
                      }
                  } else {
                      semantic_error("Erro: Símbolo já declarado neste escopo.");
                  }
              }
          }
          // 4. Limpeza da memória
          free(vec_name);
          free(type_name);
          if(size_expr) free_expression(size_expr);
      }
    // Inicialização de um vetor (ex: [1 | 2 | 3] = meuVetor;)
    | LBRACKET argument_list RBRACKET OP_ASSIGN IDENTIFIER SEMICOLON
      {
          ArgNode* arg_list = $2;
          char* vec_name = $5;
          Symbol* sym = scope_lookup(vec_name);

          if (!sym || sym->kind != SYM_VECTOR) {
              yyerror("Identificador à direita da atribuição não é um vetor declarado.");
          } else {
              DataType element_type = string_to_type(sym->type);
              size_t element_size = get_size_from_type(sym->type);
              ArgNode* current = arg_list;
              int index = 0;

              // Itera pela lista de argumentos para preencher o vetor
              while(current != NULL) {
                  if (index >= sym->data.vector_info.size) {
                      yyerror("Erro: Mais inicializadores do que o tamanho do vetor.");
                      break;
                  }
                  Expression* current_expr = (Expression*)current->value;
                  if (current_expr->type != element_type) {
                      semantic_error("Erro de tipo na lista de inicialização do vetor.");
                  } else {
                      void* dest_ptr = (char*)sym->data.vector_info.data_ptr + (index * element_size);
                      memcpy(dest_ptr, current_expr->value, element_size);
                  }
                  index++;
                  current = current->next;
              }
          }
          // Limpeza completa da lista de argumentos e das expressões contidas nela
          ArgNode* current = arg_list;
          while(current != NULL) {
              ArgNode* next = current->next;
              free_expression((Expression*)current->value);
              free(current);
              current = next;
          }
          free(vec_name);
      }
    ;

vector_access
    : IDENTIFIER LANGLE expression RANGLE
      {
          char* vec_name = $1;
          Expression* index_expr = $3;
          Symbol* sym = scope_lookup(vec_name);
          $$ = NULL; // Inicializa o resultado como nulo (falha)

          // 1. Validar o símbolo e o índice
          if (!sym || sym->kind != SYM_VECTOR) {
              semantic_error("Erro semântico: identificador não é um vetor declarado.");
          } else if (!index_expr || index_expr->type != TYPE_ATOMUS) {
              semantic_error("Erro de tipo: o índice de um vetor deve ser um inteiro (atomus).");
          } else {
              int index = *(int*)(index_expr->value);

              // 2. Verificação de limites (bounds checking)
              if (index < 0 || index >= sym->data.vector_info.size) {
                  char err_msg[128];
                  sprintf(err_msg, "Erro: Índice '%d' fora dos limites do vetor '%s'.", index, vec_name);
                  semantic_error(err_msg);
              } else {
                  // 3. Copiar o valor e criar uma nova Expression
                  DataType element_type = string_to_type(sym->type);
                  size_t element_size = get_size_from_type(sym->type);
                  void* element_ptr = (char*)sym->data.vector_info.data_ptr + (index * element_size);

                  // Aloca memória para a CÓPIA do valor
                  void* value_copy = malloc(element_size);
                  if(value_copy) {
                      memcpy(value_copy, element_ptr, element_size);
                      // Cria a nova Expression com a cópia do valor
                      $$ = create_expression(element_type, value_copy, new_temp());
                  } else {
                      yyerror("Falha ao alocar memória para o valor do acesso ao vetor.");
                  }
              }
          }
          // 4. Limpeza da memória
          free(vec_name);
          if(index_expr) free_expression(index_expr);
      }
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
          // Exemplo: ptrInvalido °atomus;
          const char* prim_types[] = {
              "atomus", "fractio", "fragmentum", "magnus", "minimus",
              "quantum", "scriptum", "symbolum", "vacuum"
          };
          int is_primitive = 0;
          for (int i = 0; i < sizeof(prim_types)/sizeof(prim_types[0]); ++i) {
              if (strcmp($3, prim_types[i]) == 0) {
                  is_primitive = 1;
                  break;
              }
          }
          if (!is_primitive) {
              Symbol* type_sym = scope_lookup($3);
              if (!type_sym || type_sym->kind != SYM_TYPE) {
                  char err[128];
                  snprintf(err, sizeof(err), "Tipo base '%s' não declarado", $3);
                  semantic_error(err);
              }
          }
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
    : IDENTIFIER OP_ADDR_OF
      {
          $$ = NULL; // Inicializa como falha
          Symbol* s = scope_lookup($1);

          if (!s) {
              char err_msg[128];
              sprintf(err_msg, "Erro semântico: variável '%s' não declarada.", $1);
              semantic_error(err_msg);
          } else {
              // 1. O "valor" desta expressão é o endereço onde o valor de 's' está armazenado.
              //    s->data.value já é um ponteiro para o valor da variável.
              void* address_of_variable = s->data.value;

              // 2. Criamos um ponteiro para guardar esse endereço.
              void** address_holder = malloc(sizeof(void*));
              if(address_holder) {
                  *address_holder = address_of_variable;
                  
                  // 3. O resultado é uma expressão do tipo ponteiro.
                  $$ = create_expression(TYPE_POINTER, address_holder, new_temp());
              } else {
                  semantic_error("Falha ao alocar memória para o endereço.");
              }
          }
          free($1);
      }
    ;

pointer_dereference 
    : OP_DEREF_POINTER IDENTIFIER
      {
          $$ = NULL; // Inicializa o resultado como falha
          Symbol* s = scope_lookup($2);

          // 1. Validar se a variável existe e é um ponteiro
          if (!s || strstr(s->type, "*") == NULL) {
              char err_msg[128];
              sprintf(err_msg, "Erro semântico: a variável '%s' não é um ponteiro.", $2);
              semantic_error(err_msg);
          } else {
              // 2. Obter o endereço que o ponteiro armazena
              void* address_held_by_pointer = s->data.value;
              if (address_held_by_pointer == NULL) {
                  semantic_error("Erro em tempo de execução: dereferência de ponteiro nulo.");
              } else {
                  // 3. Determinar o tipo e o tamanho do dado que está no endereço
                  char base_type_name[MAX_NAME_LEN];
                  get_base_type_from_pointer(s->type, base_type_name); // Função auxiliar
                  
                  DataType base_type = string_to_type(base_type_name); // Função auxiliar
                  size_t value_size = get_size_from_type(base_type_name);   // Função auxiliar

                  if (base_type == TYPE_UNDEFINED) {
                      semantic_error("Erro interno: tipo base do ponteiro desconhecido.");
                  } else {
                      // 4. Alocar memória para uma CÓPIA do valor e copiar
                      void* value_copy = malloc(value_size);
                      if (value_copy) {
                          memcpy(value_copy, address_held_by_pointer, value_size);
                          
                          // 5. Criar a Expression com o valor copiado
                          $$ = create_expression(base_type, value_copy, new_temp());
                      } else {
                          semantic_error("Falha ao alocar memória para o valor dereferenciado.");
                      }
                  }
              }
          }
          free($2);
      }
    ;

member_access_direct
    : IDENTIFIER OP_ACCESS_MEMBER IDENTIFIER
      {
          /* $1 = membro (campo), $3 = variável (instância da struct ou ponteiro para struct) */
          char* member_name = $1;
          char* var_name    = $3;

          printf("[DEBUG] member_access_direct: var='%s', member='%s'\n", var_name, member_name);

          Symbol* var = scope_lookup(var_name);

          printf("[DEBUG] scope_lookup('%s') returned %p\n", var_name, (void*)var);

          if (!var) {
              semantic_error("Variável de struct não declarada!");
              $$ = create_expression(TYPE_UNDEFINED, NULL, new_temp());
            } else if (strstr(var->type, "*")) {
                // Ponteiro para struct: desreferencie para Symbol* e acesse o campo
                char base_type[MAX_NAME_LEN];
                get_base_type_from_pointer(var->type, base_type);
                Symbol* struct_type = scope_lookup(base_type);
                if (!struct_type || !struct_type->field_table) {
                    semantic_error("Tipo base do ponteiro não é struct!");
                    $$ = create_expression(TYPE_UNDEFINED, NULL, new_temp());
                } else {
                    Symbol* struct_instance = var->data.value ? *((Symbol**)var->data.value) : NULL;
                    if (!struct_instance) {
                        semantic_error("Ponteiro nulo.");
                        $$ = create_expression(TYPE_UNDEFINED, NULL, new_temp());
                    } else {
                        Symbol* campo = st_lookup(struct_instance->instance_fields, member_name);
                        if (!campo) {
                            semantic_error("Campo não existe na struct.");
                            $$ = create_expression(TYPE_UNDEFINED, NULL, new_temp());
                        } else {
                            size_t sz = get_size_from_type(campo->type);
                            void* value_copy = NULL;
                            if (campo->data.value) {
                                value_copy = malloc(sz);
                                memcpy(value_copy, campo->data.value, sz);
                            }
                            $$ = create_expression(string_to_type(campo->type), value_copy, new_temp());
                        }
                    }
                }
            } else if (!var->instance_fields) {
              semantic_error("Variável não é struct!");
              $$ = create_expression(TYPE_UNDEFINED, NULL, new_temp());
          } else {
              // Struct direta
              Symbol* campo = st_lookup(var->instance_fields, member_name);
              if (!campo) {
                  semantic_error("Campo não existe na instância da struct!");
                  $$ = create_expression(TYPE_UNDEFINED, NULL, new_temp());
              } else {
                  DataType campo_type = string_to_type(campo->type);
                  size_t campo_size   = get_size_from_type(campo->type);
                  void*  value_copy   = NULL;

                  if (campo->data.value) {
                      value_copy = malloc(campo_size);
                      memcpy(value_copy, campo->data.value, campo_size);
                  }

                  $$ = create_expression(campo_type, value_copy, new_temp());

                  /* DEBUG: expressão criada */
                  printf("[DEBUG] create_expression returned %p\\n", (void*)$$);
              }
          }

          free(member_name);
          free(var_name);
      }
    ;



member_access_dereference
    : LPAREN OP_DEREF_POINTER IDENTIFIER RPAREN OP_ACCESS_MEMBER IDENTIFIER
      {
          // Exemplo: (°a).nome;
          Symbol* ptr = scope_lookup($3);
          char* member = $6;

          if (!ptr || !strstr(ptr->type, "*")) {
              semantic_error("Variável não é ponteiro.");
              $$ = create_expression(TYPE_UNDEFINED, NULL, new_temp());
          } else {
              char base_type[MAX_NAME_LEN];
              get_base_type_from_pointer(ptr->type, base_type);
              Symbol* struct_type = scope_lookup(base_type);
              if (!struct_type || !struct_type->field_table) {
                  semantic_error("Tipo base do ponteiro não é struct.");
                  $$ = create_expression(TYPE_UNDEFINED, NULL, new_temp());
              } else {
                  Symbol* member_sym = st_lookup(&struct_type->field_table->fields, member);
                  if (!member_sym) {
                      semantic_error("Campo não existe na struct.");
                      $$ = create_expression(TYPE_UNDEFINED, NULL, new_temp());
                  } else {
                      void* struct_ptr = ptr->data.value ? *((void**)ptr->data.value) : NULL;
                      if (!struct_ptr) {
                          semantic_error("Ponteiro nulo.");
                          $$ = create_expression(TYPE_UNDEFINED, NULL, new_temp());
                      } else {
                          // Aqui, supondo que os campos estão em ordem e sem padding
                            size_t sz = get_size_from_type(member_sym->type);
                            void* value_copy = malloc(sz);
                            if (member_sym->data.value)
                                memcpy(value_copy, member_sym->data.value, sz);
                            else
                                memset(value_copy, 0, sz);
                            $$ = create_expression(string_to_type(member_sym->type), value_copy, new_temp());
                      }
                  }
              }
          }
          free($3);
          free($6);
      }
    ;

member_access_pointer
    : IDENTIFIER OP_ACCESS_POINTER IDENTIFIER
      {
          // Exemplo: a->nome;
          Symbol* ptr = scope_lookup($1);
          char* member = $3;

          if (!ptr || !strstr(ptr->type, "*")) {
              semantic_error("Acesso '->' em variável que não é ponteiro.");
              $$ = create_expression(TYPE_UNDEFINED, NULL, new_temp());
          } else {
              char base_type[MAX_NAME_LEN];
              get_base_type_from_pointer(ptr->type, base_type);
              Symbol* struct_type = scope_lookup(base_type);
              if (!struct_type || !struct_type->field_table) {
                  semantic_error("Tipo base do ponteiro não é struct.");
                  $$ = create_expression(TYPE_UNDEFINED, NULL, new_temp());
              } else {
                  Symbol* member_sym = st_lookup(&struct_type->field_table->fields, member);
                  if (!member_sym) {
                      semantic_error("Campo não existe na struct.");
                      $$ = create_expression(TYPE_UNDEFINED, NULL, new_temp());
                  } else {
                      void* struct_ptr = ptr->data.value ? *((void**)ptr->data.value) : NULL;
                      if (!struct_ptr) {
                          semantic_error("Ponteiro nulo.");
                          $$ = create_expression(TYPE_UNDEFINED, NULL, new_temp());
                      } else {
                            size_t sz = get_size_from_type(member_sym->type);
                            void* value_copy = malloc(sz);
                            if (member_sym->data.value)
                                memcpy(value_copy, member_sym->data.value, sz);
                            else
                                memset(value_copy, 0, sz);
                            $$ = create_expression(string_to_type(member_sym->type), value_copy, new_temp());
                      }
                  }
              }
          }
          free($1);
          free($3);
      }
    ;

%%