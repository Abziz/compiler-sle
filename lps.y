%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>

extern FILE *yyout,*yyin;
extern int lineCounter;
extern char* yytext;


void yyerror(char* s){
        fprintf(stderr, "%s ,at line %d\n", s, lineCounter);
}

int yylex();

%}

%code requires {
  #include <stdlib.h>
  typedef enum { TRUE =1 ,FALSE=0} bool;
  typedef enum { INTEGER , FLOAT ,ERROR} Type;


  typedef struct {
    int ival;
    float fval;
    Type type;
  } number;


  typedef struct node {
    char id[16];
    number num;
    bool visited;
    struct node* next;
  } node;

  typedef struct undefined{
    char id[16];
    struct undefined* next;
  } undefined;

  void insertToSymbolTable(const char * id,number num);
  void updateSymbol(const char * id, number rhs);
  number GetValueFromSymbol(const char* id);
  number operatorMUL(number lhs, char opr,number rhs);
  number operatorADD(number lhs, char opr,number rhs);
  void printExpression(number num);
}


%union {
  char id[16];
  char opr;
  number num;
};

%token <id> ID
%token <num> NUM
%left <opr> ADDOP MULOP

%type <num> Type
%type <num> Expression
%type <num> Term
%type <num> Factor


%token START DO ELSE IF ENDI INT PUT PROG
%token GET REAL THEN VAR LOOP ENDL UNTIL ENDP
%token DOT SEMICOL COL COMMA LPAR RPAR
%left RELOP ASSIGNOP LOGOP
%%
Program: PROG ID SEMICOL Declarations START StmtList ENDP DOT { number progname; insertToSymbolTable($2,progname); }
      | PROG ID SEMICOL Declarations START StmtList ENDP error { yyerror("Missing '.' at end of program.");}
      | PROG ID SEMICOL Declarations START StmtList error  { yyerror("Missing 'endp' at end of program.");}
      | PROG ID SEMICOL Declarations error { yyerror("undefined reference to 'start'.");}
      | PROG ID error {yyerror("missing semi colon after program name.");}
      | PROG error {yyerror("illegal program name.");}
      | error {yyerror("program must start with token 'prog'.");}
;
Declarations: VAR DeclList SEMICOL
      | VAR DeclList error { yyerror("Expected semicolon after declaration.");}
      | error { yyerror("token 'var' was expected.");}
;
DeclList: DeclList COMMA ID COL Type  { insertToSymbolTable($3,$5);}
        | ID COL Type   { insertToSymbolTable($1,$3);}
;
Type: INT   { $$.type = INTEGER;}
    | REAL  { $$.type = FLOAT;}
;
StmtList: StmtList Statement SEMICOL {}
| StmtList Statement error { yyerror("Expected semicolon after statement.");}
| /* empty string */ {}
;
Statement: ID ASSIGNOP Expression   { updateSymbol($1,$3); }
        | ID error {yyerror("Expected symbol '<=' after identifier.");}
        | PUT Expression   { printExpression($2);}
        | GET ID   { number one ={1,1,GetValueFromSymbol($2).type}; updateSymbol($2,one);}
        | GET error {yyerror("expected identifier after 'get'.");}
        | IF BoolExp THEN StmtList ELSE StmtList ENDI {}
        | IF BoolExp THEN StmtList ENDI    { }
        | LOOP BoolExp DO StmtList ENDL    { }
        | DO StmtList UNTIL BoolExp ENDL   { }
;
BoolExp: Expression Case Expression     { }
;
Case: RELOP     { }
    | LOGOP     { }
;
Expression: Expression ADDOP Term   { $$=operatorADD($1,$2,$3);}
      | Expression error {yyerror("Expected '+' or '-' after expression.");}
      | Term    { $$=$1;}
;
Term: Term MULOP Factor     {$$ = operatorMUL($1,$2,$3); }
    | Term error {yyerror("Expected '*','\' or 'mod' after term.");}
    | Factor    { $$ = $1;}
;
Factor: ID  { $$ = GetValueFromSymbol($1);}
      | NUM  {$$ = $1;}
      | LPAR Expression RPAR    { $$ = $2;}
      | LPAR Expression error {yyerror("missing closing parenthesis.");}
      | error {yyerror("Expected an identifier or a number.");}
;

%%
