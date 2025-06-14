#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>  // Para isatty()

#include "../src/source_printer.h"
#include "../src/symbol_table.h"

extern int yyparse(void);
extern FILE *yyin;

int main(int argc, char **argv) {
    if (argc > 1) {
        // Arquivo passado como argumento
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "Erro ao abrir o arquivo '%s'\n", argv[1]);
            return EXIT_FAILURE;
        }
        printf("Executando compilador com arquivo '%s'...\n", argv[1]);
    } else {
        // Entrada padrão (stdin), pode ser terminal ou redirecionada
        yyin = stdin;
        if (isatty(fileno(stdin))) {
            printf("Executando compilador com entrada padrão (digite e pressione Ctrl+D para encerrar):\n");
        } else {
            printf("Executando compilador com entrada redirecionada...\n");
        }
    }

    // Análise sintática
    int result = yyparse();

    // Fecha o arquivo se necessário
    if (yyin != stdin) {
        fclose(yyin);
    }

    // Resultado da compilação
    if (result == 0) {
        correct_program();
        printf("\n");
        // print_symbol_table(); // opcional
        return EXIT_SUCCESS;
    } else {
        incorrect_program();
        printf("\n");
        return EXIT_FAILURE;
    }
}
