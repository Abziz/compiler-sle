/* A Bison parser, made by GNU Bison 2.4.2.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2006, 2009-2010 Free Software
   Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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

/* "%code requires" blocks.  */

/* Line 1685 of yacc.c  */
#line 20 "lps.y"

  #include <stdlib.h>
  typedef enum { INTEGER , FLOAT } Type;

  typedef struct {
    int ival;
    float fval;
    Type type;
  } number;


  typedef struct node {
    char id[16];
    number num;
    struct node* next;
  } node;


  void insertToSymbolTable(const char * id,number num);
  node * findById(node * head ,const char* id);
  void updateSymbol(const char * id, number rhs);
  void printAll(node* list);
  number GetValueFromSymbol(const char* id);
  number operatorMUL(number lhs, char opr,number rhs);
  number operatorADD(number lhs, char opr,number rhs);
  void feedback(const char * tok,const char * rule);



/* Line 1685 of yacc.c  */
#line 69 "lps.tab.h"

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ID = 258,
     NUM = 259,
     MULOP = 260,
     ADDOP = 261,
     START = 262,
     DO = 263,
     ELSE = 264,
     IF = 265,
     ENDI = 266,
     INT = 267,
     PUT = 268,
     PROG = 269,
     GET = 270,
     REAL = 271,
     THEN = 272,
     VAR = 273,
     LOOP = 274,
     ENDL = 275,
     UNTIL = 276,
     ENDP = 277,
     DOT = 278,
     SEMICOL = 279,
     COL = 280,
     COMMA = 281,
     LPAR = 282,
     RPAR = 283,
     LOGOP = 284,
     ASSIGNOP = 285,
     RELOP = 286
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1685 of yacc.c  */
#line 49 "lps.y"

  char id[16];
  char opr;
  number num;



/* Line 1685 of yacc.c  */
#line 125 "lps.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


