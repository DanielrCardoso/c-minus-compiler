#include "Parser.h"

int main(int argc, char **argv) {
    FILE *output_file = fopen("codigo_gerado.tm", "w");
    if(!output_file){
        fprintf(stderr, "ERRO: falha ao abrir o arquivo de saida\n");
        return 1;
    }

    int stdout_fd = dup(fileno(stdout));
    dup2(fileno(output_file), fileno(stdout));

    yyparse();

    printSymbolTable();

    dup2(stdout_fd, fileno(stdout));
    close(stdout_fd);
    fclose(output_file);

    return 0;
}
