#include "scope.h"

Scope *scope_stack = NULL;

void scope_init() {
    scope_stack = malloc(sizeof(Scope));
    if (!scope_stack) {
        fprintf(stderr, "Erro ao alocar escopo global.\n");
        exit(EXIT_FAILURE);
    }
    st_init(&scope_stack->table);
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
    Scope *s = scope_stack;
    int level = 0;
    if (!s) {
        printf("Nenhum escopo definido.\n");
        return;
    }
    while (s) {
        printf("==== Escopo %d ====\n", level++);
        st_print(&s->table);
        s = s->prev;
    }
}
