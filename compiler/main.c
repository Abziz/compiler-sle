
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lps.tab.h"
FILE * stxFile;
extern FILE *yyout,*yyin;
extern int lineCounter;

int yyparse();

int main(int argc, char* argv[])
{
  char * stxFileName;
  char * lstFileName;
  char * pt;
  int res;
  if(argc < 2){
    fprintf(stderr, "Not enough arguments\n");
    exit(0);
  }

  if(strrchr(argv[1],'.')){
    if(strcmp(".SLE", strrchr(argv[1],'.')) != 0 && strcmp(".sle", strrchr(argv[1],'.')) != 0 ) {
      fprintf(stderr, "The file has the wrong extension\n");
      exit(0);
    }
  }else {
    fprintf(stderr, "Wrong input file\n");
    exit(0);
  }

  stxFileName = (char *) malloc(sizeof(argv[1]) + 1);
  lstFileName = (char *) malloc(sizeof(argv[1]) + 1);

  if(!stxFileName || !lstFileName){
    fprintf(stderr, "malloc error\n");
    exit(0);
  }

  strcpy(stxFileName, argv[1]);
  strcpy(lstFileName, argv[1]);

  pt = strrchr(argv[1], '.');

  stxFileName[pt-argv[1] + 1] = 's';
  stxFileName[pt-argv[1] + 2] = 't';
  stxFileName[pt-argv[1] + 3] = 'x';

  lstFileName[pt-argv[1] + 1] = 'l';
  lstFileName[pt-argv[1] + 2] = 's';
  lstFileName[pt-argv[1] + 3] = 't';

  yyin = fopen(argv[1], "r");
  if(yyin == NULL){
    fprintf(stderr, "Can't open input file\n");
    exit(0);
  }

  yyout = fopen(lstFileName,"w");
  stxFile = fopen(stxFileName,"w");

  if(yyout == NULL || stxFile == NULL){
    fprintf(stderr, "Can't open output file\n");
    exit(0);
  }

  fprintf(yyout, "%d\t", lineCounter);

  res = yyparse();

  if(res == 0){
    printf("yyparse succeed\n");
  }

  fclose(stxFile);
  return 0;
}


void insertToSymbolTable(const char * id,numType type){
  node * elem = (node*)malloc(1*sizeof(node));
  if( elem == NULL ){
    fprintf(stderr, "malloc was fucked up\n");
  }
  strcpy(elem->id, id);
  elem->type = type;
  elem->next = head;
  head = elem;
  printf("added %s to symbol table.\n",id);
}

void updateSymbol( char * id, number val){
  node* temp = head;
  while( temp ){
    if(!strcmp(temp->id,id)){
      switch(temp->type){
        case INTEGER:
        temp->val.ival = val.ival;
        return;
        case FLOAT:
        temp->val.fval = val.fval;
        return;
      }
    }
    temp=temp->next;
  }
  fprintf(stderr, "Identifier %s could not be resolved.\n",id );
}
