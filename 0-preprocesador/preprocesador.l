%option noyywrap

%{
#include <stdio.h>
#include <string.h>

/*
    Ejemplo de "preprocesador" usando Flex:
    - Elimina comentarios que empiezan con '#'.
    - Quita saltos de línea y espacios finales.
    - Busca la línea "import library". Si la encuentra, imprime
      el "código" necesario de la librería en la salida.
    - El resto de líneas se imprimen tal cual, ya sin comentarios.
*/
%}

%%
^(.*)\r?\n {
    char line[1024];
    int length = yyleng;

    if (length > 1023) {
        length = 1023;
    }
    
    strncpy(line, yytext, length);
    line[length] = '\0';
    
    if (length >= 1 && line[length - 1] == '\n') {
        line[length - 1] = '\0';
        length--;
    }
    if (length >= 1 && line[length - 1] == '\r') {
        line[length - 1] = '\0';
        length--;
    }
    
    char *commentPos = strchr(line, '#');
    if (commentPos) {
        *commentPos = '\0';
    }
    
    int end = strlen(line) - 1;
    while (end >= 0 && (line[end] == ' ' || line[end] == '\t')) {
        line[end] = '\0';
        end--;
    }

    if (strcmp(line, "import library") == 0) {
        printf("#define LIB_FUNCTION(x)  ((x)*(x))\n");
    } else if (strlen(line) > 0) {
        printf("%s\n", line);
    }
}

. { /* do nothing */ }

%%

int main() {
    yylex();        // Escanea la entrada
    printf("\n");   // Al final, un salto de línea adicional
    return 0;
}
