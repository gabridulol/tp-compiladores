#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>  // Para isatty()

#include "../src/source_printer.h"
#include "../src/scope.h"  // novo!

extern int yyparse(void);
extern FILE *yyin;

int main(int argc, char **argv) {
    scope_init(); // inicializa escopo global

    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "Erro ao abrir o arquivo '%s'\n", argv[1]);
            return EXIT_FAILURE;
        }
        printf("Executando compilador com arquivo '%s'...\n", argv[1]);
    } else {
        yyin = stdin;
        if (isatty(fileno(stdin))) {
            printf("Executando compilador com entrada padrão (digite e pressione Ctrl+D para encerrar):\n");
        } else {
            printf("Executando compilador com entrada redirecionada...\n");
        }
    }

    // Executa a análise sintática
    int result = yyparse();

    if (yyin != stdin) {
        fclose(yyin);
    }

    // Imprime resultado final
    if (result == 0) {
        correct_program();
    } else {
        incorrect_program();
    }

    // Libera todos os escopos da pilha
    scope_cleanup();

    printf("\n");
    return (result == 0) ? EXIT_SUCCESS : EXIT_FAILURE;
}
