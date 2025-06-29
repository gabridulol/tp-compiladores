#include <stdio.h> // Necessário para FILE*


void init_tac_generator();
int finish_tac_generator();
char* new_temp();
char* new_label();
void emit(const char* op, const char* arg1, const char* arg2, const char* result);