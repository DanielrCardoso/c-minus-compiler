#include "../include/CodeGenerator.h"

// Estrutura que armazena as instruções de código gerado
struct instruction code[MAX_CODE_SIZE];

// Variáveis globais para rastrear os offsets de dados e de código
int dataOffset = 0;  // Offset atual para alocação de dados
int codeOffset = 0;  // Offset atual para a próxima instrução de código

// Array com os nomes das operações suportadas
const char *operationNames[] = {
    "HALT", "IN", "OUT", "ADD", "SUB", "MUL", "DIV", "LD",
    "LDA", "LDC", "ST", "JLT", "JLE", "JGE", "JGT", "JEQ", "JNE"
};

// Obtém o próximo local disponível para dados e incrementa o offset de dados
int getDataLocation() {
    return dataOffset++;
}

// Retorna o offset atual do código
int getCodeOffset() {
    return codeOffset;
}

// Incrementa o offset do código por um valor específico e retorna o novo offset
int incrementCodeOffset(int amount) {
    return codeOffset += amount;
}

// Gera uma nova instrução de código e incrementa o offset do código
void generateCode(enum codeOps operation, int arg0, int arg1, int arg2) {
    if (codeOffset < MAX_CODE_SIZE) {  // Verifica se ainda há espaço para mais instruções
        code[codeOffset].op = operation;  // Define a operação da instrução
        code[codeOffset].arg[0] = arg0;   // Define o primeiro argumento da instrução
        code[codeOffset].arg[1] = arg1;   // Define o segundo argumento da instrução
        code[codeOffset].arg[2] = arg2;   // Define o terceiro argumento da instrução
        codeOffset++;  // Incrementa o offset para a próxima instrução
    } else {
        // Se o limite máximo de código for alcançado, imprime um erro e encerra o programa
        fprintf(stderr, "ERROR: Maximum code size reached.\n");
        exit(1);
    }
}

// Atualiza uma instrução existente no código no endereço especificado
void updateCode(int address, enum codeOps operation, int arg0, int arg1, int arg2) {
    if (address < codeOffset) {  // Verifica se o endereço está dentro dos limites do código gerado
        code[address].op = operation;  // Atualiza a operação da instrução
        code[address].arg[0] = arg0;   // Atualiza o primeiro argumento da instrução
        code[address].arg[1] = arg1;   // Atualiza o segundo argumento da instrução
        code[address].arg[2] = arg2;   // Atualiza o terceiro argumento da instrução
    } else {
        // Se o endereço estiver fora dos limites, imprime um erro e encerra o programa
        fprintf(stderr, "ERROR: Address out of code bounds.\n");
        exit(1);
    }
}

// Empurra um valor da pilha de dados para a pilha de código
void pushToStack() {
    generateCode(LDA, sp, -1, sp);  // Carrega o valor do topo da pilha de dados para o registrador de pilha
    generateCode(ST, t1, 0, sp);    // Armazena o valor do registrador t1 na posição do topo da pilha
}

// Remove um valor do topo da pilha de dados
void popFromStack() {
    generateCode(LD, t1, 0, sp);    // Carrega o valor do topo da pilha para o registrador t1
    generateCode(LDA, sp, 1, sp);    // Atualiza o ponteiro da pilha para apontar para o próximo valor
}

// Copia o valor de um registrador para outro
void copyRegister(enum Regs from, enum Regs to) {
    generateCode(LDA, to, 0, from);  // Carrega o valor do registrador de origem para o registrador de destino
}

// Realiza uma operação aritmética com base no código de operação fornecido
void performArithmeticOperation(enum codeOps operation) {
    popFromStack();           // Remove o primeiro operando da pilha
    copyRegister(t1, t2);     // Copia o operando removido para o registrador t2
    popFromStack();           // Remove o segundo operando da pilha
    generateCode(operation, t1, t1, t2);  // Gera a instrução aritmética usando os dois operandos
    pushToStack();           // Empurra o resultado da operação de volta para a pilha
}

// Inicializa o programa configurando a pilha e os dados
void initializeProgram() {
    generateCode(LD, sp, t1, 0);           // Carrega o valor do topo da pilha para o registrador t1
    generateCode(LDC, t1, dataOffset, 0);  // Carrega o offset dos dados no registrador t1
    generateCode(SUB, sp, sp, t1);         // Ajusta o ponteiro da pilha para considerar o espaço dos dados
}

// Imprime todas as instruções geradas até o momento
void printCode() {
    for (int i = 0; i < codeOffset; i++) {  // Itera sobre todas as instruções geradas
        printf("%3d: %-5s %d, %d, %d\n", i, operationNames[(int)code[i].op], code[i].arg[0], code[i].arg[1], code[i].arg[2]);
        // Imprime o índice, a operação e os argumentos de cada instrução
    }
}
