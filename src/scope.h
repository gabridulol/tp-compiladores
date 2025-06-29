#ifndef SCOPE_H
#define SCOPE_H

#include "symbol_table.h"

typedef struct Scope {
    SymbolTable table;
    struct Scope *prev;  // Escopo pai (escopo anterior na pilha)
} Scope;


// Inicializa escopo global
void scope_init();

// Cria um novo escopo (empilha)
void scope_push();

// Remove escopo atual (desempilha)
void scope_pop();

// Insere símbolo no escopo atual
Symbol* scope_insert(const char *name, SymbolKind kind, const char *type, int line, void *value);

// Procura símbolo em todos os escopos, do mais recente ao mais antigo
Symbol* scope_lookup(const char *name);

// Procura símbolo apenas no escopo atual
Symbol* scope_lookup_current(const char *name);

// Libera toda a pilha de escopos (ex: no fim do programa)
void scope_cleanup();

// Imprime todos os símbolos de todos os escopos
void scope_print_all();

#endif