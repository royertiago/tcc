#!/bin/bash
# Provê algumas funções de conveniência para os scripts.

# $toplevel
# Caminho absoluto para a raiz do diretório.
# Inclui a barra à direita.
toplevel=$(git rev-parse --show-toplevel)/

# $modified_files
# Lista de todos os arquivos modificados neste commit,
# separados por nova-linha ('\n').
#
# A lista conterá apenas nomes absolutos, prefixados por toplevel.
modified_files=$(git diff --name-only --cached |
    sed "s|.*|$toplevel&|"
)

# print_line filename lines
# Imprime as linhas especificadas, com o nome do arquivo prefixado em roxo.
#
# Caso 'file' seja um caminho prefixado por toplevel,
# a função remove os diretórios iniciais antes de imprimir.
print_line() {
    local file="$1"
    local lines="$2"
    file=${file#$toplevel}
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
