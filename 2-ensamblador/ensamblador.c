#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <ctype.h>
#include "ensamblador.h"

#define OPCODE_LEN 7
#define REG_LEN 6 
#define ADDRESS_LEN 17
#define LABEL_LEN 100
#define NUM_LABELS 64

extern int yylex();
extern int yylineno();
extern char* yytext;
extern int yyleng;



extern FILE * yyin;
extern FILE * yyout;


void getBin(int num, char *str, int binlen)
{ 
  *(str + binlen) = '\0';
  int mask = round(pow(2,binlen));
  while(mask >>= 1){
    *str++ = !!(mask & num) + '0';
  } 

  //printf("oh my, %d, %p, %d\n", num, str, binlen);
} 

int main(void)
{
  int ntoken;
  int reg_flag = 0, label_flag = 0,label_count = 0, newline_count = 1;
  int index_labels[NUM_LABELS];
  char labels[NUM_LABELS][LABEL_LEN];
  char opcode[OPCODE_LEN] = {0};
  char reg1[REG_LEN] = {0};
  char reg2[REG_LEN] = {0};
  char address[ADDRESS_LEN] = {0};
  FILE *input = fopen("test.asm", "r");
  FILE *output = fopen("test.txt", "w");
  if (!input || !output) {
    printf("I can't open the file!");
    return -1;
  }
  yyin = input;
  yyout = output;
  //printf("opcode:%p\nreg1:%p\nreg2:%p\naddress:%p\n", opcode, reg1, reg2, address);
  //printf("---\n");


  ntoken = yylex();
  while(ntoken) {
    switch (ntoken) {
      case NOP:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case ADD:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case SUB:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case MUL:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case DIV:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case INC:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case DEC:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case AND:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case OR:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case XOR:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case NOT:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case SHL:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case SHR:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case JMP:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case JZ:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case JNZ:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case CMP:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case JG:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case JL:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case CALL:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case RET:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case LOAD:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case STORE:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case MOV:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case PUSH:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case POP:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case LOADI:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case IN:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case OUT:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case HALT:
        getBin(ntoken-1, opcode, OPCODE_LEN-1);
        break;
      case LABELI:
        label_flag = 1;
        yytext[strlen(yytext)-1] = '\0';
        strncpy(labels[label_count], yytext, LABEL_LEN);
        index_labels[label_count] = newline_count;
        //printf("%s, %d\n", labels[label_count], index_labels[label_count]);
        label_count++;
        break;
      case LABELO:
        strcpy(address, yytext);
        break;
      case REG:
        char *temp_reg = yytext;
        int reg_num = (int)temp_reg[1] - 48;
        if (reg_flag == 0){
          getBin(reg_num, reg1, REG_LEN-1);
          reg_flag = 1;
        }
        else if(reg_flag == 1){
          getBin(reg_num, reg2, REG_LEN-1);
        }
        //printf("%p\n", opcode);
        break;
      case VALUE:
        int value = atoi(yytext);
        getBin(value, address, ADDRESS_LEN-1);
        break;
      case NEWLINE:
        if (newline_count >  0 && label_flag == 0){
          for (int i = 0; i < OPCODE_LEN-1; i++){
            if (opcode[i] == '\0')
              fprintf(output, "0");
            else
              fprintf(output, "%c", opcode[i]);
          }
          for (int i = 0; i < REG_LEN-1; i++){
            if (reg1[i] == '\0')
              fprintf(output, "0");
            else
              fprintf(output,"%c", reg1[i]);
          }
          for (int i = 0; i < REG_LEN-1; i++){
            if (reg2[i] == '\0')
              fprintf(output, "0");
            else 
              fprintf(output, "%c", reg2[i]);
          }
          //printf("address: %s\n", address);
          int flag = 0;
          for (int i = 0; i < ADDRESS_LEN-1; i++){
            if (address[i]=='\0' && flag == 0)
              fprintf(output, "0");
            else if (isalpha(address[i]) != 0 && flag == 0){
              fprintf(output, "\n%c", address[i]);
              flag = 1; 
            }
            else 
              fprintf(output, "%c", address[i]);
          }
          fprintf(output, "\n");
        }
        memset(opcode,0,6);
        memset(reg1,0,5);
        memset(reg2,0,5);
        memset(address,0,16);
        reg_flag = 0;
        newline_count++;
        break;
    }
    label_flag = 0;
    ntoken = yylex();
  }
for (int i = 0; i < OPCODE_LEN-1; i++){
  if (opcode[i] == '\0')
    fprintf(output, "0");
  else
    fprintf(output, "%c", opcode[i]);
}
for (int i = 0; i < REG_LEN-1; i++){
  if (reg1[i] == '\0')
    fprintf(output, "0");
  else
    fprintf(output,"%c", reg1[i]);
}
for (int i = 0; i < REG_LEN-1; i++){
  if (reg2[i] == '\0')
    fprintf(output, "0");
  else 
    fprintf(output, "%c", reg2[i]);
}
//printf("address: %s\n", address);
int flag = 0;
for (int i = 0; i < ADDRESS_LEN-1; i++){
  if (address[i]=='\0' && flag == 0)
    fprintf(output, "0");
  else if (isalpha(address[i]) != 0 && flag == 0){
    fprintf(output, "\n%c", address[i]);
    flag = 1; 
  }
  else 
    fprintf(output, "%c", address[i]);
}
fprintf(output, "\n");
  fclose(input);
  fclose(output);

  input = fopen("test.txt", "r");
  output = fopen("test.relo", "w");

  
  char line[33];
  if (output != NULL) {
    while (fgets(line, sizeof(line), input)) {
      if (isalpha(line[0]) == 0) {
        // Print exact same line to output file
        fprintf(output, "%s", line);
      }
      else{
        int i;
        char buffer[LABEL_LEN];
        for (i = 0; i <= label_count; i++){
          if (strcmp(labels[i], line) == 0){
fprintf(output, "1010(%d)\n", index_labels[i]);
          }
        }
      }
    }
  }



  fclose(input);
  fclose(output);


  return 0;
}
