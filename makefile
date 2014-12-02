# Convenção: todos os arquivos que são transformáveis em pdf possuem
# o comando \end{document} numa linha por si só. O comando abaixo localiza
# esta linha e imprime o nome do arquivo que a contém.
GREPTEXSOURCE := grep --files-with-matches '^\\end{document}$$'

# O comando abaixo localiza os arquivos que podem ser transformados em pdf,
# de acordo com a convenção acima.
TEXSRC := $(shell find . -name "*.tex" -exec $(GREPTEXSOURCE) '{}' \;)

PDFS := $(TEXSRC:%.tex=%.pdf)

BIBNAME = bibliography.bib
BIBSRC := $(shell find bib/ -name "*.bib")

all: $(PDFS) $(BIBNAME)

bibliography.bib: $(BIBSRC)
	cat $(BIBSRC) > $(BIBNAME)

$(PDFS): %.pdf : %.tex $(BIBNAME)
	latexmk -pdf $<

clean:
	find -name "*.aux" -exec rm '{}' \;
	find -name "*.bbl" -exec rm '{}' \;
	find -name "*.blg" -exec rm '{}' \;
	find -name "*.fdb_latexmk" -exec rm '{}' \;
	find -name "*.fls" -exec rm '{}' \;
	find -name "*.log" -exec rm '{}' \;
	find -name "*.toc" -exec rm '{}' \;

veryclean:
	find -name "*.pdf" -exec rm '{}' \;
	find -name "*.dvi" -exec rm '{}' \;
	rm $(BIBNAME)
