%{
#include "y.tab.h"
#include <stdlib.h>
void yyerror(char *);
%}

DIGIT [0-9]

%%

{DIGIT}+ {
    yylval = atoi(yytext);
    return INTEGER;
}

"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MUL; }
"/"         { return DIV; }
"<"         { return LESS; }
">"         { return GREATER; }
"<="        { return LESS_EQUAL; }
">="        { return GREATER_EQUAL; }
"=="        { return EQUAL; }
"!="        { return NOT_EQUAL; }

[()\n] { return *yytext; }

[ \t] ; /* skip whitespace */

. yyerror("Unknown character");

%%

int yywrap(void) {
    return 1;
}
