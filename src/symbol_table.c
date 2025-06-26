#include "symbol_table.h"
#include <stddef.h>

// Função auxiliar para obter o tamanho em bytes de um tipo
size_t get_size_from_type(const char* type_name) {
    if (strcmp(type_name, "atomus") == 0 || strcmp(type_name, "quantum") == 0 || strcmp(type_name, "minimus") == 0) return sizeof(int);
    if (strcmp(type_name, "magnus") == 0) return sizeof(long);
    if (strcmp(type_name, "fractio") == 0 || strcmp(type_name, "fragmentum") == 0) return sizeof(double);
    if (strcmp(type_name, "symbolum") == 0) return sizeof(char);
    return sizeof(void*);
}

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
    sym->next = table->table[idx];
    sym->field_table = NULL;

    if (kind == SYM_VECTOR) { // Inicializa vetores
        sym->data.vector_info.size = 0; // Tamanho definido depois pelo Yacc
        sym->data.vector_info.data_ptr = NULL; // Ponteiro vai ser alocado no Yacc
    } else {
        sym->data.value = value;
    }

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
    printf("%-20s %-12s %-10s %-5s %-s\n", "Nome", "Tipo Dado", "Classe", "Linha", "Valor/Info");
    for (int i = 0; i < HASH_SIZE; i++) {
        Symbol *curr = table->table[i];
        while (curr) {
            const char *kind_str;
            switch (curr->kind) {
                case SYM_VAR: kind_str = "VAR"; break;
                case SYM_FUNC: kind_str = "FUNC"; break;
                case SYM_TYPE: kind_str = "TYPE"; break;
                case SYM_ENUM: kind_str = "ENUM"; break;
                case SYM_VECTOR: kind_str = "VECTOR"; break;
                default: kind_str = "OUTRO"; break;
            }

            char info_str[256] = "-";

            if (curr->kind == SYM_VECTOR) { //Imprimir vetor e seus valores
                int offset = snprintf(info_str, sizeof(info_str), "[tam: %zu, val: {", curr->data.vector_info.size);
                
                if (curr->data.vector_info.data_ptr != NULL) {
                    void* base_ptr = curr->data.vector_info.data_ptr;
                    size_t element_size = get_size_from_type(curr->type);

                    for (size_t j = 0; j < curr->data.vector_info.size; ++j) {
                        if (offset >= sizeof(info_str) - 20) {
                            offset += snprintf(info_str + offset, sizeof(info_str) - offset, "...");
                            break;
                        }

                        void* element_ptr = (char*)base_ptr + (j * element_size);
                        
                        if (strcmp(curr->type, "atomus") == 0) {
                            offset += snprintf(info_str + offset, sizeof(info_str) - offset, "%d", *(int*)element_ptr);
                        } else if (strcmp(curr->type, "fractio") == 0) {
                            offset += snprintf(info_str + offset, sizeof(info_str) - offset, "%.2f", *(double*)element_ptr);
                        } else if (strcmp(curr->type, "symbolum") == 0) {
                            offset += snprintf(info_str + offset, sizeof(info_str) - offset, "'%c'", *(char*)element_ptr);
                        }
                        if (j < curr->data.vector_info.size - 1) {
                            offset += snprintf(info_str + offset, sizeof(info_str) - offset, ", ");
                        }
                    }
                }
                snprintf(info_str + offset, sizeof(info_str) - offset, "}]");
            } else if (curr->data.value != NULL) { //Imprimir variaveis simples
                if (strcmp(curr->type, "atomus") == 0 || strcmp(curr->type, "magnus") == 0 || strcmp(curr->type, "minimus") == 0) {
                    snprintf(info_str, sizeof(info_str), "%d", *(int*)curr->data.value);
                } else if (strcmp(curr->type, "fractio") == 0 || strcmp(curr->type, "fragmentum") == 0) {
                    snprintf(info_str, sizeof(info_str), "%f", *(double*)curr->data.value);
                } else if (strcmp(curr->type, "quantum") == 0) {
                    snprintf(info_str, sizeof(info_str), "%s", (*(int*)curr->data.value) ? "Factum" : "Fictum");
                } else if (strcmp(curr->type, "symbolum") == 0) {
                    snprintf(info_str, sizeof(info_str), "'%c'", *(char*)curr->data.value);
                } else if (strcmp(curr->type, "scriptum") == 0) {
                    snprintf(info_str, sizeof(info_str), "\"%s\"", (char*)curr->data.value);
                } else {
                    snprintf(info_str, sizeof(info_str), "%p", curr->data.value);
                }
            }

            printf("%-20s %-12s %-10s %-5d %-20s\n",
                   curr->name, curr->type, kind_str, curr->line_declared, info_str);
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
            if (tmp->kind == SYM_VECTOR && tmp->data.vector_info.data_ptr != NULL) { //Libera memoria dos dados do vetor
                free(tmp->data.vector_info.data_ptr);
            } 
            free(tmp);
        }
        table->table[i] = NULL;
    }
}