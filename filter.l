%{
#include <stdio.h>
%}
%%
^\*.*     {printf("QUOTE %s\n", yytext);}
.|\n {;}
%%

int yywrap(){
    return 1;
}

int main() {
    printf("Vou começar...\n");
    yylex();
    printf("Vou terminar...\n");
    return 0;
}

