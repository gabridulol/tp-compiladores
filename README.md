# tp-compiladores
Trabalho Prático 1 - Compiladores
---

## 📁 Estrutura do Projeto

```
.
├── lex/         # Arquivos .l (código-fonte)
├── yacc/        # Arquivos .y (código-fonte)
├── src/         # Arquivos .c (código-fonte)
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
- **Desenvolvido e testado no Linux**

---

## 🔗 Referências úteis

- [Página principal do projeto ANSI C](https://www.quut.com/c/)
- [ANSI C Grammar (Lex)](https://www.quut.com/c/ANSI-C-grammar-l-2011.html)
- [ANSI C Grammar (Yacc)](https://www.quut.com/c/ANSI-C-grammar-y-2011.html)