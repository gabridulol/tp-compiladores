#include "symbol_table.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Função de hash simples (djb2)
static unsigned int hash(const char *str) {
    unsigned int hash = 5381;
    int c;
    while ((c = *str++))
        hash = ((hash << 5) + hash) + c;
    return hash % HASH_SIZE;
}

void st_init(SymbolTable *table) {
    for (int i = 0; i < HASH_SIZE; i++)
        table->table[i] = NULL;
}

Symbol* st_insert(SymbolTable *table, const char *name, SymbolKind kind, const char *type, int line, void *value) {
    unsigned int idx = hash(name);
    Symbol *curr = table->table[idx];
    // Verifica se já existe
    while (curr) {
        if (strcmp(curr->name, name) == 0)
            return NULL; 
        curr = curr->next;
    }
    // Cria novo símbolo
    Symbol *sym = (Symbol*)malloc(sizeof(Symbol));
    strncpy(sym->name, name, MAX_NAME_LEN);
    sym->kind = kind;
    strncpy(sym->type, type, MAX_NAME_LEN);
    sym->line_declared = line;
    sym->value = value;
    sym->next = table->table[idx];
    table->table[idx] = sym;
    return sym;
}

Symbol* st_lookup(SymbolTable *table, const char *name) {
    unsigned int idx = hash(name);
    Symbol *curr = table->table[idx];
    while (curr) {
        if (strcmp(curr->name, name) == 0)
            return curr;
        curr = curr->next;
    }
    return NULL;
}

void st_print(SymbolTable *table) {
    printf("\nTabela de Símbolos:\n");
    printf("%-20s %-10s %-10s %-5s\n", "Nome", "Tipo", "Classe", "Linha");
    for (int i = 0; i < HASH_SIZE; i++) {
        Symbol *curr = table->table[i];
        while (curr) {
            const char *kind_str = (curr->kind == SYM_VAR) ? "VAR" :
                                   (curr->kind == SYM_FUNC) ? "FUNC" : "TYPE";
            printf("%-20s %-10s %-10s %-5d\n", curr->name, curr->type, kind_str, curr->line_declared);
            curr = curr->next;
        }
    }
}

void st_free(SymbolTable *table) {
    for (int i = 0; i < HASH_SIZE; i++) {
        Symbol *curr = table->table[i];
        while (curr) {
            Symbol *tmp = curr;
            curr = curr->next;
            free(tmp);
        }
        table->table[i] = NULL;
    }
}