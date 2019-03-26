%{
#include <stdio.h>
#include <glib.h>
#include <gmodule.h>
int countT = 0, countQ = 0, countA = 0;

void removeSubstring(char *s,const char *toremove){
  while( s=strstr(s,toremove) )
    memmove(s,s+strlen(toremove),1+strlen(s+strlen(toremove)));
}

void trim(char *str){
    size_t totrim;
    int i = 0;
    char* seps = "\t\n\v\f\r ";
    totrim = strspn(str, seps);
    if (totrim > 0) {
        size_t len = strlen(str);
        if (totrim == len) {
            str[0] = '\0';
        }
        else {
            memmove(str, str + totrim, len + 1 - totrim);
        }
    }

    i = strlen(str) - 1;
    while (i >= 0 && strchr(seps, str[i]) != NULL) {
        str[i] = '\0';
        i--;
    }
}

void cleanString(char *s){
    removeSubstring(s, "&quot;");
    removeSubstring(s, "*");
    removeSubstring(s, "\'");
    removeSubstring(s,"“");
    trim(s);
}

%}
%x QUOTES
%x ALL
%%
\<revision\>\n.*\<id\>165415.*          { BEGIN ALL;}
<ALL>\{\{Autor                          { BEGIN QUOTES;}
<QUOTES>.*Nome.*=.* {
    char* autor = strdup(yytext+6);
    removeSubstring(autor, "=");
    cleanString(autor);
    printf("\nQuotes de %s:\n\n", autor);
    countA++;
    }
<QUOTES>^\*(\ )?([\“\'\"]|&quot;).* {
    char* s = strdup(yytext);
    cleanString(s);
    printf("\n\t\"%s\"\n",s);
    countQ++;
    }
<QUOTES>^[:\-* ]+Tradução.*:.*  {
    char* trad = strdup(yytext);
    cleanString(trad);
    printf("\t-->%s\n", trad);
    countT++;
    }
<QUOTES>\</page\>                       { BEGIN ALL;}
.|\n         {;}
<QUOTES>.|\n {;}
<ALL>.|\n {;}
%%

int yywrap(){
    return 1;
}



int main() {
    printf("Vou começar...\n");
    yylex();
    printf("All done.\n");
    printf("Numero Autores = %d.\n", countA);
    printf("Numero Quotes = %d.\n", countQ);
    printf("Numero Traduções = %d\n", countT); 
    printf("Vou terminar...\n");
    return 0;
}

