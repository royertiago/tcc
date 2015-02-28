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

# Convenção: todos os arquivos que são transformáveis em pdf possuem
# o comando \end{document} numa linha por si só. O comando abaixo localiza
# esta linha e imprime o nome do arquivo que a contém.
GREPTEXSOURCE := grep --files-with-matches '^\\end{document}$$'

# O comando abaixo localiza os arquivos que podem ser transformados em pdf,
# de acordo com a convenção acima.
TEXSRC := $(shell find . -name "*.tex" -exec $(GREPTEXSOURCE) {} +)

PDF := $(TEXSRC:%.tex=%.pdf)

BIBNAME = bibliography.bib
BIBSRC := $(shell find bib/ -name "*.bib")

all: $(PDF) $(BIBNAME)

$(BIBNAME): $(BIBSRC)
	cat $(BIBSRC) > $(BIBNAME)

$(PDF): %.pdf : %.tex $(BIBNAME)
	latexmk -pdf $<

mostlyclean:
	$(call clean-section,LaTeX temporaries)

clean: mostlyclean
	$(call clean-section,Binary output)
	rm $(BIBNAME)
