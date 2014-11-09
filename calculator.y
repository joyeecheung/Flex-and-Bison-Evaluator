%{
#include <stdio.h>
void yyerror(char *);
int yylex(void);
int yydebug = 0;
extern int yyparse();
extern FILE *yyin;
%}

%debug
%token INTEGER
%token MINUS PLUS MUL DIV LESS GREATER EQUAL LESS_EQUAL GREATER_EQUAL NOT_EQUAL
%token TRUE FALSE AND OR NOR NOT

%left '?' ':'
%left AND NOR OR
%left LESS GREATER LESS_EQUAL GREATER_EQUAL EQUAL NOT_EQUAL
%left PLUS MINUS
%left MUL DIV
%left NOT
%%

program:
    program statement '\n'
    | /* NULL */
    ;

statement:
    logicexpr { printf("%s\n", $1 == 0 ? "False" : "True"); }
    | numexpr { printf("%d\n", $1); }
    ;

numexpr:
    logicexpr "?" numexpr ":" numexpr   { $$ = $1 ? $3 : $5; }
    | INTEGER
    | MINUS numexpr { $$ = -$2; }
    | numexpr PLUS numexpr { $$ = $1 + $3; }
    | numexpr MINUS numexpr { $$ = $1 - $3; }
    | numexpr MUL numexpr { $$ = $1 * $3; }
    | numexpr DIV numexpr { $$ = $1 / $3; }
    | '(' numexpr ')' { $$ = $2; }
    ;

logicexpr:
    TRUE  { $$ = 1; }
    | FALSE { $$ = 0; }
    | NOT logicexpr  { $$ = !$2; }
    | logicexpr AND logicexpr  { $$ = $1 && $3; }
    | logicexpr OR logicexpr  { $$ = $1 || $3; }
    | logicexpr NOR logicexpr  { $$ = !($1 || $3); }
    | numexpr LESS numexpr { $$ = $1 < $3; }
    | numexpr GREATER numexpr { $$ = $1 > $3; }
    | numexpr EQUAL numexpr { $$ = $1 == $3; }
    | numexpr LESS_EQUAL numexpr { $$ = $1 <= $3; }
    | numexpr GREATER_EQUAL numexpr { $$ = $1 >= $3; }
    | numexpr NOT_EQUAL numexpr { $$ = $1 != $3; }
    | '(' logicexpr ')' { $$ = $2; }
    ;


%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main( int argc, char **argv )
{
    ++argv, --argc;  /* skip over program name */
    if ( argc > 0 )
         yyin = fopen( argv[0], "r" );
    else
         yyin = stdin;

    yyparse();
 }