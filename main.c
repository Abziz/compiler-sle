
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
    fprintf(stderr,"damn nigga %s",argv[1]);
    exit(1);
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




void insertToSymbolTable(const char * id,number num){
  node* test = findById(head,id);
  if( test != NULL){
    fprintf(stderr, "Symbol %s allready defined.\n",id);
    return;
  }
  node * elem = (node*)malloc(1*sizeof(node));
  if( elem == NULL ){
    fprintf(stderr, "malloc was fucked up\n");
    exit(1);
  }
  strcpy(elem->id, id);
  elem->num.type = num.type;
  elem->next = head;
  head = elem;
  fprintf(stdout,"added %s to symbol table.\n",id);
}

node * findById(node * list,const char* id){
  while( list ){
    if(!strcmp(list->id,id)){
      break;
    }
    list = list->next;
  }
  return list;
}

void updateSymbol(const char * id, number rhs){
  node* elem = findById(head,id);
  if( !elem ){
    fprintf(stderr, "Symbol %s could not be resolved.\n",id );
    return;
  }
  if(elem->num.type == FLOAT){
    elem->num.fval = rhs.type==FLOAT? rhs.fval:(float)rhs.ival;
  }else{
    elem->num.ival = rhs.type==FLOAT? (int)rhs.fval:rhs.ival;
  }
  return;
}

void printAll(node* list){
  while( list ){
    fprintf(stdout,"%s : %f \n",list->id,list->num.type==FLOAT? list->num.fval:list->num.ival);
    list = list->next;
  }
}

number GetValueFromSymbol(node* list,const char* id){
  node* temp = findById(list,id);
  if( !temp ){
    return temp->num;
  }
  fprintf(stderr,"Symbol %s could not be resolved.\n",id);
  number error;
  return error;
}

number operatorADD(number lhs, char opr,number rhs){
  number ans;
  float x = lhs.type == FLOAT? lhs.fval:(float)lhs.ival;
  float y = rhs.type == FLOAT? rhs.fval:(float)lhs.ival;
  y = opr == '-' ? -y:y;
  if( lhs.type == INT && rhs.type == INT){
    ans.type == INT;
    ans.ival = (int)(x+y);
  }
  else{
    ans.type == FLOAT;
    ans.fval = x+y;
  }
  return ans;
}

number operatorMUL(number lhs, char opr,number rhs){
  number ans;
  float x = lhs.type == FLOAT? lhs.fval:(float)lhs.ival;
  float y = rhs.type == FLOAT? rhs.fval:(float)lhs.ival;
  if( lhs.type == INT && rhs.type == INT){
    ans.type == INT;
  }
  else{
    ans.type == FLOAT;
  }

  switch( opr ){
    case '*':
    if(ans.type == FLOAT){
      ans.fval = x*y;
    }else{
      ans.ival = (int)(x*y);
    }
    break;
    case '%':
    if( ans.type == INT){
      ans.ival = lhs.ival % rhs.ival;
    }else{
      fprintf(stderr,"Operand types missmatch for operator mod\n");
    }
    break;
    case '/':
    if( y != 0){
      if( ans.type == FLOAT){
        ans.fval = x/y;
      }else{
        ans.ival = (int)x/y;
      }
      break;
    }
    fprintf(stderr,"The universe is complicated therefore can not divide by zero.\n");
    break;
  }
  return ans;
}
