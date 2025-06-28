#ifndef AST_H
#define AST_H

#include "expression.h"
#include "symbol_table.h"
#include "scope.h"

// Tipos de nós da AST
typedef enum {
    AST_LITERAL,
    AST_VARIABLE,
    AST_BINARY,
    AST_ASSIGN,
    AST_BLOCK,
    AST_ITERARE
} ASTNodeKind;

// Nó genérico da AST
typedef struct ASTNode {
    ASTNodeKind kind;
    union {
        // Literal: valor já armazenado
        struct {
            DataType type;
            void* value;
        } literal;
        // Referência a variável
        char* variable_name;
        // Operação binária
        struct {
            int op;
            struct ASTNode* left;
            struct ASTNode* right;
        } binary;
        // Atribuição: var = expr
        struct {
            char* variable_name;
            struct ASTNode* expr;
        } assign;
        // Bloco de statements
        struct {
            struct ASTNode** statements;
            int count;
        } block;
        // Laço iterare
        struct {
            struct ASTNode* condition;
            struct ASTNode* increment;
            struct ASTNode* body;
        } iterare;
    } data;
} ASTNode;

// Construtores
ASTNode* ast_make_literal(DataType type, void* value);
ASTNode* ast_make_variable(const char* name);
ASTNode* ast_make_binary(int op, ASTNode* left, ASTNode* right);
ASTNode* ast_make_assign(const char* name, ASTNode* expr);
ASTNode* ast_make_block(ASTNode** stmts, int count);
ASTNode* ast_make_iterare(ASTNode* condition, ASTNode* increment, ASTNode* body);

// Destrutor
void ast_free(ASTNode* node);

// Avaliador da AST: retorna uma Expression* com o valor resultante
Expression* evaluate_ast(ASTNode* node);

#endif