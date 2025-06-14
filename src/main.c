#include <stdio.h>
#include <stdlib.h>

extern int yyparse(void);
extern FILE *yyin;

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "Erro ao abrir o arquivo '%s'\n", argv[1]);
            return EXIT_FAILURE;
        }
        printf("Executando compilador com arquivo '%s'...\n", argv[1]);
    } else {
        printf("Executando compilador com entrada padrão (digite e pressione Ctrl+D para encerrar):\n");
        yyin = stdin;
    }

    int result = yyparse();

    if (result == 0) {
        // Mensagem de sucesso já é emitida no parser (translation_unit)
        return EXIT_SUCCESS;
    } else {
        // Mensagem de erro já foi emitida por yyerror
        return EXIT_FAILURE;
    }
}
