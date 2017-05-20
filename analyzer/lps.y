%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

FILE *stx;

void yyerror(const char* err);
int yylex();
%}
%locations


%token START
%token DO
%token ELSE
%token IF
%token ENDI
%token INT
%token PUT
%token PROG
%token GET
%token REAL
%token THEN
%token VAR
%token LOOP
%token ENDL
%token UNTIL
%token ENDP
%token DOT
%token SEMICOLON
%token COLON
%token COMMA
%token RPAR
%token LPAR
%token ID
%token NUM
%token RELOP
%token LOGOP
%token ADDOP
%token MULOP
%token ASSIGNOP


%start Program

%%
Program: PROG ID SEMICOLON Declarations START StmtList ENDP DOT		{fprintf(stx,"Program: PROG ID SEMICOLON Declarations START StmtList ENDP DOT\n"); return 0;}
	|error 															{return 0;}
;
Declarations: VAR DecList SEMICOLON	 								{fprintf(stx,"Declarations: VAR DecList SEMICOLON\n");}
	|error															{return 0;}
;
DecList: DecList COMMA ID COLON Type								{fprintf(stx,"DecList: DecList COMMA ID COLON Type\n");}
	|ID COLON Type													{fprintf(stx,"DecList: ID COLON Type\n");}
	|error															{return 0;}
;
Type: INT 															{fprintf(stx,"Type: INT\n");}
	|REAL															{fprintf(stx,"Type: REAL\n");}
	|error															{return 0;}
;
StmtList: StmtList Statment SEMICOLON 								{fprintf(stx,"StmtList: StmtList Statment SEMICOLON\n");}
	| 																{fprintf(stx,"StmtList: \'epsilon\'\n");}
;
Statment: ID ASSIGNOP Expression									{fprintf(stx,"Statment: ID ASSIGNOP Expression\n");}
	|PUT Expression													{fprintf(stx,"Statment: PUT Expression\n");}
	|GET ID															{fprintf(stx,"Statment: GET ID\n");}
	|IF BoolExp THEN StmtList ELSE StmtList ENDI					{fprintf(stx,"Statment: IF BoolExp THEN StmtList ELSE StmtList ENDI\n");}
	|IF BoolExp THEN StmtList ENDI									{fprintf(stx,"Statment: IF BoolExp THEN StmtList ENDI\n");}
	|LOOP BoolExp DO StmtList ENDL									{fprintf(stx,"Statment: LOOP BoolExp DO StmtList ENDL\n");}
	|DO StmtList UNTIL BoolExp ENDL									{fprintf(stx,"Statment: DO StmtList UNTIL BoolExp ENDL\n");}
	|error															{return 0;}
;
BoolExp: Expression Case Expression									{fprintf(stx,"BoolExp: Expression Case Expression\n");}
;
Case: RELOP 														{fprintf(stx,"Case: RELOP\n");}
	|LOGOP															{fprintf(stx,"Case: LOGOP\n");}
	|error 															{return 0;}
;
Expression: Expression ADDOP Term 									{fprintf(stx,"Expression: Expression ADDOP Term\n");}
	|Term															{fprintf(stx,"Expression: Term\n");}
;
Term: Term MULOP Factor												{fprintf(stx,"Term: Term MULOP Factor\n");}
	|Factor															{fprintf(stx,"Term: Factor\n");}
;
Factor: ID 															{fprintf(stx,"Factor: ID\n");}
	|NUM 															{fprintf(stx,"Factor: NUM\n");}
	|LPAR Expression RPAR											{fprintf(stx,"Factor: LPAR Expression RPAR\n");}
	|error {return 0;}
;
%%
