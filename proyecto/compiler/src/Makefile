SRC=codegen.cpp instr.cpp parser.cpp procentry.cpp strentry.cpp token.cpp
MAIN=main.cpp
LEXER=lexer.cpp
INCLUDE=codegen.h instr.h parser.h procentry.h strentry.h token.h
LEX=scanner.flex
LIBS=-lfl
BIN=sasm
TESTDIR=../test
TESTS=correct1.asm correct2.asm incorrect1.asm incorrect2.asm incorrect3.asm \
incorrect4.asm incorrect5.asm prueba.asm hello.asm bad.asm
CFLAGS=-g

compile: lexer ${MAIN} ${SRC} ${INCLUDE}
	g++ ${CFLAGS} -o ${BIN} ${SRC} ${LEXER} ${LIBS} 

lexer: ${LEX}
	flex -o ${LEXER} ${LEX}

.PHONY : clean

clean:
	rm -rf *~ *.o ${BIN} ${LEXER}

test: compile
	${foreach dir,${TESTS}, ./${BIN} < ${TESTDIR}/${dir} ;}
