#include "symbol_table.h"

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
    printf("%-20s %-12s %-10s %-5s %-20s\n", "Nome", "Tipo Dado", "Classe", "Linha", "Valor");
    for (int i = 0; i < HASH_SIZE; i++) {
        Symbol *curr = table->table[i];
        while (curr) {
            const char *kind_str =
                (curr->kind == SYM_VAR)  ? "VAR"  :
                (curr->kind == SYM_FUNC) ? "FUNC" :
                (curr->kind == SYM_TYPE) ? "TYPE" : 
                (curr->kind == SYM_ENUM) ? "ENUM" : "OUTRO";

            char valor_str[64] = "-";
            if (curr->value != NULL) {
                if (
                    strcmp(curr->type, "atomus") == 0 ||
                    strcmp(curr->type, "magnus") == 0 ||
                    strcmp(curr->type, "minimus") == 0
                ) {
                    snprintf(valor_str, sizeof(valor_str), "%d", curr->value ? *(int*)curr->value : 0);
                } else if (
                    strcmp(curr->type, "fractio") == 0 ||
                    strcmp(curr->type, "fragmentum") == 0
                ) {
                    snprintf(valor_str, sizeof(valor_str), "%f", curr->value ? *(float*)curr->value : 0.0f);
                } else if (strcmp(curr->type, "quantum") == 0) {
                    snprintf(valor_str, sizeof(valor_str), "%s", (*(int*)curr->value) ? "factum" : "fictum");
                } else if (strcmp(curr->type, "symbolum") == 0) {
                    snprintf(valor_str, sizeof(valor_str), "'%c'", curr->value ? *(char*)curr->value : ' ');
                } else if (strcmp(curr->type, "scriptum") == 0) {
                    snprintf(valor_str, sizeof(valor_str), "%s", (char*)curr->value ? (char*)curr->value : "-");
                } else {
                    snprintf(valor_str, sizeof(valor_str), "%p", curr->value);
                }
            }

            printf("%-20s %-12s %-10s %-5d %-20s\n",
                   curr->name, curr->type, kind_str, curr->line_declared, valor_str);
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