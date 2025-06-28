#ifndef EXPRESSION_H
#define EXPRESSION_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef enum {
    TYPE_UNDEFINED,
    TYPE_ATOMUS,     // Inteiro
    TYPE_FRACTIO,    // Float/Double
    TYPE_SYMBOLUM,   // Char
    TYPE_SCRIPTUM,   // String
    TYPE_QUANTUM,     // Booleano (verdadeiro/falso)
    TYPE_POINTER     // Tipo ponteiro genérico
} DataType;

typedef struct {
    const char* key;
    DataType value;
} TypeMapEntry;

// Estrutura que representa o resultado de QUALQUER expressão
typedef struct Expression {
    DataType type;  // O tipo do resultado (ex: TYPE_ATOMUS)
    void* value;    // Ponteiro para o valor real (ex: um int*)
} Expression;

const char* get_type_name(int type);
const char* get_op_name(int op);

// Cria uma expressão a partir de um tipo e um valor
Expression* create_expression(DataType type, void* value);

// Libera a memória de uma expressão
void free_expression(Expression* expr);

// A "calculadora" principal: avalia expressões binárias (a + b, a == b, etc.)
Expression* evaluate_binary_expression(Expression* left, int op, Expression* right);

// (Opcional, mas recomendado) Converte uma string de tipo para nosso enum
DataType string_to_type(const char* type_str);

// Extrai o nome do tipo base de um tipo ponteiro (ex: "atomus" de "atomus*")
void get_base_type_from_pointer(const char* pointer_type, char* base_type_buffer);

#endif