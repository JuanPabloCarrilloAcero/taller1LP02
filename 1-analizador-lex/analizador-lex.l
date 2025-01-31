%{

#define KW 200
#define IF 201
#define THEN 202
#define ELSE 203
#define RELOP 400
#define LT 1
#define LE 2
#define EQ 3
#define NE 4
#define GT 5
#define GE 6
#define NUMBER 500
#define ID 501


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_IDS 100
#define MAX_NUMS 100

typedef struct {
    char *lexeme;
} IDEntry;

typedef struct {
    double value;
} NumEntry;

IDEntry idTable[MAX_IDS];
int idCount = 0;

NumEntry numTable[MAX_NUMS];
int numCount = 0;

int installID();
int installNum();

int yylval;
%}

/* definiciones regulares */
delim   [ \t\n]
ws      {delim}+
letter  [A-Za-z]
digit   [0-9]
id      {letter}({letter}|{digit})*
number  {digit}+(\.{digit}+)?(E[+-]?{digit}+)?

%%
{ws}        /* ignora espacios en blanco */
"if"        { yylval = IF; printf("KW:%d ", yylval);return(KW); }
"then"      { yylval = THEN; printf("KW:%d ", yylval); return(KW); }
"else"      { yylval = ELSE; printf("KW:%d ", yylval); return(KW); }
{id}        { yylval = installID(); printf("%d ", yylval); return(ID); }
{number}    { yylval = installNum(); printf("%d ", yylval); return(NUMBER); }
"=="        { yylval = EQ; printf("RELOP:%d ", yylval); return(RELOP); }
"!="        { yylval = NE; printf("RELOP:%d ", yylval); return(RELOP); }
"<"         { yylval = LT; printf("RELOP:%d ", yylval); return(RELOP); }
"<="        { yylval = LE; printf("RELOP:%d ", yylval); return(RELOP); }
">"         { yylval = GT; printf("RELOP:%d ", yylval); return(RELOP); }
">="        { yylval = GE; printf("RELOP:%d ", yylval); return(RELOP); }
%%

int installID() {
    if (idCount < MAX_IDS) {
        idTable[idCount].lexeme = strdup(yytext);
        return idCount++;
    } else {
        fprintf(stderr, "Tabla de IDs llena.\n");
        exit(1);
    }
}

int installNum() {
    if (numCount < MAX_NUMS) {
        numTable[numCount].value = atof(yytext);
        return numCount++;
    } else {
        fprintf(stderr, "Tabla de Números llena.\n");
        exit(1);
    }
}

