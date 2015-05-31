#!/bin/bash
# Script que detecta a ausência de ties (~, non-breakable space)
# em comandos \cite.

lack_tie=0
show_tie_message() {
    if ((lack_tie == 0)); then
        echo -n $(tput setaf 1)
        echo Existem números de página, em comandos '\cite', sem ties.
        echo -n Considere substituir, por exemplo, "'[p. 15]' por '[p.~15]'."
        echo $(tput sgr0)
        (( lack_tie = 1 ))
        (( error = 1 ))
    fi
}

for file in $modified_files; do
    offending_lines=$(added_lines "$file" |
        grep --color=always '\[p. [0-9]*\(\]\|,[^]]*]\)'
    )
    if [ ! -z "$offending_lines" ]; then
        show_tie_message
        print_line "$file" "$offending_lines"
    fi
done
