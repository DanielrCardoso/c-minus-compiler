%{
#include "Parser.h"
extern int yylex();
void yyerror(const char *s);
%}

%union {
    char *cadeia;
    int intval;
}

%token ATRIBUICAO ADICAO SUBTRACAO MULTIPLICACAO DIVISAO PONTOEVIRGULA VIRGULA
%token PARENTESEESQUERDO PARENTESEDIREITO COLCHETEESQUERDO COLCHETEDIREITO
%token CHAVEESQUERDA CHAVEDIREITA MENOR MENORIGUAL MAIOR MAIORIGUAL IGUAL DIFERENTE
%token IF ELSE WHILE RETURN VOID INT FLOAT GETS PUTS MAIN THEN
%token <cadeia> IDENTIFICADOR
%token <intval> NUMERO

%type <cadeia> variavel

%start programa

%left ADICAO SUBTRACAO
%left MULTIPLICACAO DIVISAO
%left UMINUS

%%
programa:
    INT MAIN PARENTESEESQUERDO VOID PARENTESEDIREITO CHAVEESQUERDA
        lista_declaracoes { initializeProgram(); }
        lista_afirmacoes {
            generateCode(HALT, 0, 0, 0);
            simbolo* atual = tabela_de_simbolos;
            while (atual != NULL) {
                if (atual->usada == 0) {
                    printf("WARNING: A variável \"%s\" foi declarada mas não utilizada.\n", atual->nome);
                }
                atual = atual->prox;
            }
            printCode();
            YYACCEPT;
        }
    CHAVEDIREITA
    ;

lista_declaracoes:
    lista_declaracoes declaracao_var
    | declaracao_var
    |
    ;

declaracao_var:
    tipo IDENTIFICADOR PONTOEVIRGULA { declarar($2); }
    ;

tipo:
    VOID
    | INT
    ;

lista_afirmacoes:
    lista_afirmacoes afirmacao
    |
    ;

afirmacao:
    afirmacao_expressao
    | afirmacao_selecao
    | afirmacao_iterativa
    | afirmacao_retorno
    | afirmacao_gets
    | afirmacao_puts
    ;

afirmacao_expressao:
    expressao PONTOEVIRGULA
    | PONTOEVIRGULA
    ;

afirmacao_selecao:
    IF PARENTESEESQUERDO expressao PARENTESEDIREITO THEN CHAVEESQUERDA {
        incrementCodeOffset(4);
        add_stack(start_if_ptr, getCodeOffset());
    } lista_afirmacoes CHAVEDIREITA {
        int start_else = getCodeOffset();
        int start_if = sub_stack(start_if_ptr);
        updateCode(start_if - 4, LD, t1, 0, sp);
        updateCode(start_if - 3, LDA, sp, 1, sp);
        updateCode(start_if - 2, LDC, t2, start_else, 0);
        updateCode(start_if - 1, JEQ, t1, 0, t2);
    }
    | IF PARENTESEESQUERDO expressao PARENTESEDIREITO CHAVEESQUERDA {
        incrementCodeOffset(4);
        add_stack(start_if_ptr, getCodeOffset());
    } lista_afirmacoes CHAVEDIREITA ELSE CHAVEESQUERDA {
        incrementCodeOffset(3);
        add_stack(start_else_ptr, getCodeOffset());
    } lista_afirmacoes {
        int end_else = getCodeOffset();
        int start_else = sub_stack(start_else_ptr);
        int start_if = sub_stack(start_if_ptr);
        updateCode(start_if - 4, LD, t1, 0, sp);
        updateCode(start_if - 3, LDA, sp, 1, sp);
        updateCode(start_if - 2, LDC, t2, start_else, 0);
        updateCode(start_if - 1, JEQ, t1, 0, t2);
        updateCode(start_else - 3, LDC, t1, end_else, 0);
        updateCode(start_else - 2, LDC, t2, 0, 0);
        updateCode(start_else - 1, JEQ, t2, 0, t1);
    }
    CHAVEDIREITA
    ;

afirmacao_iterativa:
    WHILE PARENTESEESQUERDO {
        add_stack(start_comp_ptr, getCodeOffset());
    } expressao {
        incrementCodeOffset(4);
        add_stack(start_while_ptr, getCodeOffset());
    } PARENTESEDIREITO CHAVEESQUERDA lista_afirmacoes {
        int start_while = sub_stack(start_while_ptr);
        int start_comp = sub_stack(start_comp_ptr);
        generateCode(LDC, t1, start_comp, 0);
        generateCode(LDC, t2, 0, 0);
        generateCode(JEQ, t2, 0, t1);
        int end_while = getCodeOffset();
        updateCode(start_while - 4, LD, t1, 0, sp);
        updateCode(start_while - 3, LDA, sp, 1, sp);
        updateCode(start_while - 2, LDC, t2, end_while, 0);
        updateCode(start_while - 1, JEQ, t1, 0, t2);
    }
    CHAVEDIREITA
    ;

afirmacao_retorno:
    RETURN PONTOEVIRGULA
    | RETURN expressao PONTOEVIRGULA
    ;

afirmacao_gets:
    GETS PARENTESEESQUERDO IDENTIFICADOR PARENTESEDIREITO PONTOEVIRGULA {
        int offset = utilizar($3);
        generateCode(IN, t1, 0, 0);
        generateCode(LDC, t2, 0, 0);
        generateCode(LD, t2, 0, t2);
        generateCode(ST, t1, -offset, t2);
    }
    ;

afirmacao_puts:
    PUTS PARENTESEESQUERDO fator PARENTESEDIREITO PONTOEVIRGULA {
        popFromStack();
        generateCode(OUT, t1, 0, 0);
    }
    ;

expressao:
    IDENTIFICADOR ATRIBUICAO expressao {
        int offset = utilizar($1);
        popFromStack();
        generateCode(LDC, t2, 0, 0);
        generateCode(LD, t2, 0, t2);
        generateCode(ST, t1, -offset, t2);
    }
    | expressao_simples
    ;

variavel:
    IDENTIFICADOR {
        int offset = utilizar($1);
        generateCode(LDC, t1, 0, 0);
        generateCode(LD, t1, 0, t1);
        generateCode(LD, t1, -offset, t2);
        pushToStack();
        $$ = $1;
    }
    ;

expressao_simples:
    expressao_matematica MENOR expressao_matematica {
        performArithmeticOperation(SUB);
        popFromStack();
        copyRegister(t1, t2);
        generateCode(LDC, t1, 1, 0);
        generateCode(JLT, t2, 1, pc);
        generateCode(LDC, t1, 0, 0);
        pushToStack();
    }
    | expressao_matematica MENORIGUAL expressao_matematica {
        performArithmeticOperation(SUB);
        popFromStack();
        copyRegister(t1, t2);
        generateCode(LDC, t1, 1, 0);
        generateCode(JLE, t2, 1, pc);
        generateCode(LDC, t1, 0, 0);
        pushToStack();
    }
    | expressao_matematica MAIOR expressao_matematica {
        performArithmeticOperation(SUB);
        popFromStack();
        copyRegister(t1, t2);
        generateCode(LDC, t1, 1, 0);
        generateCode(JGT, t2, 1, pc);
        generateCode(LDC, t1, 0, 0);
        pushToStack();
    }
    | expressao_matematica MAIORIGUAL expressao_matematica {
        performArithmeticOperation(SUB);
        popFromStack();
        copyRegister(t1, t2);
        generateCode(LDC, t1, 1, 0);
        generateCode(JGE, t2, 1, pc);
        generateCode(LDC, t1, 0, 0);
        pushToStack();
    }
    | expressao_matematica IGUAL expressao_matematica {
        performArithmeticOperation(SUB);
        popFromStack();
        copyRegister(t1, t2);
        generateCode(LDC, t1, 1, 0);
        generateCode(JEQ, t2, 1, pc);
        generateCode(LDC, t1, 0, 0);
        pushToStack();
    }
    | expressao_matematica DIFERENTE expressao_matematica {
        performArithmeticOperation(SUB);
        popFromStack();
        copyRegister(t1, t2);
        generateCode(LDC, t1, 1, 0);
        generateCode(JNE, t2, 1, pc);
        generateCode(LDC, t1, 0, 0);
        pushToStack();
    }
    | expressao_matematica
    ;

expressao_matematica:
    expressao_matematica ADICAO expressao_matematica {
        performArithmeticOperation(ADD);
    }
    | expressao_matematica SUBTRACAO expressao_matematica {
        performArithmeticOperation(SUB);
    }
    | expressao_matematica MULTIPLICACAO expressao_matematica {
        performArithmeticOperation(MUL);
    }
    | expressao_matematica DIVISAO expressao_matematica {
        performArithmeticOperation(DIV);
    }
    | fator
    ;

fator:
    NUMERO {
        generateCode(LDC, t1, $1, 0);
        pushToStack();
    }
    | variavel
    | PARENTESEESQUERDO expressao PARENTESEDIREITO
    ;

%%