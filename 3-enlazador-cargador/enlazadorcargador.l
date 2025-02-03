%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char storedBinary16[33] = "";  // para almacenar la línea BINARY16 (32 bits como string, aquí 16 bits)
%}

%option noyywrap

BINARY32    ^[01]{32}$
BINARY16    ^[01]{16}$
RELOC_TOKEN ^1010\([0-9]+\)$

%%

{BINARY32}    {
                  // Instrucción completa: se imprime directamente
                   // printf("%s\n", yytext);
                   printf("%s", yytext);
              }

{BINARY16}    {
                  // Guarda el token BINARY16 en una variable global
                  strncpy(storedBinary16, yytext, 16);
                  storedBinary16[16] = '\0';
                  // (Opcional) Imprime o registra que se encontró una instrucción parcial
                  // printf("TOKEN BINARY16: %s\n", yytext);
              }

{RELOC_TOKEN} {
                  // Extraer el número entre paréntesis:
                  char *start = strchr(yytext, '(');
                  char *end = strchr(yytext, ')');
                  if(start && end && end > start) {
                      size_t len = end - start - 1;
                      char number[32];
                      strncpy(number, start+1, len);
                      number[len] = '\0';
                      // Convertir el número a entero
                      int relocValue = atoi(number);
                      // Convertir el número a binario de 16 bits manualmente
                      char relocBin[17];
                      for(int i = 15; i >= 0; i--) {
                          relocBin[15 - i] = (relocValue & (1 << i)) ? '1' : '0';
                      }
                      relocBin[16] = '\0'; // Asegurarse de que la cadena esté terminada en nulo

                      // Combinar la instrucción parcial con el valor de relocalización
                      // printf("%s%s\n", storedBinary16, relocBin);
                      printf("%s%s", storedBinary16, relocBin);
                      
                      // Limpiar la variable para evitar confusiones futuras.
                      storedBinary16[0] = '\0'; // Ahora solo limpiamos cuando realmente se haya usado el valor
                  } else {
                      fprintf(stderr, "Error en token RELOC mal formado: %s\n", yytext);
                  }
              }

[ \t\r]+    { /* Ignorar espacios y saltos de línea */ }


%%

int main(void) {
    yylex();
    return 0;
}