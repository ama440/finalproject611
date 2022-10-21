In this project I analyze the Behavioral Risk Factor Surveillance System (BRFSS) data from 2015. The BRFSS interviews roughly 450,000 US adults by telephone each year, collecting data about health risk behaviors, chronic health conditions, and dietary and exercise habits. The data also includes basic demographic information. My goal was to identify the main risk factors for heart disease, the leading cause of death in the United States. Using a selection of other chronic health variables, as well as dietary, smoking, and exercise information, I determine what conditions and habits are most highly associated with heart disease.

According to the Centers for Disease Control and Prevention (CDC), there are several main risk factors for heart disease. Health conditions like high blood pressure, high blood cholesterol levels, diabetes, and obesity are known to increase the risk of heart disease. In addition, behaviors such as lack of physical activity, improper diet, excessive alcohol consumption, and tobacco use increase the risk of heart disease. In my analysis of the BRFSS data, I examine the strength of association between these variables and heart disease.

The dataset is quite large, containing several hundred variables and over 400,000 observations. As such, the cleaning and manipulation of the dataset poses a challenge. Though several people on Kaggle have posted cleaned datasets, I think this pre-analysis data manipulation process will help me develop crucial R and/or Python skills, and it will also allow me to select the variables I would like to keep. I believe there is also a fair amount of missing data, so starting with the raw dataset will allow me to address the missingness in the manner I deem most appropriate.

In terms of my analysis, I produce visualizations--some interactive--that effectively present information about the dataset. I also create several predictive models that help quantify the association between heart disease and its potential risk factors. Given the large size of the dataset, I splitting into training and testing sets.

Link to the dataset: https://www.kaggle.com/datasets/cdc/behavioral-risk-factor-surveillance-system?select=2015.csv

Link to the codebook containing information about the variables: https://www.cdc.gov/brfss/annual_data/2015/pdf/codebook15_llcp.pdf

How to reproduce this project:

