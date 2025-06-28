#include "loops.h"
#include "symbol_table.h"
#include "scope.h"
#include "expression.h"
#include "ast.h"
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
        case TYPE_SYMBOLUM:
            fprintf(stderr, "'%c'", *(char*)expr->value);
            break;
        case TYPE_SCRIPTUM:
            fprintf(stderr, "\"%s\"", (char*)expr->value);
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

Expression* clone_expression(const Expression* expr) {
    if (!expr) return NULL;

    Expression* new_expr = malloc(sizeof(Expression));
    if (!new_expr) return NULL;

    new_expr->type = expr->type;
    new_expr->value = NULL;

    size_t size = get_size_from_type(get_type_name(expr->type));
    if (expr->value && size > 0) {
        new_expr->value = malloc(size);
        if (new_expr->value) {
            memcpy(new_expr->value, expr->value, size);
        }
    }

    // Copie outros campos, se existirem

    return new_expr;
}


// --- Execução de laço estilo FOR / WHILE ---
// Supondo que você tenha um tipo ASTNode e uma função:
//   Expression* evaluate_ast(ASTNode* node);
// que percorre a árvore e retorna uma nova Expression* com o valor atual.

// void execute_iterare(ASTNode* condition_node,
//                      ASTNode* increment_node,
//                      void (*loop_block_fn)(void))
// {
//     if (!condition_node || !loop_block_fn) {
//         fprintf(stderr, "[Erro] [execute_iterare] condição ou bloco nulo.\n");
//         return;
//     }

//     fprintf(stderr, "[DEBUG] [execute_iterare] Iniciando laço ITERARE\n");

//     scope_push();
//     int iter = 0;

//     while (1) {
//         // 1) Re-avalia a condição a cada iteração
//         Expression* cond_expr = evaluate_ast(condition_node);
//         Expression* cond_bool = evaluate_boolean(cond_expr, "condição do ITERARE");
//         if (!cond_bool) {
//             // erro ou não-booleano
//             break;
//         }

//         fprintf(stderr, "[DEBUG] [execute_iterare] Iter %d – condição = ", iter);
//         print_expression(cond_bool);
//         int keep = *(int*)cond_bool->value;
//         free_expression(cond_bool);

//         if (!keep) {
//             fprintf(stderr, "[DEBUG] [execute_iterare] Condição falsa. Saindo do laço.\n");
//             break;
//         }

//         // 2) Executa o corpo
//         loop_block_fn();

//         // 3) Re-avalia o incremento (para aplicar side-effect em 'i')
//         if (increment_node) {
//             Expression* inc_expr = evaluate_ast(increment_node);
//             free_expression(inc_expr);
//         }

//         iter++;
//     }

//     scope_pop();
//     fprintf(stderr, "[DEBUG] [execute_iterare] Laço encerrado após %d iterações.\n", iter);
// }
