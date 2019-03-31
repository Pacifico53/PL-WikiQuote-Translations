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
char* antigo_autor;

int countT = 0, countQ = 0, countA = 0;

void removeSubstring(char *s,const char *toremove){
  while( s=strstr(s,toremove) )
    memmove(s,s+strlen(toremove),1+strlen(s+strlen(toremove)));
}

void trim(char *str, char *seps){
    size_t totrim;
    int i = 0;
    if(!seps){
        seps = "\t\n\v\f\r ";
    }
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
    trim(s, NULL);
}

%}
%x QUOTES
%x ALL
%%
\<sha1\>rv40uc.*                    { BEGIN ALL;}       /* A primeira page que de facto tem quotes aparece depois deste sha1.*/
<ALL>\<page\>                       { BEGIN QUOTES;}    
<QUOTES>\<title\>Wiki.*             { BEGIN ALL;}       /* Estas paginas têm texto em formato quote que nao é quote*/
<QUOTES>\<title\>Ajuda:.*           { BEGIN ALL;}       /* por isso colocamos esta regra para nao procurar quotes nelas.*/
<QUOTES>\<title\>Nacionalismo.*     { BEGIN ALL;}
<QUOTES>\<title\>Locu.*             { BEGIN ALL;}
<QUOTES>\<title\>Castleva.*         { BEGIN ALL;}
<QUOTES>\<title\>.* {
    nome_autor = strdup(yytext+7);
    cleanString(nome_autor);
    trim(nome_autor, "</title>");
    printf("\nQuotes de %s:\n\n", nome_autor);
    countA++;
    }
<QUOTES>^[*:\-\ '\"\“]+Traduç.*:.*  {
    char* trad = strdup(yytext);
    cleanString(trad);
    trim(trad, ":-");
    fprintf(traducoes,"<tr><td> %s </td><td> %s </td></tr>\n", texto_quote ,trad);
    printf("\t-->%s\n", trad);
    countT++;
    }
<QUOTES>^\*\ +[^\[\{].* {
    texto_quote = strdup(yytext);
    cleanString(texto_quote);
    if(nome_autor==antigo_autor){
        fprintf(quotes,"<li>%s</li>\n", texto_quote);
        printf("\n\t\"%s\"\n",texto_quote);
        countQ++;
    }
    else{
        antigo_autor=nome_autor;
        fprintf(quotes,"</ul>\n <p><strong>-- %s</strong></p>\n <ul><li>%s</li>\n", nome_autor , texto_quote);
        printf("\n\t\"%s\"\n",texto_quote);
        countQ++;
    }
}
<QUOTES>\</page\>                   { BEGIN ALL;}
.|\n            {;}
<QUOTES>.|\n    {;}
<ALL>.|\n       {;}
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
    fprintf(inicial,"<h1 align='center'> Wiki Quotes: traduções </h1>\n");
    fprintf(inicial,"<li><a href=\"%s\">%s</a><br><hr></li>\n","quotes.html", "Quotes com os Autores");
    fprintf(inicial,"<li><a href=\"%s\">%s</a><br><hr></li>\n","traducoes.html", "Traduções");
    fprintf(inicial,"<li><a href=\"%s\">%s</a><br><hr></li>\n","estatistica.html", "Estatistica");
    
    fprintf(quotes,"<h1 align='center'> Lista das Quotes e Autores </h1>\n");
    fprintf(traducoes,"<h1 align='center'> Tabela das Traduções </h1>\n");
    fprintf(traducoes,"<style> table, th, td { border: 2px solid black; border-collapse: collapse;} th, td {padding: 5px;} </style>\n <table> <tr><th>Quotes</th><th>Traduções</th></tr>\n");
    yylex();
    fprintf(traducoes,"</table>\n");

    fprintf(estatistica,"<h1 align='center'> Estatisticas </h1>");
    fprintf(estatistica,"<h4>Encontrados %d autores</h4><br><hr>\n", countA);
    fprintf(estatistica,"<h4>Encontrados %d quotes</h4><br><hr>\n", countQ);
    fprintf(estatistica,"<h4>Encontrados %d traducoes</h4><br><hr>\n", countT);

    fclose(inicial);
    fclose(quotes);
    fclose(traducoes);
    fclose(estatistica);
    
    printf("Input todo percorrido.\n");
    printf("Numero Autores = %d.\n", countA);
    printf("Numero Quotes = %d.\n", countQ);
    printf("Numero Traduções = %d\n", countT); 
    printf("Vou terminar...\n");
    return 0;
}

