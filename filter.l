%{
#include <stdio.h>
%}
%x QUOTES
%%
\<revision\>\n.*\<id\>165415.*          { BEGIN QUOTES;}
<QUOTES>^\*.*                           {printf("QUOTE:\"%s\"\n", yytext);}
<QUOTES>^[:\-* ]{1,12}Tradução.*:.*     {printf("TRADUÇAO:\"%s\"\n", yytext);}
.|\n         {;}
<QUOTES>.|\n {;}
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

