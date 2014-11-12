%{
#include "y.tab.h"
#include <stdlib.h>

void yyerror(char *);
%}

DIGIT [0-9]

%%

{DIGIT}+ {
    yylval.d.val = atoi(yytext);
    yylval.d.type = NUM;
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
"True"      { yylval.d.type = BOOL; return TRUE; }
"False"     { yylval.d.type = BOOL; return FALSE; }
"and"       { return AND; }
"or"        { return OR; }
"xor"       { return XOR; }
"not"       { return NOT; }
"?"          { return QUESTION; }
":"          { return COLON; }
"("          { return LEFT_PAREN; }
")"          { return RIGHT_PAREN; }
"\n"          { return ENDL; }

[ \t] ; /* skip whitespace */

. yyerror("Unknown character");

%%

int yywrap(void) {
    return 1;
}
