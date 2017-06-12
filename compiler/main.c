
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lps.tab.h"

extern FILE *yyout,*yyin,*stxFile;
static node* head = NULL;

extern int lineCounter;
const char * src;
int yyparse();

int main(int argc, char** argv){
  src = argv[1];
  char lst[20] = "";
  char stx[20] = "";
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
    strcat(lst, fileName);
    strcat(lst, ".lst");
    strcat(stx, fileName);
    strcat(stx, ".stx");
    //yyout for lst and FILE* stx for stx.
    if(!(yyout = fopen(lst,"w")) || !(stxFile = fopen(stx, "w"))){
      perror("Error openning file");
    }
    /* shits going down here */
    int err = yyparse();
    if(err){
      fprintf(stdout,"parse was not successful\n");
    }else{
      fprintf(stdout,"parse was successful\n");
    }
    /* end shit*/
    fclose(stxFile);
    //		fclose(yyin);
    //		fclose(yyout);
  }else{
    perror("arguments not valid");
  }
  return 0;
}

void printExpression(number num){
  switch(num.type){
    case INTEGER:
    printf("%d\n",num.ival);
    return;
    case FLOAT:
    printf("%f\n",num.fval);
    return;
  }
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
}

node * findById(node * list,const char* id){
  node * temp = list;
  while( temp ){
    if(!strcmp(temp->id,id)){
      break;
    }
    temp = temp->next;
  }
  return temp;
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
    list = list->next;
  }
}

number GetValueFromSymbol(const char* id){
  node* temp = findById(head,id);
  if( temp != NULL ){
    return temp->num;
  }
  fprintf(stderr,"Symbol %s could not be resolved.\n",id);
  number error;
  return error;
}

number operatorADD(number lhs, char opr,number rhs){
  number ans;
  ans.ival = 0;
  ans.fval = 0;
  float x = lhs.type == FLOAT? lhs.fval:(float)lhs.ival;
  float y = rhs.type == FLOAT? rhs.fval:(float)rhs.ival;
  y = (opr=='-'? -y:y);
  if( lhs.type == INTEGER && rhs.type == INTEGER){
    ans.type = INTEGER;
    ans.ival = (int)(x+y);
  }
  else{
    ans.type = FLOAT;
    ans.fval = x+y;
  }

  return ans;
}

number operatorMUL(number lhs, char opr,number rhs){
  number ans;

  float x = lhs.type == FLOAT? lhs.fval:(float)lhs.ival;
  float y = rhs.type == FLOAT? rhs.fval:(float)rhs.ival;
  if( lhs.type == INTEGER && rhs.type == INTEGER){
    ans.type = INTEGER;
  }
  else{
    ans.type = FLOAT;
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
    if( ans.type == INTEGER){
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
