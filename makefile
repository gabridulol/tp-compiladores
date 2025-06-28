# Ferramentas
CC = gcc
FLEX = flex
BISON = bison

# Diretórios
LEX_DIR = lex
YACC_DIR = yacc
SRC_DIR = src
BIN_DIR = bin
OBJ_DIR = obj

# Fontes
LEX_SRC = $(LEX_DIR)/lex.l
YACC_SRC = $(YACC_DIR)/yacc.y
MAIN_SRC = $(SRC_DIR)/main.c
SYMBOL_TABLE_SRC = $(SRC_DIR)/symbol_table.c
SOURCE_PRINTER_SRC = $(SRC_DIR)/source_printer.c
SCOPE_SRC = $(SRC_DIR)/scope.c
EXPRESSION_SRC = $(SRC_DIR)/expression.c
LOOPS_SRC = $(SRC_DIR)/loops.c

# Gerados
LEX_GEN = $(LEX_DIR)/lex.yy.c
YACC_GEN = $(YACC_DIR)/yacc.tab.c
YACC_HDR = $(YACC_DIR)/yacc.tab.h

# Objetos
MAIN_OBJ = $(OBJ_DIR)/main.o
LEX_OBJ = $(OBJ_DIR)/lex.yy.o
YACC_OBJ = $(OBJ_DIR)/yacc.tab.o
SYMBOL_TABLE_OBJ = $(OBJ_DIR)/symbol_table.o
SOURCE_PRINTER_OBJ = $(OBJ_DIR)/source_printer.o
SCOPE_OBJ = $(OBJ_DIR)/scope.o
EXPRESSION_OBJ = $(OBJ_DIR)/expression.o
LOOPS_OBJ = $(OBJ_DIR)/loops.o

# Executáveis
COMPILER_EXEC = $(BIN_DIR)/compiler.out

# Alvo padrão
all: $(COMPILER_EXEC)

# Criação dos diretórios se não existirem
$(BIN_DIR) $(OBJ_DIR):
	mkdir -p $@

# Geração dos arquivos do Bison (header, .c e .output)
$(YACC_DIR)/yacc.tab.c $(YACC_DIR)/yacc.tab.h $(YACC_DIR)/yacc.output: $(YACC_SRC) | $(YACC_DIR)
	@$(BISON) -d -v -o $(YACC_DIR)/yacc.tab.c $(YACC_SRC)

# Geração do analisador léxico (após o header do yacc)
$(LEX_GEN): $(LEX_SRC) $(YACC_HDR) | $(LEX_DIR)
	$(FLEX) -o $(LEX_GEN) $(LEX_SRC)

# Compilação dos objetos
$(MAIN_OBJ): $(MAIN_SRC) | $(OBJ_DIR)
	$(CC) -c $(MAIN_SRC) -o $@ -I$(YACC_DIR) -I$(SRC_DIR)

$(LEX_OBJ): $(LEX_GEN) $(YACC_HDR) | $(OBJ_DIR)
	$(CC) -c $(LEX_GEN) -o $@ -I$(YACC_DIR)

$(YACC_OBJ): $(YACC_GEN) | $(OBJ_DIR)
	$(CC) -c $(YACC_GEN) -o $@ -I$(YACC_DIR)

$(SYMBOL_TABLE_OBJ): $(SYMBOL_TABLE_SRC) | $(OBJ_DIR)
	$(CC) -c $(SYMBOL_TABLE_SRC) -o $@ -I$(SRC_DIR)

$(SOURCE_PRINTER_OBJ): $(SOURCE_PRINTER_SRC) | $(OBJ_DIR)
	$(CC) -c $(SOURCE_PRINTER_SRC) -o $@ -I$(SRC_DIR)

$(SCOPE_OBJ): $(SCOPE_SRC) | $(OBJ_DIR)
	$(CC) -c $(SCOPE_SRC) -o $@ -I$(SRC_DIR)

$(EXPRESSION_OBJ): $(EXPRESSION_SRC) | $(OBJ_DIR)
	$(CC) -c $(EXPRESSION_SRC) -o $@ -I$(SRC_DIR)

$(LOOPS_OBJ): $(LOOPS_SRC) | $(OBJ_DIR)
	$(CC) -c $(LOOPS_SRC) -o $@ -I$(SRC_DIR)

# Compilação do compilador completo
$(COMPILER_EXEC): $(MAIN_OBJ) $(LEX_OBJ) $(YACC_OBJ) $(SYMBOL_TABLE_OBJ) $(SOURCE_PRINTER_OBJ) $(SCOPE_OBJ) $(EXPRESSION_OBJ) $(LOOPS_OBJ) | $(BIN_DIR)
	$(CC) $^ -lm -o $@

# Execução do compilador (entrada padrão ou redirecionada com <)
run_compiler: $(COMPILER_EXEC)
	@./$(COMPILER_EXEC)

# Limpeza
clean:
	rm -f $(OBJ_DIR)/*.o $(LEX_GEN) $(YACC_GEN) $(YACC_HDR) $(YACC_DIR)/yacc.output $(COMPILER_EXEC)
