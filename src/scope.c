#include "scope.h"
#include "symbol_table.h"
#include <stdio.h>
#include <stdlib.h>

#define INITIAL_CAPACITY 8

// Fila de escopos: histórico de criação (para print final)
static Scope **scope_queue = NULL;
static int      capacity    = 0;
static int      queue_top   = -1;

// Ponteiro para o escopo atual (inserções e chain parent)
static Scope *scope_atual = NULL;

void scope_init(void) {
    capacity    = INITIAL_CAPACITY;
    scope_queue = malloc(sizeof(Scope*) * capacity);
    if (!scope_queue) { perror("malloc scope_queue"); exit(EXIT_FAILURE); }
    queue_top = -1;
    // Cria escopo global
    scope_push();
}

void scope_push(void) {
    if (!scope_queue) scope_init();
    // Cria novo escopo
    Scope *s = malloc(sizeof(Scope));
    if (!s) { perror("malloc Scope"); exit(EXIT_FAILURE); }
    st_init(&s->table);
    // Define parent para árvore de escopos
    s->prev = scope_atual;
    // Atualiza escopo atual
    scope_atual = s;
    // Registra no histórico
    if (queue_top + 1 >= capacity) {
        capacity *= 2;
        scope_queue = realloc(scope_queue, sizeof(Scope*) * capacity);
        if (!scope_queue) { perror("realloc scope_queue"); exit(EXIT_FAILURE); }
    }
    scope_queue[++queue_top] = s;
}

void scope_pop(void) {
    if (!scope_atual) {
        fprintf(stderr, "[Aviso] Nenhum escopo para desempilhar.\n");
        return;
    }
    // Apenas desfaz o escopo atual, sem liberar, para uso posterior em print
    scope_atual = scope_atual->prev;
}

Symbol* scope_insert(const char *name, SymbolKind kind,
                     const char *type, int line, void *value) {
    if (!scope_atual) scope_push();
    return st_insert(&scope_atual->table, name, kind, type, line, value);
}

Symbol* scope_lookup(const char *name) {
    for (Scope *s = scope_atual; s; s = s->prev) {
        Symbol* sym = st_lookup(&s->table, name);
        if (sym) return sym;
    }
    return NULL;
}

Symbol* scope_lookup_current(const char *name) {
    if (!scope_atual) return NULL;
    return st_lookup(&scope_atual->table, name);
}

void scope_cleanup(void) {
    // Libera todos os escopos do histórico
    for (int i = 0; i <= queue_top; ++i) {
        Scope *s = scope_queue[i];
        st_free(&s->table);
        free(s);
    }
    free(scope_queue);
    scope_queue = NULL;
    capacity    = 0;
    queue_top   = -1;
    scope_atual = NULL;
}

void scope_print_all(void) {
    // Imprime todos os escopos na ordem de criação
    for (int i = 0; i <= queue_top; ++i) {
        printf("==== Escopo %d (parent=%p) ====\n",
               i, (void*)scope_queue[i]->prev);
        st_print(&scope_queue[i]->table);
    }
}
