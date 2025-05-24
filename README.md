# tp-compiladores
Trabalho Prático 1 - Compiladores

### Analisador Léxico - Projeto Flex

Este projeto contém dois analisadores léxicos desenvolvidos com **Flex**:

- `lex.l`: analisador principal.
- `debug_lex.l`: versão de depuração com saídas coloridas.

---

## 📁 Estrutura do Projeto

```
.
├── lex/         # Arquivos .l (código fonte)
│   ├── lex.l
│   └── debug_lex.l
├── bin/         # Executáveis gerados
└── makefile     # Script de compilação
```
---

## ⚙️ Compilação e Execução

### Compilação

Para compilar ambos os analisadores:

```bash
make
```

### Execução

#### Sem arquivo (entrada padrão via terminal):

```bash
make run_lex
make run_debug
```

#### Com arquivo de entrada:

```bash
make run_lex ARQUIVO=entrada.txt
make run_debug ARQUIVO=entrada.txt
```

### Limpeza

Para remover arquivos `.c` gerados e executáveis da pasta `bin/`:

```bash
make clean
```

---

## 💡 Requisitos

- **Lex - Flex**
- **Yacc - Bison**
- **Compilador de C**:
- Desenvolvido e testado no Linux