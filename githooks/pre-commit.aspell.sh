#!/bin/bash
# Script que usa o programa aspell para detectar erros ortográficos.

had_wrong_words=0
show_wrong_words_message() {
    if (( had_wrong_words == 0 )); then
        echo -n $(tput setaf 1)
        echo Existem palavras com ortografia incorreta no commit.
        echo -n $(tput sgr0)
        (( had_wrong_words = 1 ))
        (( error = 1 ))
    fi
}

# words_to_regex word_list
# Gera uma expressão regular que casará com as palavras de word_list.
# Inclui os delimitadores \< e \>.
words_to_regex() {
    word_list=$1
    echo $word_list | sed 's#.*#\\<\\(&\\)\\>#;s# #\\\|#g'
}

for file in $modified_files; do
    wrong_words=$(aspell --lang=pt-br --mode=tex --list <<< "$(added_lines $file)")
    word_regex=$(words_to_regex "$wrong_words")

    offending_lines=$(added_lines "$file" |
        grep --color=always "$word_regex"
    )

    if [ ! -z "$offending_lines" ]; then
        show_wrong_words_message
        print_line "$file" "$offending_lines"
    fi
done
