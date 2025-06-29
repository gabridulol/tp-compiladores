#ifndef SCOPE_H
#define SCOPE_H

#include "symbol_table.h"
#include <stdbool.h>


typedef enum {
    BLOCK_NONE,
    BLOCK_GLOBAL,
    BLOCK_FUNCTION,
    BLOCK_LOOP,
    BLOCK_CONDITIONAL,
} BlockType;

static const char *BlockTypeNames[] = {
    [BLOCK_NONE]        = "Nenhum",
    [BLOCK_GLOBAL]      = "Global",
    [BLOCK_FUNCTION]    = "Função",
    [BLOCK_LOOP]        = "Loop",
    [BLOCK_CONDITIONAL] = "Condicional",
};


typedef struct Scope {
    SymbolTable table;
    char type[MAX_NAME_LEN]; // Tipo do escopo (ex: "atomus", "fractio", etc.)
    BlockType block_type;
    int index;
    struct Scope *prev;  // Escopo pai (escopo anterior na pilha)
} Scope;


// Inicializa escopo global
void scope_init();

// Empilha um novo escopo com o tipo especificado
void scope_push_formula(BlockType block_type, const char *type);

// Cria um novo escopo (empilha)
void scope_push(BlockType block_type);

// Remove escopo atual (desempilha)
void scope_pop();

// Insere símbolo no escopo atual
Symbol* scope_insert(const char *name, SymbolKind kind, const char *type, int line, void *value);

// Procura símbolo em todos os escopos, do mais recente ao mais antigo
Symbol* scope_lookup(const char *name);
bool scope_allowed(const BlockType allowed[], int count, char *type_redire);

// Procura símbolo apenas no escopo atual
Symbol* scope_lookup_current(const char *name);

// Libera toda a pilha de escopos (ex: no fim do programa)
void scope_cleanup();

// Imprime todos os símbolos de todos os escopos
void scope_print_all();

#endif