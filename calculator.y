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
%token TRUE FALSE AND OR XOR NOT
%token QUESTION COLON LEFT_PAREN RIGHT_PAREN ENDL

%type <d> expr
%type <d> ternary
%type <i> INTEGER

%nonassoc QUESTION COLON

%left AND XOR OR
%left LESS GREATER LESS_EQUAL GREATER_EQUAL EQUAL NOT_EQUAL
%left PLUS MINUS
%left MUL DIV
%left NOT

%code requires {
#define NUM 1
#define BOOL 2

struct Data {
    int val;
    int type;
};
}

%union {
    int i;
    struct Data d;
}

%%

program: program expr ENDL  { if ($2.type == BOOL)
                                  printf("%s\n", $2.val == 1 ? "True" : "False");
                              else
                                  printf("%d\n", $2.val);
                            }
        | /* NULL */
        ;


expr: TRUE  { $$.type = BOOL; $$.val = 1; }
    | FALSE { $$.type = BOOL; $$.val = 0; }
    | INTEGER { $$.type = NUM; $$.val = $1; }
    | ternary { $$.type = $1.type; $$.val = $1.val; }
    | NOT expr  { $$.type = BOOL; $$.val = !$2.val; }
    | expr AND expr  { $$.type = BOOL; $$.val = $1.val && $3.val; }
    | expr OR expr  { $$.type = BOOL; $$.val = $1.val || $3.val; }
    | expr XOR expr  { $$.type = BOOL; $$.val = $1.val ^ $3.val; }
    | expr LESS expr { $$.type = BOOL; $$.val = $1.val < $3.val; }
    | expr GREATER expr { $$.type = BOOL; $$.val = $1.val > $3.val; }
    | expr EQUAL expr { $$.type = BOOL; $$.val = $1.val == $3.val; }
    | expr LESS_EQUAL expr { $$.type = BOOL; $$.val = $1.val <= $3.val; }
    | expr GREATER_EQUAL expr { $$.type = BOOL; $$.val = $1.val >= $3.val; }
    | expr NOT_EQUAL expr { $$.type = BOOL; $$.val = $1.val != $3.val; }
    | MINUS expr { $$.type = NUM; $$.val = -$2.val; }
    | expr PLUS expr { $$.type = NUM; $$.val = $1.val + $3.val; }
    | expr MINUS expr { $$.type = NUM; $$.val = $1.val - $3.val; }
    | expr MUL expr { $$.type = NUM; $$.val = $1.val * $3.val; }
    | expr DIV expr { $$.type = NUM; $$.val = $1.val / $3.val; }
    | LEFT_PAREN expr RIGHT_PAREN { $$.type = $2.type; $$.val = $2.val; }
    ;

ternary: expr QUESTION expr COLON expr   { $$.val = $1.val ? $3.val : $5.val;
                                           $$.type = $1.val ? $3.type : $5.type;}
        ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(int argc, char **argv) {
    ++argv, --argc;  /* skip over program name */
    if (argc > 0)
        yyin = fopen( argv[0], "r" );
    else
        yyin = stdin;

    yyparse();

    return 0;
 }
