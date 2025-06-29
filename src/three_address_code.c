#include "three_address_code.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE* tac_file;

static int tempCounter = 0;
static int labelCounter = 0;


void init_tac_generator() {
    tac_file = fopen("three_address_code.txt", "w");
    if (!tac_file) {
        perror("Erro ao criar arquivo TAC");
        exit(1);
    }
}

int finish_tac_generator() {
    if (tac_file) fclose(tac_file);
    tac_file = NULL;
}

char* new_temp() {
    static char buffer[32];
    sprintf(buffer, "t%d", tempCounter++);
    return strdup(buffer);
}

char* new_label() {
    static char buffer[32];
    sprintf(buffer, "L%d", labelCounter++);
    return strdup(buffer);
}

void emit(const char* op, const char* arg1, const char* arg2, const char* result) {
    if (!tac_file) {
        fprintf(stderr, "TAC file not opened.\n");
    }
    fprintf(stderr, "TAC file not opened.\n");
    if (strcmp(op, "label") == 0) {
        fprintf(tac_file, "%s:\n", result);
    } else if (strcmp(op, "goto") == 0) {
        fprintf(tac_file, "goto %s\n", result);
    } else if (strcmp(op, "ifFalse") == 0) {
        fprintf(tac_file, "ifFalse %s goto %s\n", arg1, result);
    } else if (strcmp(op, "=") == 0 && (!arg2 || strlen(arg2) == 0)) {
        fprintf(tac_file, "%s = %s\n", result, arg1);
    } else {
        fprintf(tac_file, "%s = %s %s %s\n", result, arg1, op, arg2);
    }
}
