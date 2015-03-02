# clean-section name
# Localiza, no .gitignore, uma seção delimitada por
# '# name' no início e uma linha em branco no fim
# e exclui todos os arquivos que correspondem
# aos glob patterns contidos nesta seção.
define clean-section
set -f; \
pattern_list=$$( \
	sed '0,/^# $(1)$$/d' .gitignore \
	| sed '/^$$/,$$d' \
); \
for pattern in $$pattern_list; do \
	find -name $$pattern -exec rm {} +; \
done
endef

# Todos os arquivos tex deste diretório
TEX := $(shell find . -name "*.tex")

# Convenção: todos os arquivos que são transformáveis em pdf possuem
# o comando \end{document} numa linha por si só.
# Note que este comando pode falhar com linhas excessivamente grandes.
TEXSRC := $(shell grep --files-with-matches '^\\end{document}$$' $(TEX))

# Dependências
#
# Estes arquivos são gerados pelo latexmk
# durante o processo de compilação.
#
# Eles contêm uma regra
# que torna tanto o arquivo .pdf quanto o .dep.mk
# dependentes de todos os arquivos
# que influenciam em sua compilação.
#
# Note que não existe nenhuma receita disponível para arquivos .dep.mk,
# embora eles serem construídos junto do .pdf.
# Como ambos os arquivos possuem os mesmos conjuntos de dependências,
# não costuma haver problema em ``mentir'' para o makefile neste caso,
# pois sempre que o .dep.mk precisa ser reconstruído
# (de acordo com a regra criada pelo latexmk)
# o .pdf também precisa.
#
# Há um caso em que esta ``mentira'' causa problemas:
# quando o .pdf existe, mas o .dep.mk não.
# Isso pode ocorrer, por exemplo, quando algum .dep.mk
# é excluído acidentalmente.
# Precisamos de um malabarismo adicional para lidar com este caso.
#
# A solução usada é fazer o .pdf depender do .dep.mk,
# e adicionar uma regra sem prerequisitos nem receita para o .dep.mk.
# Na inexistência do .dep.mk,
# o .pdf possuirá como dependência apenas o .dep.mk.
# Como o .dep.mk não existe, ele deve ser reconstruído.
# Como sua regra não possui nem receita nem prerequisitos,
# o makefile considera que ele acabou de ser atualizado
# e, portanto, o .pdf precisa ser reconstruído.
# Então, o comando de construção do .pdf gera o .dep.mk.
#
# (O latexmk é inteligente o bastante para recompilar o .pdf
# apenas se os hashes dos arquivos se alteraram,
# portanto uma mera deleção dos *.dep.mk é corrigida rapidamente.)
#
# Quando o .dep.mk existe,
# a única regra que criamos para ele perde o sentido,
# pois ela é subsumida pela regra que o próprio .dep.mk define.
# Entretanto, o .pdf ainda depende do .dep.mk.
# Mas é a própria receita do .pdf que irá construir o .dep.mk!
# Portanto, precisamos nos assegurar de que a timestamp do .pdf
# seja sempre posterior à timestamp do .dep.mk.
# Isso é alcançado com um simples `touch $*.pdf`.
DEP := $(TEXSRC:%.tex=%.dep.mk)

PDF := $(TEXSRC:%.tex=%.pdf)

include bib/makefile
-include $(DEP)

# Regras

.DEFAULT_GOAL := all

all: bib-all $(PDF)

$(DEP): %.dep.mk:

$(PDF): %.pdf: %.dep.mk
	latexmk -pdf $*.tex --deps-out=$*.dep.mk
	touch $*.pdf

mostlyclean: bib-mostlyclean
	$(call clean-section,LaTeX temporaries)

clean: bib-clean mostlyclean
	$(call clean-section,Binary output)
