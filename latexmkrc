@default_files = (
    'ratificacao1',
    'ratificacao2',
    'paper',
    'tcc',
    'seminario-2015-03-26',
    'livreto',
    'defesa',
    'proposta',
);
$pdf_mode = 1; $postscript_mode = $dvi_mode = 0;
$bibtex_use = 2; # Treat bbl files as regeneratable
$clean_ext = 'nav snm lsb thm';

system("make -s -C bib");
# Side effect: 'latexmk -C' does not erase bib/bibliography.bib.
