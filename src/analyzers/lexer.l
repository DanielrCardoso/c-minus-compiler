%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h"

%}

id          [a-zA-Z][a-zA-Z0-9]*
numero      [-+]?([0-9]*[.][0-9]+|[0-9]+)
comentario  "/*"(.|\n)*"*/"
whitespace  [ \t\n]+

%%

"="          { printf("ATRIBUICAO: %s\n", yytext); return ATRIBUICAO; }
"+"          { printf("ADICAO: %s\n", yytext); return ADICAO; }
"-"          { printf("SUBTRACAO: %s\n", yytext); return SUBTRACAO; }
"*"          { printf("MULTIPLICACAO: %s\n", yytext); return MULTIPLICACAO; }
"/"          { printf("DIVISAO: %s\n", yytext); return DIVISAO; }

"<="         { printf("MENORIGUAL: %s\n", yytext); return MENORIGUAL; }
"<"          { printf("MENOR: %s\n", yytext); return MENOR; }
">="         { printf("MAIORIGUAL: %s\n", yytext); return MAIORIGUAL; }
">"          { printf("MAIOR: %s\n", yytext); return MAIOR; }
"=="         { printf("IGUAL: %s\n", yytext); return IGUAL; }
"!="         { printf("DIFERENTE: %s\n", yytext); return DIFERENTE; }

";"          { printf("PONTOEVIRGULA: %s\n", yytext); return PONTOEVIRGULA; }
","          { printf("VIRGULA: %s\n", yytext); return VIRGULA; }

"("          { printf("PARENTESEESQUERDO: %s\n", yytext); return PARENTESEESQUERDO; }
")"          { printf("PARENTESEDIREITO: %s\n", yytext); return PARENTESEDIREITO; }
"["          { printf("COLCHETEESQUERDO: %s\n", yytext); return COLCHETEESQUERDO; }
"]"          { printf("COLCHETEDIREITO: %s\n", yytext); return COLCHETEDIREITO; }
"{"          { printf("CHAVEESQUERDA: %s\n", yytext); return CHAVEESQUERDA; }
"}"          { printf("CHAVEDIREITA: %s\n", yytext); return CHAVEDIREITA; }

"gets"       { printf("GETS: %s\n", yytext); return GETS; }
"puts"       { printf("PUTS: %s\n", yytext); return PUTS; }

"if"         { printf("IF: %s\n", yytext); return IF; }
"else"       { printf("ELSE: %s\n", yytext); return ELSE; }
"while"      { printf("WHILE: %s\n", yytext); return WHILE; }
"return"     { printf("RETURN: %s\n", yytext); return RETURN; }
"void"       { printf("VOID: %s\n", yytext); return VOID; }
"int"        { printf("INT: %s\n", yytext); return INT; }
"float"      { printf("FLOAT: %s\n", yytext); return FLOAT; }
"main"       { printf("MAIN: %s\n", yytext); return MAIN; }
"then"       { printf("THEN: %s\n", yytext); return THEN; }
{id}         { printf("IDENTIFICADOR: %s\n", yytext); yylval.cadeia = (char *) strdup(yytext); return IDENTIFICADOR; }
{numero}     { yylval.intval = atof(yytext); return NUMERO; /* printf("NUMERO: %s\n", yytext); */ }
{comentario} { /* printf("COMENTARIO: %s\n", yytext); */ }
{whitespace} { /* Ignora espacos em branco */ }
.            { printf("UNKNOWN: %s\n", yytext); }

%%
int yywrap() {
    return 1;
}