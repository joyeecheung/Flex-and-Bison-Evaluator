all: demo

test: output.txt result.txt
	diff output.txt result.txt

output.txt: demo test.txt
	./demo test.txt > output.txt

demo: token.l calculator.y
	bison -y -d calculator.y
	flex token.l
	gcc y.tab.c lex.yy.c -lfl -o demo

clean:
	rm -f output.txt demo
	rm y.tab.c lex.yy.c y.tab.h

.PHONY: test
