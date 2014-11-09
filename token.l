%{
#include "y.tab.h"
#include <stdlib.h>
void yyerror(char *);
%}

DIGIT [0-9]
ID    [_a-zA-Z][_a-zA-Z0-9]*

%%
{ID} {
    yylval = *yytext - 'a';
    return VARIABLE;
}

{DIGIT}+ {
    yylval = atoi(yytext);
    return INTEGER;
}

[-+()=*/\n] { return *yytext; }

[ \t] ; /* skip whitespace */

. yyerror("Unknown character");

%%

int yywrap(void) {
    return 1;
}
