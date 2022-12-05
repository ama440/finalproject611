.PHONY: clean

clean:
	rm -rf models
	rm -rf figures
	rm -rf .created-dirs
	rm -f writeup.pdf
	rm -f writeup.log
	rm -f writeup.aux
	rm -f writeup.synctex.gz
	rm -f texput.log
	rm -f Rplots.pdf
	rm -f summary_gbm.csv
	rm -f summary_log.csv
	rm -f univariate.csv
	rm -f rotation.csv

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
	
# Build dimensionality reduction figures
figures/pca.png figures/mca.png: source_data/data2015.csv dim_reduce.R setup.R
	Rscript dim_reduce.R
	
# Build plot of ROC curve for logistic model
figures/roc_log.png: source_data/data2015.csv logistic.R setup.R
	Rscript logistic.R
	
# Build plot of ROC curve for GBM model
figures/roc_gbm.png: source_data/data2015.csv gbm.R setup.R
	Rscript gbm.R

# Build the final report for the project.
writeup.pdf: figures/agehist.png figures/agebox.png figures/bmibox.png\
 figures/fruitbox.png figures/smoking_mosaic.png figures/heart_attack_mosaic.png\
 figures/agesmokebox.png figures/pca.png figures/mca.png\
 figures/roc_log.png figures/roc_gbm.png\
 writeup.tex
	pdflatex writeup.tex
