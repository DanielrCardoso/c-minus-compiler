#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "CodeGenerator.h"

typedef struct simbolo {
    char *nome;
    int usada;
    int offset;
    struct simbolo *prox;
} simbolo;

static simbolo* tabela_de_simbolos = NULL;

simbolo* adicionaSimbolo(char* nome);
simbolo* procuraSimbolo(char* nome);
void printSymbolTable();

#endif
