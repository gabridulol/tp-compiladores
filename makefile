# Compilador e ferramentas
CC = gcc
FLEX = flex

# Diretórios
LEX_DIR = lex
BIN_DIR = bin
FILES_DIR = files

# Fontes
LEX_SRC = $(LEX_DIR)/lex.l
DEBUG_SRC = $(LEX_DIR)/lex_debug.l

# Executáveis
LEX_EXEC = $(BIN_DIR)/lex.out
DEBUG_EXEC = $(BIN_DIR)/debug_lex.out

# Alvo padrão
all: $(LEX_EXEC) $(DEBUG_EXEC)

# Criação da pasta bin se não existir
$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# Compilação do analisador principal
$(LEX_EXEC): $(LEX_SRC) | $(BIN_DIR)
	$(FLEX) -o lex.yy.c $(LEX_SRC)
	$(CC) lex.yy.c -o $(LEX_EXEC)

# Compilação do analisador de debug
$(DEBUG_EXEC): $(DEBUG_SRC) | $(BIN_DIR)
	$(FLEX) -o debug.yy.c $(DEBUG_SRC)
	$(CC) debug.yy.c -o $(DEBUG_EXEC)

# Execução
run:
	@echo "Uso: make run_lex [ARQUIVO=arquivo.txt] ou make run_debug [ARQUIVO=arquivo.txt]"

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

# Limpeza
clean:
	rm -f lex.yy.c debug.yy.c
	rm -f $(LEX_EXEC) $(DEBUG_EXEC)