#ifndef PARSER_H
#define PARSER_H

#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "SymbolTable.h"
#include "CodeGenerator.h"

#define MAX_STACK_SIZE 32
#define add_stack(sp, n) (*((sp)++) = (n))
#define sub_stack(sp) (*--(sp))

int utilizar(char* nome);
void declarar(char* nome);
int getDataLocation();
int getCodeOffset();
int incrementCodeOffset(int amount);
void generateCode(enum codeOps operation, int arg0, int arg1, int arg2);
void updateCode(int addr, enum codeOps operation, int arg0, int arg1, int arg2);
void popFromStack();
void pushToStack();
void copyRegister(enum Regs from, enum Regs to);
void initializeProgram();
void performArithmeticOperation(enum codeOps op);
void printCode();
void yyerror(const char *s);

extern int stack1[MAX_STACK_SIZE], stack2[MAX_STACK_SIZE], stack3[MAX_STACK_SIZE], stack4[MAX_STACK_SIZE], stack5[MAX_STACK_SIZE];
extern int *start_if_ptr, *start_else_ptr, *start_comp_ptr, *start_while_ptr, *end_while_ptr;

#endif
