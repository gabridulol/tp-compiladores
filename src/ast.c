#include "ast.h"
#include <stdlib.h>
#include <string.h>

// Helpers
static void* clone_value(DataType type, void* src) {
    size_t sz = get_size_from_type(get_type_name(type));
    void* dst = malloc(sz);
    memcpy(dst, src, sz);
    return dst;
}

// Construtores
ASTNode* ast_make_literal(DataType type, void* value) {
    ASTNode* n = malloc(sizeof(ASTNode));
    n->kind = AST_LITERAL;
    n->data.literal.type = type;
    n->data.literal.value = clone_value(type, value);
    return n;
}

ASTNode* ast_make_variable(const char* name) {
    ASTNode* n = malloc(sizeof(ASTNode));
    n->kind = AST_VARIABLE;
    n->data.variable_name = strdup(name);
    return n;
}

ASTNode* ast_make_binary(int op, ASTNode* left, ASTNode* right) {
    ASTNode* n = malloc(sizeof(ASTNode));
    n->kind = AST_BINARY;
    n->data.binary.op = op;
    n->data.binary.left = left;
    n->data.binary.right = right;
    return n;
}

ASTNode* ast_make_assign(const char* name, ASTNode* expr) {
    ASTNode* n = malloc(sizeof(ASTNode));
    n->kind = AST_ASSIGN;
    n->data.assign.variable_name = strdup(name);
    n->data.assign.expr = expr;
    return n;
}

ASTNode* ast_make_block(ASTNode** stmts, int count) {
    ASTNode* n = malloc(sizeof(ASTNode));
    n->kind = AST_BLOCK;
    n->data.block.statements = stmts;
    n->data.block.count = count;
    return n;
}

ASTNode* ast_make_iterare(ASTNode* condition, ASTNode* increment, ASTNode* body) {
    ASTNode* n = malloc(sizeof(ASTNode));
    n->kind = AST_ITERARE;
    n->data.iterare.condition = condition;
    n->data.iterare.increment = increment;
    n->data.iterare.body = body;
    return n;
}

// Liberar recursivamente
void ast_free(ASTNode* node) {
    if (!node) return;
    switch (node->kind) {
        case AST_LITERAL:
            free(node->data.literal.value);
            break;
        case AST_VARIABLE:
            free(node->data.variable_name);
            break;
        case AST_BINARY:
            ast_free(node->data.binary.left);
            ast_free(node->data.binary.right);
            break;
        case AST_ASSIGN:
            free(node->data.assign.variable_name);
            ast_free(node->data.assign.expr);
            break;
        case AST_BLOCK:
            for (int i = 0; i < node->data.block.count; i++)
                ast_free(node->data.block.statements[i]);
            free(node->data.block.statements);
            break;
        case AST_ITERARE:
            ast_free(node->data.iterare.condition);
            ast_free(node->data.iterare.increment);
            ast_free(node->data.iterare.body);
            break;
    }
    free(node);
}

// Avaliador
Expression* evaluate_ast(ASTNode* node) {
    if (!node) return NULL;
    switch (node->kind) {
        case AST_LITERAL: {
            return create_expression(node->data.literal.type,
                                     clone_value(node->data.literal.type,
                                                 node->data.literal.value));
        }
        case AST_VARIABLE: {
            Symbol* sym = scope_lookup(node->data.variable_name);
            if (!sym) {
                fprintf(stderr, "[Error] Variável '%s' não declarada.\n", node->data.variable_name);
                return NULL;
            }
            DataType dt = string_to_type(sym->type);
            void* val = clone_value(dt, sym->data.value);
            return create_expression(dt, val);
        }
        case AST_BINARY: {
            Expression* L = evaluate_ast(node->data.binary.left);
            Expression* R = evaluate_ast(node->data.binary.right);
            return evaluate_binary_expression(L, node->data.binary.op, R);
        }
        case AST_ASSIGN: {
            // Avalia expressão e armazena no símbolo
            Expression* expr = evaluate_ast(node->data.assign.expr);
            Symbol* sym = scope_lookup(node->data.assign.variable_name);
            if (!sym) {
                fprintf(stderr, "[Error] Variável '%s' não declarada.\n", node->data.assign.variable_name);
                free_expression(expr);
                return NULL;
            }
            DataType dt = string_to_type(sym->type);
            free(sym->data.value);
            sym->data.value = clone_value(dt, expr->value);
            return expr;
        }
        case AST_BLOCK: {
            for (int i = 0; i < node->data.block.count; i++) {
                evaluate_ast(node->data.block.statements[i]);
            }
            return NULL;
        }
        case AST_ITERARE: {
            // Usa execute_iterare, passando ASTNodes
            extern void execute_iterare_ast(ASTNode*, ASTNode*, ASTNode*);
            execute_iterare_ast(node->data.iterare.condition,
                                node->data.iterare.increment,
                                node->data.iterare.body);
            return NULL;
        }
    }
    return NULL;
}
