# Project template

Template for a general structure of a project

## General info

This template is a recommended structure for R projects which consists of modular codes with individual functions and purposes. The Config file is the single file where all variables, packages, criteria are defined. Operations are singled out in folders and R-codes.

## Default Main structure

```

├─ Data
|   ├─ Input
|   ├─ Processed
|   └─ Temp
├─ Outputs
|   ├─ Data
|   ├─ Figures
|   └─ Tables
├─ R
|   ├─ ___Init_project___.R
|   ├─ 00_Config_file.R
|   ├─ 01_Data_processing
|   ├─ 02_Main_analyses
|   ├─ 03_Supplementary_analyses
|   ├─ Functions
|       └─ example_fc.R
├─ renv
|   ├─ activate.R
|   ├─ library
|   ├─ settings.json
|   └─ library_list.lock
├─ README.md
├─ LICENSE
└─ [project name].Rproj
```

## Getting the code

The project is accessible in two ways:
  
  1. If a user has a [GitHub account](https://github.com/), the easiest way is to [clone](https://happygitwithr.com/clone.html) this GitHub repo.
  
  2. A user can download the latest *Release* of the project as a zip file from the Release page.

The R project consists of codes with individual scripts and functions. All scripts are stored in the `R/` folder.
## Set up

Once a user obtains their version of the project, there are several steps to be done before using it:

* Update [R](https://en.wikipedia.org/wiki/R_(programming_language)) and [R-studio IDE](https://posit.co/products/open-source/rstudio/). There are many guides on how to do so (e.g. [here](https://jennhuck.github.io/workshops/install_update_R.html))

* Execute all individual steps with the `___Init_project___.R` script. This will result in the preparation of all R-packages using the [`{renv}` package](https://rstudio.github.io/renv/articles/renv.html), which is an R dependency management of your projects. Mainly it will install [`{RUtilpol}`](https://github.com/HOPE-UIB-BIO/R-Utilpol-package) and all dependencies. `{RUtilpol}` is used throughout the project as a version control of files.
