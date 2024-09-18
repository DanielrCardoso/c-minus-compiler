#include "Parser.h"

// Declaração de pilhas para gerenciamento de controle de fluxo
int stack1[MAX_STACK_SIZE], stack2[MAX_STACK_SIZE], stack3[MAX_STACK_SIZE], stack4[MAX_STACK_SIZE], stack5[MAX_STACK_SIZE];

// Ponteiros para o início e fim das pilhas usadas em diferentes contextos
int *start_if_ptr = stack1;
int *start_else_ptr = stack2;
int *start_comp_ptr = stack3;
int *start_while_ptr = stack4;
int *end_while_ptr = stack5;

// Função para utilizar uma variável
int utilizar(char* nome) {
    // Procura o símbolo na tabela de símbolos pelo nome fornecido
    simbolo* s = procuraSimbolo(nome);
    
    // Verifica se o símbolo foi encontrado
    if(s == NULL) {
        // Se não encontrado, imprime uma mensagem de erro e encerra o programa
        printf("ERRO: A variável \"%s\" não foi declarada.\n", nome);
        exit(EXIT_FAILURE);
    }
    
    // Marca a variável como utilizada
    s->usada = 1;
    
    // Retorna o offset da variável
    return s->offset;
}

// Função para declarar uma nova variável
void declarar(char* nome) {
    // Procura o símbolo na tabela de símbolos pelo nome fornecido
    simbolo* s = procuraSimbolo(nome);
    
    // Verifica se o símbolo já foi declarado
    if(s != NULL) {
        // Se já foi declarado, imprime uma mensagem de erro e encerra o programa
        printf("ERRO: A variável \"%s\" já foi declarada\n", nome);
        exit(EXIT_FAILURE);
    }
    
    // Adiciona o novo símbolo à tabela de símbolos
    s = adicionaSimbolo(nome);
}

// Função de tratamento de erros de sintaxe
void yyerror(const char *s) {
    // Imprime uma mensagem de erro de sintaxe para o fluxo de erro padrão
    fprintf(stderr, "ERRO: erro de sintaxe: %s\n", s);
}
