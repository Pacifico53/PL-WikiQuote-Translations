#include <gmodule.h>
#include <glib.h>
#include <stdlib.h>


typedef struct GARRAY_quotes* QUOTES;

//AUTORES_QUOTES create_hashtable_autores_quotes (char* autor, GArray* quotes);

QUOTES create_garray_quotes (char* quote, char* traducao);

quote getQuote (QUOTES q);

traducao getTraducao (QUOTES q);