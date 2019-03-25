#include "estrutura.h"

typedef struct quotes {
	char* quote;
	char* traducao;
}


/*AUTORES_QUOTES create_hashtable_autores_quotes (char* autor, GArray* quotes){
	AUTORES_QUOTES q = malloc(sizeof(struct HASHTABLE_autores_quotes));
	q -> autor = autor;
	q -> quotes = quotes;

	return q;
}
*/

QUOTES create_garray_quotes (char* quote, char* traducao){
	QUOTES q = malloc(sizeof(struct GARRAY_quotes));
	q -> quote = quote;
	q -> traducao = traducao;

	return q; 
}

quote getQuote (QUOTES q) {
	return q -> quote;
}

traducao getTraducao (QUOTES q){
	return q -> traducao;
}





