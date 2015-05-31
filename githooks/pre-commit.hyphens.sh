#!/bin/bash
# Script que detecta se o commit introduzirá hífens no repositório.
#
# Assumimos as funções de conveniência de githooks/pre-commit.utilities.sh

has_hyphen=0
show_hyphen_message() {
    if ((has_hyphen == 0)); then
        echo -n $(tput setaf 1)
        echo As linhas abaixo serão submetidas ao repositório com hífens.
        echo Considere substituí-los por '"='
        echo -n ou ignore este aviso com git commit --no-verify.
        echo $(tput sgr0)
        (( has_hyphen = 1 ))
        (( error = 1 ))
    fi
}

for file in $modified_files; do
    offending_lines=$(added_lines "$file" | grep --color=always '[-]')
    if [ ! -z "$offending_lines" ]; then
        show_hyphen_message
        print_line "$file" "$offending_lines"
    fi
done
