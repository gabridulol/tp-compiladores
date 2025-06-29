#include "loops.h"
#include "symbol_table.h"
#include "scope.h"
#include "expression.h"
#include "ast.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// --- Execução genérica de bloco AST (stub) ---
void execute_block(void* bloco) {
    // Substituir por execução real de ASTNode*
    printf("[DEBUG] Executando bloco (placeholder)\n");
}

// Bloco corrente para uso em wrapper
void* current_loop_block = NULL;

void iter_block_wrapper(void) {
    if (current_loop_block) {
        execute_block(current_loop_block);
    }
}

// Debug: imprime Expression para rastreamento
static void print_expression(const Expression* expr) {
    if (!expr) {
        fprintf(stderr, "NULL\n");
        return;
    }
    fprintf(stderr, "Expression(Type: %s, Value: ", get_type_name(expr->type));
    switch (expr->type) {
        case TYPE_UNDEFINED:
            fprintf(stderr, "undefined");
            break;
        case TYPE_VACUUM:
            fprintf(stderr, " ");
            break;
        case TYPE_ATOMUS:
        case TYPE_QUANTUM:
            fprintf(stderr, "%d", *(int*)expr->value);
            break;
        case TYPE_FRACTIO:
            fprintf(stderr, "%.2f", *(double*)expr->value);
            break;
        case TYPE_FRAGMENTUM:
            fprintf(stderr, "%.2lf", *(double*)expr->value);
            break;
        case TYPE_MAGNUS:
            fprintf(stderr, "%lld", *(long long int*)expr->value);
            break;
        case TYPE_MINIMUS:
            fprintf(stderr, "%d", *(short*)expr->value);
            break;
        case TYPE_SYMBOLUM:
            fprintf(stderr, "'%c'", *(char*)expr->value);
            break;
        case TYPE_SCRIPTUM:
            fprintf(stderr, "\"%s\"", (char*)expr->value);
            break;
        case TYPE_POINTER:
            if (expr->value) {
                fprintf(stderr, "%p", *(void**)expr->value);
            }
            else {
                fprintf(stderr, "NULL");
            }
            break;
        default:
            fprintf(stderr, "???:%p", expr->value);
    }
    fprintf(stderr, ")\n");
}

// Valida se expr é TYPE_QUANTUM (booleano)
Expression* evaluate_boolean(Expression* expr, const char* context) {
    if (!expr) {
        fprintf(stderr, "[Erro] Expressão nula em '%s'\n", context);
        return NULL;
    }
    if (expr->type != TYPE_QUANTUM) {
        fprintf(stderr, "[Erro] Expressão em '%s' deve ser 'quantum'.\n", context);
        print_expression(expr);
        free_expression(expr);
        return NULL;
    }
    return expr;
}

// Avalia expressões com side-effects (ex: i = i + 1)
Expression* evaluate_expression(Expression* expr) {
    // Se a AST suportar atribuições como expressões, trate aqui
    return expr;
}

// Clona expressão para uso independente
Expression* clone_expression(const Expression* expr) {
    if (!expr) return NULL;
    Expression* copy = malloc(sizeof(Expression));
    if (!copy) return NULL;
    copy->type = expr->type;
    copy->value = NULL;
    size_t sz = get_size_from_type(get_type_name(expr->type));
    if (expr->value && sz > 0) {
        copy->value = malloc(sz);
        if (copy->value) memcpy(copy->value, expr->value, sz);
    }
    return copy;
}

// Laço FOR: reavalia condição, executa corpo e aplica incremento
// void execute_iterare(ASTNode* condition_node,
//                      ASTNode* increment_node,
//                      void (*loop_block_fn)(void)) {
//     if (!condition_node || !loop_block_fn) {
//         fprintf(stderr, "[Erro] execute_iterare: condição ou bloco nulo.\n");
//         return;
//     }
//     fprintf(stderr, "[DEBUG] Iniciando FOR\n");
//     scope_push();
//     int iter = 0;
//     while (1) {
//         Expression* cond = evaluate_ast(condition_node);
//         Expression* cb   = evaluate_boolean(cond, "condição do FOR");
//         if (!cb) break;
//         int keep = *(int*)cb->value;
//         free_expression(cb);
//         if (!keep) break;
//         fprintf(stderr, "[DEBUG] Iter %d - condição verdadeira\n", iter);
//         loop_block_fn();
//         if (increment_node) {
//             Expression* inc = evaluate_ast(increment_node);
//             free_expression(inc);
//         }
//         iter++;
//     }
//     scope_pop();
//     fprintf(stderr, "[DEBUG] FOR encerrado após %d iterações\n", iter);
// }

// // Laço WHILE: reavalia condição e executa corpo
// void execute_dum(ASTNode* condition_node,
//                  void (*loop_block_fn)(void)) {
//     if (!condition_node || !loop_block_fn) {
//         fprintf(stderr, "[Erro] execute_dum: condição ou bloco nulo.\n");
//         return;
//     }
//     fprintf(stderr, "[DEBUG] Iniciando WHILE\n");
//     scope_push();
//     int iter = 0;
//     while (1) {
//         Expression* cond = evaluate_ast(condition_node);
//         Expression* cb   = evaluate_boolean(cond, "condição do WHILE");
//         if (!cb) break;
//         int keep = *(int*)cb->value;
//         free_expression(cb);
//         if (!keep) break;
//         fprintf(stderr, "[DEBUG] Iter %d - condição verdadeira\n", iter);
//         loop_block_fn();
//         iter++;
//     }
//     scope_pop();
//     fprintf(stderr, "[DEBUG] WHILE encerrado após %d iterações\n", iter);
// }
