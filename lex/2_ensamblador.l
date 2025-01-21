%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
 * Variables globales (muy simplificado, normalmente usarías
 * estructuras o un parser más robusto).
 */
static char var_for[64];       // Nombre de la variable de 'for'
static int  from_val = 0;      // Límite inferior del for
static int  to_val   = 0;      // Límite superior del for

static char var_sum[64];       // Nombre de la variable que hace sum (ej. 'sum')
static int  sum_init_val = 0;  // Valor inicial asignado a 'sum'

static char array_index_var[64]; // Variable usada como índice en array[i]

/* 
 * Banderas para saber si hemos reconocido cada parte:
 *  - sum = 0;
 *  - for i = 0 to 5:
 *  - sum += array[i];
 */
static int got_sum_assign        = 0;
static int got_for_loop          = 0;
static int got_sum_array_assign  = 0;

%}

/*
 * Expresiones regulares auxiliares:
 */
VAR   [a-zA-Z_][a-zA-Z0-9_]*     
DIGIT [0-9]+                     
%%
{VAR}[ \t]*"="[ \t]*{DIGIT}[ \t]*";"  {
    // Ejemplo de texto que coincide: "sum = 0;"  
    // Extraemos <var_sum> y <sum_init_val>
    sscanf(yytext, "%s = %d;", var_sum, &sum_init_val);
    got_sum_assign = 1;
}
"for"[ \t]+{VAR}[ \t]*"="[ \t]*{DIGIT}[ \t]+"to"[ \t]*{DIGIT}[ \t]*":" {
    // Ejemplo: "for i = 0 to 5:"
    sscanf(yytext, "for %s = %d to %d:", var_for, &from_val, &to_val);
    got_for_loop = 1;
}

{VAR}[ \t]*"\+="[ \t]*"array"[ \t]*"["[ \t]*{VAR}[ \t]*"]"[ \t]*";" {
    // Ejemplo: "sum += array[i];"
    sscanf(yytext, "%s += array[%s];", var_sum, array_index_var);
    got_sum_array_assign = 1;
}

[\r\n]+   { /* no hacemos nada */ }
[ \t]+    { /* no hacemos nada */ }

.         { /* ignorar o manejar error */ }
%%

int main(void)
{
    /* Invocar el análisis léxico sobre la entrada estándar */
    yylex();

    /*
     * Si se reconocieron las tres partes:
     *   1) sum = X;
     *   2) for i = A to B:
     *   3) sum += array[i];
     * Generamos (pseudo)assembly.
     */
    if (got_sum_assign && got_for_loop && got_sum_array_assign) {
        /* 
         * En un caso real, podríamos verificar que 'from_val' sea 0, 
         * que la variable 'sum' coincida con la del bucle, etc.
         * Aquí solo generamos un ejemplo estático, 
         * usando R0 para 'sum', R1 para contador, R2 para base del array, R3 para temporal.
         */

        printf("LOADI R0 %d\n", sum_init_val);

        /* Suponemos que el bucle inicia en 'from_val' y corre hasta 'to_val', 
           así que R1 llevará la cantidad de iteraciones (to_val - from_val + 1),
           aunque aquí tomamos la simplificación de que from_val = 0. */
        printf("LOADI R1 %d\n", to_val);

        printf("LOADI R2 0x0100\n");

        /* Línea 5, por ejemplo, donde inicia el cuerpo del bucle */
        printf("LOAD R3 R2\n");
        printf("ADD R3 R0\n");
        printf("INC R2\n");
        printf("DEC R1\n");
        /* El '3' en JNZ 3 se refiere a la instrucción que está en la línea 5 
           si contamos desde 1. Podríamos usar etiquetas en un ensamblador real. */
        printf("JNZ 3\n");

        printf("HALT\n");
    } else {
        fprintf(stderr,
            "No se encontró la secuencia completa (sum=...; for...; sum+=array...;)\n");
    }

    return 0;
}
