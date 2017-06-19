%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>

typedef enum { TRUE =1 ,FALSE=0} bool;
typedef enum { INTEGER , FLOAT ,ERROR} Type;
typedef struct number {
  int ival;
  float fval;
  Type type;
} number;



extern FILE *yyout,*yyin;
extern int lineCounter;
extern char* yytext;
void insertToSymbolTable(const char * id,number num);
void updateSymbol(const char * id, number rhs);
number GetValueFromSymbol(const char* id);
number operatorMUL(number lhs, char opr,number rhs);
number operatorADD(number lhs, char opr,number rhs);
bool evaluate_bool(number lhs,char opr, number rhs);
void printExpression(number num);
int yylex();
void yyerror(char* s){
        fprintf(stderr, "%s ,at line %d\n", s, lineCounter);
}

%}
%union {
 number num;
 char id[16];
 char opr;
 bool boolean;
}


%token <id> ID
%token <num> NUM
%left <opr> ADDOP MULOP RELOP LOGOP

%type <num> Type
%type <num> Expression
%type <num> Term
%type <num> Factor
%type <opr> Case
%type <boolean> BoolExp

%token START DO ELSE IF ENDI INT PUT PROG
%token GET REAL THEN VAR LOOP ENDL UNTIL ENDP
%token DOT SEMICOL COL COMMA LPAR RPAR
%left ASSIGNOP
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
        | DeclList COMMA ID error { yyerror("Expected colon after identifier.");}
        | DeclList COMMA error { yyerror("expected identifier after ','");}
        | DeclList error { yyerror("expected ',' after declaration list");}
        | ID COL Type   { insertToSymbolTable($1,$3);}
        | ID error { yyerror("expected colon after identifier");}
        | error { yyerror("Expected identifier after 'var'");}
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
        | IF BoolExp THEN StmtList ELSE StmtList error {yyerror("expected 'endi' at end of statement");}
        | IF BoolExp THEN StmtList ENDI    { }
        | IF BoolExp THEN StmtList error { yyerror("Expected 'endi' or 'else' at end of statement");}
        | IF BoolExp error { yyerror("Missing 'then' after 'if' ");}
        | LOOP BoolExp DO StmtList ENDL    { }
        | LOOP BoolExp DO StmtList error { yyerror("Expected 'endl' at end of statement"); }
        | LOOP BoolExp error { yyerror("Expected 'do' after 'loop'");}
        | DO StmtList UNTIL BoolExp ENDL   { }
        | DO StmtList UNTIL BoolExp error { yyerror("Expected 'endl' at end of statement");}
        | DO StmtList error {yyerror("Expected 'until' after 'do'");}
        | error {yyerror("undefined beginning of a statement");}
;
BoolExp: Expression Case Expression { $$ = evaluate_bool($1,$2,$3); fprintf(stdout,"evaluated %s\n",$$==TRUE?"true":"false");}
;
Case: RELOP     {$$=$1;}
    | LOGOP     {$$=$1;}
;

Expression: Expression ADDOP Term   { $$=operatorADD($1,$2,$3);}
      | Expression error  {yyerror("Expected '+' or '-' after expression.");}
      | Term    { $$=$1;}
;
Term: Term MULOP Factor     {$$ = operatorMUL($1,$2,$3); }
    | Term error  {yyerror("Expected '*','/' or 'mod' after term.");}
    | Factor    { $$ = $1;}
;
Factor: ID  { $$ = GetValueFromSymbol($1);}
      | NUM  {$$ = $1;}
      | LPAR Expression RPAR    { $$ = $2;}
      | LPAR Expression error  {yyerror("missing closing parenthesis.");}
      | error {yyerror("Expected an identifier or a number.");}
;

%%
