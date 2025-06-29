#include "scope.h"

Scope *scope_stack = NULL;
Scope *scope_menor = NULL;

void scope_init() {
    scope_stack = malloc(sizeof(Scope));
    if (!scope_stack) {
        fprintf(stderr, "Erro ao alocar escopo global.\n");
        exit(EXIT_FAILURE);
    }
    st_init(&scope_stack->table);
    scope_menor->table.table[0] = NULL; 
    scope_stack->prev = NULL;
}

void scope_push() {
    Scope *new_scope = malloc(sizeof(Scope));
    if (!new_scope) {
        fprintf(stderr, "Erro ao alocar novo escopo.\n");
        exit(EXIT_FAILURE);
    }
    st_init(&new_scope->table);
    new_scope->prev = scope_stack;
    scope_stack = new_scope;
}

void scope_pop() {
    if (scope_stack) {
        Scope *old = scope_stack;
        scope_stack = scope_stack->prev;
        st_free(&old->table);
        free(old);
    } else {
        fprintf(stderr, "[Aviso] Tentativa de desempilhar escopo inexistente.\n");
    }
}

Symbol* scope_insert(const char *name, SymbolKind kind, const char *type, int line, void *value) {
    if (!scope_stack) {
        fprintf(stderr, "Erro: escopo atual não inicializado.\n");
        return NULL;
    }
    return st_insert(&scope_stack->table, name, kind, type, line, value);
}

Symbol* scope_lookup(const char *name) {
    for (Scope *s = scope_stack; s != NULL; s = s->prev) {
        Symbol *found = st_lookup(&s->table, name);
        if (found) return found;
    }
    return NULL;
}

Symbol* scope_lookup_current(const char *name) {
    if (!scope_stack) return NULL;
    return st_lookup(&scope_stack->table, name);
}

void scope_cleanup() {
    while (scope_stack) {
        scope_pop();
    }
}

void scope_print_all() {
    int count = 0;
    for (Scope *s = scope_stack; s != NULL; s = s->prev) {
        count++;
    }

    Scope **scopes = malloc(sizeof(Scope*) * count);
    int i = count - 1;
    for (Scope *s = scope_stack; s != NULL; s = s->prev) {
        scopes[i--] = s;
    }

    for (int j = 0; j < count; j++) {
        printf("==== Escopo %d ====\n", j);
        st_print(&scopes[j]->table);
    }

    free(scopes);
}

