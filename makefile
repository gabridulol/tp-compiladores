# Compilador e ferramentas
CC = gcc
FLEX = flex
BISON = bison

# Diretórios
LEX_DIR = lex
YACC_DIR = yacc
BIN_DIR = bin
SRC_DIR = src

# Fontes
LEX_SRC = $(LEX_DIR)/lex.l
LEX_DEBUG_SRC = $(LEX_DIR)/lex_debug.l
YACC_SRC = $(YACC_DIR)/yacc.y
SYMBOL_TABLE_SRC_C = $(SRC_DIR)/symbol_table.c
SYMBOL_TABLE_SRC_H = $(SRC_DIR)/symbol_table.h

# Gerados
LEX_GEN = $(LEX_DIR)/lex.yy.c
LEX_DEBUG_GEN = $(LEX_DIR)/lex_debug.yy.c
YACC_GEN = $(YACC_DIR)/yacc.tab.c
YACC_HDR = $(YACC_DIR)/yacc.tab.h

# Executáveis
LEX_EXEC = $(BIN_DIR)/lex.out
LEX_DEBUG_EXEC = $(BIN_DIR)/lex_debug.out
COMPILER_EXEC = $(BIN_DIR)/compiler.out

# Alvo padrão
all: $(LEX_EXEC) $(LEX_DEBUG_EXEC) $(COMPILER_EXEC)

# Criação da pasta bin se não existir
$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# Geração dos arquivos do Bison (header e .c)
$(YACC_HDR): $(YACC_SRC)
	$(BISON) -d -o $(YACC_GEN) $(YACC_SRC)

# Compilação do analisador principal
$(LEX_EXEC): $(LEX_SRC) $(YACC_HDR) $(SYMBOL_TABLE_SRC_C) | $(BIN_DIR)
	$(FLEX) -o $(LEX_GEN) $(LEX_SRC)
	$(CC) $(LEX_GEN) $(YACC_GEN) $(SYMBOL_TABLE_SRC_C) -o $(LEX_EXEC) -I $(YACC_DIR) -I $(SRC_DIR) -lfl

# Compilação da versão de debug
$(LEX_DEBUG_EXEC): $(LEX_DEBUG_SRC) | $(BIN_DIR)
	$(FLEX) -o $(LEX_DEBUG_GEN) $(LEX_DEBUG_SRC)
	$(CC) $(LEX_DEBUG_GEN) -o $(LEX_DEBUG_EXEC)

# Compilação do compilador completo (yacc + lex)
$(COMPILER_EXEC): $(YACC_HDR) $(LEX_SRC) $(SYMBOL_TABLE_SRC_C) | $(BIN_DIR)
	$(FLEX) -o $(LEX_GEN) $(LEX_SRC)
	$(CC) $(YACC_GEN) $(LEX_GEN) $(SYMBOL_TABLE_SRC_C) -o $(COMPILER_EXEC) -I $(YACC_DIR) -I $(SRC_DIR) -lfl

# Execução
run:
	@echo "Uso: make run_lex [ARQUIVO=arquivo.txt], make run_debug [ARQUIVO=arquivo.txt] ou make run_compiler [ARQUIVO=arquivo.txt]"

run_lex: $(LEX_EXEC)
	@if [ -n "$$ARQUIVO" ]; then \
		echo "Executando com arquivo '$$ARQUIVO'..."; \
		./$(LEX_EXEC) < "$$ARQUIVO"; \
	else \
		echo "Executando com entrada padrão (digite e pressione Ctrl+D para encerrar):"; \
		./$(LEX_EXEC); \
	fi

run_debug: $(LEX_DEBUG_EXEC)
	@if [ -n "$$ARQUIVO" ]; then \
		echo "Executando com arquivo '$$ARQUIVO'..."; \
		./$(LEX_DEBUG_EXEC) < "$$ARQUIVO"; \
	else \
		echo "Executando com entrada padrão (digite e pressione Ctrl+D para encerrar):"; \
		./$(LEX_DEBUG_EXEC); \
	fi

run_compiler: $(COMPILER_EXEC)
	@if [ -n "$$ARQUIVO" ]; then \
		echo "Executando compilador com arquivo '$$ARQUIVO'..."; \
		./$(COMPILER_EXEC) < "$$ARQUIVO"; \
	else \
		echo "Executando compilador com entrada padrão (digite e pressione Ctrl+D para encerrar):"; \
		./$(COMPILER_EXEC); \
	fi

# Limpeza
clean:
	rm -f $(LEX_GEN) $(LEX_DEBUG_GEN) $(YACC_GEN) $(YACC_HDR)
	rm -f $(LEX_EXEC) $(LEX_DEBUG_EXEC) $(COMPILER_EXEC)
