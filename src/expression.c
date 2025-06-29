#include "expression.h"
#include "../yacc/yacc.tab.h"
#include "symbol_table.h"
#include <math.h>
#include <stdio.h>
#include <string.h>

// Por enquanto, vamos deixar a mais complexa vazia.

const char* get_type_name(int type) {
    switch (type) {
        case TYPE_UNDEFINED: return "UNDEFINED";
        case TYPE_ATOMUS:    return "ATOMUS";     // inteiro
        case TYPE_FRACTIO:   return "FRACTIO";    // float/double
        case TYPE_SYMBOLUM:  return "SYMBOLUM";   // char
        case TYPE_SCRIPTUM:  return "SCRIPTUM";   // string
        case TYPE_QUANTUM:   return "QUANTUM";    // booleano
        case TYPE_POINTER:   return "POINTER";    // ponteiro
        default:             return "UNKNOWN_TYPE";
    }
}

const char* get_op_name(int op) {
    // Mapeia os códigos de operação para seus nomes
    switch (op) {
        case OP_ADD: return "+";   // soma
        case OP_MULTIPLY: return "*";   // multiplicação
        case OP_SUBTRACT: return "-";   // subtração
        case OP_DIVIDE: return "/";   // divisão
        case OP_MODULUS: return "%";   // módulo
        case OP_EXP: return "^";   // exponenciação
        case OP_EQUAL: return "==";  // igualdade
        case OP_NOT_EQUAL: return "!=";  // diferente
        case OP_LESS_THAN: return "<";   // menor que
        case OP_GREATER_THAN: return ">";   // maior que
        case OP_GREATER_EQUAL: return ">=";  // maior ou igual
        case OP_LESS_EQUAL: return "<=";  // menor ou igual
        default:  return "UNKNOWN_OP";
    }
}


Expression* create_expression(DataType type, void* value) {
    Expression* expr = (Expression*)malloc(sizeof(Expression));
    expr->type = type;
    expr->value = value;
    return expr;
}

void free_expression(Expression* expr) {
    if (expr) {
        free(expr->value); // Libera o valor interno
        free(expr);        // Libera a própria estrutura
    }
}

// Converte a string de tipo do seu YACC para o nosso enum
DataType string_to_type(const char* type_str) {
    static const TypeMapEntry map[] = {
        {"atomus", TYPE_ATOMUS},
        {"fractio", TYPE_FRACTIO},
        {"symbolum", TYPE_SYMBOLUM},
        {"scriptum", TYPE_SCRIPTUM},
        {"quantum", TYPE_QUANTUM},
        {"pointer", TYPE_POINTER},
        {NULL, TYPE_UNDEFINED}
    };

    for (int i = 0; map[i].key != NULL; i++) {
        if (strcmp(type_str, map[i].key) == 0) {
            // fprintf(stderr, "[DEBUG] string_to_type: '%s' => %d\n", type_str, map[i].value);
            return map[i].value;
        }
    }

    // fprintf(stderr, "[DEBUG] string_to_type: '%s' => %d (undefined)\n", type_str, TYPE_UNDEFINED);
    return TYPE_UNDEFINED;
}



Expression* evaluate_binary_expression(Expression* left, int op, Expression* right) {
    if (!left || !right) {
        perror("Erro semântico: operando nulo em expressão binária.");
        return NULL;
    }

    // --- Print de Depuração Inicial ---
    // printf("[DEBUG: evaluate_binary] Operação: %d, Tipo da Esquerda: %s (%d), Tipo da Direita: %s (%d)\n",
    //    op,
    //    get_type_name(left->type), left->type,
    //    get_type_name(right->type), right->type);

    // --- 1. Verificação de Tipos ---
    // Por enquanto, exigimos que os tipos sejam idênticos.
    // Uma melhoria futura seria permitir "promoção de tipo" (ex: atomus + fractio).
    if (left->type != right->type) {
        perror("Erro semântico: tipos incompatíveis para operação binária.");
        free_expression(left);
        free_expression(right);
        return NULL;
    }

    DataType result_type = left->type; // O tipo do resultado geralmente é o mesmo dos operandos.
    void* result_value = NULL;         // Ponteiro para o valor calculado.

    // --- 2. Realizar a operação baseada no tipo e no operador ---
    switch (left->type) {
        case TYPE_ATOMUS: {
            int lval = *(int*)left->value;
            int rval = *(int*)right->value;
            // printf("[DEBUG: evaluate_atomus] Left: %d, Op: %s (%d), Right: %d\n",
    //    lval, get_op_name(op), op, rval);

            int* result = malloc(sizeof(int));
            double* fresult = malloc(sizeof(double));
            
            if (!result) { perror("Falha de alocação de memória."); break; }
            if (!fresult) { perror("Falha de alocação de memória."); break; }

            switch (op) {
                // Operadores Aritméticos
                case OP_ADD: *result = lval + rval; result_type = TYPE_ATOMUS; break;
                case OP_SUBTRACT: *result = lval - rval; result_type = TYPE_ATOMUS; break;
                case OP_MULTIPLY: *result = lval * rval; result_type = TYPE_ATOMUS; break;
                case OP_DIVIDE: *fresult = (double)lval / (double)rval; result_type = TYPE_FRACTIO; break;
                case OP_MODULUS: *result = lval % rval; result_type = TYPE_ATOMUS; break;
                case OP_EXP: *result = (int)pow((double)lval, (double)rval); result_type = TYPE_ATOMUS; break;

                // Operadores Relacionais (retornam um booleano/TYPE_QUANTUM)
                case OP_EQUAL: *result = (lval == rval); result_type = TYPE_QUANTUM; break;
                case OP_NOT_EQUAL: *result = (lval != rval); result_type = TYPE_QUANTUM; break;
                case OP_GREATER_THAN: *result = (lval > rval); result_type = TYPE_QUANTUM; break;
                case OP_LESS_THAN: *result = (lval < rval); result_type = TYPE_QUANTUM; break;
                case OP_GREATER_EQUAL: *result = (lval >= rval); result_type = TYPE_QUANTUM; break;
                case OP_LESS_EQUAL: *result = (lval <= rval); result_type = TYPE_QUANTUM; break;

                default:
                    perror("Erro semântico: operador não suportado para o tipo atomus.");
                    free(result);
                    result = NULL;
                    break;
            }
            if (op == OP_DIVIDE){
                result_value = fresult;
            } else {
                result_value = result;
            }
            break;
        }

        case TYPE_FRACTIO: {
            double lval = *(double*)left->value;
            double rval = *(double*)right->value;
            // printf("[DEBUG: evaluate_fractio] Left: %.6f, Op: %s (%d), Right: %.6f\n",
    //    lval, get_op_name(op), op, rval);

            double* result = malloc(sizeof(double));
            int* bool_result = NULL;
            if (!result) { perror("Falha de alocação de memória."); break; }

            switch (op) {
                // Operadores Aritméticos
                case OP_ADD: *result = lval + rval; result_type = TYPE_FRACTIO; break;
                case OP_SUBTRACT: *result = lval - rval; result_type = TYPE_FRACTIO; break;
                case OP_MULTIPLY: *result = lval * rval; result_type = TYPE_FRACTIO; break;
                case OP_DIVIDE: *result = lval / rval; result_type = TYPE_FRACTIO; break;
                case OP_MODULUS: *result = fmod(lval, rval); result_type = TYPE_FRACTIO; break;

                // Operadores Relacionais
                case OP_EQUAL: bool_result = malloc(sizeof(int)); *bool_result = (lval == rval); result_type = TYPE_QUANTUM; break;
                case OP_NOT_EQUAL: bool_result = malloc(sizeof(int)); *bool_result = (lval != rval); result_type = TYPE_QUANTUM; break;
                case OP_GREATER_THAN: bool_result = malloc(sizeof(int)); *bool_result = (lval > rval); result_type = TYPE_QUANTUM; break;
                case OP_LESS_THAN: bool_result = malloc(sizeof(int)); *bool_result = (lval < rval); result_type = TYPE_QUANTUM; break;
                case OP_GREATER_EQUAL: bool_result = malloc(sizeof(int)); *bool_result = (lval >= rval); result_type = TYPE_QUANTUM; break;
                case OP_LESS_EQUAL: bool_result = malloc(sizeof(int)); *bool_result = (lval <= rval); result_type = TYPE_QUANTUM; break;
                default:
                    perror("Erro semântico: operador não suportado para o tipo fractio.");
                    free(result);
                    result = NULL;
                    break;
            }
            // Define o valor do resultado dependendo se foi uma op booleana ou de double
            if (bool_result) {
                result_value = bool_result;
                free(result); // Libera o double não utilizado
            } else {
                result_value = result;
            }
            break;
        }

        default:
            perror("Erro semântico: tipo de dado não suporta operações binárias.");
            break;
    }

    // --- Limpeza dos operandos ---
    // As expressões 'left' e 'right' foram "consumidas" nesta operação,
    // então liberamos a memória que elas ocupavam.
    free_expression(left);
    free_expression(right);

    if (result_value == NULL) {
        // Se result_value for nulo, significa que uma operação falhou.
        return NULL;
    }

    // --- 3. Criar e retornar a nova Expression com o resultado ---
    // printf("[DEBUG: evaluate_binary] Result Type: %s (%d)\n",
    //    get_type_name(result_type), result_type);
    return create_expression(result_type, result_value);
}

void get_base_type_from_pointer(const char* pointer_type, char* base_type_buffer) {
    const char* asterisk_pos = strchr(pointer_type, '*');
    if (asterisk_pos != NULL) {
        size_t length = asterisk_pos - pointer_type;
        strncpy(base_type_buffer, pointer_type, length);
        base_type_buffer[length] = '\0';
    } else {
        // Caso não seja um ponteiro, apenas copia (para segurança)
        strcpy(base_type_buffer, pointer_type);
    }
}


