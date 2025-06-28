#ifndef LOOPS_H
#define LOOPS_H

#include "expression.h"
#include <stdbool.h>

extern void* current_loop_block;

void execute_block(void* bloco);

void iter_block_wrapper(void);

void execute_iterare(Expression* condition_expr, Expression* increment_expr, void (*loop_block_fn)(void));


Expression* evaluate_boolean(Expression* expr, const char* context);
Expression* evaluate_expression(Expression* expr); // assume já avaliada

#endif
