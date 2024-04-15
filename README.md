This repository contains the files to help automate the deployment of a very simple express js api to azure web app. The api folder contains the app.js file for the api, the ifrastructure folder contains the main.tf file for the required infrastructure and the cicd folder contains the yaml code for the automation pipline which has two stages build and deploy. In order to run this you will need to have a devops tenant, an active azure subscription, configure a project and a service principal, give that sp access to the sub, create and the pipeline. The pipeline will trigger to any changes pushed to the main branch.