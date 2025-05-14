%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *msg);

int tempVar = 0;

typedef struct {
    char name[100];
} symbol;

symbol symtab[100];
int symcount = 0;

int addSymbol(char *name) {
    for (int i = 0; i < symcount; i++) {
        if (strcmp(symtab[i].name, name) == 0) return i;
    }
    strcpy(symtab[symcount].name, name);
    return symcount++;
}
%}

%union {
    int num;
    char* id;
}

%token <id> ID
%token <num> NUMBER
%token INT PRINT IF ELSE WHILE
%token ASSIGN PLUS MINUS MUL DIV SEMICOLON
%token LT GT LE GE EQ NE
%token LBRACE RBRACE LPAREN RPAREN

%type <num> expr bool_expr

%left PLUS MINUS
%left MUL DIV

%%

program:
    program stmt
    |
    ;

stmt:
    INT ID SEMICOLON {
        addSymbol($2);
        printf("// declare int %s\n", $2);
    }
    |
    ID ASSIGN expr SEMICOLON {
        printf("%s = t%d;\n", $1, $3);
    }
    |
    PRINT ID SEMICOLON {
        printf("print %s;\n", $2);
    }
    |
    IF LPAREN bool_expr RPAREN block {
        printf("// if block\n");
    }
    |
    IF LPAREN bool_expr RPAREN block ELSE block {
        printf("// if-else block\n");
    }
    |
    WHILE LPAREN bool_expr RPAREN block {
        printf("// while block\n");
    }
    ;

block:
    LBRACE stmt_list RBRACE
    ;

stmt_list:
    stmt_list stmt
    |
    /* empty */
    ;

bool_expr:
    expr LT expr    { printf("t%d = t%d < t%d;\n", tempVar, $1, $3); $$ = tempVar++; }
    |
    expr GT expr    { printf("t%d = t%d > t%d;\n", tempVar, $1, $3); $$ = tempVar++; }
    |
    expr LE expr    { printf("t%d = t%d <= t%d;\n", tempVar, $1, $3); $$ = tempVar++; }
    |
    expr GE expr    { printf("t%d = t%d >= t%d;\n", tempVar, $1, $3); $$ = tempVar++; }
    |
    expr EQ expr    { printf("t%d = t%d == t%d;\n", tempVar, $1, $3); $$ = tempVar++; }
    |
    expr NE expr    { printf("t%d = t%d != t%d;\n", tempVar, $1, $3); $$ = tempVar++; }
    ;

expr:
    NUMBER {
        printf("t%d = %d;\n", tempVar, $1);
        $$ = tempVar++;
    }
    |
    ID {
        printf("t%d = %s;\n", tempVar, $1);
        $$ = tempVar++;
    }
    |
    expr PLUS expr {
        printf("t%d = t%d + t%d;\n", tempVar, $1, $3);
        $$ = tempVar++;
    }
    |
    expr MINUS expr {
        printf("t%d = t%d - t%d;\n", tempVar, $1, $3);
        $$ = tempVar++;
    }
    |
    expr MUL expr {
        printf("t%d = t%d * t%d;\n", tempVar, $1, $3);
        $$ = tempVar++;
    }
    |
    expr DIV expr {
        printf("t%d = t%d / t%d;\n", tempVar, $1, $3);
        $$ = tempVar++;
    }
    ;

%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *msg) {
    fprintf(stderr, "Error: %s\n", msg);
}
