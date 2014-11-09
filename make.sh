bison -y -d calculator.y
flex token.l
gcc y.tab.c lex.yy.c -o demo

