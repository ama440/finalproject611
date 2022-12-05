Chronic Health Condition and Behavioral Risk Factors for Heart Disease
===========================================================================

In this project I analyze the Behavioral Risk Factor Surveillance System (BRFSS) data from 2015. The BRFSS interviews roughly 450,000 US adults by telephone each year, collecting data about health risk behaviors, chronic health conditions, and dietary and exercise habits. The data also includes basic demographic information. My goal was to identify the main risk factors for heart disease, the leading cause of death in the United States. Using a selection of other chronic health variables, as well as dietary, smoking, and exercise information, I determine what conditions and habits are most highly associated with heart disease.

According to the Centers for Disease Control and Prevention (CDC), there are several main risk factors for heart disease. Health conditions like high blood pressure, high blood cholesterol levels, diabetes, and obesity are known to increase the risk of heart disease. In addition, behaviors such as lack of physical activity, improper diet, excessive alcohol consumption, and tobacco use increase the risk of heart disease. In my analysis of the BRFSS data, I examine the strength of association between these variables and heart disease.

The dataset is quite large, containing several hundred variables and over 400,000 observations. As such, the cleaning and manipulation of the dataset poses a challenge. Though several people on Kaggle have posted cleaned datasets, I think this pre-analysis data manipulation process will help me develop crucial R and/or Python skills, and it will also allow me to select the variables I would like to keep. I believe there is also a fair amount of missing data, so starting with the raw dataset will allow me to address the missingness in the manner I deem most appropriate.

In terms of my analysis, I produce univariate and bivariate visualizations that summarize information about the dataset and attempt to visualize the data in two dimensions by performing principal component analysis and multiple correspondence analysis. I also create several predictive models that help quantify the association between heart disease and its potential risk factors. Given the large size of the dataset, I split into training and testing sets.

Using This Repository
=====================

The dataset is too large to be uploaded to Github, so you can instead find it here:

- Link to the dataset: https://www.kaggle.com/datasets/cdc/behavioral-risk-factor-surveillance-system?select=2015.csv

- Link to the codebook containing information about the variables: https://www.cdc.gov/brfss/annual_data/2015/pdf/codebook15_llcp.pdf

Clone the Git repository onto your local filesystem, then manually save the dataset as a file named "data2015.csv" in a folder called "source_data" within the repository. Note that when you press the download button on Kaggle, the folder will contain data from 2011 to 2015. Keep only the 2015 dataset, since that is the one I used for this analysis.

Once you have the repository, you can use Docker to start an RStudio server and reproduce the report. To do so, make sure Docker Desktop is running, and then build the Docker container using the following code:

```
docker build . -t 611-final-project
```

You can then launch the container using the command

```
docker run -v $(pwd):/home/rstudio/work\
           -e PASSWORD=yourpassword\
           -p 8787:8787\
           --rm\
           611-final-project
```

where you should replace `yourpassword` with a password of your choosing. You then visit http://localhost:8787 via a browser on your machine to access the machine and development environment. Log in using the username "rstudio" and the password you set when launching the container.

Once the RStudio server is running, first make `work` the working directory. You can then reproduce the report by running `make writeup.pdf` in the terminal within the Docker container. Running `make clean` will remove the writeup and generated figures from the repository. The file `writeup_copy.pdf` contains the report in case any step in the process goes wrong.

