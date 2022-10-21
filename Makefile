.created-dirs:
	mkdir -p models
	mkdir -p figures
	mkdir -p derived_data
	touch .created-dirs

# Build the final report for the project.
writeup.pdf: figures/bpi_intensity_by_group.png
	pdflatex writeup.tex
