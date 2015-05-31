#!/bin/bash
# Provê algumas funções de conveniência para os scripts.

# print_line filename lines
# Imprime as linhas especificatas, com o nome do arquivo prefixado em roxo.
print_line() {
    local file="$1"
    local lines="$2"
    sed "s|\(.*\)|$(tput setaf 5)$file$(tput sgr0):\1|" <<< "$lines"
}

# added_lines filename
# Escreve em stdout todas as linhas a serem adicionadas do arquivo,
# mas sem os '+' iniciais.
added_lines() {
    local file="$1"
    git diff --cached -- "$file" | sed -n 's/^[+]\([^+]\)/\1/p'
    # Precisamos daquele [^+] para não incluir na saida
    # a linha com +++ que contém o nome do arquivo.
}
