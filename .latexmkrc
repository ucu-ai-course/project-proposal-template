#!/usr/bin/env perl
# Конфігурація latexmk: примусово XeLaTeX + Biber.
# Overleaf це також підхоплює через "% !TeX program = xelatex" у main.tex.

$pdf_mode = 1;
$pdflatex = 'xelatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';
$biber = 'biber %O %B';
$bibtex_use = 2;

@default_files = ('main.tex');

$clean_ext = 'bbl bcf run.xml synctex.gz fdb_latexmk fls';
