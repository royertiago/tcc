#!/bin/bash
# Para conjugar um verbo no futuro em inglês
# é adicionando a palavra "will" antes do verbo;
# por exemplo, "will compute".
#
# A tradução literal para o português é "irá computar".
# Mas existe uma tradução melhor: "computará".
# Este script alerta a presença de palavras como "irá" e "iremos",
# pois muitas vezes elas podem ser substituidas por construções melhores.
#
# Eu peguei o cacoete de escrever usando "irá" e "iremos"
# após me acostumar a escrever em inglês a documentação de meus programas.

cacoete_verbo_ir=0
mensagem_cacoete_ir() {
    if ((cacoete_verbo_ir == 0)); then
        echo -n $(tput setaf 1)
        echo Considere substituir construções como \"irá computar\"
        echo -n por \"computará\" nas linhas abaixo.
        echo $(tput sgr0)
        (( cacoete_verbo_ir = 1 ))
        (( error = 1 ))
    fi
}

conjugacoes_ir="[Ii]rá\|[Ii]remos\|[Ii]rão"

for file in $modified_files; do
    offending_lines=$(added_lines "$file" |
        grep --color=always "\<\($conjugacoes_ir\)\>"
    )
    if [ ! -z "$offending_lines" ]; then
        mensagem_cacoete_ir
        print_line "$file" "$offending_lines"
    fi
done
