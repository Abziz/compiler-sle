%{
#include <stdio.h>
#include "lps.tab.h"

int lineCounter = 1;

%}

LETTER	[a-zA-Z]
DIGIT		[0-9]
ID			{LETTER}({LETTER}|{DIGIT})*
NUM 		{DIGIT}*("."?){DIGIT}
WS			[ \t]+

%x comment
%%

"/*"		BEGIN comment;
<comment>"*/"	BEGIN INITIAL;
<comment>.|\n	;

start	{ECHO; return START;}
do		{ECHO; return DO;}
else	{ECHO; return ELSE;}
if		{ECHO; return IF;}
endi	{ECHO; return ENDI;}
int		{ECHO; return INT;}
put		{ECHO; return PUT;}
prog	{ECHO; return PROG;}
get		{ECHO; return GET;}
real	{ECHO; return REAL;}
then	{ECHO; return THEN;}
var		{ECHO; return VAR;}
loop	{ECHO; return LOOP;}
endl	{ECHO; return ENDL;}
until	{ECHO; return UNTIL;}
endp	{ECHO; return ENDP;}
mod		{ECHO;  yylval.opr = '%';  return MULOP;}

"."		{ECHO; return DOT;}
";"		{ECHO; return SEMICOL;}
":"		{ECHO; return COL;}
","		{ECHO; return COMMA;}
")"		{ECHO; return LPAR;}
"("		{ECHO; return RPAR;}

{ID}	{ECHO; strcpy(yylval.id,yytext); return ID;}

{NUM}	{ ECHO;
				if(strchr(yytext,'.')){
					yylval.num.fval = atof(yytext);
					yylval.num.type = FLOAT;
				}else{
					yylval.num.ival = atoi(yytext);
					yylval.num.type = INTEGER;
				}
				return NUM;
			}
"<"			{ECHO; return RELOP;}
">"			{ECHO; return RELOP;}
"<>"		{ECHO; return RELOP;}
"="			{ECHO; return RELOP;}

"&"		{ECHO; return LOGOP;}
"~"		{ECHO; return LOGOP;}

"+"		{ECHO; yylval.opr = *yytext; return ADDOP;}
"-"		{ECHO; yylval.opr = *yytext; return ADDOP;}

"*"		{ECHO; yylval.opr = *yytext; return MULOP;}
"/"		{ECHO; yylval.opr = *yytext; return MULOP;}


"<="	{ECHO; return ASSIGNOP;}

{WS}	ECHO;

\n      {lineCounter++; fprintf(yyout, "\n%d\t", lineCounter);}

.		{fprintf(yyout, "Lexical error occur on the lexeme (%s)", yytext); exit(0);}

%%

int yywrap()
{
	return 1;
}
