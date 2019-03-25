#include "estrutura.h"

typedef struct fullQuote {
    char* quote;
    char* traducao;
};

fullQuote newQUOTE (char* q, char* t){
	fullQuote q = malloc(sizeof(struct fullQuote));
	q->quote = q;
	q->traducao = t;

	return q; 
}

char* getQuote (fullQuote q) {
	return q->quote;
}

char* getTraducao (fullQuote q){
	return q->traducao;
}


