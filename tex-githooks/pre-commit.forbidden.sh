#!/bin/bash
# Script que detecta "frases proibidas".

forbidden_regex='\<é as\>\|\<são a\>' # como em "não é as funções..."

found_forbidden=0
show_forbidden_message() {
    if ((found_forbidden == 0)); then
        echo -n $(tput setaf 1)
        echo -n Considere remover as seguintes expressões \"estranhas\":
        echo $(tput sgr0)
        (( found_forbidden = 1 ))
        (( error = 1 ))
    fi
}

for file in $modified_files; do
    offending_lines=$(added_lines "$file" |
        grep --color=always "$forbidden_regex"
    )
    if [ ! -z "$offending_lines" ]; then
        show_forbidden_message
        print_line "$file" "$offending_lines"
    fi
done
