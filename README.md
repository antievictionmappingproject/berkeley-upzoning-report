
# Data analyses for the AEMP Berkeley Upzoning Report

This is a repository containg scripts and plots for the AEMP Berkeley Upzoning Report. 

### Directory structure

- Root: This README, various system-interaction things 
  - src: The main codebase for this repository 
    - cleaning: Scripts and Rmd's to clean data goes here
    - plots: Viz that we make should be written to here
    - utils: Utility functions to make life easier
  - data: this directory will only be generated when you open the `.Rproj` file and R runs the Google Drive syncing script. 

### Workflow 

This project works through an R project, which ensures that users across different computers all have the same environment and solves the headache of filenames particularly elegantly. It also uses `renv`, an R package management library that ensures all collaborators are on the same page. Finally, our data (hosted in a Google Drive ) All of these features require opening the `berkeley-upzoning-report.Rproj` file through RStudio and working through the produced environment. 

Let's keep all of our data files in the `data` folder [online](https://drive.google.com/drive/folders/1JtVxTi4Dfa3Eo32FP03TWKp7bjamMhtb). You can drag-and-drop to move files, or you can also use a few utility functions loaded by the `.Rprofile` script at startup. These functions are called `drive_push` and `drive_pull` and upload local data to this folder and pull data from this folder, respectively. 

### Quick links 

[Project folder](https://drive.google.com/drive/folders/1OlAi7OXPoAcBQgOhYXh6QHe0Ps9V7wHT)
[Rent Stabilization Board's amendment to the upzonign proposal](https://antievictionmap.slack.com/files/U0CD666UV/F024B4Q81EV/2021_mar_18_rsb_proposed_amendments_to_fourplex_zoning_proposal__2_.pdf)
[Resolution to end exclusionary housing in Berkeley (in this context allowing upzoning)](https://antievictionmap.slack.com/files/U01ENHJCE6N/F0273CPFRDF/2021-02-23_item_29_resolution_to_end_exclusionary.pdf)

Questions: Contact Nathan at nathan.kim@yale.edu
