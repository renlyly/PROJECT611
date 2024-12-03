Cell type proportion on Parkinson’s disease.
=============================================
Author: Shilin Yu, student at UNC Gillings.

# Description

This project analyzes a dataset of demographics and cell type proportions associated with Parkinson's disease based on processed data from the [PDBP study](https://amp-pd.org/). Cell type proportions were calculated using a deconvolution algorithm while excluding RNA sequencing data. 
The report displays some findings from the data along with some descriptive analysis and Principal component analysis (PCA).

# Using This Repository

## Build the envrionment: Docker
This repository is desgin for using with Docker, but you can also review the Dockerfile to understand the appropriate package and Interpreter requirements for running the code. In order to run the Dockerfile, we should build the Docker image first through [Docker Desktop](https://www.docker.com).  A Docker image is similar to a miniaturized virtual machine that is built for easy duplication and can run on most computers. 

```
docker build -t my_image_name .
```

To build a docker container, Dockerfile needs to be built into an image first, and then use this image to start the container. Use the following command to build the image -t my_image_name: The -t flag is used to name the image (e.g. my_image_name) for easy reference in subsequent operations. '.': Indicates that the Dockerfile is in the current directory. :

After the image is built, you can use the docker run command to run the container, You can visit http://localhost:8787 via a browser on your machine to access the working space. We can also use port 8888 as an alternative:

```
docker run -v $(pwd):/workspace/myproject \
           -p 8787:8787 \
           -p 8888:8888 \
           -e PASSWORD="$(cat .password)" \
           -it my_image_name /bin/bash
```

## Git
The full code and data a availiable in `git clone https://github.com/renlyly/611project.git`. If the files under the 'HW folder This is the develop version.

## create the results: makefile

We can used the makefile to build the report. The best way to understand what the project does is to examine the Makefile.

```         
make report
```

The defualt setting of the report is pdf file. If you prefer the html version you can also generate the report with the following command:

```         
make report.html
```

We can also clean the project results, if we want to recreate the results we can run the following command the clean the previous results:

```         
make clean
```

IF we want to regenerate specific data and figure we can generate the data and figure with the following command as an example:

```         
make data.csv
make cor_plot.jpg
```

# Report
The main product of this analysis is A report on how the details of the results in Report.Rmd. Build the report to find out the details.