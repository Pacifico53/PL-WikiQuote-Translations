%{

#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>

FILE* inicial;
FILE* quotes;
FILE* autor;
FILE* traducoes;
FILE* estatistica;

char* filename[1024];
char* nome_autor;
char* texto_quote;

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
    removeSubstring(s, "\"");
    removeSubstring(s, "“");
    trim(s);
}

%}
%x QUOTES
%x ALL
%%
\<revision\>\n.*\<id\>165415.*          { BEGIN ALL;}
<ALL>\{\{Autor                          { BEGIN QUOTES;}
<QUOTES>.*Nome.*=.* {
    nome_autor = strdup(yytext+6);
    removeSubstring(nome_autor, "=");


    cleanString(nome_autor);

    printf("\nQuotes de %s:\n\n", nome_autor);
    countA++;
    }
<QUOTES>^\*(\ )?([\“\'\"]|&quot;).* {

    texto_quote = strdup(yytext);
    fprintf(quotes,"<p>%s %s</p>", texto_quote , nome_autor);
    cleanString(texto_quote); 
    printf("\n\t\"%s\"\n",texto_quote);
    countQ++;
    }
<QUOTES>^[:\-* ]+Tradução.*:.*  {

    char* trad = strdup(yytext);
    cleanString(trad);
    fprintf(traducoes,"<p> %s </p><p> %s </p>", texto_quote ,trad);
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

    inicial = fopen("index.html", "w");
    quotes = fopen("quotes.html", "w");
    traducoes = fopen("traducoes.html", "w");
    estatistica = fopen("estatistica.html", "w");
    
    fprintf(inicial,"<a href=\"%s\">%s</a><br><hr>","quotes.html", "Quotes com os Autores");
    fprintf(inicial,"<a href=\"%s\">%s</a><br><hr>","traducoes.html", "Traduções");
    fprintf(inicial,"<a href=\"%s\">%s</a><br><hr>","estatistica.html", "Estatistica");
    
    fprintf(estatistica,"<table>");
    
    yylex();
    fprintf(estatistica,"<h4>Há %d autores</h4><br><hr>", countA);
    fprintf(estatistica,"<h4>Há %d quotes</h4><br><hr>", countQ);
    fprintf(estatistica,"<h4>Há %d traduções</h4><br><hr>", countT);

    fclose(inicial);
    fclose(quotes);
    fclose(traducoes);
    fclose(estatistica);
    
    printf("All done.\n");
    printf("Numero Autores = %d.\n", countA);
    printf("Numero Quotes = %d.\n", countQ);
    printf("Numero Traduções = %d\n", countT); 
    printf("Vou terminar...\n");
    return 0;
}

