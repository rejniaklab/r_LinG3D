**Project Title**
LinG3D: Visualizing the Spatio-Temporal Dynamics of Clonal Evolution

**Description**
This code generates the 3D lineage trees of (1) all clones; (2) individual clones; (3) all clones , but with only those cells that survived to the end of simulation; and (4) individual clones containing only those cells that survived to the end of simulation – see the quick guide to LinG3D routines. The code is generated in three programming languages: Matlab, R, and Python.

**Installing**

R: the required libraries are readr, rapportools, rgl, and devtools. 

        install.packages("readr")   

        install.packages("rapportools")
        
        install.packages("rgl")

        install.packages("devtools")
   
        library(devtools)  # load the devtools library

        install_github("rejniaklab/r_LinG3D")  # install the package from GitHub

        library(LinG3D)  # load the LinG3D library

        linG3DClone(arguments)  # run the routine (example)

**Authors**
Anjun Hu,
Awino Maureiq E. Ojwang’,
Kayode Olumoyin,
Katarzyna Rejniak

**Version**
0.1
Initial release

**License**
This project is licensed under the GNU General Public License v3.0.
