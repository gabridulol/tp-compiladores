/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_YACC_YACC_TAB_H_INCLUDED
# define YY_YY_YACC_YACC_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    IDENTIFIER = 258,              /* IDENTIFIER  */
    LIT_STRING = 259,              /* LIT_STRING  */
    LIT_CHAR = 260,                /* LIT_CHAR  */
    LIT_INT = 261,                 /* LIT_INT  */
    LIT_FLOAT = 262,               /* LIT_FLOAT  */
    KW_SI = 263,                   /* KW_SI  */
    KW_NON = 264,                  /* KW_NON  */
    KW_ITERARE = 265,              /* KW_ITERARE  */
    KW_PERSISTO = 266,             /* KW_PERSISTO  */
    KW_VERTERE = 267,              /* KW_VERTERE  */
    KW_CASUS = 268,                /* KW_CASUS  */
    KW_AXIOM = 269,                /* KW_AXIOM  */
    KW_RUPTIO = 270,               /* KW_RUPTIO  */
    KW_CONTINUUM = 271,            /* KW_CONTINUUM  */
    KW_REDIRE = 272,               /* KW_REDIRE  */
    KW_MOL = 273,                  /* KW_MOL  */
    KW_HOMUNCULUS = 274,           /* KW_HOMUNCULUS  */
    KW_ENUMERARE = 275,            /* KW_ENUMERARE  */
    KW_DESIGNARE = 276,            /* KW_DESIGNARE  */
    KW_FORMULA = 277,              /* KW_FORMULA  */
    KW_REVELARE = 278,             /* KW_REVELARE  */
    KW_LECTURA = 279,              /* KW_LECTURA  */
    KW_MAGNITUDO = 280,            /* KW_MAGNITUDO  */
    KW_ET = 281,                   /* KW_ET  */
    KW_VEL = 282,                  /* KW_VEL  */
    KW_NE = 283,                   /* KW_NE  */
    KW_AUT = 284,                  /* KW_AUT  */
    TYPE_VACUUM = 285,             /* TYPE_VACUUM  */
    TYPE_ATOMUS = 286,             /* TYPE_ATOMUS  */
    TYPE_FRAGMENTUM = 287,         /* TYPE_FRAGMENTUM  */
    TYPE_FRACTIO = 288,            /* TYPE_FRACTIO  */
    TYPE_QUANTUM = 289,            /* TYPE_QUANTUM  */
    TYPE_MAGNUS = 290,             /* TYPE_MAGNUS  */
    TYPE_MINIMUS = 291,            /* TYPE_MINIMUS  */
    TYPE_SYMBOLUM = 292,           /* TYPE_SYMBOLUM  */
    TYPE_SCRIPTUM = 293,           /* TYPE_SCRIPTUM  */
    LIT_FACTUM = 294,              /* LIT_FACTUM  */
    LIT_FICTUM = 295,              /* LIT_FICTUM  */
    OP_ARROW_ASSIGN = 296,         /* OP_ARROW_ASSIGN  */
    OP_DEREF_POINTER = 297,        /* OP_DEREF_POINTER  */
    OP_ADDR_OF = 298,              /* OP_ADDR_OF  */
    OP_LSHIFT_ARRAY = 299,         /* OP_LSHIFT_ARRAY  */
    OP_RSHIFT_ARRAY = 300,         /* OP_RSHIFT_ARRAY  */
    OP_ACCESS_MEMBER = 301,        /* OP_ACCESS_MEMBER  */
    OP_ACCESS_POINTER = 302,       /* OP_ACCESS_POINTER  */
    OP_EXP = 303,                  /* OP_EXP  */
    OP_INTEGER_DIVIDE = 304,       /* OP_INTEGER_DIVIDE  */
    OP_ADD = 305,                  /* OP_ADD  */
    OP_SUBTRACT = 306,             /* OP_SUBTRACT  */
    OP_MULTIPLY = 307,             /* OP_MULTIPLY  */
    OP_DIVIDE = 308,               /* OP_DIVIDE  */
    OP_MODULUS = 309,              /* OP_MODULUS  */
    OP_EQUAL = 310,                /* OP_EQUAL  */
    OP_NOT_EQUAL = 311,            /* OP_NOT_EQUAL  */
    OP_GREATER_THAN = 312,         /* OP_GREATER_THAN  */
    OP_LESS_THAN = 313,            /* OP_LESS_THAN  */
    OP_GREATER_EQUAL = 314,        /* OP_GREATER_EQUAL  */
    OP_LESS_EQUAL = 315,           /* OP_LESS_EQUAL  */
    OP_LOGICAL_AND = 316,          /* OP_LOGICAL_AND  */
    OP_LOGICAL_OR = 317,           /* OP_LOGICAL_OR  */
    OP_LOGICAL_NOT = 318,          /* OP_LOGICAL_NOT  */
    OP_LOGICAL_XOR = 319,          /* OP_LOGICAL_XOR  */
    LBRACE = 320,                  /* LBRACE  */
    RBRACE = 321,                  /* RBRACE  */
    SEMICOLON = 322,               /* SEMICOLON  */
    LPAREN = 323,                  /* LPAREN  */
    RPAREN = 324,                  /* RPAREN  */
    PIPE = 325,                    /* PIPE  */
    COLON = 326,                   /* COLON  */
    PREC_UNARY_PREFIX = 327,       /* PREC_UNARY_PREFIX  */
    UNARY_MINUS = 328              /* UNARY_MINUS  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 36 "yacc/yacc.y"

    int val_int;       // Para literais inteiros
    double val_float;  // Para literais float
    char *str;         // Para strings e identificadores

#line 143 "yacc/yacc.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_YACC_YACC_TAB_H_INCLUDED  */
