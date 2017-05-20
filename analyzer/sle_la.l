%{
	#include "lps.tab.h"
	int line = 1;
	int column = 1;
	extern void printError(const char * fmt, ...);
	extern char *src;
	#define UPDATE_COL column+=yyleng;
	#define UPDATE_LINE column=1;line++;

	typedef enum{
		LT=1,GT,EQ,NE,MIN,ADD,MUL,DIV,MOD,AND,NEG,NOT
	} attribute;
	int att;
%}


letter		[a-zA-Z]
digit		[0-9]
id			{letter}({letter}|{digit})*
num			{digit}+|({digit}+"."{digit}+)
logop		\&)|~|\!
addop		\+|\-
mulop		\*|\/|mod
asignop		<\=
ws			 [ \t]+
%x comment

%%
"/*"		BEGIN comment;
<comment>"*/"	BEGIN INITIAL;
<comment>.|\n	;

start		{ECHO;UPDATE_COL;return START;}
do			{ECHO;UPDATE_COL;return DO;}
else		{ECHO;UPDATE_COL;return ELSE;}
if			{ECHO;UPDATE_COL;return IF;}
endi		{ECHO;UPDATE_COL;return ENDI;}
int			{ECHO;UPDATE_COL;return INT;}
put			{ECHO;UPDATE_COL;return PUT;}
prog 		{ECHO;UPDATE_COL;return PROG;}
get			{ECHO;UPDATE_COL;return GET;}
real		{ECHO;UPDATE_COL;return REAL;}
then		{ECHO;UPDATE_COL;return THEN;}
var			{ECHO;UPDATE_COL;return VAR;}
loop		{ECHO;UPDATE_COL;return LOOP;}
endl		{ECHO;UPDATE_COL;return ENDL;}
until		{ECHO;UPDATE_COL;return UNTIL;}
endp		{ECHO;UPDATE_COL;return ENDP;}
"."			{ECHO;column++;return DOT;}
";"			{ECHO;column++;return SEMICOLON;}
":"			{ECHO;column++;return COLON;}
","			{ECHO;column++;return COMMA;}
")"			{ECHO;column++;return RPAR;}
"("			{ECHO;column++;return LPAR;}
"<"			{ECHO;column++;att = LT; return RELOP;}
">"			{ECHO;column++;att = GT; return RELOP;}
"<>"		{ECHO;column+=2;att = NE; return RELOP;}
"="			{ECHO;column++;att = EQ; return RELOP;}
"&"			{ECHO;column++;att = AND; return LOGOP;}
"~"	 		{ECHO;column++;att = NEG; return LOGOP;}
"!"			{ECHO;column++;att = NOT; return LOGOP;}
"+"			{ECHO;column++;att = ADD; return ADDOP;}
"-"			{ECHO;column++;att = MIN; return ADDOP;}
"*"			{ECHO;column++;att = MUL; return MULOP;}
"/"			{ECHO;column++;att = DIV; return MULOP;}
"%"			{ECHO;column++;att = MOD; return MULOP;}
"<="		{ECHO;column+=2;return ASSIGNOP;}
{id}		{ECHO;UPDATE_COL;return ID;}
{num} 		{ECHO;UPDATE_COL;return NUM;}
{ws}		{ECHO;UPDATE_COL;}
\n 			{UPDATE_LINE fprintf(yyout,"\n%d ", line);}
. 			{UPDATE_COL printError("\n%s.sle:%d:%d syntax error: '%s' was not expected.\n",src,line,column-yyleng,yytext); exit(1);}
%%


int yywrap(){
	return 1;
}
