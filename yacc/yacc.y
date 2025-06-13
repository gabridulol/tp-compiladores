%{
#include <stdio.h>
#include <stdlib.h> 
#include <string.h>
#include "../src/symbol_table.h" 

// Se você modularizar, inclua os headers aqui:
// #include "symbol_table.h"
// #include "type_system.h"
// #include "ast.h"

extern FILE *yyin;         // <- Adicione esta linha
// extern int yylex(void); // (já deve existir ou ser implícita)
// void yyerror(const char *s); // protótipo já deve estar declarado

extern int yylineno;       // Linha gerenciada pelo Flex

// Protótipo da função do lexer
int yylex(void);
// Protótipo da função de erro do parser
void yyerror(const char *s);

// Variável global para o número da linha (geralmente gerenciada pelo Lex/Flex)
extern int yylineno;

SymbolTable st_global;
%}

/* ===== Definição da União de Valores yylval ===== */
// Define os tipos de dados que os tokens e não-terminais podem carregar.
// Estes campos devem corresponder ao uso de yylval no seu arquivo .l
%union {
    int val_int;
    double val_float; 
    char *str;
}

/* ===== Declaração dos Tokens (Terminais) ===== */
// Tokens que carregam valores (associados à %union)
%token <str> IDENTIFIER LIT_STRING LIT_CHAR
%token <val_int> LIT_INT
%token <val_float> LIT_FLOAT // LIT_FLOAT do lex.txt

%type <str> primario expressao
%type <str> tipo nome_tipo_base


// Palavras-chave (não carregam valor intrínseco além do seu tipo de token)
%token KW_SI KW_NON KW_ITERARE KW_PERSISTO KW_VERTERE KW_CASUS KW_AXIOM
%token KW_RUPTIO KW_CONTINUUM KW_REDIRE KW_MOL KW_HOMUNCULUS KW_ENUMERARE
%token KW_DESIGNARE KW_FORMULA KW_REVELARE KW_LECTURA KW_MAGNITUDO
%token KW_ET KW_VEL KW_NE KW_AUT

// Tipos Primitivos
%token TYPE_VACUUM TYPE_ATOMUS TYPE_FRAGMENTUM TYPE_FRACTIO TYPE_QUANTUM
%token TYPE_MAGNUS TYPE_MINIMUS TYPE_SYMBOLUM TYPE_SCRIPTUM

// Literais Booleanos
%token LIT_FACTUM LIT_FICTUM

// Operadores e Delimitadores (maioria não carrega valor)
%token OP_ARROW_ASSIGN        // -->
%token OP_DEREF_POINTER       // °
%token OP_ADDR_OF             // £
%token OP_LSHIFT_ARRAY        // <<
%token OP_RSHIFT_ARRAY        // >>
%token OP_ACCESS_MEMBER       // .
%token OP_ACCESS_POINTER      // ==>
%token OP_EXP                 // **
%token OP_INTEGER_DIVIDE      // //
%token OP_ADD                 // +
%token OP_SUBTRACT            // -
%token OP_MULTIPLY            // *
%token OP_DIVIDE              // /
%token OP_MODULUS             // %
%token OP_EQUAL               // ==
%token OP_NOT_EQUAL           // !=
%token OP_GREATER_THAN        // >
%token OP_LESS_THAN           // <
%token OP_GREATER_EQUAL       // >=
%token OP_LESS_EQUAL          // <=
%token OP_LOGICAL_AND         // &&
%token OP_LOGICAL_OR          // ||
%token OP_LOGICAL_NOT         // !
%token OP_LOGICAL_XOR         // ^
%token LBRACE                 // {
%token RBRACE                 // }
%token SEMICOLON              // ;
%token LPAREN                 // (
%token RPAREN                 // )
%token PIPE                   // |
%token COLON          // -> (para casus)


/* ===== Associatividade e Precedência de Operadores ===== */
// Da MENOR para a MAIOR precedência

%right OP_ARROW_ASSIGN       // Sua atribuição "-->"

%left  KW_VEL OP_LOGICAL_OR  // "vel" ou "||"
%left  KW_ET OP_LOGICAL_AND   // "et" ou "&&"
%left  KW_AUT OP_LOGICAL_XOR  // "aut" ou "^"

// Operadores relacionais são geralmente não associativos para evitar a == b == c
%nonassoc OP_EQUAL OP_NOT_EQUAL
%nonassoc OP_LESS_THAN OP_GREATER_THAN OP_LESS_EQUAL OP_GREATER_EQUAL

%left  OP_ADD OP_SUBTRACT
%left  OP_MULTIPLY OP_DIVIDE OP_MODULUS OP_INTEGER_DIVIDE

%right OP_EXP                // Exponenciação "**"

// Para os operadores unários de prefixo e o type cast, vamos definir um nível de precedência
// usando um "token fictício". Chamaremos este nível de 'PREC_UNARY_PREFIX'.
// A associatividade (left/right) para tokens de precedência unária não é tão crítica,
// mas 'right' é comum para operadores de prefixo.
%right PREC_UNARY_PREFIX

// Os operadores pós-fixos ('.', '==>', '£', '<< >>') têm sua precedência
// naturalmente definida pela estrutura da gramática (sendo aplicados a 'primario').
// Se surgirem conflitos de shift/reduce, pode ser necessário declará-los aqui
// com uma precedência ainda maior que PREC_UNARY_PREFIX.
// Ex: %left OP_ACCESS_MEMBER OP_ACCESS_POINTER OP_ADDR_OF OP_LSHIFT_ARRAY

// Operadores unários (prefixo) têm alta precedência
%precedence OP_LOGICAL_NOT KW_NE OP_DEREF_POINTER UNARY_MINUS // UNARY_MINUS é um token fictício para precedência do '-' unário
// Operadores pós-fixos (como '£', '.', '==>', '<< >>') têm precedência ainda maior
%precedence OP_ADDR_OF OP_ACCESS_MEMBER OP_ACCESS_POINTER OP_LSHIFT_ARRAY OP_RSHIFT_ARRAY


/* ===== Símbolo Inicial da Gramática ===== */
%start programa

%%
/* ===== Seção de Regras da Gramática ===== */

// ### Estrutura Geral ###
programa: 
        | programa_nao_vazio
        ;

programa_nao_vazio: declaracao_ou_comando
                  | programa_nao_vazio declaracao_ou_comando
                  ;

declaracao_ou_comando: declaracao { printf("\033[1;32mDeclaração reconhecida.\033[0m\n"); }
                     | comando    { printf("\033[1;32mComando reconhecido.\033[0m\n"); }
                     ;

// ### Declarações ###
declaracao: declaracao_variavel
          | declaracao_funcao
          | declaracao_tipo
          | declaracao_designacao
          ;

declaracao_tipo: declaracao_homunculus
               | declaracao_enumeracao
               ;
/* me ajude a formatar com verde nas mensagens corretas */
declaracao_homunculus: IDENTIFIER LBRACE corpo_homunculus RBRACE KW_HOMUNCULUS SEMICOLON {
            if (st_lookup(&st_global, $1) != NULL) {
                yyerror("Tipo já declarado!");
            } else {
                st_insert(&st_global, $1, SYM_TYPE, "homunculus", yylineno, NULL);
                printf("\033[1;32mDeclaração Homunculus: %s\033[0m\n", $1);
            }
            free($1);
}
                    ;
corpo_homunculus: 
                | corpo_homunculus declaracao_variavel
                ;

declaracao_enumeracao: IDENTIFIER LBRACE lista_enum_ident RBRACE KW_ENUMERARE SEMICOLON
                    { printf("\033[1;32mDeclaração Enumerare para %s\033[0m\n", $1); /* Ação: Registrar enum $1 com identificadores $3 */ free($1); }
                    ;
lista_enum_ident: IDENTIFIER { free($1); }
                | lista_enum_ident PIPE IDENTIFIER { free($3); }
                ;

declaracao_designacao: tipo IDENTIFIER KW_DESIGNARE SEMICOLON
                    { printf("\033[1;32mDesignare (typedef): %s\033[0m\n", $2); /* Ação: Registrar typedef: $2 é um alias para $1 */ free($2); }
                    ;
declaracao_variavel: IDENTIFIER tipo SEMICOLON
                    {
                        if (st_lookup(&st_global, $1) != NULL) {
                            yyerror("Variável já declarada!");
                        } else {
                            st_insert(&st_global, $1, SYM_VAR, $2, yylineno, NULL);
                            printf("\033[1;32mDeclaração de Variável: %s\033[0m\n", $1);
                        }
                        free($1);
                    }
                   | KW_MOL IDENTIFIER tipo SEMICOLON
                    {
                        if (st_lookup(&st_global, $2) != NULL) {
                            yyerror("Constante já declarada!");
                        } else {
                            st_insert(&st_global, $2, SYM_VAR, $3, yylineno, NULL); // Ou SYM_CONST se criar esse tipo
                            printf("\033[1;32mDeclaração de Constante (mol): %s\033[0m\n", $2);
                        }
                        free($2);
                    }
                   | IDENTIFIER tipo OP_ARROW_ASSIGN expressao SEMICOLON
                    {
                        if (st_lookup(&st_global, $1) != NULL) {
                            yyerror("Variável já declarada!");
                        } else {
                            st_insert(&st_global, $1, SYM_VAR, $2, yylineno, $4);
                            printf("\033[1;32mDeclaração de Variável com Inicialização: %s\033[0m\n", $1);
                        }
                        free($1);
                    }
                   | KW_MOL IDENTIFIER tipo OP_ARROW_ASSIGN expressao SEMICOLON
                    {
                        if (st_lookup(&st_global, $2) != NULL) {
                            yyerror("Constante já declarada!");
                        } else {
                            st_insert(&st_global, $2, SYM_VAR, $3, yylineno, $5); // Ou SYM_CONST se criar esse tipo
                            printf("\033[1;32mDeclaração de Constante (mol) com Inicialização: %s\033[0m\n", $2);
                        }
                        free($2);
                    }
                   ;

declaracao_funcao: KW_FORMULA LPAREN lista_parametros_opt RPAREN IDENTIFIER OP_ARROW_ASSIGN tipo LBRACE programa RBRACE
                {
                    if (st_lookup(&st_global, $5) != NULL) {
                        yyerror("Função já declarada!");
                    } else {
                        st_insert(&st_global, $5, SYM_FUNC, $7, yylineno, NULL);
                        printf("\033[1;32mDeclaração de Função (formula): %s\033[0m\n", $5);
                    }
                    free($5);
                }
                ;
lista_parametros_opt: 
                    | lista_parametros
                    ;

// ### Tipos ###
tipo: nome_tipo_base
    | tipo OP_DEREF_POINTER
    | tipo OP_LSHIFT_ARRAY expressao_opt OP_RSHIFT_ARRAY
    ;
expressao_opt: 
             | expressao
             ;

nome_tipo_base: TYPE_VACUUM
              | TYPE_ATOMUS
              | TYPE_FRAGMENTUM
              | TYPE_FRACTIO
              | TYPE_QUANTUM
              | TYPE_MAGNUS
              | TYPE_MINIMUS
              | TYPE_SYMBOLUM
              | TYPE_SCRIPTUM
              | IDENTIFIER      { printf("\033[1;32mTipo definido pelo usuário (homunculus/designare): %s\033[0m\n", $1); /* Ação: $1 é um nome de tipo */ free($1); }
              ;

lista_parametros: parametro
                | lista_parametros PIPE parametro
                ;
parametro: IDENTIFIER tipo
            {
                if (st_lookup(&st_global, $1) != NULL) {
                    yyerror("Parâmetro já declarado!");
                } else {
                    st_insert(&st_global, $1, SYM_VAR, $2, yylineno, NULL); // Ou SYM_PARAM se criar esse tipo
                    printf("\033[1;32mParâmetro: %s\033[0m\n", $1);
                }
                free($1);
            }
            ;

// ### Comandos ###
comando: comando_condicional
       | comando_repeticao
       | chamada_funcao_atribuicao SEMICOLON
       | comando_iteracao
       | comando_selecao
       | comando_retorno SEMICOLON
       | comando_atribuicao SEMICOLON
       | chamada_funcao SEMICOLON
       | expressao SEMICOLON  // Expressão isolada
       { printf("\033[1;32mExpressão isolada reconhecida.\033[0m\n"); }
       | comando_ruptio
       | comando_continuum
       | comando_leitura
       | comando_revelacao
       | LBRACE programa RBRACE    // Bloco de escopo
       | SEMICOLON                 // Comando vazio
       ;

comando_atribuicao: expressao OP_ARROW_ASSIGN expressao_posfixa // expressao_posfixa deve ser um L-value
                  { printf("\033[1;32mComando de Atribuição (-->)\033[0m\n"); /* Ação: Atribuir $1 a $3. Verificar tipos. */ }
                  ;

chamada_funcao_atribuicao: LPAREN expressao RPAREN IDENTIFIER OP_ARROW_ASSIGN IDENTIFIER
                         { printf("\033[1;32mChamada de Função com Atribuição: %s --> %s\033[0m\n", $4, $6); free($4); free($6); }
                         ;

comando_condicional: LPAREN expressao RPAREN KW_SI comando non_opt
                  ;
non_opt: 
       | KW_NON comando
       ;

comando_repeticao: LPAREN expressao RPAREN KW_PERSISTO comando
                ;

comando_iteracao: LPAREN comando_atribuicao_opt SEMICOLON expressao_opt SEMICOLON expressao_opt RPAREN KW_ITERARE comando
                ;
comando_atribuicao_opt: 
                      | comando_atribuicao // Note: atribuição aqui não tem ';'
                      ;

comando_selecao: LPAREN expressao RPAREN KW_VERTERE LBRACE casos_lista caso_padrao_opt RBRACE
              ;
casos_lista: 
           | casos_lista caso
           ;
caso: KW_CASUS expressao COLON comandos_bloco
    ;
comandos_bloco: comando // Um único comando
              | LBRACE programa RBRACE // Um bloco de comandos
              ;
caso_padrao_opt: 
               | KW_AXIOM COLON comandos_bloco
               ;

comando_retorno: expressao_opt KW_REDIRE
                ;

comando_ruptio: KW_RUPTIO SEMICOLON ;
comando_continuum: KW_CONTINUUM SEMICOLON ;

comando_leitura: LPAREN expressao_posfixa RPAREN KW_LECTURA SEMICOLON // 'lectura' espera um L-value (ex: variável)
                ;
                
comando_revelacao: OP_LSHIFT_ARRAY expressao OP_RSHIFT_ARRAY KW_REVELARE SEMICOLON
                 { printf("\033[1;32mComando de Revelação\033[0m\n"); }
                 ;

// ### Expressões (Hierarquia de Operadores) ###
expressao: expressao_logica_vel
          ;

expressao_logica_vel: expressao_logica_et
                    | expressao_logica_vel KW_VEL expressao_logica_et
                    | expressao_logica_vel OP_LOGICAL_OR expressao_logica_et
                    ;

expressao_logica_et: expressao_xor
                   | expressao_logica_et KW_ET expressao_xor
                   | expressao_logica_et OP_LOGICAL_AND expressao_xor
                   ;

expressao_xor: expressao_relacional
             | expressao_xor KW_AUT expressao_relacional
             | expressao_xor OP_LOGICAL_XOR expressao_relacional
             ;

expressao_relacional: expressao_aritmetica
                    | expressao_relacional OP_EQUAL expressao_aritmetica
                    | expressao_relacional OP_NOT_EQUAL expressao_aritmetica
                    | expressao_relacional OP_LESS_THAN expressao_aritmetica
                    | expressao_relacional OP_GREATER_THAN expressao_aritmetica
                    | expressao_relacional OP_LESS_EQUAL expressao_aritmetica
                    | expressao_relacional OP_GREATER_EQUAL expressao_aritmetica
                    ;

expressao_aritmetica: termo
                    | expressao_aritmetica OP_ADD termo
                    | expressao_aritmetica OP_SUBTRACT termo
                    ;

termo: fator_exponencial
     | termo OP_MULTIPLY fator_exponencial
     | termo OP_DIVIDE fator_exponencial
     | termo OP_MODULUS fator_exponencial
     | termo OP_INTEGER_DIVIDE fator_exponencial
     ;

fator_exponencial: expressao_posfixa
                 | expressao_posfixa OP_EXP fator_exponencial
                 ;

fator: LPAREN tipo RPAREN fator %prec PREC_UNARY_PREFIX // Type Cast
     | expressao_posfixa
     | OP_DEREF_POINTER fator %prec PREC_UNARY_PREFIX // Dereferência '°'
     | KW_NE fator            %prec PREC_UNARY_PREFIX // Negação lógica 'ne'
     | OP_LOGICAL_NOT fator   %prec PREC_UNARY_PREFIX // Negação lógica '!'
     | OP_SUBTRACT fator      %prec PREC_UNARY_PREFIX // Negação aritmética '-'
     ;

expressao_posfixa: primario
                 | expressao_posfixa OP_ACCESS_MEMBER IDENTIFIER { free($3); }
                 | expressao_posfixa OP_ACCESS_POINTER IDENTIFIER { free($3); }
                 | expressao_posfixa OP_ADDR_OF
                 | expressao_posfixa OP_LSHIFT_ARRAY expressao OP_RSHIFT_ARRAY
                 ;

primario: IDENTIFIER                { /* Ação: Referenciar $1 na tabela de símbolos */ $$ = $1; }
        | LIT_INT                   { /* Ação: Converter inteiro em string ou nó de AST */ $$ = NULL; }
        | LIT_FLOAT                 { $$ = NULL; }
        | LIT_STRING                { $$ = $1; }
        | LIT_FACTUM                { $$ = NULL; }
        | LIT_FICTUM                { $$ = NULL; }
        | LPAREN expressao RPAREN   { $$ = $2; }
        | chamada_funcao
        | expressao_magnitudo
        ;

expressao_magnitudo: KW_MAGNITUDO LPAREN tipo RPAREN
                   | KW_MAGNITUDO LPAREN expressao RPAREN
                   ;

chamada_funcao: LPAREN expressao RPAREN IDENTIFIER
              { printf("\033[1;32mChamada de Função: %s\033[0m\n", $4); free($4); }
              ;

lista_argumentos_opt: 
                    | lista_argumentos
                    ;

lista_argumentos: expressao
                | lista_argumentos PIPE expressao
                ;

%%

int main(int argc, char *argv[]) {
    st_init(&st_global);
    
    if (argc > 1) {
        FILE *inputFile = fopen(argv[1], "r");
        if (!inputFile) {
            perror(argv[1]);
            return 1;
        }
        yyin = inputFile; // Define a entrada do lexer para o arquivo
    } else {
        printf("\033[1;32mLendo da entrada padrão (Ctrl+D para finalizar):\033[0m\n");
        yyin = stdin; // Entrada padrão se nenhum arquivo for fornecido
    }

    printf("\033[1;32m--- Iniciando Análise ---\033[0m\n");
    int result = yyparse(); // Inicia a análise sintática
    
    if (result == 0) {
        printf("\033[1;32m--- Análise Concluída: Programa sintaticamente correto ---\033[0m\n");
    } else {
        printf("\033[1;35m--- Análise Concluída: Programa sintaticamente incorreto ---\033[0m\n");
    }

    // if (st_global) {
    //     printf("\n--- Conte$2 of ‘declaracao_variavel’ has no declared type
    //  údo da Tabela de Símbolos ---\n");
    //     print_symbol_table(st_global, stdout);
    //     destroy_symbol_table(st_global);
    // }
    
    if (argc > 1 && yyin != stdin) {
        fclose(yyin);
    }

    st_print(&st_global);
    st_free(&st_global);
    return result;
}

// Função de tratamento de erro do Yacc/Bison
void yyerror(const char *s) {
    fprintf(stderr, "\033[1;35mERRO SINTÁTICO na linha %d: %s\033[0m\n", yylineno, s);

    // Exemplo: Exibir o token atual (se disponível)
    extern char *yytext; // yytext é gerenciado pelo Flex
    if (yytext && *yytext != '\0') {
        fprintf(stderr, "\033[1;35mToken inesperado: '%s'\033[0m\n", yytext);
    }
}