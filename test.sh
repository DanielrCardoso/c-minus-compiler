#!/bin/bash

# Define o nome do compilador
COMPILER_NAME="c_minus_compiler"

# Verifica se o compilador está disponível
if ! [ -x "$(command -v ./$COMPILER_NAME)" ]; then
  echo "Compilador não encontrado, tentando construir..."
  ./build.sh
fi

# Verifica novamente se o compilador está disponível após tentativa de construção
if ! [ -x "$(command -v ./$COMPILER_NAME)" ]; then
  echo "Falha ao construir o compilador. Certifique-se de que build.sh está configurado corretamente."
  exit 1
fi

# Executa testes de 1 a 7
for i in {1..7}
do
  echo "Executando o $COMPILER_NAME com teste$i.c - Teste $i"
  ./$COMPILER_NAME < examples/teste$i.c
  echo
  echo
  echo "=========================================================================="
  echo
  echo
done

# Permissões para executar este script:
# chmod +x test.sh
# ./test.sh