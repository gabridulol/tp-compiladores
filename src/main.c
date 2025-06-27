#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>           // Para isatty()

#include "../src/source_printer.h"
#include "../src/symbol_table.h"  // declara st_print(), etc. :contentReference[oaicite:0]{index=0}
#include "../src/scope.h"         // declara scope_init(), scope_cleanup(), current_scope :contentReference[oaicite:1]{index=1}

extern int yyparse(void);
extern FILE *yyin;
extern int yydebug;

int main(int argc, char **argv) {
    /* 1. Inicializa escopo global */
    scope_init();
        //yydebug = 1;

    /* 2. Abre o arquivo ou stdin */
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
            printf("Executando compilador com entrada padrão (Ctrl+D para encerrar):\n");
        } else {
            printf("Executando compilador com entrada redirecionada...\n");
        }
    }

    /* 3. Chama o parser */
    int result = yyparse();

    /* 4. Fecha o arquivo se não for stdin */
    if (yyin != stdin) {
        fclose(yyin);
    }

    /* 5. Imprime estado de compilação */
    if (result == 0) {
        correct_program();
        printf("\n");
    } else {
        incorrect_program();
        printf("\n");
    }

    /* 6. Imprime a tabela de símbolos do escopo corrente */
    scope_print_all();

    /* 7. Libera todos os escopos e tabelas alocadas */
    scope_cleanup();

    return (result == 0) ? EXIT_SUCCESS : EXIT_FAILURE;
}
