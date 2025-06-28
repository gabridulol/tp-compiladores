#ifndef LOOPS_H
#define LOOPS_H

#include "expression.h"
#include <stdbool.h>

extern void* current_loop_block;

void execute_block(void* bloco);

void iter_block_wrapper(void);

void execute_iterare_ast(ASTNode* cond, ASTNode* incr, ASTNode* body);


Expression* clone_expression(const Expression* expr);

Expression* evaluate_boolean(Expression* expr, const char* context);

Expression* evaluate_expression(Expression* expr); // assume já avaliada

#endif
