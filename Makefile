.PHONY: clean

clean:
	rm -rf models
	rm -rf figures
	rm -rf .created-dirs
	rm -f writeup.pdf
	rm -f writeup.log
	rm -f writeup.aux
	rm -f texput.log
	rm -f Rplots.pdf

.created-dirs:
	mkdir -p models
	mkdir -p figures
	mkdir -p derived_data
	touch .created-dirs

# Build a figure showing comparative boxplot of age distribution by heart disease status
figures/agebox.png: source_data/data2015.csv exploratory.R setup.R
	Rscript exploratory.R

# Build the final report for the project.
writeup.pdf: figures/agebox.png writeup.tex
	pdflatex writeup.tex
