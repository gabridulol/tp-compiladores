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
static char last_type[MAX_NAME_LEN] = "global"; // Tipo do escopo atual

void scope_init(void) {
    capacity    = INITIAL_CAPACITY;
    scope_queue = malloc(sizeof(Scope*) * capacity);
    if (!scope_queue) { perror("malloc scope_queue"); exit(EXIT_FAILURE); }
    queue_top = -1;
    // Cria escopo global
    scope_push(BLOCK_GLOBAL);
}

void scope_push_formula(BlockType block_type, const char *type){
    strncpy(last_type, type, MAX_NAME_LEN);
    scope_push(block_type);
}

void scope_push(BlockType block_type) {
    if (!scope_queue) scope_init();
    if (queue_top + 1 >= capacity) {
        capacity *= 2;
        scope_queue = realloc(scope_queue, sizeof(Scope*) * capacity);
        if (!scope_queue) { perror("realloc scope_queue"); exit(EXIT_FAILURE); }
    }
    Scope *s = malloc(sizeof(Scope));
    if (!s) { perror("malloc Scope"); exit(EXIT_FAILURE); }
    st_init(&s->table);
    s->prev       = scope_atual;
    s->index      = queue_top + 1;
    s->block_type = block_type;
    strncpy(s->type, last_type, MAX_NAME_LEN);
    scope_atual   = s;
    scope_queue[++queue_top] = s;
}

void scope_pop(void) {
    if (!scope_atual) {
        fprintf(stderr, "[Aviso] Nenhum escopo para desempilhar.\n");
        return;
    }
    // Apenas desfaz o escopo atual, sem liberar, para uso posterior em print
    fprintf(stderr, "[DEBUG] Desempilhando escopo %d do tipo %s\n",
           scope_atual->index, BlockTypeNames[scope_atual->block_type]);
    scope_atual = scope_atual->prev;
}

Symbol* scope_insert(const char *name, SymbolKind kind,
                     const char *type, int line, void *value) {
    if (!scope_atual) scope_push(BLOCK_NONE);
    return st_insert(&scope_atual->table, name, kind, type, line, value);
}

Symbol* scope_lookup(const char *name) {
    for (Scope *s = scope_atual; s; s = s->prev) {
        Symbol* sym = st_lookup(&s->table, name);
        if (sym) return sym;
    }
    return NULL;
}

bool scope_allowed(const BlockType allowed[], int count, char *type_redire) {
    if (!scope_atual) {
        fprintf(stderr, "[Erro] Nenhum escopo atual definido.");
        return false;
    }
    // Verifica no escopo atual e nos ancestrais
    for (Scope *s = scope_atual; s; s = s->prev) {
        for (int i = 0; i < count; ++i) {
            if (s->block_type == allowed[i]) {
                printf("\n[DEBUG] Escopo atual (%s) permitido para esta construção.\n", BlockTypeNames[s->block_type]);
                printf("[DEBUG] Escopo numero (%d) é permitido para esta construção.\n", s->index);

                if (s->block_type == BLOCK_FUNCTION) {
                    if (strcmp(type_redire, s->type) == 0) {
                        fprintf(stderr, "[DEBUG] Escopo atual é uma função do tipo '%s'.\n", s->type);
                    }
                    else {
                        fprintf(stderr, "[DEBUG] Escopo atual é uma função do tipo '%s', mas foi redirecionado para '%s'.\n", s->type, type_redire);
                        return false; 
                    }
                }
                return true;
            }
        }
    }

    fprintf(stderr, "[Erro] Escopo atual (%s) não permitido para esta construção.\n", BlockTypeNames[scope_atual->block_type]);
    return false;
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
    const int LINE_WIDTH = 60;

    // Cabeçalho geral
    printf("\n=================================================================\n");
    printf("%*s%s%*s\n",
           (LINE_WIDTH - (int)strlen(" Escopos Registrados "))/2, "",
           " Escopos Registrados ",
           (LINE_WIDTH - (int)strlen(" Escopos Registrados "))/2, "");
    printf("=================================================================\n");

    // Itera sobre cada escopo armazenado
    for (int i = 0; i <= queue_top; ++i) {
        Scope *s = scope_queue[i];
        const char *blockName = BlockTypeNames[s->block_type];
        int parentIdx = s->prev ? s->prev->index : -1;

        // Título do escopo centralizado
        char title[128];
        if (s->block_type == BLOCK_FUNCTION) {
            // Função: inclui tipo da função
            snprintf(title, sizeof(title), " Escopo %d | %s (%s) | Pai: %d ",
                     i, blockName, s->type, parentIdx);
        } else {
            snprintf(title, sizeof(title), " Escopo %d | %s | Pai: %d ",
                     i, blockName, parentIdx);
        }
        int len = strlen(title);
        int pad = (LINE_WIDTH - len) / 2;
        printf("\n\n----------------------------------------------------------------");
        printf("\n");
        for (int j = 0; j < pad; ++j) putchar(' ');
        printf("%s", title);
        printf("\n-----------------------------------------------------------------");
        for (int j = 0; j < LINE_WIDTH - len - pad; ++j) putchar(' ');
        printf("\n");

        // Conteúdo da tabela de símbolos
        st_print(&s->table);
    }

    // Rodapé geral
    printf("\n=================================================================\n");
}



