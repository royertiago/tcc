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

# extract-latex-dependencies filename
# Extrai todos os arquivos incluídos por filename
# através de comandos "input" e "include".
define extract-latex-dependencies
sed -n 's/[^%]*\\\(input\|include\) *{\([^}]*\)}.*/\2.tex/p' $(1)
endef

# tex-target file
# Alvo para arquivos .tex
# Este alvo atualiza a timestamp do arquivo.
# Desta forma, o próprio sistema de makefiles
# se encarrega de gerenciar as dependências para nós.
#
# Uma inconveniência: caso o arquivo esteja aberto no Vim,
# ele reclamará que o arquivo foi "modificado" desde a última escrita.
define tex-rule

$(1): $(shell $(call extract-latex-dependencies, $(1)))
	touch $(1)

endef

# generate-tex-rule file
# Gera um alvo para arquivos .tex de acordo com a variável tex-target.
define generate-tex-rule
$(eval $(call tex-rule,$(1)))
endef


# Todos os arquivos tex deste diretório
TEX := $(shell find . -name "*.tex")

# Convenção: todos os arquivos que são transformáveis em pdf possuem
# o comando \end{document} numa linha por si só.
# Note que este comando pode falhar com linhas excessivamente grandes.
TEXSRC := $(shell grep --files-with-matches '^\\end{document}$$' $(TEX))

PDF := $(TEXSRC:%.tex=%.pdf)


include bib/makefile

# Regras

.DEFAULT_GOAL := all

all: bib-all $(PDF)

$(PDF): %.pdf : %.tex $(BIB)
	latexmk -pdf $<

# Gera toda a cadeia de pré-requisidos para arquivos .tex.
$(eval $(foreach file,$(TEX),$(call tex-rule,$(file))))

mostlyclean: bib-mostlyclean
	$(call clean-section,LaTeX temporaries)

clean: bib-clean mostlyclean
	$(call clean-section,Binary output)
