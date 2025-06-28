%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../src/symbol_table.h"
#include "../src/scope.h"
#include "../src/source_printer.h"
#include "../src/expression.h"
#include "../src/loops.h"

extern int yylineno;

typedef struct ArgNode {
    void* value;          // Ponteiro para o valor do argumento
    struct ArgNode* next; // Ponteiro para o próximo argumento na lista
} ArgNode;


FieldTable *current_struct_fields = NULL;

int yylex(void);

void yyerror(const char *s);
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
%token KW_NON_SI // Deprecated, NON SI is token KW_NON and KW_SI
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

%type <arg_list> argument_list

%type <ptr> block
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
        { scope_push(); }     /* cria novo escopo */
      statement_list
      RBRACE
      {
          $$ = NULL; // OU ponteiro real para o bloco
      }
      // { scope_pop(); }      / remoção do escopo pode ser feita em cada produção individual
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
    : expression OP_ASSIGN IDENTIFIER SEMICOLON // Atribuição a uma variável simples
      {
          Expression* value_expr = $1;
          char* var_name = $3;
          Symbol* sym = scope_lookup(var_name);

          // 1. Validar se a variável existe
          if (sym == NULL) {
              char err_msg[128];
              sprintf(err_msg, "Erro semântico: variável '%s' não declarada.", var_name);
              yyerror(err_msg);
          } else {
              // 2. Checar se os tipos são compatíveis
              DataType declared_type = string_to_type(sym->type);
              if (value_expr->type != declared_type) {
                  char err_msg[256];
                  sprintf(err_msg, "Erro de tipo: impossível atribuir valor à variável '%s'.", var_name);
                  yyerror(err_msg);
              } else {
                  // 3. Atribuir o novo valor, liberando o antigo se existir
                  if (sym->data.value) {
                      free(sym->data.value);
                  }
                  sym->data.value = value_expr->value; // Transfere o ponteiro do valor
                  value_expr->value = NULL;            // Evita o duplo free
              }
          }

          // 4. Limpeza da memória
          free_expression(value_expr); // Libera o "invólucro" da Expression
          free(var_name);
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
              yyerror(err_msg);
          } else {
              // 2. Checar os tipos da expressão de índice e do valor
              DataType element_type = string_to_type(sym->type);
              if (index_expr->type != TYPE_ATOMUS) {
                  yyerror("Erro de tipo: o índice de um vetor deve ser um inteiro (atomus).");
              } else if (value_expr->type != element_type) {
                  yyerror("Erro de tipo: o valor a ser atribuído é incompatível com o tipo do vetor.");
              } else {
                  // 3. Realizar a atribuição
                  int index = *(int*)(index_expr->value); // Extrai o valor do índice

                  // Verificação de limites (bounds checking)
                  if (index < 0 || index >= sym->data.vector_info.size) {
                      char err_msg[128];
                      sprintf(err_msg, "Erro: Índice '%d' fora dos limites do vetor '%s'.", index, vec_name);
                      yyerror(err_msg);
                  } else {
                      // Se tudo estiver certo, copia o valor
                      size_t element_size = get_size_from_type(sym->type);
                      void* dest_ptr = (char*)sym->data.vector_info.data_ptr + (index * element_size);
                      memcpy(dest_ptr, value_expr->value, element_size);
                  }
              }
          }

          // 4. Limpeza da memória
          free_expression(value_expr);
          free_expression(index_expr);
          free(vec_name);
      }
    ;

import_statement
    : IDENTIFIER KW_EVOCARE SEMICOLON 
   ;

//

expression_statement
    : expression SEMICOLON
      {
          // $1 é o Expression* final da expressão
          if ($1) {
              if ($1->type == TYPE_ATOMUS && $1->value) {
                  printf(">> Resultado Final (atomus): %d\n", *(int*)$1->value);
              } else if ($1->type == TYPE_FRACTIO && $1->value) {
                  printf(">> Resultado Final (fractio): %f\n", *(double*)$1->value);
              }
              free_expression($1); // Libera a expressão final
          }
      }
    ;

primary_expression
    : IDENTIFIER
      {
          Symbol *s = scope_lookup($1);
          if (!s) {
              fprintf(stderr, "Erro: identificador '%s' não declarado na linha %d\n", $1, yylineno);
              $$ = NULL;
              semantic_error("Identificador não declarado.");
          } else {
              DataType type = string_to_type(s->type);
              size_t value_size = get_size_from_type(s->type);
              void* value_copy = malloc(value_size);
              if (s->data.value) { 
                  memcpy(value_copy, s->data.value, value_size);
              } else {
                  free(value_copy);
                  value_copy = NULL;
              }
              $$ = create_expression(type, value_copy);
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
    | member_access_direct
      {
          $$ = $1;
      }
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
      { $$ = evaluate_binary_expression($1, OP_ADD, $3); }
    | expression OP_SUBTRACT unary_expression
      { $$ = evaluate_binary_expression($1, OP_SUBTRACT, $3); }
    | expression OP_MULTIPLY unary_expression
      { $$ = evaluate_binary_expression($1, OP_MULTIPLY, $3); }
    | expression OP_DIVIDE unary_expression
      { $$ = evaluate_binary_expression($1, OP_DIVIDE, $3); }
    | expression OP_MODULUS unary_expression
      { $$ = evaluate_binary_expression($1, OP_MODULUS, $3); }
    | expression OP_EXP unary_expression
      { $$ = evaluate_binary_expression($1, OP_EXP, $3); }
    | expression OP_INTEGER_DIVIDE unary_expression
      { $$ = evaluate_binary_expression($1, OP_INTEGER_DIVIDE, $3); }

    /* --- Operadores Relacionais (de Comparação) --- */
    | expression OP_EQUAL unary_expression
      { $$ = evaluate_binary_expression($1, OP_EQUAL, $3); }
    | expression OP_NOT_EQUAL unary_expression
      { $$ = evaluate_binary_expression($1, OP_NOT_EQUAL, $3); }
    | expression OP_LESS_THAN unary_expression
      { $$ = evaluate_binary_expression($1, OP_LESS_THAN, $3); }
    | expression OP_GREATER_THAN unary_expression
      { $$ = evaluate_binary_expression($1, OP_GREATER_THAN, $3); }
    | expression OP_LESS_EQUAL unary_expression
      { $$ = evaluate_binary_expression($1, OP_LESS_EQUAL, $3); }
    | expression OP_GREATER_EQUAL unary_expression
      { $$ = evaluate_binary_expression($1, OP_GREATER_EQUAL, $3); }

    /* --- Operadores Lógicos --- */
    | expression OP_LOGICAL_AND unary_expression
      { $$ = evaluate_binary_expression($1, OP_LOGICAL_AND, $3); }
    | expression OP_LOGICAL_OR unary_expression
      { $$ = evaluate_binary_expression($1, OP_LOGICAL_OR, $3); }
    | expression OP_LOGICAL_XOR unary_expression
      { $$ = evaluate_binary_expression($1, OP_LOGICAL_XOR, $3); }

    /* --- Operadores de Atribuição e Acesso (se forem expressões) --- */
    // Nota: A atribuição como expressão (ex: a = b = 5) é mais complexa.
    // A regra abaixo funciona se 'evaluate_binary_expression' for adaptada
    // para modificar o símbolo e retornar o valor.
    | expression OP_ASSIGN assing_value
      {
          // O tratamento para atribuição como expressão precisa de uma lógica
          // especial. Por simplicidade, é comum tratar atribuição apenas
          // como um statement (instrução), não como uma expressão que retorna valor.
          // Se precisar que 'a = 5' retorne '5', a função de avaliação
          // precisará ser mais inteligente.
      }
    ;

constant
    : LIT_INT
      {
          int *val = malloc(sizeof(int));
          *val = $1;
          // CORREÇÃO: Usar o nome do ENUM
          $$ = create_expression(TYPE_ATOMUS, val); 
      }
    | LIT_FLOAT
      {
          double *val = malloc(sizeof(double));
          *val = $1;
          // CORREÇÃO: Usar o nome do ENUM (este já estava certo)
          $$ = create_expression(TYPE_FRACTIO, val); 
      }
    | LIT_FACTUM
      {
          int *val = malloc(sizeof(int));
          *val = 1; // 1 para verdadeiro
          // CORREÇÃO: Usar o nome do ENUM
          $$ = create_expression(TYPE_QUANTUM, val);
      }
    | LIT_FICTUM
      {
          int *val = malloc(sizeof(int));
          *val = 0; // 0 para falso
          // CORREÇÃO: Usar o nome do ENUM
          $$ = create_expression(TYPE_QUANTUM, val);
      }
    | LIT_CHAR
      {
          // CORREÇÃO: Usar o nome do ENUM
          $$ = create_expression(TYPE_SYMBOLUM, strdup($1)); 
      }
    ;

string
    : LIT_STRING
      {
        $$ = create_expression(KW_TYPE_SCRIPTUM, strdup($1));
      }
    ;

//

assing_value
    : IDENTIFIER
    | vector_access
    | pointer_statement
    ;

declaration_statement
    : IDENTIFIER type_specifier opcional_constant SEMICOLON{
          if (current_struct_fields) {
              st_insert(&current_struct_fields->fields, $1, SYM_VAR, $2, yylineno, NULL);
          } else {
              if (scope_lookup($1) != NULL) {
                  Symbol *sym = scope_lookup($1);
                  if(sym->kind != SYM_VAR) {
                      semantic_error("Variável já declarada com outro tipo!");
                  } else {
                      sym->kind = SYM_VAR;
                      sym->line_declared = yylineno;
                  }
              } else {
                // Verifica se o tipo é uma struct definida
                Symbol *type_sym = scope_lookup($2);
                Symbol *var_sym = scope_insert($1, SYM_VAR, $2, yylineno, NULL);

                if (type_sym && type_sym->kind == SYM_TYPE && type_sym->field_table) {
                    // É uma struct: cria tabela de campos da instância
                    var_sym->instance_fields = malloc(sizeof(SymbolTable));
                    st_init(var_sym->instance_fields);

                    // Para cada campo da struct, cria um símbolo na instância
                    for (int i = 0; i < HASH_SIZE; i++) {
                        Symbol *field = type_sym->field_table->fields.table[i];
                        while (field) {
                            st_insert(var_sym->instance_fields, field->name, SYM_VAR, field->type, yylineno, NULL);
                            field = field->next;
                        }
                    }
                }
              }
          }
          free($1);
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
                  initial_value_expr->value = NULL;
                  free_expression(initial_value_expr);
              }
          }
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
    | declaration_statement
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
    | IDENTIFIER                   { $$ = strdup($1); }
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
          yyerror("Função já declarada!");
        } else {
          scope_insert($5, SYM_FUNC, $7, yylineno, NULL);
        }
        free($5);
        scope_push(); // Cria escopo da função após inserir a função
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

/* ```
Declarações de salto: continuum, ruptio e redire */
jump_statement
    : KW_CONTINUUM SEMICOLON
    | KW_RUPTIO SEMICOLON
    | KW_REDIRE SEMICOLON
    | expression KW_REDIRE SEMICOLON
    ;

conditional_statement
    : LPAREN expression RPAREN KW_SI block { scope_pop(); }
    | LPAREN expression RPAREN KW_SI block { scope_pop(); } conditional_non_statement
    | LPAREN expression RPAREN KW_VERTERE LBRACE { scope_push(); } causal_statement RBRACE { scope_pop(); }
    ;

conditional_non_statement
    : KW_NON block { scope_pop(); }
    | KW_NON conditional_statement
    ;

causal_statement
    : KW_CASUS expression COLON statement_list 
    | KW_AXIOM COLON statement_list 
    ;

    
iteration_statement
    : LPAREN expression RPAREN KW_PERSISTO block
      {
        scope_push();

        Expression* cond = $2;
        if (cond == NULL) {
            yyerror("Expressão condicional do 'persisto' não pode ser nula.");
            scope_pop();
            YYERROR;  // Para abortar o parsing
        }
        if (cond->type != TYPE_QUANTUM) {
            yyerror("Expressão condicional do 'persisto' precisa ser do tipo 'quantum'.");
            free_expression(cond);
            scope_pop();
            YYERROR;
        }

        current_loop_block = $5;
        fprintf(stderr, "[DEBUG] Persisto (while) iniciado. current_loop_block = %p\n", (void*)current_loop_block);
        execute_iterare(cond, NULL, iter_block_wrapper);
        free_expression(cond);

        scope_pop();
      }

    | LPAREN expression_statement expression_statement expression RPAREN KW_ITERARE block
      {
        scope_push();

        fprintf(stderr, "[DEBUG] FOR estilo C: inicialização; condição; incremento\n");
        fprintf(stderr, "[DEBUG] current_loop_block = %p\n", (void*)$7);

        current_loop_block = $7;

        if ($3 == NULL) {
            yyerror("Expressão de condição no for não pode ser nula.");
            scope_pop();
            YYERROR;
        }
        if ($3->type != TYPE_QUANTUM) {
            yyerror("Expressão condicional do for precisa ser do tipo 'quantum'.");
            free_expression($3);
            scope_pop();
            YYERROR;
        }

        execute_iterare($3, $4, iter_block_wrapper);

        scope_pop();
      }

    | LPAREN expression_statement expression_statement RPAREN KW_ITERARE block
      {
        scope_push();

        fprintf(stderr, "[DEBUG] FOR estilo C: inicialização; condição (sem incremento)\n");
        fprintf(stderr, "[DEBUG] current_loop_block = %p\n", (void*)$6);

        current_loop_block = $6;

        if ($3 == NULL) {
            yyerror("Expressão de condição no for não pode ser nula.");
            scope_pop();
            YYERROR;
        }
        if ($3->type != TYPE_QUANTUM) {
            yyerror("Expressão condicional do for precisa ser do tipo 'quantum'.");
            free_expression($3);
            scope_pop();
            YYERROR;
        }

        execute_iterare($3, NULL, iter_block_wrapper);

        scope_pop();
      }

    | LPAREN declaration_statement expression_statement expression RPAREN KW_ITERARE block
      {
        scope_push();

        fprintf(stderr, "[DEBUG] FOR estilo C: declaração; condição; incremento\n");
        fprintf(stderr, "[DEBUG] current_loop_block = %p\n", (void*)$7);

        current_loop_block = $7;

        if ($3 == NULL) {
            yyerror("Expressão de condição no for não pode ser nula.");
            scope_pop();
            YYERROR;
        }
        if ($3->type != TYPE_QUANTUM) {
            yyerror("Expressão condicional do for precisa ser do tipo 'quantum'.");
            free_expression($3);
            scope_pop();
            YYERROR;
        }

        execute_iterare($3, $4, iter_block_wrapper);

        scope_pop();
      }

    | LPAREN declaration_statement expression_statement RPAREN KW_ITERARE block
      {
        scope_push();

        fprintf(stderr, "[DEBUG] FOR estilo C: declaração; condição (sem incremento)\n");
        fprintf(stderr, "[DEBUG] current_loop_block = %p\n", (void*)$6);

        current_loop_block = $6;

        if ($3 == NULL) {
            yyerror("Expressão de condição no for não pode ser nula.");
            scope_pop();
            YYERROR;
        }
        if ($3->type != TYPE_QUANTUM) {
            yyerror("Expressão condicional do for precisa ser do tipo 'quantum'.");
            free_expression($3);
            scope_pop();
            YYERROR;
        }

        execute_iterare($3, NULL, iter_block_wrapper);

        scope_pop();
      }
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

enum_assignment
    : IDENTIFIER OP_ASSIGN IDENTIFIER IDENTIFIER KW_ENUMERARE SEMICOLON
      {
           if (scope_lookup($1) != NULL) {
                semantic_error("Enumeração já declarada!");
            }else{
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

vector
    : IDENTIFIER type_specifier LANGLE expression RANGLE SEMICOLON
    | IDENTIFIER SEMICOLON
    ;
    
// Declaração de um vetor (ex: vetor1 atomus << 10 >>;)
vector_statement
    : IDENTIFIER type_specifier LANGLE expression RANGLE SEMICOLON
      {
          char* vec_name = $1;
          char* type_name = $2;
          Expression* size_expr = $4;

          // 1. Validar a expressão de tamanho
          if (!size_expr) {
              yyerror("Expressão de tamanho do vetor é inválida.");
          } else if (size_expr->type != TYPE_ATOMUS) {
              yyerror("Erro de tipo: o tamanho de um vetor deve ser um inteiro (atomus).");
          } else {
              int vector_size = *(int*)(size_expr->value); // Extração correta do valor

              if (vector_size <= 0) {
                  yyerror("O tamanho do vetor deve ser um número positivo.");
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
                      yyerror("Erro: Símbolo já declarado neste escopo.");
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
                      yyerror("Erro de tipo na lista de inicialização do vetor.");
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
              yyerror("Erro semântico: identificador não é um vetor declarado.");
          } else if (!index_expr || index_expr->type != TYPE_ATOMUS) {
              yyerror("Erro de tipo: o índice de um vetor deve ser um inteiro (atomus).");
          } else {
              int index = *(int*)(index_expr->value);

              // 2. Verificação de limites (bounds checking)
              if (index < 0 || index >= sym->data.vector_info.size) {
                  char err_msg[128];
                  sprintf(err_msg, "Erro: Índice '%d' fora dos limites do vetor '%s'.", index, vec_name);
                  yyerror(err_msg);
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
                      $$ = create_expression(element_type, value_copy);
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
    : OP_ADDR_OF IDENTIFIER
      {
          $$ = NULL; // Inicializa como falha
          Symbol* s = scope_lookup($2);

          if (!s) {
              char err_msg[128];
              sprintf(err_msg, "Erro semântico: variável '%s' não declarada.", $2);
              yyerror(err_msg);
          } else {
              // 1. O "valor" desta expressão é o endereço onde o valor de 's' está armazenado.
              //    s->data.value já é um ponteiro para o valor da variável.
              void* address_of_variable = s->data.value;

              // 2. Criamos um ponteiro para guardar esse endereço.
              void** address_holder = malloc(sizeof(void*));
              if(address_holder) {
                  *address_holder = address_of_variable;
                  
                  // 3. O resultado é uma expressão do tipo ponteiro.
                  $$ = create_expression(TYPE_POINTER, address_holder);
              } else {
                  yyerror("Falha ao alocar memória para o endereço.");
              }
          }
          free($2);
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
              yyerror(err_msg);
          } else {
              // 2. Obter o endereço que o ponteiro armazena
              void* address_held_by_pointer = s->data.value;
              if (address_held_by_pointer == NULL) {
                  yyerror("Erro em tempo de execução: dereferência de ponteiro nulo.");
              } else {
                  // 3. Determinar o tipo e o tamanho do dado que está no endereço
                  char base_type_name[MAX_NAME_LEN];
                  get_base_type_from_pointer(s->type, base_type_name); // Função auxiliar
                  
                  DataType base_type = string_to_type(base_type_name); // Função auxiliar
                  size_t value_size = get_size_from_type(base_type_name);   // Função auxiliar

                  if (base_type == TYPE_UNDEFINED) {
                      yyerror("Erro interno: tipo base do ponteiro desconhecido.");
                  } else {
                      // 4. Alocar memória para uma CÓPIA do valor e copiar
                      void* value_copy = malloc(value_size);
                      if (value_copy) {
                          memcpy(value_copy, address_held_by_pointer, value_size);
                          
                          // 5. Criar a Expression com o valor copiado
                          $$ = create_expression(base_type, value_copy);
                      } else {
                          yyerror("Falha ao alocar memória para o valor dereferenciado.");
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
          $$ = NULL; // Por padrão, a operação falha.
          char* struct_var_name = $1;
          char* member_name = $3;
          
          // 1. Buscar a variável da struct na tabela de símbolos.
          Symbol* struct_sym = scope_lookup(struct_var_name);

          if (!struct_sym) {
              yyerror("Erro: Variável da struct não declarada.");
          } else if (strcmp(struct_sym->type, "homunculus") != 0) { // Checa se é uma struct
              yyerror("Erro: Acesso a membro em uma variável que não é uma struct.");
          } else if (!struct_sym->field_table) {
              yyerror("Erro interno: Tabela de campos da struct não encontrada.");
          } else {
              // --- Lógica a ser implementada quando as structs estiverem funcionais ---
              
              // TODO 1: Buscar o 'member_name' na tabela de campos da struct.
              // Symbol* member_sym = st_lookup(&struct_sym->field_table->fields, member_name);
              // if (!member_sym) { yyerror("Membro não existe na struct."); }

              // TODO 2: Calcular o offset do membro e obter o ponteiro para o dado.
              // Onde 'member_sym->offset' seria o deslocamento em bytes do membro.
              // void* member_data_ptr = (char*)struct_sym->data.value + member_sym->offset;
              
              // TODO 3: Copiar o valor do membro para uma nova Expression.
              // DataType member_type = string_to_type(member_sym->type);
              // size_t member_size = get_size_from_type(member_sym->type);
              // void* value_copy = malloc(member_size);
              // memcpy(value_copy, member_data_ptr, member_size);
              // $$ = create_expression(member_type, value_copy);

              printf("AVISO: Lógica de acesso a membro '.' ainda não totalmente implementada.\n");
              // Por enquanto, retornamos uma expressão vazia para não quebrar a gramática.
              $$ = create_expression(TYPE_UNDEFINED, NULL);
          }

          free(struct_var_name);
          free(member_name);
      }
    ;


member_access_dereference
    : LPAREN OP_DEREF_POINTER IDENTIFIER RPAREN OP_ACCESS_MEMBER IDENTIFIER
      {
          // Esta forma de acesso é semanticamente idêntica a '->'.
          // A implementação seria a mesma de 'member_access_pointer',
          // usando $3 como o nome da variável ponteiro e $6 como o nome do membro.
          
          // (Aqui entraria a mesma lógica de 'member_access_pointer' com os devidos ajustes de índice)
          
          printf("AVISO: Lógica de acesso a membro '(*p).' ainda não totalmente implementada.\n");
          $$ = create_expression(TYPE_UNDEFINED, NULL);
          free($3);
          free($6);
      }
    ;

member_access_pointer
    : IDENTIFIER OP_ACCESS_POINTER IDENTIFIER
      {
          $$ = NULL;
          char* pointer_var_name = $1;
          char* member_name = $3;
          
          // 1. Buscar a variável ponteiro na tabela de símbolos.
          Symbol* pointer_sym = scope_lookup(pointer_var_name);

          // 2. Validar se é um ponteiro para uma struct.
          if (!pointer_sym || strstr(pointer_sym->type, "*") == NULL) {
              yyerror("Erro: Acesso '->' em uma variável que não é um ponteiro.");
          } else {
              // --- Lógica a ser implementada ---

              // TODO 1: Obter a definição do tipo da struct.
              // char base_type_name[MAX_NAME_LEN];
              // get_base_type_from_pointer(pointer_sym->type, base_type_name);
              // Symbol* struct_type_def = scope_lookup(base_type_name);
              // if (!struct_type_def || !struct_type_def->field_table) { ... }
              
              // TODO 2: Buscar o membro na 'field_table' da DEFINIÇÃO do tipo.
              // Symbol* member_sym = st_lookup(&struct_type_def->field_table->fields, member_name);
              
              // TODO 3: Obter o endereço da struct para a qual o ponteiro aponta.
              // void* struct_data_ptr = pointer_sym->data.value;

              // TODO 4: Calcular o endereço do membro e copiar seu valor.
              // void* member_data_ptr = (char*)struct_data_ptr + member_sym->offset;
              // ... (lógica de cópia e criação de Expression, como no acesso direto) ...

              printf("AVISO: Lógica de acesso a membro '->' ainda não totalmente implementada.\n");
              $$ = create_expression(TYPE_UNDEFINED, NULL);
          }
          
          free(pointer_var_name);
          free(member_name);
      }
    ;

%%
