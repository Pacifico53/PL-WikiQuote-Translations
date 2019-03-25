%{
#include <stdio.h>
#include <glib.h>
#include <gmodule.h>
#include "estrutura.h"
GArray *allQuotes;
GHashTable *hash;
char *s;
int size = 0;
char* autor;
%}
%x QUOTES
%x ALL
%%
\<revision\>\n.*\<id\>165415.*          { BEGIN ALL;}
<ALL>\{\{Autor                          { BEGIN QUOTES;}
<QUOTES>.*Nome.*=.*                     { autor = strdup(yytext);printf("!!!!%s\n", autor);}     
<QUOTES>^\*\ ([\“\'\"]|&quot;).* {
    s = strdup(yytext);
    fullQuote q = newQUOTE(s, " "); 
    g_array_append_val(allQuotes, s);
    size++;
    }
<QUOTES>^[:\-* ]+Tradução.*:.*          { printf("TRADUÇAO:\"%s\" %s\n", yytext, autor); }
<QUOTES>\</page\>                       { BEGIN ALL;}    
.|\n         {;}
<QUOTES>.|\n {;}
<ALL>.|\n {;}
%%

int yywrap(){
    return 1;
}

int main() {
    hash = g_hash_table_new(NULL, NULL);
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

