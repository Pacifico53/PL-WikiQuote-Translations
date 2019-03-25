#include <gmodule.h>
#include <glib.h>
#include <stdlib.h>

typedef struct fullQuote;

fullQuote create_garray_quotes (char* quote, char* traducao);

char* getQuote (fullQuote q);

char* getTraducao (fullQuote q);

