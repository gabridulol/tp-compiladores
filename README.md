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

### 🔧 Compilar o Projeto

Para compilar o projeto, execute o comando abaixo:

```bash
make
```
---

### 📄 Executar o Analisador Léxico

Para executar o analisador léxico, utilize:

```bash
make run_lex
```

Para analisar um arquivo específico, use:

```bash
make run_lex ARQUIVO=seuarquivo.txt
```
---

### 🛠️ Executar o Analisador Léxico com Debug (Colorido)

Para executar o analisador léxico com informações de depuração:

```bash
make run_debug
```

Para analisar um arquivo específico com depuração, use:

```bash
make run_debug ARQUIVO=seuarquivo.txt
```
---

### 🖥️ Executar o Compilador Completo (Lex + Yacc)

Para executar o compilador completo, utilize:

```bash
make run_compiler
```

Para analisar um arquivo específico com o compilador completo, use:

```bash
make run_compiler ARQUIVO=seuarquivo.txt
```
---

### 🧹 Limpeza de Arquivos Gerados

Para remover todos os arquivos gerados (executáveis e arquivos intermediários), execute:

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