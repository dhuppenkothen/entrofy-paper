SRC = main
LDIR = /Library/TeX/texbin/
supplementary_materials.pdf: supplementary_materials.tex $(SRC).pdf
	$(LDIR)pdflatex supplementary_materials.tex

$(SRC).pdf: $(SRC).tex extra_refs.tex
	$(LDIR)pdflatex $<
	$(LDIR)bibtex $(SRC)
	$(LDIR)pdflatex $<
	$(LDIR)pdflatex $<

extra_refs.tex: supplementary_materials.tex
	$(LDIR)pdflatex supplementary_materials.tex
	grep citation supplementary_materials.aux | sed -e's/citation/nocite/' > extra_refs.tex

check: $(SRC).tex
	$(LDIR)chktex $<
	ispell -t $<

gray: $(SRC).pdf
	gs -sOutputFile=$(SRC)-gray.pdf -sDEVICE=pdfwrite \
        -sColorConversionStrategy=Gray -dProcessColorModel=/DeviceGray \
        -dCompatibilityLevel=1.4 -dNOPAUSE -dBATCH $(SRC).pdf

clean:
	rm -f *.aux *.log *.out

spotless: clean
	rm -f *.dvi *.bak *.bbl *.blg
