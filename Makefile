.PHONY: clean
.PHONY: report

clean:
	rm -f report.pdf
	rm -f report.html
	rm -f Prop_imply.csv data.csv meta.csv prop2_long.csv prop2_sortl.csv
	rm -f bar_plot.jpg bar_plot_sort.jpg bar_plot_sort2.jpg
	rm -f cor_plot.jpg box_plot_1.jpg time_plotCD4.jpg ROC_CD8.jpg
	rm -f PCA_plot1.jpg PCA_plot2.jpg

Prop_imply.csv data.csv meta.csv: data_process.R prop_all.rds PDBP_metadata.csv
	Rscript data_process.R

prop2_long.csv prop2_sortl.csv: box_data.R data.csv prop_all.rds
	Rscript box_data.R

bar_plot.jpg bar_plot_sort.jpg bar_plot_sort2.jpg: Plot_A.R prop2_long.csv prop2_sortl.csv
	Rscript Plot_A.R

cor_plot.jpg: Plot_B.R Prop_imply.csv
	Rscript Plot_B.R

box_plot_1.jpg: Plot_C.R data.csv
	Rscript Plot_C.R

time_plotCD4.jpg: Plot_D.R data.csv
	Rscript Plot_D.R

ROC_CD8.jpg: Plot_E.R data.csv
	Rscript Plot_E.R

PCA_plot1.jpg PCA_plot2.jpg: Plot_F.R data.csv
	Rscript Plot_F.R

report: report.pdf

report.pdf: Report.Rmd \
	bar_plot.jpg bar_plot_sort.jpg bar_plot_sort2.jpg \
	cor_plot.jpg box_plot_1.jpg time_plotCD4.jpg ROC_CD8.jpg \
	PCA_plot1.jpg PCA_plot2.jpg
	Rscript -e 'rmarkdown::render("Report.Rmd", "pdf_document")'
