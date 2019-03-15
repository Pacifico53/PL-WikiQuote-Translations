%{
#include <stdio.h>
#include <glib.h>
#include <gmodule.h>
GArray *allQuotes;
char *s;
int size = 0;
%}
%x QUOTES
%%
\<revision\>\n.*\<id\>165415.*          { BEGIN QUOTES;}
<QUOTES>^\*\ ([\“\'\"]|&quot;).* {
    s = strdup(yytext);
    g_array_append_val(allQuotes, s);
    size++;
    }
<QUOTES>^[:\-* ]+Tradução.*:.*          { printf("TRADUÇAO:\"%s\"\n", yytext); }
.|\n         {;}
<QUOTES>.|\n {;}
%%

int yywrap(){
    return 1;
}

int main() {
    allQuotes = g_array_new(FALSE, FALSE, sizeof(char*));
    printf("Vou começar...\n");
    yylex();
    int i = 0;
    for(i = 0; i < size; i++){
        printf("QUOTE: %s\n", g_array_index(allQuotes, char*, i));
    }
    printf("Vou terminar...\n");
    return 0;
}

