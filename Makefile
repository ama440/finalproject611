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


# Build summary figures
figures/agehist.png figures/agebox.png figures/bmibox.png figures/fruitbox.png\
 figures/smoking_mosaic.png figures/heart_attack_mosaic.png figures/agesmokebox.png:\
 source_data/data2015.csv exploratory.R setup.R
	Rscript exploratory.R

# Build the final report for the project.
writeup.pdf: figures/agehist.png figures/agebox.png figures/bmibox.png\
 figures/fruitbox.png figures/smoking_mosaic.png figures/heart_attack_mosaic.png\
 figures/agesmokebox.png writeup.tex
	pdflatex writeup.tex
