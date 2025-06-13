# Compilador e ferramentas
CC = gcc
FLEX = flex
BISON = bison

# Diretórios
LEX_DIR = lex
YACC_DIR = yacc
BIN_DIR = bin

# Fontes
LEX_SRC = $(LEX_DIR)/lex.l
DEBUG_SRC = $(LEX_DIR)/lex_debug.l
YACC_SRC = $(YACC_DIR)/translate.y

# Gerados
LEX_GEN = lex.yy.c
DEBUG_GEN = debug.yy.c
YACC_GEN = translate.tab.c
YACC_HDR = translate.tab.h

# Executáveis
LEX_EXEC = $(BIN_DIR)/lex.out
DEBUG_EXEC = $(BIN_DIR)/debug_lex.out
COMPILER_EXEC = $(BIN_DIR)/compilador_alchemica

# Alvo padrão
all: $(LEX_EXEC) $(DEBUG_EXEC) $(COMPILER_EXEC)

# Criação da pasta bin se não existir
$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# Compilação do analisador principal
$(LEX_EXEC): $(LEX_SRC) | $(BIN_DIR)
	$(FLEX) -o $(LEX_GEN) $(LEX_SRC)
	$(CC) $(LEX_GEN) -o $(LEX_EXEC)

# Compilação do analisador de debug
$(DEBUG_EXEC): $(DEBUG_SRC) | $(BIN_DIR)
	$(FLEX) -o $(DEBUG_GEN) $(DEBUG_SRC)
	$(CC) $(DEBUG_GEN) -o $(DEBUG_EXEC)

# Compilação do compilador completo (lex + yacc)
$(COMPILER_EXEC): $(YACC_SRC) $(LEX_SRC) | $(BIN_DIR)
	$(BISON) -d -o $(YACC_GEN) $(YACC_SRC)
	$(FLEX) -o $(LEX_GEN) $(LEX_SRC)
	$(CC) $(YACC_GEN) $(LEX_GEN) -o $(COMPILER_EXEC) -lfl

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

run_debug: $(DEBUG_EXEC)
	@if [ -n "$$ARQUIVO" ]; then \
		echo "Executando com arquivo '$$ARQUIVO'..."; \
		./$(DEBUG_EXEC) < "$$ARQUIVO"; \
	else \
		echo "Executando com entrada padrão (digite e pressione Ctrl+D para encerrar):"; \
		./$(DEBUG_EXEC); \
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
	rm -f $(LEX_GEN) $(DEBUG_GEN) $(YACC_GEN) $(YACC_HDR)
	rm -f $(LEX_EXEC) $(DEBUG_EXEC) $(COMPILER_EXEC)