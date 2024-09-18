#!/bin/bash

# Criar diretório para os arquivos gerados se ele não existir
mkdir -p src/generated

# Gerar o analisador léxico com Flex
flex -o src/generated/lex.yy.c src/analyzers/lexer.l

# Gerar o parser com Bison
bison -dv -o src/generated/parser.tab.c src/analyzers/parser.y

bison -dv -o src/generated/y.tab.c src/analyzers/parser.y

# Compilar os arquivos gerados e o código fonte adicional
# Garantindo que o diretório include esteja corretamente especificado com a flag -I
gcc -Isrc/include src/generated/lex.yy.c src/generated/y.tab.c src/utils/CodeGenerator.c src/utils/SymbolTable.c src/utils/Parser.c src/main.c -o c_minus_compiler

echo "Build concluído com sucesso!"
