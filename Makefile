TEX:=$(wildcard *.tex)
TEX_PDF=$(TEX:.tex=.pdf)
AUX=$(TEX:.tex=.aux)
LOGOS:=$(wildcard logos/*.svg)
FIGURAS:=$(wildcard img/*.svg)
FIGURAS_NPDF:=$(wildcard img/*.png img/*.jpg)
ANIMATION:=$(wildcard ani/*.svg)
CODIGO=
BIB=refimg.bib
LOGOS_PDF=$(LOGOS:.svg=.pdf)
FIGURAS_PDF=$(FIGURAS:.svg=.pdf)
ANIMATION_DONE:=$(ANIMATION:.svg=.done)
CODIGO_PDF=$(CODIGO:.c=.pdf)
PDF=$(FIGURAS_PDF) $(CODIGO_PDF) $(LOGOS_PDF)
NPDF=$(FIGURAS_NPDF)
GARBAGE=*.aux *.bbl *.blg *.log *.toc *.lof *.nav *.out *.snm *.vrb

all: $(TEX_PDF)

$(TEX_PDF): %.pdf : %.tex $(PDF) $(NPDF) $(BIB) $(ANIMATION_DONE)
	rm -f $(<:.tex=.lof)
	pdflatex -interaction=nonstopmode -halt-on-error $<
	bibtex $(<:.tex=.aux) || true
	pdflatex -interaction=nonstopmode -halt-on-error $<
	pdflatex -interaction=nonstopmode -halt-on-error $<

$(FIGURAS_PDF): %.pdf : %.svg
	printf "file-open:%s;\
		export-area-page;\
		export-filename:%s;\
		export-overwrite;\
		export-do;" $^ $@\
		| inkscape --shell

$(LOGOS_PDF): %.pdf : %.svg
	printf "file-open:%s;\
		export-area-drawing;\
		export-filename:%s;\
		export-overwrite;\
		export-do;" $^ $@\
		| inkscape --shell

$(CODIGO_PDF): %.pdf :%.c
	printf ":set syntax \n\
		:set number \n\
		:set printfont=currier:8 \n\
		:set printoptions=number:y,header:0 \n\
		:colorscheme default \n\
		:hardcopy > %s \n\
		:q\n" $(<:.c=.ps) |\
		vim $<
	printf "file-open:%s;\
		export-area-drawing;\
		export-filename:%s;\
		export-do" $(<:.c=.ps) $@ \
		| inkscape --shell
	rm $(<:.cpp=.ps)

$(ANIMATION_DONE): %.done : %.svg
	./misc/frames.sh $^
	touch $@

clean:
	rm -f $(GARBAGE)
	rm -f $(PDF) $(DATOS) $(TEX_PDF) ani/*.pdf $(ANIMATION_DONE)

clean-garbage:
	rm -f $(GARBAGE)

pdf-only: all clean-garbage
	rm -f $(PDF)

help:
	@echo make all
	@echo - Creates all files
	@echo make pdf-only
	@echo - Removes temporary files
	@echo make resize
	@echo - Resize all raster graphics to 1080px width
	@echo make clean
	@echo - Removes all files
	@echo make help
	@echo - Shows this help

resize:
	./misc/resize.sh $(NPDF)
