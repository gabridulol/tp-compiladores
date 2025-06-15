# tp-compiladores
Trabalho Prático 1 - Compiladores
---

### 📁 Estrutura do Projeto

```
.
├── lex/         # Contém os arquivos de definição do analisador léxico (Flex)
├── yacc/        # Contém os arquivos de definição do analisador sintático (Bison)
├── src/         # Contém o código-fonte principal do projeto em linguagem C
├── bin/         # Diretório para os executáveis gerados após a compilação
├── obj/         # Diretório para os arquivos objeto gerados durante a compilação
├── files/       # Arquivos de testes na linguagem +O
├── makefile     # Arquivo de script para automação da compilação e execução
└── README.md    # Documentação com instruções para uso do projeto
```

---
## ⚙️ Compilação e Execução

### 🔧 Compilar o Projeto

Para compilar o projeto, execute:

```bash
make
```

---

### 🖥️ Executar o Compilador Completo (Lex + Yacc)

Para executar o compilador com entrada manual (digite o código e finalize com `Ctrl+D`):

```bash
make run_compiler
```

Para analisar um arquivo via redirecionamento:

```bash
make run_compiler < [file_path]
```

---

### 🧹 Limpeza de Arquivos Gerados

Para remover todos os arquivos intermediários e executáveis:

```bash
make clean
```

---

## 💡 Requisitos

- **Lex - Flex**
- **Yacc - Bison**
- **Compilador de C**:
- **Desenvolvido e testado no Linux**

---

## 🔗 Referências úteis

- [Página principal do projeto ANSI C](https://www.quut.com/c/)
- [ANSI C Grammar (Lex)](https://www.quut.com/c/ANSI-C-grammar-l-2011.html)
- [ANSI C Grammar (Yacc)](https://www.quut.com/c/ANSI-C-grammar-y-2011.html)
- AHO, A.V.; LAM, M.S.; SETHI, R.; ULLMAN, J.D. Compiladores: Princípios, técnicas e ferramentas.