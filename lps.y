%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>

extern FILE *yyout,*yyin;
extern int lineCounter;
extern char* yytext;
FILE * stxFile;

int yyerror(char* s){
        fprintf(stxFile, "\nparse error at:\"%s\" ,at line %d\n", yytext, lineCounter);
        fprintf(stderr, "parse error at:\"%s\" ,at line %d\n", yytext, lineCounter);
        //exit(1);
}

int yylex();

%}

%code requires {
  typedef enum numType { INTEGER , FLOAT } numType;
  typedef union {
    int ival;
    float fval;
  } number;

  typedef struct node {
    char id[16];
    number val;
    numType type;
    struct node* next;
  } node;
  static node* head = NULL;
  void insertToSymbolTable(const char * id,numType type);
  void updateSymbol(char * id, number val);
}


%union {
  char id[16];
  char opr;
  numType type;
  number num;
};

%token <id> ID
%token <num> NUM
%left <opr> ADDOP MULOP

%type <type> Type
%type <num> Expression
%type <num> Term
%type <num> Factor


%token START DO ELSE IF ENDI INT PUT PROG
%token GET REAL THEN VAR LOOP ENDL UNTIL ENDP
%token DOT SEMICOL COL COMMA LPAR RPAR
%left RELOP ASSIGNOP LOGOP
%%
Program: PROG ID SEMICOL Declarations START StmtList ENDP DOT
;
Declarations: VAR DeclList SEMICOL
;
DeclList: DeclList COMMA ID COL Type  { insertToSymbolTable($3,$5);}
        | ID COL Type   { insertToSymbolTable($1,$3);}
;
Type: INT   { $$= INTEGER;}
    | REAL  { $$= FLOAT;}
;
StmtList: StmtList Statement SEMICOL {}
        | /* empty string */ {}
;
Statement: ID ASSIGNOP Expression   { updateSymbol($1,$3); }
         | PUT Expression   { fprintf(stxFile, "Statement -> PUT Expression\n");}
         | GET ID   { fprintf(stxFile, "Statement -> GET ID\n");}
         | IF BoolExp THEN StmtList ELSE StmtList ENDI
            { fprintf(stxFile, "Statement -> IF BoolExp THEN StmtList ELSE StmtList ENDI\n");}
         | IF BoolExp THEN StmtList ENDI    { fprintf(stxFile, "Statement -> IF BoolExp THEN StmtList ENDI\n");}
         | LOOP BoolExp DO StmtList ENDL    { fprintf(stxFile, "Statement -> LOOP BoolExp DO StmtList ENDL\n");}
         | DO StmtList UNTIL BoolExp ENDL   { fprintf(stxFile, "Statement -> DO StmtList UNTIL BoolExp ENDL\n");}
;
BoolExp: Expression Case Expression     { fprintf(stxFile, "BoolExp -> Expression Case Expression\n");}
;
Case: RELOP     { fprintf(stxFile, "Case -> RELOP\n");}
    | LOGOP     { fprintf(stxFile, "Case -> LOGOP\n");}
;
Expression: Expression ADDOP Term   { fprintf(stxFile, "Expression -> Expression ADDOP Term\n");}
          | Term    { fprintf(stxFile, "Expression -> Term\n");}
;
Term: Term MULOP Factor     { fprintf(stxFile, "Term -> Term MULOP Factor\n");}
    | Factor    { fprintf(stxFile, "Term -> Factor\n");}
;
Factor: ID  { fprintf(stxFile, "Factor -> ID\n");}
      | NUM     { fprintf(stxFile, "Factor -> NUM\n");}
      | RPAR Expression LPAR    { fprintf(stxFile, "Factor -> RPAR Expression LPAR\n");}
;

%%
