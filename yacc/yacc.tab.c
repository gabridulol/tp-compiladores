/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison implementation for Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output, and Bison version.  */
#define YYBISON 30802

/* Bison version string.  */
#define YYBISON_VERSION "3.8.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "yacc/yacc.y"

#include <stdio.h>
#include <stdlib.h> 
#include <string.h>

// Se você modularizar, inclua os headers aqui:
// #include "symbol_table.h"
// #include "type_system.h"
// #include "ast.h"

extern FILE *yyin;         // <- Adicione esta linha
// extern int yylex(void); // (já deve existir ou ser implícita)
// void yyerror(const char *s); // protótipo já deve estar declarado

extern int yylineno;       // Linha gerenciada pelo Flex

// Protótipo da função do lexer
int yylex(void);
// Protótipo da função de erro do parser
void yyerror(const char *s);

// Variável global para o número da linha (geralmente gerenciada pelo Lex/Flex)
extern int yylineno;

// Se você tiver uma tabela de símbolos global (para simplificar no início)
// SymbolTable *st_global;

#line 99 "yacc/yacc.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

#include "yacc.tab.h"
/* Symbol kind.  */
enum yysymbol_kind_t
{
  YYSYMBOL_YYEMPTY = -2,
  YYSYMBOL_YYEOF = 0,                      /* "end of file"  */
  YYSYMBOL_YYerror = 1,                    /* error  */
  YYSYMBOL_YYUNDEF = 2,                    /* "invalid token"  */
  YYSYMBOL_IDENTIFIER = 3,                 /* IDENTIFIER  */
  YYSYMBOL_LIT_STRING = 4,                 /* LIT_STRING  */
  YYSYMBOL_LIT_CHAR = 5,                   /* LIT_CHAR  */
  YYSYMBOL_LIT_INT = 6,                    /* LIT_INT  */
  YYSYMBOL_LIT_FLOAT = 7,                  /* LIT_FLOAT  */
  YYSYMBOL_KW_SI = 8,                      /* KW_SI  */
  YYSYMBOL_KW_NON = 9,                     /* KW_NON  */
  YYSYMBOL_KW_ITERARE = 10,                /* KW_ITERARE  */
  YYSYMBOL_KW_PERSISTO = 11,               /* KW_PERSISTO  */
  YYSYMBOL_KW_VERTERE = 12,                /* KW_VERTERE  */
  YYSYMBOL_KW_CASUS = 13,                  /* KW_CASUS  */
  YYSYMBOL_KW_AXIOM = 14,                  /* KW_AXIOM  */
  YYSYMBOL_KW_RUPTIO = 15,                 /* KW_RUPTIO  */
  YYSYMBOL_KW_CONTINUUM = 16,              /* KW_CONTINUUM  */
  YYSYMBOL_KW_REDIRE = 17,                 /* KW_REDIRE  */
  YYSYMBOL_KW_MOL = 18,                    /* KW_MOL  */
  YYSYMBOL_KW_HOMUNCULUS = 19,             /* KW_HOMUNCULUS  */
  YYSYMBOL_KW_ENUMERARE = 20,              /* KW_ENUMERARE  */
  YYSYMBOL_KW_DESIGNARE = 21,              /* KW_DESIGNARE  */
  YYSYMBOL_KW_FORMULA = 22,                /* KW_FORMULA  */
  YYSYMBOL_KW_REVELARE = 23,               /* KW_REVELARE  */
  YYSYMBOL_KW_LECTURA = 24,                /* KW_LECTURA  */
  YYSYMBOL_KW_MAGNITUDO = 25,              /* KW_MAGNITUDO  */
  YYSYMBOL_KW_ET = 26,                     /* KW_ET  */
  YYSYMBOL_KW_VEL = 27,                    /* KW_VEL  */
  YYSYMBOL_KW_NE = 28,                     /* KW_NE  */
  YYSYMBOL_KW_AUT = 29,                    /* KW_AUT  */
  YYSYMBOL_TYPE_VACUUM = 30,               /* TYPE_VACUUM  */
  YYSYMBOL_TYPE_ATOMUS = 31,               /* TYPE_ATOMUS  */
  YYSYMBOL_TYPE_FRAGMENTUM = 32,           /* TYPE_FRAGMENTUM  */
  YYSYMBOL_TYPE_FRACTIO = 33,              /* TYPE_FRACTIO  */
  YYSYMBOL_TYPE_QUANTUM = 34,              /* TYPE_QUANTUM  */
  YYSYMBOL_TYPE_MAGNUS = 35,               /* TYPE_MAGNUS  */
  YYSYMBOL_TYPE_MINIMUS = 36,              /* TYPE_MINIMUS  */
  YYSYMBOL_TYPE_SYMBOLUM = 37,             /* TYPE_SYMBOLUM  */
  YYSYMBOL_TYPE_SCRIPTUM = 38,             /* TYPE_SCRIPTUM  */
  YYSYMBOL_LIT_FACTUM = 39,                /* LIT_FACTUM  */
  YYSYMBOL_LIT_FICTUM = 40,                /* LIT_FICTUM  */
  YYSYMBOL_OP_ARROW_ASSIGN = 41,           /* OP_ARROW_ASSIGN  */
  YYSYMBOL_OP_DEREF_POINTER = 42,          /* OP_DEREF_POINTER  */
  YYSYMBOL_OP_ADDR_OF = 43,                /* OP_ADDR_OF  */
  YYSYMBOL_OP_LSHIFT_ARRAY = 44,           /* OP_LSHIFT_ARRAY  */
  YYSYMBOL_OP_RSHIFT_ARRAY = 45,           /* OP_RSHIFT_ARRAY  */
  YYSYMBOL_OP_ACCESS_MEMBER = 46,          /* OP_ACCESS_MEMBER  */
  YYSYMBOL_OP_ACCESS_POINTER = 47,         /* OP_ACCESS_POINTER  */
  YYSYMBOL_OP_EXP = 48,                    /* OP_EXP  */
  YYSYMBOL_OP_INTEGER_DIVIDE = 49,         /* OP_INTEGER_DIVIDE  */
  YYSYMBOL_OP_ADD = 50,                    /* OP_ADD  */
  YYSYMBOL_OP_SUBTRACT = 51,               /* OP_SUBTRACT  */
  YYSYMBOL_OP_MULTIPLY = 52,               /* OP_MULTIPLY  */
  YYSYMBOL_OP_DIVIDE = 53,                 /* OP_DIVIDE  */
  YYSYMBOL_OP_MODULUS = 54,                /* OP_MODULUS  */
  YYSYMBOL_OP_EQUAL = 55,                  /* OP_EQUAL  */
  YYSYMBOL_OP_NOT_EQUAL = 56,              /* OP_NOT_EQUAL  */
  YYSYMBOL_OP_GREATER_THAN = 57,           /* OP_GREATER_THAN  */
  YYSYMBOL_OP_LESS_THAN = 58,              /* OP_LESS_THAN  */
  YYSYMBOL_OP_GREATER_EQUAL = 59,          /* OP_GREATER_EQUAL  */
  YYSYMBOL_OP_LESS_EQUAL = 60,             /* OP_LESS_EQUAL  */
  YYSYMBOL_OP_LOGICAL_AND = 61,            /* OP_LOGICAL_AND  */
  YYSYMBOL_OP_LOGICAL_OR = 62,             /* OP_LOGICAL_OR  */
  YYSYMBOL_OP_LOGICAL_NOT = 63,            /* OP_LOGICAL_NOT  */
  YYSYMBOL_OP_LOGICAL_XOR = 64,            /* OP_LOGICAL_XOR  */
  YYSYMBOL_LBRACE = 65,                    /* LBRACE  */
  YYSYMBOL_RBRACE = 66,                    /* RBRACE  */
  YYSYMBOL_SEMICOLON = 67,                 /* SEMICOLON  */
  YYSYMBOL_LPAREN = 68,                    /* LPAREN  */
  YYSYMBOL_RPAREN = 69,                    /* RPAREN  */
  YYSYMBOL_PIPE = 70,                      /* PIPE  */
  YYSYMBOL_COLON = 71,                     /* COLON  */
  YYSYMBOL_PREC_UNARY_PREFIX = 72,         /* PREC_UNARY_PREFIX  */
  YYSYMBOL_UNARY_MINUS = 73,               /* UNARY_MINUS  */
  YYSYMBOL_YYACCEPT = 74,                  /* $accept  */
  YYSYMBOL_programa = 75,                  /* programa  */
  YYSYMBOL_programa_nao_vazio = 76,        /* programa_nao_vazio  */
  YYSYMBOL_declaracao_ou_comando = 77,     /* declaracao_ou_comando  */
  YYSYMBOL_declaracao = 78,                /* declaracao  */
  YYSYMBOL_declaracao_tipo = 79,           /* declaracao_tipo  */
  YYSYMBOL_declaracao_homunculus = 80,     /* declaracao_homunculus  */
  YYSYMBOL_corpo_homunculus = 81,          /* corpo_homunculus  */
  YYSYMBOL_declaracao_enumeracao = 82,     /* declaracao_enumeracao  */
  YYSYMBOL_lista_enum_ident = 83,          /* lista_enum_ident  */
  YYSYMBOL_declaracao_designacao = 84,     /* declaracao_designacao  */
  YYSYMBOL_declaracao_variavel = 85,       /* declaracao_variavel  */
  YYSYMBOL_declaracao_funcao = 86,         /* declaracao_funcao  */
  YYSYMBOL_lista_parametros_opt = 87,      /* lista_parametros_opt  */
  YYSYMBOL_tipo = 88,                      /* tipo  */
  YYSYMBOL_expressao_opt = 89,             /* expressao_opt  */
  YYSYMBOL_nome_tipo_base = 90,            /* nome_tipo_base  */
  YYSYMBOL_lista_parametros = 91,          /* lista_parametros  */
  YYSYMBOL_parametro = 92,                 /* parametro  */
  YYSYMBOL_comando = 93,                   /* comando  */
  YYSYMBOL_comando_atribuicao = 94,        /* comando_atribuicao  */
  YYSYMBOL_comando_condicional = 95,       /* comando_condicional  */
  YYSYMBOL_non_opt = 96,                   /* non_opt  */
  YYSYMBOL_comando_repeticao = 97,         /* comando_repeticao  */
  YYSYMBOL_comando_iteracao = 98,          /* comando_iteracao  */
  YYSYMBOL_comando_atribuicao_opt = 99,    /* comando_atribuicao_opt  */
  YYSYMBOL_comando_selecao = 100,          /* comando_selecao  */
  YYSYMBOL_casos_lista = 101,              /* casos_lista  */
  YYSYMBOL_caso = 102,                     /* caso  */
  YYSYMBOL_comandos_bloco = 103,           /* comandos_bloco  */
  YYSYMBOL_caso_padrao_opt = 104,          /* caso_padrao_opt  */
  YYSYMBOL_comando_retorno = 105,          /* comando_retorno  */
  YYSYMBOL_comando_ruptio = 106,           /* comando_ruptio  */
  YYSYMBOL_comando_continuum = 107,        /* comando_continuum  */
  YYSYMBOL_comando_leitura = 108,          /* comando_leitura  */
  YYSYMBOL_comando_revelacao = 109,        /* comando_revelacao  */
  YYSYMBOL_expressao = 110,                /* expressao  */
  YYSYMBOL_expressao_logica_vel = 111,     /* expressao_logica_vel  */
  YYSYMBOL_expressao_logica_et = 112,      /* expressao_logica_et  */
  YYSYMBOL_expressao_xor = 113,            /* expressao_xor  */
  YYSYMBOL_expressao_relacional = 114,     /* expressao_relacional  */
  YYSYMBOL_expressao_aritmetica = 115,     /* expressao_aritmetica  */
  YYSYMBOL_termo = 116,                    /* termo  */
  YYSYMBOL_fator_exponencial = 117,        /* fator_exponencial  */
  YYSYMBOL_expressao_posfixa = 118,        /* expressao_posfixa  */
  YYSYMBOL_primario = 119,                 /* primario  */
  YYSYMBOL_expressao_magnitudo = 120,      /* expressao_magnitudo  */
  YYSYMBOL_chamada_funcao = 121,           /* chamada_funcao  */
  YYSYMBOL_lista_argumentos_opt = 122,     /* lista_argumentos_opt  */
  YYSYMBOL_lista_argumentos = 123          /* lista_argumentos  */
};
typedef enum yysymbol_kind_t yysymbol_kind_t;




#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

/* Work around bug in HP-UX 11.23, which defines these macros
   incorrectly for preprocessor constants.  This workaround can likely
   be removed in 2023, as HPE has promised support for HP-UX 11.23
   (aka HP-UX 11i v2) only through the end of 2022; see Table 2 of
   <https://h20195.www2.hpe.com/V2/getpdf.aspx/4AA4-7673ENW.pdf>.  */
#ifdef __hpux
# undef UINT_LEAST8_MAX
# undef UINT_LEAST16_MAX
# define UINT_LEAST8_MAX 255
# define UINT_LEAST16_MAX 65535
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))


/* Stored state numbers (used for stacks). */
typedef yytype_uint8 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif


#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YY_USE(E) ((void) (E))
#else
# define YY_USE(E) /* empty */
#endif

/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
#if defined __GNUC__ && ! defined __ICC && 406 <= __GNUC__ * 100 + __GNUC_MINOR__
# if __GNUC__ * 100 + __GNUC_MINOR__ < 407
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")
# else
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# endif
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if !defined yyoverflow

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* !defined yyoverflow */

#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  78
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   289

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  74
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  50
/* YYNRULES -- Number of rules.  */
#define YYNRULES  127
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  225

/* YYMAXUTOK -- Last valid token kind.  */
#define YYMAXUTOK   328


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK                     \
   ? YY_CAST (yysymbol_kind_t, yytranslate[YYX])        \
   : YYSYMBOL_YYUNDEF)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73
};

#if YYDEBUG
/* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,   137,   137,   138,   141,   142,   145,   146,   150,   151,
     152,   153,   156,   157,   160,   163,   164,   167,   170,   171,
     174,   178,   180,   182,   184,   188,   191,   192,   196,   197,
     198,   200,   201,   204,   205,   206,   207,   208,   209,   210,
     211,   212,   213,   216,   217,   219,   224,   225,   226,   227,
     228,   229,   230,   231,   232,   233,   234,   235,   236,   239,
     243,   245,   246,   249,   252,   254,   255,   258,   260,   261,
     263,   265,   266,   268,   269,   272,   275,   276,   278,   280,
     284,   286,   287,   288,   291,   292,   293,   296,   297,   298,
     301,   302,   303,   304,   305,   306,   307,   310,   311,   312,
     315,   316,   317,   318,   319,   322,   323,   334,   335,   336,
     337,   338,   341,   342,   343,   344,   345,   346,   347,   348,
     349,   352,   353,   356,   359,   360,   363,   364
};
#endif

/** Accessing symbol of state STATE.  */
#define YY_ACCESSING_SYMBOL(State) YY_CAST (yysymbol_kind_t, yystos[State])

#if YYDEBUG || 0
/* The user-facing name of the symbol whose (internal) number is
   YYSYMBOL.  No bounds checking.  */
static const char *yysymbol_name (yysymbol_kind_t yysymbol) YY_ATTRIBUTE_UNUSED;

/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "\"end of file\"", "error", "\"invalid token\"", "IDENTIFIER",
  "LIT_STRING", "LIT_CHAR", "LIT_INT", "LIT_FLOAT", "KW_SI", "KW_NON",
  "KW_ITERARE", "KW_PERSISTO", "KW_VERTERE", "KW_CASUS", "KW_AXIOM",
  "KW_RUPTIO", "KW_CONTINUUM", "KW_REDIRE", "KW_MOL", "KW_HOMUNCULUS",
  "KW_ENUMERARE", "KW_DESIGNARE", "KW_FORMULA", "KW_REVELARE",
  "KW_LECTURA", "KW_MAGNITUDO", "KW_ET", "KW_VEL", "KW_NE", "KW_AUT",
  "TYPE_VACUUM", "TYPE_ATOMUS", "TYPE_FRAGMENTUM", "TYPE_FRACTIO",
  "TYPE_QUANTUM", "TYPE_MAGNUS", "TYPE_MINIMUS", "TYPE_SYMBOLUM",
  "TYPE_SCRIPTUM", "LIT_FACTUM", "LIT_FICTUM", "OP_ARROW_ASSIGN",
  "OP_DEREF_POINTER", "OP_ADDR_OF", "OP_LSHIFT_ARRAY", "OP_RSHIFT_ARRAY",
  "OP_ACCESS_MEMBER", "OP_ACCESS_POINTER", "OP_EXP", "OP_INTEGER_DIVIDE",
  "OP_ADD", "OP_SUBTRACT", "OP_MULTIPLY", "OP_DIVIDE", "OP_MODULUS",
  "OP_EQUAL", "OP_NOT_EQUAL", "OP_GREATER_THAN", "OP_LESS_THAN",
  "OP_GREATER_EQUAL", "OP_LESS_EQUAL", "OP_LOGICAL_AND", "OP_LOGICAL_OR",
  "OP_LOGICAL_NOT", "OP_LOGICAL_XOR", "LBRACE", "RBRACE", "SEMICOLON",
  "LPAREN", "RPAREN", "PIPE", "COLON", "PREC_UNARY_PREFIX", "UNARY_MINUS",
  "$accept", "programa", "programa_nao_vazio", "declaracao_ou_comando",
  "declaracao", "declaracao_tipo", "declaracao_homunculus",
  "corpo_homunculus", "declaracao_enumeracao", "lista_enum_ident",
  "declaracao_designacao", "declaracao_variavel", "declaracao_funcao",
  "lista_parametros_opt", "tipo", "expressao_opt", "nome_tipo_base",
  "lista_parametros", "parametro", "comando", "comando_atribuicao",
  "comando_condicional", "non_opt", "comando_repeticao",
  "comando_iteracao", "comando_atribuicao_opt", "comando_selecao",
  "casos_lista", "caso", "comandos_bloco", "caso_padrao_opt",
  "comando_retorno", "comando_ruptio", "comando_continuum",
  "comando_leitura", "comando_revelacao", "expressao",
  "expressao_logica_vel", "expressao_logica_et", "expressao_xor",
  "expressao_relacional", "expressao_aritmetica", "termo",
  "fator_exponencial", "expressao_posfixa", "primario",
  "expressao_magnitudo", "chamada_funcao", "lista_argumentos_opt",
  "lista_argumentos", YY_NULLPTR
};

static const char *
yysymbol_name (yysymbol_kind_t yysymbol)
{
  return yytname[yysymbol];
}
#endif

#define YYPACT_NINF (-124)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-125)

#define yytable_value_is_error(Yyn) \
  0

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
static const yytype_int16 yypact[] =
{
      97,   190,  -124,  -124,  -124,   -54,   -49,    21,   -31,     7,
    -124,  -124,  -124,  -124,  -124,  -124,  -124,  -124,  -124,  -124,
    -124,    97,  -124,     2,    60,    97,  -124,  -124,  -124,  -124,
    -124,  -124,  -124,  -124,    12,    52,  -124,  -124,    29,  -124,
    -124,  -124,  -124,    41,  -124,  -124,  -124,  -124,    38,    -5,
      -3,     3,   180,    35,   122,  -124,   219,  -124,  -124,    71,
    -124,    96,    -8,  -124,  -124,   216,   136,   117,    36,  -124,
      58,  -124,    78,   -34,   160,  -124,    56,    76,  -124,  -124,
     138,  -124,    58,  -124,  -124,  -124,    58,    58,    58,    58,
      58,    58,    58,    58,    58,    58,    58,    58,    58,    58,
      58,    58,    58,    58,    58,  -124,    58,   157,   164,    58,
    -124,  -124,     8,     6,    58,  -124,    99,   216,   100,    98,
    -124,   -30,    40,   108,  -124,   109,    58,    32,   162,   178,
      58,   121,   144,  -124,   225,    -3,    -3,     3,     3,   180,
     180,    35,    35,    35,    35,    35,    35,   122,   122,  -124,
    -124,  -124,  -124,   167,  -124,  -124,  -124,   216,   186,  -124,
     189,   211,   166,    58,  -124,    47,   227,   136,  -124,  -124,
    -124,   175,    13,    13,   199,   203,   206,  -124,  -124,  -124,
    -124,  -124,   207,   208,  -124,  -124,   209,   204,  -124,    58,
     222,  -124,  -124,  -124,  -124,  -124,  -124,  -124,   216,   210,
      13,  -124,    17,   119,   267,  -124,    58,   212,  -124,   214,
      97,    13,   213,   176,  -124,   215,  -124,   176,    97,  -124,
    -124,  -124,  -124,   220,  -124
};

/* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE does not specify something else to do.  Zero
   means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       2,   112,   115,   113,   114,     0,     0,     0,     0,     0,
      33,    34,    35,    36,    37,    38,    39,    40,    41,   116,
     117,     2,    58,    65,     0,     3,     4,     6,    10,    12,
      13,    11,     8,     9,     0,     0,    28,     7,     0,    46,
      47,    48,    49,     0,    53,    54,    55,    56,    32,    80,
      81,    84,    87,    90,    97,   100,   105,   107,   120,   119,
      42,    15,     0,    76,    77,     0,    26,     0,     0,   112,
     124,    66,     0,   126,   105,   119,     0,   125,     1,     5,
       0,    29,    31,    75,    51,    50,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   110,     0,     0,     0,     0,
      52,    18,     0,     0,     0,    21,     0,     0,     0,    27,
      43,   112,     0,     0,    57,   126,    31,   118,     0,     0,
       0,     0,     0,    32,    59,    82,    83,    85,    86,    88,
      89,    91,    92,    94,    93,    96,    95,    98,    99,   104,
     101,   102,   103,     0,   108,   109,   106,     0,     0,    16,
       0,     0,     0,     0,    22,    45,     0,     0,   121,   122,
     118,     0,    31,    31,     0,     0,     0,   123,   127,    20,
      30,   111,     0,     0,    19,    23,     0,     0,    44,    31,
      61,    63,    68,    79,    78,    14,    17,    24,     0,     0,
      31,    60,    73,     0,     0,    62,     0,     0,    69,     0,
       2,    31,     0,    31,    67,     0,    64,    31,     2,    71,
      74,    25,    70,     0,    57
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -124,   -20,  -124,   253,  -124,  -124,  -124,  -124,  -124,  -124,
    -124,   170,  -124,  -124,     1,   -79,  -124,  -124,   118,  -123,
     264,  -124,  -124,  -124,  -124,  -124,  -124,  -124,  -124,    72,
    -124,  -124,  -124,  -124,  -124,  -124,   -19,  -124,   -42,    16,
      25,   163,    -7,    93,   -13,  -124,  -124,     0,  -124,  -124
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_uint8 yydefgoto[] =
{
       0,    24,    25,    26,    27,    28,    29,   112,    30,   113,
      31,    32,    33,   118,    34,    35,    36,   119,   120,    37,
      38,    39,   201,    40,    41,    72,    42,   202,   208,   220,
     209,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    57,    58,    75,    76,    77
};

/* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule whose
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      59,    68,    62,   132,    73,    69,     2,    86,     3,     4,
      74,   157,   -42,    63,   -42,    80,    69,     2,    64,     3,
       4,    59,    87,    89,    65,    59,     7,     9,     5,     6,
     206,   207,    91,   114,    81,   127,    82,    66,     9,   -42,
     172,    19,    20,   173,   174,   135,   136,   171,   123,   190,
     191,   125,    19,    20,    81,   175,    82,    88,    90,   115,
      78,    69,     2,   133,     3,     4,   116,    92,   122,    83,
      70,  -124,   160,   134,   158,    67,   161,   205,    21,    86,
      22,    23,    81,     9,    82,    99,   100,   153,   216,    81,
     219,    82,   147,   148,   219,   162,    84,    19,    20,   111,
       1,     2,   124,     3,     4,   137,   138,   133,    85,   168,
     199,   178,     5,     6,   -31,     7,   139,   140,   165,     8,
     121,     2,     9,     3,     4,   129,    70,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,   110,   117,
     163,    81,     9,    82,   186,   126,   130,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,    62,   131,
     154,    81,    21,    82,    22,    23,   164,   155,   167,   166,
     133,   101,    59,    59,   102,   103,   104,   169,   170,    69,
       2,   177,     3,     4,   210,    70,   176,   212,   179,   180,
     215,     5,     6,    60,   149,   150,   151,   152,   223,   203,
      59,     9,   156,   105,   106,   182,   107,   108,   109,   183,
      59,    59,   181,    59,   184,    19,    20,    59,    59,    60,
      10,    11,    12,    13,    14,    15,    16,    17,    18,   128,
     187,   200,   -42,   185,   -42,    93,    94,    95,    96,    97,
      98,   218,   189,    22,    23,   198,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    61,   141,   142,   143,   144,
     145,   146,   105,   106,   192,   107,   108,   109,   105,   106,
     193,   107,   108,   194,   195,   196,   197,   211,    79,   204,
     214,   221,   159,   213,   217,   188,   224,    71,     0,   222
};

static const yytype_int16 yycheck[] =
{
       0,    21,     1,    82,    23,     3,     4,    41,     6,     7,
      23,     3,    42,    67,    44,     3,     3,     4,    67,     6,
       7,    21,    27,    26,     3,    25,    18,    25,    15,    16,
      13,    14,    29,    41,    42,    69,    44,    68,    25,    69,
       8,    39,    40,    11,    12,    87,    88,   126,    67,   172,
     173,    70,    39,    40,    42,    23,    44,    62,    61,    67,
       0,     3,     4,    82,     6,     7,    65,    64,    67,    17,
      68,    69,    66,    86,    66,    68,    70,   200,    65,    41,
      67,    68,    42,    25,    44,    50,    51,   106,   211,    42,
     213,    44,    99,   100,   217,   114,    67,    39,    40,     3,
       3,     4,    66,     6,     7,    89,    90,   126,    67,    69,
     189,   130,    15,    16,    17,    18,    91,    92,   117,    22,
       3,     4,    25,     6,     7,    69,    68,    30,    31,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    67,     3,
      41,    42,    25,    44,   163,    67,    70,    30,    31,    32,
      33,    34,    35,    36,    37,    38,    39,    40,   157,    21,
       3,    42,    65,    44,    67,    68,    67,     3,    70,    69,
     189,    49,   172,   173,    52,    53,    54,    69,    69,     3,
       4,     3,     6,     7,    65,    68,    24,   206,    67,    45,
     210,    15,    16,     3,   101,   102,   103,   104,   218,   198,
     200,    25,   109,    43,    44,    19,    46,    47,    48,    20,
     210,   211,    45,   213,     3,    39,    40,   217,   218,     3,
      30,    31,    32,    33,    34,    35,    36,    37,    38,    69,
       3,     9,    42,    67,    44,    55,    56,    57,    58,    59,
      60,    65,    67,    67,    68,    41,    30,    31,    32,    33,
      34,    35,    36,    37,    38,    65,    93,    94,    95,    96,
      97,    98,    43,    44,    65,    46,    47,    48,    43,    44,
      67,    46,    47,    67,    67,    67,    67,    10,    25,    69,
      66,    66,   112,    71,    71,   167,    66,    23,    -1,   217
};

/* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
   state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,     3,     4,     6,     7,    15,    16,    18,    22,    25,
      30,    31,    32,    33,    34,    35,    36,    37,    38,    39,
      40,    65,    67,    68,    75,    76,    77,    78,    79,    80,
      82,    84,    85,    86,    88,    89,    90,    93,    94,    95,
      97,    98,   100,   105,   106,   107,   108,   109,   110,   111,
     112,   113,   114,   115,   116,   117,   118,   119,   120,   121,
       3,    65,    88,    67,    67,     3,    68,    68,    75,     3,
      68,    94,    99,   110,   118,   121,   122,   123,     0,    77,
       3,    42,    44,    17,    67,    67,    41,    27,    62,    26,
      61,    29,    64,    55,    56,    57,    58,    59,    60,    50,
      51,    49,    52,    53,    54,    43,    44,    46,    47,    48,
      67,     3,    81,    83,    41,    67,    88,     3,    87,    91,
      92,     3,    88,   110,    66,   110,    67,    69,    69,    69,
      70,    21,    89,   110,   118,   112,   112,   113,   113,   114,
     114,   115,   115,   115,   115,   115,   115,   116,   116,   117,
     117,   117,   117,   110,     3,     3,   117,     3,    66,    85,
      66,    70,   110,    41,    67,    88,    69,    70,    69,    69,
      69,    89,     8,    11,    12,    23,    24,     3,   110,    67,
      45,    45,    19,    20,     3,    67,   110,     3,    92,    67,
      93,    93,    65,    67,    67,    67,    67,    67,    41,    89,
       9,    96,   101,    88,    69,    93,    13,    14,   102,   104,
      65,    10,   110,    71,    66,    75,    93,    71,    65,    93,
     103,    66,   103,    75,    66
};

/* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr1[] =
{
       0,    74,    75,    75,    76,    76,    77,    77,    78,    78,
      78,    78,    79,    79,    80,    81,    81,    82,    83,    83,
      84,    85,    85,    85,    85,    86,    87,    87,    88,    88,
      88,    89,    89,    90,    90,    90,    90,    90,    90,    90,
      90,    90,    90,    91,    91,    92,    93,    93,    93,    93,
      93,    93,    93,    93,    93,    93,    93,    93,    93,    94,
      95,    96,    96,    97,    98,    99,    99,   100,   101,   101,
     102,   103,   103,   104,   104,   105,   106,   107,   108,   109,
     110,   111,   111,   111,   112,   112,   112,   113,   113,   113,
     114,   114,   114,   114,   114,   114,   114,   115,   115,   115,
     116,   116,   116,   116,   116,   117,   117,   118,   118,   118,
     118,   118,   119,   119,   119,   119,   119,   119,   119,   119,
     119,   120,   120,   121,   122,   122,   123,   123
};

/* YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     0,     1,     1,     2,     1,     1,     1,     1,
       1,     1,     1,     1,     6,     0,     2,     6,     1,     3,
       4,     3,     4,     5,     6,    10,     0,     1,     1,     2,
       4,     0,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     3,     2,     1,     1,     1,     1,
       2,     2,     2,     1,     1,     1,     1,     3,     1,     3,
       6,     0,     2,     5,     9,     0,     1,     8,     0,     2,
       4,     1,     3,     0,     3,     2,     2,     2,     5,     5,
       1,     1,     3,     3,     1,     3,     3,     1,     3,     3,
       1,     3,     3,     3,     3,     3,     3,     1,     3,     3,
       1,     3,     3,     3,     3,     1,     3,     1,     3,     3,
       2,     4,     1,     1,     1,     1,     1,     1,     3,     1,
       1,     4,     4,     4,     0,     1,     1,     3
};


enum { YYENOMEM = -2 };

#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab
#define YYNOMEM         goto yyexhaustedlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Backward compatibility with an undocumented macro.
   Use YYerror or YYUNDEF. */
#define YYERRCODE YYUNDEF


/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)




# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Kind, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo,
                       yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YY_USE (yyoutput);
  if (!yyvaluep)
    return;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo,
                 yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yykind < YYNTOKENS ? "token" : "nterm", yysymbol_name (yykind));

  yy_symbol_value_print (yyo, yykind, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp,
                 int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       YY_ACCESSING_SYMBOL (+yyssp[yyi + 1 - yynrhs]),
                       &yyvsp[(yyi + 1) - (yynrhs)]);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args) ((void) 0)
# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif






/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg,
            yysymbol_kind_t yykind, YYSTYPE *yyvaluep)
{
  YY_USE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yykind, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/* Lookahead token kind.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;




/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate = 0;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus = 0;

    /* Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* Their size.  */
    YYPTRDIFF_T yystacksize = YYINITDEPTH;

    /* The state stack: array, bottom, top.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss = yyssa;
    yy_state_t *yyssp = yyss;

    /* The semantic value stack: array, bottom, top.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs = yyvsa;
    YYSTYPE *yyvsp = yyvs;

  int yyn;
  /* The return value of yyparse.  */
  int yyresult;
  /* Lookahead symbol kind.  */
  yysymbol_kind_t yytoken = YYSYMBOL_YYEMPTY;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yychar = YYEMPTY; /* Cause a token to be read.  */

  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END
  YY_STACK_PRINT (yyss, yyssp);

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    YYNOMEM;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        YYNOMEM;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          YYNOMEM;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */


  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token\n"));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = YYEOF;
      yytoken = YYSYMBOL_YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else if (yychar == YYerror)
    {
      /* The scanner already issued an error message, process directly
         to error recovery.  But do not keep the error token as
         lookahead, it is too special and may lead us to an endless
         loop in error recovery. */
      yychar = YYUNDEF;
      yytoken = YYSYMBOL_YYerror;
      goto yyerrlab1;
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 6: /* declaracao_ou_comando: declaracao  */
#line 145 "yacc/yacc.y"
                                  { printf("Declaração reconhecida.\n"); }
#line 1398 "yacc/yacc.tab.c"
    break;

  case 7: /* declaracao_ou_comando: comando  */
#line 146 "yacc/yacc.y"
                                  { printf("Comando reconhecido.\n"); }
#line 1404 "yacc/yacc.tab.c"
    break;

  case 14: /* declaracao_homunculus: IDENTIFIER LBRACE corpo_homunculus RBRACE KW_HOMUNCULUS SEMICOLON  */
#line 161 "yacc/yacc.y"
                    { printf("Declaração Homunculus: %s\n", (yyvsp[-5].str)); /* Ação: Registrar tipo homunculus $1 com corpo $3 */ free((yyvsp[-5].str)); }
#line 1410 "yacc/yacc.tab.c"
    break;

  case 17: /* declaracao_enumeracao: IDENTIFIER LBRACE lista_enum_ident RBRACE KW_ENUMERARE SEMICOLON  */
#line 168 "yacc/yacc.y"
                    { printf("Declaração Enumerare para %s\n", (yyvsp[-5].str)); /* Ação: Registrar enum $1 com identificadores $3 */ free((yyvsp[-5].str)); }
#line 1416 "yacc/yacc.tab.c"
    break;

  case 18: /* lista_enum_ident: IDENTIFIER  */
#line 170 "yacc/yacc.y"
                             { free((yyvsp[0].str)); }
#line 1422 "yacc/yacc.tab.c"
    break;

  case 19: /* lista_enum_ident: lista_enum_ident PIPE IDENTIFIER  */
#line 171 "yacc/yacc.y"
                                                   { free((yyvsp[0].str)); }
#line 1428 "yacc/yacc.tab.c"
    break;

  case 20: /* declaracao_designacao: tipo IDENTIFIER KW_DESIGNARE SEMICOLON  */
#line 175 "yacc/yacc.y"
                    { printf("Designare (typedef): %s\n", (yyvsp[-2].str)); /* Ação: Registrar typedef: $2 é um alias para $1 */ free((yyvsp[-2].str)); }
#line 1434 "yacc/yacc.tab.c"
    break;

  case 21: /* declaracao_variavel: IDENTIFIER tipo SEMICOLON  */
#line 179 "yacc/yacc.y"
                    { printf("Declaração de Variável: %s\n", (yyvsp[-2].str)); /* Ação: Inserir $1 na tabela de símbolos com tipo $2 */ free((yyvsp[-2].str)); }
#line 1440 "yacc/yacc.tab.c"
    break;

  case 22: /* declaracao_variavel: KW_MOL IDENTIFIER tipo SEMICOLON  */
#line 181 "yacc/yacc.y"
                    { printf("Declaração de Constante (mol): %s\n", (yyvsp[-2].str)); /* Ação: Inserir $2 como constante com tipo $3 */ free((yyvsp[-2].str)); }
#line 1446 "yacc/yacc.tab.c"
    break;

  case 23: /* declaracao_variavel: IDENTIFIER tipo OP_ARROW_ASSIGN expressao SEMICOLON  */
#line 183 "yacc/yacc.y"
                    { printf("Declaração de Variável com Inicialização: %s\n", (yyvsp[-4].str)); /* Ação: Inserir $1 com tipo $2, inicializado com $4 */ free((yyvsp[-4].str)); }
#line 1452 "yacc/yacc.tab.c"
    break;

  case 24: /* declaracao_variavel: KW_MOL IDENTIFIER tipo OP_ARROW_ASSIGN expressao SEMICOLON  */
#line 185 "yacc/yacc.y"
                    { printf("Declaração de Constante (mol) com Inicialização: %s\n", (yyvsp[-4].str)); /* Ação: Inserir $2 como constante com tipo $3, inicializado com $5 */ free((yyvsp[-4].str)); }
#line 1458 "yacc/yacc.tab.c"
    break;

  case 25: /* declaracao_funcao: KW_FORMULA LPAREN lista_parametros_opt RPAREN IDENTIFIER OP_ARROW_ASSIGN tipo LBRACE programa RBRACE  */
#line 189 "yacc/yacc.y"
                { printf("Declaração de Função (formula): %s\n", (yyvsp[-5].str)); /* Ação: Registrar função $5 com parâmetros $3, tipo de retorno $7 e corpo $9 */ free((yyvsp[-5].str)); }
#line 1464 "yacc/yacc.tab.c"
    break;

  case 42: /* nome_tipo_base: IDENTIFIER  */
#line 213 "yacc/yacc.y"
                                { printf("Tipo definido pelo usuário (homunculus/designare): %s\n", (yyvsp[0].str)); /* Ação: $1 é um nome de tipo */ free((yyvsp[0].str)); }
#line 1470 "yacc/yacc.tab.c"
    break;

  case 45: /* parametro: IDENTIFIER tipo  */
#line 220 "yacc/yacc.y"
            { printf("Parâmetro: %s\n", (yyvsp[-1].str)); /* Ação: Processar parâmetro $1 com tipo $2 */ free((yyvsp[-1].str)); }
#line 1476 "yacc/yacc.tab.c"
    break;

  case 59: /* comando_atribuicao: expressao OP_ARROW_ASSIGN expressao_posfixa  */
#line 240 "yacc/yacc.y"
                  { printf("Comando de Atribuição (-->)\n"); /* Ação: Atribuir $1 a $3. Verificar tipos. */ }
#line 1482 "yacc/yacc.tab.c"
    break;

  case 108: /* expressao_posfixa: expressao_posfixa OP_ACCESS_MEMBER IDENTIFIER  */
#line 335 "yacc/yacc.y"
                                                                 { free((yyvsp[0].str)); }
#line 1488 "yacc/yacc.tab.c"
    break;

  case 109: /* expressao_posfixa: expressao_posfixa OP_ACCESS_POINTER IDENTIFIER  */
#line 336 "yacc/yacc.y"
                                                                  { free((yyvsp[0].str)); }
#line 1494 "yacc/yacc.tab.c"
    break;

  case 112: /* primario: IDENTIFIER  */
#line 341 "yacc/yacc.y"
                                    { /* Ação: Referenciar $1 na tabela de símbolos */ (yyval.str) = (yyvsp[0].str); }
#line 1500 "yacc/yacc.tab.c"
    break;

  case 113: /* primario: LIT_INT  */
#line 342 "yacc/yacc.y"
                                    { /* Ação: Converter inteiro em string ou nó de AST */ (yyval.str) = NULL; }
#line 1506 "yacc/yacc.tab.c"
    break;

  case 114: /* primario: LIT_FLOAT  */
#line 343 "yacc/yacc.y"
                                    { (yyval.str) = NULL; }
#line 1512 "yacc/yacc.tab.c"
    break;

  case 115: /* primario: LIT_STRING  */
#line 344 "yacc/yacc.y"
                                    { (yyval.str) = (yyvsp[0].str); }
#line 1518 "yacc/yacc.tab.c"
    break;

  case 116: /* primario: LIT_FACTUM  */
#line 345 "yacc/yacc.y"
                                    { (yyval.str) = NULL; }
#line 1524 "yacc/yacc.tab.c"
    break;

  case 117: /* primario: LIT_FICTUM  */
#line 346 "yacc/yacc.y"
                                    { (yyval.str) = NULL; }
#line 1530 "yacc/yacc.tab.c"
    break;

  case 118: /* primario: LPAREN expressao RPAREN  */
#line 347 "yacc/yacc.y"
                                    { (yyval.str) = (yyvsp[-1].str); }
#line 1536 "yacc/yacc.tab.c"
    break;

  case 123: /* chamada_funcao: LPAREN lista_argumentos_opt RPAREN IDENTIFIER  */
#line 357 "yacc/yacc.y"
              { printf("Chamada de Função: %s\n", (yyvsp[0].str)); /* Ação: Criar nó de chamada de função para $4 com argumentos $2 */ free((yyvsp[0].str)); }
#line 1542 "yacc/yacc.tab.c"
    break;


#line 1546 "yacc/yacc.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", YY_CAST (yysymbol_kind_t, yyr1[yyn]), &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYSYMBOL_YYEMPTY : YYTRANSLATE (yychar);
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
      yyerror (YY_("syntax error"));
    }

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;
  ++yynerrs;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  /* Pop stack until we find a state that shifts the error token.  */
  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYSYMBOL_YYerror;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYSYMBOL_YYerror)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  YY_ACCESSING_SYMBOL (yystate), yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", YY_ACCESSING_SYMBOL (yyn), yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturnlab;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturnlab;


/*-----------------------------------------------------------.
| yyexhaustedlab -- YYNOMEM (memory exhaustion) comes here.  |
`-----------------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  goto yyreturnlab;


/*----------------------------------------------------------.
| yyreturnlab -- parsing is finished, clean up and return.  |
`----------------------------------------------------------*/
yyreturnlab:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  YY_ACCESSING_SYMBOL (+*yyssp), yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif

  return yyresult;
}

#line 367 "yacc/yacc.y"


int main(int argc, char *argv[]) {
    // st_global = create_symbol_table(100); // Exemplo de inicialização da tabela
    
    if (argc > 1) {
        FILE *inputFile = fopen(argv[1], "r");
        if (!inputFile) {
            perror(argv[1]);
            return 1;
        }
        yyin = inputFile; // Define a entrada do lexer para o arquivo
    } else {
        printf("Lendo da entrada padrão (Ctrl+D para finalizar):\n");
        yyin = stdin; // Entrada padrão se nenhum arquivo for fornecido
    }

    printf("--- Iniciando Análise ---\n");
    int result = yyparse(); // Inicia a análise sintática
    
    if (result == 0) {
        printf("--- Análise Concluída: Programa sintaticamente correto ---\n");
    } else {
        printf("--- Análise Concluída: Programa sintaticamente incorreto ---\n");
    }

    // if (st_global) {
    //     printf("\n--- Conteúdo da Tabela de Símbolos ---\n");
    //     print_symbol_table(st_global, stdout);
    //     destroy_symbol_table(st_global);
    // }
    
    if (argc > 1 && yyin != stdin) {
        fclose(yyin);
    }
    return result;
}

// Função de tratamento de erro do Yacc/Bison
void yyerror(const char *s) {
    // yylineno é uma variável global mantida pelo Lex/Flex
    fprintf(stderr, "ERRO SINTÁTICO na linha %d: %s\n", yylineno, s);
}
