#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#define MAX_NAME_LEN 64
#define HASH_SIZE 997

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum {
    SYM_VAR,
    SYM_FUNC,
    SYM_TYPE
    // Adicione outros tipos conforme necessário
} SymbolKind;

typedef struct Symbol {
    char name[MAX_NAME_LEN];
    SymbolKind kind;
    char type[MAX_NAME_LEN]; // Ex: "atomus", "fractio", etc.
    void *value;
    int line_declared;
    struct Symbol *next; // Para colisões (encadeamento)
} Symbol;

typedef struct {
    Symbol *table[HASH_SIZE];
} SymbolTable;

// Funções da tabela
void st_init(SymbolTable *table);
Symbol* st_insert(SymbolTable *table, const char *name, SymbolKind kind, const char *type, int line, void *value);
Symbol* st_lookup(SymbolTable *table, const char *name);
void st_print(SymbolTable *table);
void st_free(SymbolTable *table);

#endif // SYMBOL_TABLE_H