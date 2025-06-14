# tp-compiladores
Trabalho Prático 1 - Compiladores
---

## 📁 Estrutura do Projeto

```
.
├── lex/         # Arquivos Lex (Flex)
├── yacc/        # Arquivos Yacc (Bison)
├── src/         # Arquivos do código-fonte (Linguagem C)
├── bin/         # Executáveis gerados
└── makefile     # Script de compilação
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