%{
/* Usamos el codigo de la tabla de simbolos */
#include "codegen.h"
#include "token.h"
#include "parser.h"
#include <cmath>
#include <cstring>
#include <deque>
#include <iostream>
#include <fstream>
#define MAX_STR_SIZE 256

using std::deque;
using std::cerr;
using std::cout;
using std::endl;
using std::ofstream;
using std::ios;

%}
	deque<Token> tokens;
	
	char strlit[MAX_STR_SIZE];
	int strlitlen;
	void lexerror(const char* msg);
	bool overFlag = false;

	void insertChar(char c){
  	   if(strlitlen < MAX_STR_SIZE){
    	      strlit[strlitlen++] = c;
  	   } else {
    	      overFlag = true;
	   }	   
	}

	int num_lines = 1;
	bool lexer_stop = false;

%x STRING

%%

[ \t]+  /* Ignora espacios en blanco */
\n	{ 
	  ++num_lines;
	}
;(.)*   /* Ignorar comentarios */

 /* Registros */

"$r"[0-7]   {
	      Token t(REG, yytext[yyleng-1] - '0', num_lines, NULL);
	      tokens.push_back(t);
	    }
"$ra"       {
	      Token t(REG, 11, num_lines, NULL);
	      tokens.push_back(t);
	    }
"$sp"       {
	      Token t(REG, 13, num_lines, NULL);
	      tokens.push_back(t);
	    }
"$a"[0-1]   {
	      Token t(REG, 8 + yytext[yyleng-1] - '0', num_lines, NULL);
	      tokens.push_back(t);
	    }
"$s0"	    {
	      Token t(REG, 10, num_lines, NULL);
	      tokens.push_back(t);
	    }
"$pc"	    {
	      Token t(REG, 12, num_lines, NULL);
	      tokens.push_back(t);
	    }

 /* Palabras Reservadas */

add	    {
	      Token t(OPCODE, 0, num_lines, NULL);
	      tokens.push_back(t);
	    }
sub	    {
	      Token t(OPCODE, 1, num_lines, NULL);
	      tokens.push_back(t);
	    }
mul	    {
	      Token t(OPCODE, 2, num_lines, NULL);
	      tokens.push_back(t);
	    }
div	    {
	      Token t(OPCODE, 3, num_lines, NULL);
	      tokens.push_back(t);
	    }
fadd	    {
	      Token t(OPCODE, 4, num_lines, NULL);
	      tokens.push_back(t);
	    }
fsub	    {
	      Token t(OPCODE, 5, num_lines, NULL);
	      tokens.push_back(t);
	    }
fmul	    {
	      Token t(OPCODE, 6, num_lines, NULL);
	      tokens.push_back(t);
	    }
fdiv	    {
	      Token t(OPCODE, 7, num_lines, NULL);
	      tokens.push_back(t);
	    }
and	    {
	      Token t(OPCODE, 8, num_lines, NULL);
	      tokens.push_back(t);
	    }
or	    {
	      Token t(OPCODE, 9, num_lines, NULL);
	      tokens.push_back(t);
	    }
xor	    {
	      Token t(OPCODE, 10, num_lines, NULL);
	      tokens.push_back(t);
	    }
not	    {
	      Token t(OPCODE, 11, num_lines, NULL);
	      tokens.push_back(t);
	    }
lb	    {
	      Token t(OPCODE, 12, num_lines, NULL);
	      tokens.push_back(t);
	    }
lw	    {
	      Token t(OPCODE, 13, num_lines, NULL);
	      tokens.push_back(t);
	    }
sb	    {
	      Token t(OPCODE, 14, num_lines, NULL);
	      tokens.push_back(t);
	    }
sw	    {
	      Token t(OPCODE, 15, num_lines, NULL);
	      tokens.push_back(t);
	    }
li	    {
	      Token t(OPCODE, 16, num_lines, NULL);
	      tokens.push_back(t);
	    }
b	    {
	      Token t(OPCODE, 17, num_lines, NULL);
	      tokens.push_back(t);
	    }
beqz	    {
	      Token t(OPCODE, 18, num_lines, NULL);
	      tokens.push_back(t);
	    }
bltz	    {
	      Token t(OPCODE, 19, num_lines, NULL);
	      tokens.push_back(t);
	    }
syscall	    {
	      Token t(OPCODE, 20, num_lines, NULL);
	      tokens.push_back(t);
	    }

 /* Instrucciones adicionales 
  * Se agrega un opcode ficticio de 21 para MOV.
  */

mov         {
	      Token t(OPCODE, 21, num_lines, NULL);
	      tokens.push_back(t);
	    }

 /* Macros de definicion */

".text"	       {
	         Token t(TEXT, 0, num_lines, NULL);
	      	 tokens.push_back(t);
	       }
".ascii"[ \t]  {
		 Token t(ASCII, 0, num_lines, NULL);
	      	 tokens.push_back(t);
	       }
".asciiz"[ \t] {
		 Token t(ASCIIZ, 0, num_lines, NULL);
	      	 tokens.push_back(t);
	       }

 /* Numeros, ids y strings */

-?[0-9]+     	      {
	      	        Token t(INT, atoi(yytext), num_lines, NULL);
			tokens.push_back(t);
	    	      }

[a-zA-Z][a-zA-Z0-9]*  {
		        char *id = new char[strlen(yytext)+1];
			strcpy(id, yytext);
	      	        Token t(ID, 0, num_lines, id);
			tokens.push_back(t);
	    	      }
\"		      {
			strlitlen = 0;
			int i;
			for(i = 0 ; i < MAX_STR_SIZE ; ++i){
			   strlit[i] = '\0';
			}
			BEGIN(STRING);
		      }
<STRING>\\\"	      insertChar('"');
<STRING>\\[^bnft\\]   yyless(1); insertChar(yytext[0]);
<STRING>\\b	      insertChar('\b');
<STRING>\\n	      insertChar('\n');
<STRING>\\f	      insertChar('\f');
<STRING>\\t	      insertChar('\t');
<STRING>\\\\	      insertChar('\\');
<STRING>[\n]	      lexerror("Malformed string literal");
<STRING>\"	      {
		        BEGIN(INITIAL);
		      	if(overFlag){
			  strlit[0] = '\0';
			  lexerror("String literal size overflow");
			} else {
			  strlit[strlitlen] = '\0';
			  char *ns = new char[strlitlen+1];
			  strcpy(ns, strlit);
			  Token t(STR, 0, num_lines, ns);
			  tokens.push_back(t);
			}
		      }
<STRING>.	      insertChar(yytext[0]);

 /* Simbolos */

":"	    {
	       Token t(COLON, 0, num_lines, NULL);
	       tokens.push_back(t);
	    }
","	    {
	       Token t(COMA, 0, num_lines, NULL);
	       tokens.push_back(t);
	    }

 /* En caso de no encontrar nada, fallo */

.	    { 
	       lexerror("Unrecognized token");
	    }

%%
void lexerror(const char* msg){
     cerr << msg << " near " << yytext << " on line: " << num_lines << endl;
     lexer_stop = true;
}

#include "main.cpp"
