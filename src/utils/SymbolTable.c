#include "../include/SymbolTable.h"

// Função para adicionar um novo símbolo à tabela de símbolos
simbolo* adicionaSimbolo(char* nome) {
    // Aloca memória para o novo símbolo
    simbolo* ptr = (simbolo*) malloc(sizeof(simbolo));
    
    // Aloca memória e copia o nome do símbolo
    ptr->nome = (char*) malloc(strlen(nome) + 1);
    strcpy(ptr->nome, nome);
    
    // Define o offset do símbolo usando a função getDataLocation
    ptr->offset = getDataLocation();
    
    // Define se o símbolo foi usado (marcado como 1) ou não (marcado como 0)
    if (strcmp(nome, "main") == 0) {
        ptr->usada = 1;  // "main" é considerado como usado
    } else {
        ptr->usada = 0;  // Outros símbolos não são marcados como usados inicialmente
    }

    // Insere o símbolo no início da lista de símbolos
    ptr->prox = tabela_de_simbolos;
    tabela_de_simbolos = ptr;

    // Retorna o ponteiro para o novo símbolo adicionado
    return ptr;
}

// Função para procurar um símbolo na tabela de símbolos pelo nome
simbolo* procuraSimbolo(char* nome) {
    simbolo* atual = tabela_de_simbolos;

    // Percorre a lista de símbolos procurando pelo nome
    while (atual != NULL) {
        if (strcmp(atual->nome, nome) == 0) {
            return atual;  // Retorna o símbolo encontrado
        }
        atual = atual->prox;  // Move para o próximo símbolo na lista
    }
    // Retorna NULL se o símbolo não for encontrado
    return NULL;
}

// Função para imprimir a tabela de símbolos formatada
void printSymbolTable() {
    // Imprime o cabeçalho da tabela de símbolos
    printf("\nTabela de Símbolos:\n");
    printf("+----------------+---------+--------+\n");
    printf("| Nome           | Offset  | Usada  |\n");
    printf("+----------------+---------+--------+\n");

    simbolo* atual = tabela_de_simbolos;
    
    // Percorre a lista de símbolos e imprime cada um formatado
    while (atual != NULL) {
        printf("| %-14s | %7d | %6d |\n", atual->nome, atual->offset, atual->usada);
        atual = atual->prox;  // Move para o próximo símbolo na lista
    }

    // Imprime a borda inferior da tabela
    printf("+----------------+---------+--------+\n");
}
