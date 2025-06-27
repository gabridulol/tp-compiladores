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
    SYM_TYPE,
    SYM_ENUM,
    SYM_VECTOR
    // Adicione outros tipos conforme necessário
} SymbolKind;

struct FieldTable; // Forward declaration

typedef struct Symbol {
    char name[MAX_NAME_LEN];
    SymbolKind kind;
    char type[MAX_NAME_LEN]; // Ex: "atomus", "fractio", etc.
    int line_declared;
    struct Symbol *next; // Para colisões (encadeamento)
    struct FieldTable *field_table;
    struct SymbolTable *instance_fields;
    
    union { //Armazena o value para variaveis simples, ou a struct para vetores
        void* value; //Valor de variaveis simples
        struct {
            size_t size; // Tamanho do vetor.
            void* data_ptr; // Ponteiro para a memória alocada para o primeiro elemento do vetor.
        } vector_info;
    } data;

} Symbol;

typedef struct SymbolTable {
    Symbol *table[HASH_SIZE];
} SymbolTable;

typedef struct FieldTable {
    SymbolTable fields;
} FieldTable;

// Funções da tabela
void st_init(SymbolTable *table);
Symbol* st_insert(SymbolTable *table, const char *name, SymbolKind kind, const char *type, int line, void *value);
Symbol* st_lookup(SymbolTable *table, const char *name);
void st_print(SymbolTable *table);
void st_free(SymbolTable *table);
size_t get_size_from_type(const char* type_name);

#endif // SYMBOL_TABLE_H