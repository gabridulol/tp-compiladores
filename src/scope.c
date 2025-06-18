#include "scope.h"

Scope *current_scope = NULL;

void scope_init() {
    current_scope = malloc(sizeof(Scope));
    st_init(&current_scope->table);
    current_scope->prev = NULL;
}

void scope_push() {
    Scope *new_scope = malloc(sizeof(Scope));
    st_init(&new_scope->table);
    new_scope->prev = current_scope;
    current_scope = new_scope;
}

void scope_pop() {
    if (current_scope) {
        Scope *old = current_scope;
        current_scope = current_scope->prev;
        st_free(&old->table);
        free(old);
    }
}

Symbol* scope_insert(const char *name, SymbolKind kind, const char *type, int line, void *value) {
    return st_insert(&current_scope->table, name, kind, type, line, value);
}

Symbol* scope_lookup(const char *name) {
    Scope *s = current_scope;
    while (s) {
        Symbol *found = st_lookup(&s->table, name);
        if (found) return found;
        s = s->prev;
    }
    return NULL;
}

Symbol* scope_lookup_current(const char *name) {
    return st_lookup(&current_scope->table, name);
}

void scope_cleanup() {
    while (current_scope) {
        scope_pop();
    }
}