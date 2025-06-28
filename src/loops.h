#ifndef LOOPS_H
#define LOOPS_H

#include "expression.h"
#include "ast.h"
#include <stdbool.h>

// Ponteiro para o bloco atual em loop
extern void* current_loop_block;

// Executa o conteúdo genérico de um bloco AST
void execute_block(void* bloco);
// Wrapper para chamar execute_block a partir de ponteiro global
void iter_block_wrapper(void);

// Laço estilo for: condição, incremento e corpo
// void execute_iterare(ASTNode* condition_node,
//                      ASTNode* increment_node,
//                      void (*loop_block_fn)(void));

// // Laço estilo while: condição e corpo
// void execute_dum(ASTNode* condition_node,
//                  void (*loop_block_fn)(void));

// Avalia e valida expressão booleana (quantum)
Expression* evaluate_boolean(Expression* expr, const char* context);
// Avalia expressões com possíveis side-effects (incrementos, atribuições)
Expression* evaluate_expression(Expression* expr);
// Clona expressão para reavaliações independentes
Expression* clone_expression(const Expression* expr);

#endif // LOOPS_H