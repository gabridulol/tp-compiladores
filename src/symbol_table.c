#include "symbol_table.h"
#include <stddef.h>

// Função auxiliar para obter o tamanho em bytes de um tipo
size_t get_size_from_type(const char* type_name) {
    if (!type_name) return sizeof(void*);
    if (strcmp(type_name, "atomus") == 0 || strcmp(type_name, "quantum") == 0) return sizeof(int);
    if (strcmp(type_name, "fractio") == 0) return sizeof(double);
    if (strcmp(type_name, "symbolum") == 0) return sizeof(char);
    return sizeof(void*);
}

// hash djb2
static unsigned int hash(const char *str) {
    unsigned int h = 5381;
    int c;
    while ((c = *str++)) h = ((h << 5) + h) + c;
    return h % HASH_SIZE;
}

void st_init(SymbolTable *table) {
    for (int i = 0; i < HASH_SIZE; i++) table->table[i] = NULL;
}

Symbol* st_insert(SymbolTable *table, const char *name,
                  SymbolKind kind, const char *type,
                  int line, void *value) {
    unsigned idx = hash(name);
    // Verifica duplicata
    for (Symbol *c = table->table[idx]; c; c = c->next) {
        if (strcmp(c->name, name) == 0) return NULL;
    }
    Symbol *s = malloc(sizeof(Symbol));
    strcpy(s->name, name);
    strcpy(s->type, type);
    s->kind = kind;
    s->line_declared = line;
    s->data.value = (kind == SYM_VECTOR) ? NULL : value;
    if (kind == SYM_VECTOR) {
        s->data.vector_info.size = 0;
        s->data.vector_info.data_ptr = NULL;
    }
    s->next = table->table[idx];
    table->table[idx] = s;
    return s;
}

Symbol* st_lookup(SymbolTable *table, const char *name) {
    unsigned idx = hash(name);
    for (Symbol *c = table->table[idx]; c; c = c->next) {
        if (strcmp(c->name, name) == 0) return c;
    }
    return NULL;
}

void st_print(SymbolTable *table) {
    // Cabeçalho da tabela
    printf(" %-20s | %-10s | %-7s | %-5s | %s\n",
           "Nome", "Tipo", "Classe", "Linha", "Valor/Info");
    printf("-%-20s-+-%-10s-+-%-7s-+-%-5s-+-%s\n",
           "--------------------", "----------", "-------", "-----", "----------");

    // Itera sobre cada bucket do hash
    for (int i = 0; i < HASH_SIZE; i++) {
        for (Symbol *c = table->table[i]; c; c = c->next) {
            // Mapeia a classe para string
            const char *cls;
            switch (c->kind) {
                case SYM_VAR:    cls = "VAR";    break;
                case SYM_FUNC:   cls = "FUNC";   break;
                case SYM_TYPE:   cls = "TYPE";   break;
                case SYM_ENUM:   cls = "ENUM";   break;
                case SYM_VECTOR: cls = "VECTOR"; break;
                default:         cls = "OUTRO";  break;
            }

            // Formata o campo de informação (valor ou tamanho)
            char info[128] = "";
            if (c->kind == SYM_VECTOR) {
                snprintf(info, sizeof(info), "[tam: %zu]", c->data.vector_info.size);
            } else if (c->data.value) {
                if (strcmp(c->type, "atomus") == 0) {
                    snprintf(info, sizeof(info), "%d", *(int*)c->data.value);
                } else if (strcmp(c->type, "fractio") == 0) {
                    snprintf(info, sizeof(info), "%.2f", *(double*)c->data.value);
                } else if (strcmp(c->type, "symbolum") == 0) {
                    snprintf(info, sizeof(info), "'%c'", *(char*)c->data.value);
                }
            }

            // Linha formatada
            printf(" %-20s | %-10s | %-7s | %-5d | %s\n",
                   c->name,
                   c->type,
                   cls,
                   c->line_declared,
                   info);
        }
    }
}


void st_free(SymbolTable *table) {
    for (int i = 0; i < HASH_SIZE; i++) {
        Symbol *c = table->table[i];
        while (c) {
            Symbol *t = c;
            c = c->next;
            if (t->kind == SYM_VECTOR && t->data.vector_info.data_ptr)
                free(t->data.vector_info.data_ptr);
            free(t);
        }
        table->table[i] = NULL;
    }
}
