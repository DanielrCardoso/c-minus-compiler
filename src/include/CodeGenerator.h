#ifndef CODE_GENERATOR_H
#define CODE_GENERATOR_H

#include <stdio.h>

#define MAX_CODE_SIZE 999

enum codeOps {HALT, IN, OUT, ADD, SUB, MUL, DIV, LD, LDA, LDC, ST, JLT, JLE, JGE, JGT, JEQ, JNE,};

extern char *op_name[];

struct instruction{
    enum codeOps op;
    int arg[3];
};

extern struct instruction code[999];

enum Regs {t1, t2, t3,r1, r2, sp, mp, pc,};

extern int dataOffset;
extern int codeOffset;

int getDataLocation();
int getCodeOffset();
int incrementCodeOffset(int amount);

void generateCode(enum codeOps operation, int arg0, int arg1, int arg2);
void updateCode(int address, enum codeOps operation, int arg0, int arg1, int arg2);
void pushToStack();
void popFromStack();
void copyRegister(enum Regs from, enum Regs to);
void performArithmeticOperation(enum codeOps operation);
void initializeProgram();
void printCode();

#endif