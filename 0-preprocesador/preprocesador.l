%option noyywrap

%{
#include <stdio.h>
#include <string.h>
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

    if (strcmp(line, "import iseven") == 0 || strcmp(line, "import isodd") == 0) {
        // Do nothing
    } else if (strlen(line) > 0) {
        printf("%s\n", line);
    }

}

. { /* do nothing */ }

%%

int main() {
    yylex();        // Escanea la entrada
    return 0;
}
