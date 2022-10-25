.created-dirs:
	mkdir -p models
	mkdir -p figures
	mkdir -p derived_data
	touch .created-dirs


figures/agebox.png: source_data/data2015.csv exploratory.R setup.R
	Rscript exploratory.R

# Build the final report for the project.
writeup.pdf: figures/bpi_intensity_by_group.png
	pdflatex writeup.tex
