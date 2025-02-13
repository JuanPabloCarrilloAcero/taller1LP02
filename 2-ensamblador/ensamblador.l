%{
#include "ensamblador.h" 

%}

mayus_letter [A-Z0-9_]
number [0-9]
integer [+-]?[0-9]{number}*
label [A-Z]{mayus_letter}*
%%

"NOP"                   return NOP;
"ADD"                   return ADD;
"SUB"                   return SUB;
"MUL"                   return MUL;
"DIV"                   return DIV;
"INC"                   return INC;
"DEC"                   return DEC;
"AND"                   return AND;
"OR"                    return OR;
"XOR"                   return XOR;
"NOT"                   return NOT;
"SHL"                   return SHL;
"SHR"                   return SHR;
"JMP"                   return JMP;
"JZ"                    return JZ;
"CMP"                   return CMP;
"JG"                    return JG;
"JL"                    return JL;
"CALL"                  return CALL;
"RET"                   return RET;
"LOAD"                  return LOAD;
"STORE"                 return STORE;
"MOV"                   return MOV;
"PUSH"                  return PUSH;
"POP"                   return POP;
"LOADI"                 return LOADI;
"IN"                    return IN;
"OUT"                   return OUT;
"HALT"                  return HALT;

R[0-7]                  return REG;
{label}                 return LABELO;
{label}:                return LABELI;
{integer}               return VALUE;
[\n]                    return NEWLINE;
[ \t]                   ;

.                       printf("Unexpected character: %s\n", yytext);


%%

int yywrap(void)
{
  return 1;
}
