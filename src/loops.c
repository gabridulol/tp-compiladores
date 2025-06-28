#include "loops.h"
#include "symbol_table.h"
#include "scope.h"
#include "expression.h"
#include <stdio.h>
#include <stdlib.h>

// --- Execução de bloco (a ser substituído por execução real do AST) ---
void execute_block(void* bloco) {
    printf("[DEBUG] Executando bloco (placeholder)\n");
}

// Bloco atual para usar em wrapper, se necessário
void* current_loop_block = NULL;

void iter_block_wrapper(void) {
    if (current_loop_block) {
        execute_block(current_loop_block);
    }
}


// --- Impressão útil para debug de expressões ---
void print_expression(Expression* expr) {
    if (!expr) {
        fprintf(stderr, "NULL");
        return;
    }

    fprintf(stderr, "Expression(Type: %s, Value: ", get_type_name(expr->type));

    switch (expr->type) {
        case TYPE_ATOMUS:
        case TYPE_QUANTUM:
            fprintf(stderr, "%d", *(int*)expr->value);
            break;
        case TYPE_FRACTIO:
            fprintf(stderr, "%.2f", *(double*)expr->value);
            break;
        default:
            fprintf(stderr, "???");
            break;
    }
    fprintf(stderr, ")\n");
}

// --- Validação de booleano ---
Expression* evaluate_boolean(Expression* expr, const char* context) {
    if (!expr) {
        fprintf(stderr, "[Erro] Expressão nula no contexto: %s\n", context);
        return NULL;
    }

    if (expr->type != TYPE_QUANTUM) {
        fprintf(stderr, "[Erro] Expressão no contexto '%s' deve ser do tipo 'quantum'.\n", context);
        fprintf(stderr, "[Erro] Expression = ");
        print_expression(expr);
        free_expression(expr);
        return NULL;
    }

    return expr;
}

// --- Avaliação de expressão ---
// Aqui é onde incrementos com efeito colateral deveriam ser tratados, como "i --> i + 1"
// Caso contrário, será ignorado
Expression* evaluate_expression(Expression* expr) {
    // Se a linguagem tiver atribuições como expressões, implemente aqui
    // Por agora, consideramos que expr já está avaliado
    return expr;
}

// --- Execução de laço estilo FOR / WHILE ---
void execute_iterare(Expression* condition_expr, Expression* increment_expr, void (*loop_block_fn)(void)) {
    if (!condition_expr) {
        fprintf(stderr, "[Erro] Expressão de condição nula no ITERARE.\n");
        return;
    }

    fprintf(stderr,
        "[DEBUG] execute_iterare - Condição: Tipo %s (%d), Incremento: %s\n",
        get_type_name(condition_expr->type), condition_expr->type,
        increment_expr ? get_type_name(increment_expr->type) : "NENHUM"
    );

    // Avalia primeira vez a condição
    Expression* cond = evaluate_boolean(condition_expr, "condição do ITERARE");
    if (!cond) return;

    scope_push();  // novo escopo para o loop

    while (*(int*)cond->value) {
        free_expression(cond);  // libera resultado anterior

        loop_block_fn();        // executa o corpo do laço

        if (increment_expr) {
            Expression* incr_result = evaluate_expression(increment_expr);
            if (incr_result) {
                free_expression(incr_result);  // apenas para manter coerência
            } else {
                fprintf(stderr, "[Erro] Incremento malformado no ITERARE.\n");
                break;
            }
        }

        cond = evaluate_boolean(condition_expr, "reavaliação da condição do ITERARE");
        if (!cond) break;  // condição malformada
    }

    if (cond) free_expression(cond);
    scope_pop(); // fecha escopo do loop
}
