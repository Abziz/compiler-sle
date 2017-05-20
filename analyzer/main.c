#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

#include "lps.tab.h"

extern int yyparse(),line,column,yyleng;
extern char * yytext;
extern FILE *yyin,*yyout,*stx;
const char * src;
void printError(const char * fmt, ...);

int main(int argc, char** argv){
	src = argv[1];
	char lstFile[20] = "";
	char stxFile[20] = "";
	int result;
	// project and input
	if(argc >= 2){
		if(strchr(argv[1],'.') != NULL){ // makesure file has an extension
			char * ext = strchr(argv[1],'.')+1;
			if(!strcmp("sle",ext) && !strcmp("SLE",ext)) // make sure extension is "sle"
			{
				perror("File must be of type '.sle' or '.SLE'\n");
				exit(1);
			}
		}
		else {
			perror("File must be of type '.sle' or '.SLE'\n");
			exit(1);
		}

		if((yyin = fopen(argv[1],"r")) == NULL){ // use file as yyin
			perror("Error openning file!");
			exit(1);
		}
		char* fileName = strtok(argv[1], ".");
		strcat(lstFile, fileName);
		strcat(lstFile, ".lst");
		strcat(stxFile, fileName);
		strcat(stxFile, ".stx");
		//yyout for lst and FILE* stx for stx.
		if(!(yyout = fopen(lstFile,"w")) || !(stx = fopen(stxFile, "w"))){
			perror("Error openning file");
		}
		/* shits going down here */
		int err = yyparse();
		if(err){
			fprintf(stdout,"parse was not successful\n",line);
		}else{
			fprintf(stdout,"parse was successful\n");
		}
		/* end shit*/
		fclose(stx);
		fclose(yyin);
		fclose(yyout);
	}else{
		perror("arguments not valid");
	}
	return 0;
}
void printError(const char * fmt, ...){
	va_list arglist;
	va_start( arglist, fmt );
	vfprintf(yyout,fmt,arglist);
	vfprintf(stdout,fmt,arglist);
}

int yyerror(const char * err){
	fprintf(yyout,"\n%s.sle:%d:%d:parser error: unexpected token %s \n",src,line,column-yyleng,yytext);
	fprintf(stdout,"\n%s.sle:%d:%d:parser error: unexpected token %s \n",src,line,column-yyleng,yytext);
	exit(1);
}
