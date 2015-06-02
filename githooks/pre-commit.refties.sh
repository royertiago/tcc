#!/bin/bash
# Script que detecta a ausência de ties (~) antes de comanods \ref.

lack_ref_tie=0
show_ref_tie_message() {
    if ((lack_tie == 0)); then
        echo -n $(tput setaf 1)
        echo -n Considere adicionar ties '(~)' antes de comandos '\ref'.
        echo $(tput sgr0)
        (( lack_tie = 1 ))
        (( error = 1 ))
    fi
}

for file in $modified_files; do
    offending_lines=$(added_lines "$file" |
        grep --color=always '\(^\|[^~]\)\\ref'
    )
    if [ ! -z "$offending_lines" ]; then
        show_ref_tie_message
        print_line "$file" "$offending_lines"
    fi
done
