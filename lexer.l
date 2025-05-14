%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

digit   [0-9]+
id      [a-zA-Z_][a-zA-Z0-9_]*

%%

"int"           { return INT; }
"print"         { return PRINT; }
"if"            { return IF; }
"else"          { return ELSE; }
"while"         { return WHILE; }

"<="            { return LE; }
">="            { return GE; }
"=="            { return EQ; }
"!="            { return NE; }
"<"             { return LT; }
">"             { return GT; }

"{"             { return LBRACE; }
"}"             { return RBRACE; }
"("             { return LPAREN; }
")"             { return RPAREN; }

{id}            { yylval.id = strdup(yytext); return ID; }
{digit}         { yylval.num = atoi(yytext); return NUMBER; }

"="             { return ASSIGN; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MUL; }
"/"             { return DIV; }
";"             { return SEMICOLON; }

[ \t\r\n]+      { /* skip whitespace */ }

.               { return yytext[0]; }

%%

int yywrap() { return 1; }
