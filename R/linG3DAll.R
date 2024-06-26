#' 3D lineage tree visualization tool
#'
#' @author A. Hu, A.M.E. Ojwang", K.D. Olumoyin, and K.A. Rejniak.
#'
#' @description This is a companion code for the paper "LinG3D: Visualizing the
#' Spatio-Temporal Dynamics of Clonal Evolution".
#'
#' @details This code generates the 3D lineage tree of all clones
#'
#' It requires the following data in the pathData/data/ directory:.
#' \itemize{
#' \item cell_history.txt -- file with info about each cell.
#' \item cellID_##.txt    -- cell IDs in a file with index number.
#' \item cellXY_##.txt    -- cell coordinates in a file with index.
#' \item drug.txt         -- concentration of a drug for background.
#'  }
#'
#' @param pathData  -- directory with input data
#' @param numClones -- total number of clones in the data
#' @param IsGradient -- draw drug gradient in the background 1-yes; 0-no;
#' @param xmin,xmax,ymin,ymax -- dimensions of the spatial domain
#' @param tmin,tmax -- dimensions of the temporal domain
#' @param fileStep -- frequency of the sampled data
#' @param toPrint -- save the final figure 1-yes; 0-no;
#'
#' @examples
#' for the examples discussed in the paper use:
#'   EXAMPLE 1:
#'   linG3DAll(pathData="exampleB05", numClones=9, IsGradient=1,
#'             xmin=-100, xmax=100, ymin=-100, ymax=100,
#'             tmin=0, tmax=100000, fileStep=2000, toPrint=0)
#'
#'   EXAMPLE 2:
#'   linG3DAll(pathData="exampleB005", numClones=147, IsGradient=1,
#'             xmin=-100, xmax=100, ymin=-100, ymax=100,
#'             tmin=0, tmax=100000, fileStep=2000, toPrint=0)
#'
#'   EXAMPLE 3:
#'   linG3DAliveAll(pathData="exampleExp",  numClones=10, IsGradient=0,
#'                  xmin=0, xmax=1500, ymin=0, ymax=1000,
#'                  tmin=0, tmax=864, fileStep=4, toPrint=0)
#' @export

linG3DAll <- function(pathData, numClones, IsGradient,
                      xmin, xmax, ymin, ymax,
                      tmin, tmax, fileStep, toPrint) {

options(scipen = 999)  # disables printing in scientific notation

#---------------------------parameters---------------------------------#

# parameters
pathData <- pathData  # exampleB05 or exampleB005
numClones=numClones;
toPrint <- toPrint  # save the final figure 1-yes; 0-no;
IsGradient <- IsGradient  # draw drug gradient in the background 1-yes; 0-no;
xmin <- xmin; xmax <- xmax; ymin <- ymin; ymax <- ymax  # 2D domain boundaries
tmin <- tmin; tmax <- tmax  # time/iteration boundaries
timeStep <- (tmax-tmin)/(2.5*(xmax-xmin))
fileStep <- fileStep # frequency of data
stepDraw <- 200

# directory with cell and drug data
dataDirectory <- system.file(paste0(pathData,"/data/"), package="LinG3D")

# to save the final figure
if (toPrint==1){
  pathFigs <- paste0("fig_clones")
  dir.create(pathFigs) }

#-----------------------prepare 3d view using rgl---------------------------------#

open3d()
axes3d()
view3d()
add_Axes <- function(x, y, z, axis.col = NA) {  # needed to properly position the 3D
  mintemp <- function(ii){ c(-max(abs(ii)), max(abs(ii))) * 1.05 }
  xmintemp <- mintemp(x);  zmintemp <- mintemp(z);
  segments3d(xmintemp, c(0, 0), c(0, 0), color = NA)
  segments3d(c(0, 0), y, c(0, 0), color = NA)
  segments3d(c(0, 0), c(0, 0), zmintemp, color = NA)
}  # end add-Axes function
add_Axes(c(xmin,xmax),c(0,tmax/timeStep),c(ymin,ymax))  # set the axes
aspect3d(1, 2, 1)  # required aspect ratio x=1, y=2, z=1
grid3d(c("x+-","y+","z-"), col = "#DCDCDC", n = 6)  # set grid on the visible axes only
goodview <- matrix(c(0.6949471,-0.7133674,0.09030721,0,
                     0.1982032,0.3107649,0.92959183,0,
                     -0.6912048,-0.6281178,0.35735679,0,
                     0,0,0,1), nrow = 4,ncol = 4, byrow = TRUE)  # user view captured from screen
highlevel()
par3d(windowRect = c(0,0, 1200, 1200), userMatrix = goodview, zoom=0.75, cex=2)  # set final view

#--------------------------prepare color code--------------------------------------------------#

col <- c("#FF00FF","#FF0000","#00FFFF","#0000FF","#00FF00","#000000","#FFBF00",
         "#FFFF00","#BFFF00","#808000","#FFB6C1","#00BFFF","#0080FF","#FAEBD7",
         "#8000FF","#9ACD32","#FF0080","#660000","#664D00","#006666","#CCCCFF",
         "#FFCCFF","#99CCFF","#FF9999","#009900","#009999","#99004D","#FFE4E1",
         "#800000","#666699","#99FFCC","#DA70D6","#FF8000","#C0C0C0","#808080",
         "#4B0082","#A52A2A","#D8BFD8","#DC143C","#F5DEB3","#FF6347","#FF7F50",
         "#CD5C5C","#F08080","#E9967A","#FA8072","#FFA07A","#FF4500","#FF8C00",
         "#FFA500","#FFD700","#B8860B","#DAA520","#006400","#FFF0F5","#BC8F8F",
         "#FFF8DC","#32CD32","#90EE90","#98FB98","#8FBC8F","#00FA9A","#00FF7F",
         "#2E8B57","#66CDAA","#3CB371","#20B2AA","#2F4F4F","#008080","#008B8B",
         "#F0E68C","#F5F5DC","#E0FFFF","#00CED1","#FFE4B5","#FF1493","#AFEEEE",
         "#7FFFD4","#B0E0E6","#5F9EA0","#4682B4","#6495ED","#DEB887","#1E90FF",
         "#EEE8AA","#BDB76B","#6B8E23","#7CFC00","#7FFF00","#ADFF2F","#B22222",
         "#DDA0DD","#FFEBCD") #}
Ncol <- length(col)

#--------------------------draw background function------------------------------------------#

DrawBackground <- function(drug,tmax,timeStep,xmin,xmax,ymin,ymax){

  drugmin <- min(min(drug)); drugmax <- max(max(drug)); drugstep <- (drugmax-drugmin)/4

  kk <- tmax/timeStep
  Nx <- nrow(drug);  Ny <- ncol(drug); hgx <- (xmax-xmin)/Nx; hgy <- (ymax-ymin)/Ny

  for (ii in 1:Nx){
    for (jj in 1:Ny){
      if ((drug[ii,jj]>=drugmin)&&(drug[ii,jj]<drugmin+drugstep)){
        polygon3d(x=c(xmin+(ii-1)*hgx,xmin+ii*hgx,xmin+ii*hgx,xmin+(ii-1)*hgx,xmin+(ii-1)*hgx),
                  y=c(kk,kk,kk,kk,kk),
                  z=c(ymin+(jj-1)*hgy,ymin+(jj-1)*hgy,ymin+jj*hgy,ymin+jj*hgy,ymin+(jj-1)*hgy),
                  col="blue",fill=TRUE,add=TRUE,plot=TRUE,coords=c(x=1,z=3),alpha=0.25)

      } else if ((drug[ii,jj]>=drugmin+drugstep)&&(drug[ii,jj]<drugmin+2*drugstep)) {
        polygon3d(x=c(xmin+(ii-1)*hgx,xmin+ii*hgx,xmin+ii*hgx,xmin+(ii-1)*hgx,xmin+(ii-1)*hgx),
                  y=c(kk,kk,kk,kk,kk),
                  z=c(ymin+(jj-1)*hgy,ymin+(jj-1)*hgy,ymin+jj*hgy,ymin+jj*hgy,ymin+(jj-1)*hgy),
                  col="#00FFFF",fill=TRUE,add=TRUE,plot=TRUE,coords=c(x=1,z=3),alpha=0.25)

      } else if ((drug[ii,jj]>=drugmin+2*drugstep)&&(drug[ii,jj]<drugmin+3*drugstep)){
        polygon3d(x=c(xmin+(ii-1)*hgx,xmin+ii*hgx,xmin+ii*hgx,xmin+(ii-1)*hgx,xmin+(ii-1)*hgx),
                  y=c(kk,kk,kk,kk,kk),
                  z=c(ymin+(jj-1)*hgy,ymin+(jj-1)*hgy,ymin+jj*hgy,ymin+jj*hgy,ymin+(jj-1)*hgy),
                  col="yellow",fill=TRUE,add=TRUE,plot=TRUE,coords=c(x=1,z=3),alpha=0.25)

      } else {
        polygon3d(x=c(xmin+(ii-1)*hgx,xmin+ii*hgx,xmin+ii*hgx,xmin+(ii-1)*hgx,xmin+(ii-1)*hgx),
                  y=c(kk,kk,kk,kk,kk),
                  z=c(ymin+(jj-1)*hgy,ymin+(jj-1)*hgy,ymin+jj*hgy,ymin+jj*hgy,ymin+(jj-1)*hgy),
                  col="red",fill=TRUE,add = TRUE,plot = TRUE,coords = c(x=1,z=3),alpha=0.25)
      }
    } # end for jj gradient
  }  # end for ii gradient
}  # end draw background function

# draw background with drug gradient
if (IsGradient==1){
  drug <- read.table(paste0(dataDirectory,"/drug.txt"),header = F)
  DrawBackground(drug,tmax,timeStep,xmin,xmax,ymin,ymax)
}

#--------------------------draw trees------------------------------------------#

# load cell history file
hist <- read.table(paste0(dataDirectory,"/cell_history.txt"),header = F)

for (cloneNum in 0:numClones) {
  print(paste0("clone = ",cloneNum," of ",numClones))
  indLast=which(hist[,2]==cloneNum)

  # initialize Nmatrix
  Nmatrix <- 0

  # run the for loop to find Nmatrix for matrix_to_draw
  for (ii in 1:length(indLast)){# for every cell with index in indLast
    if (ii%%100==0) { print("... calculating"); }

    cellNum <- hist[indLast[ii],1]  # cell ID
    mothNum <- hist[indLast[ii],3]  # mother ID
    strtNum <- hist[indLast[ii],4]  # cell birth
    Num  <- hist[indLast[ii],5]
    Num <- max(tmax,min(Num,tmax))  # cell div/death/tmax

    # find all appearances of the cellNum
    kkStart <- fileStep*floor(strtNum/fileStep)  # initial file number
    kkEnd   <- fileStep*floor(Num/fileStep)  # final file number

    i <- kkEnd; vec <- c(); j <- 1
    while (i>=(kkStart+fileStep)) { vec[j] <- i; i <- i-fileStep; j <- j+1;}

    for (kk in vec) {
      # cell ID and cell XY from the first file
      fileMeID  <- as.matrix(read.table(paste0(dataDirectory,"/cellID_",kk,".txt"),header = F),dimnames=NULL)
      colnames(fileMeID) <- NULL;
      fileMeXY  <- as.matrix(read.table(paste0(dataDirectory,"/cellXY_",kk,".txt"),header = F),dimnames=NULL)
      colnames(fileMeXY) <- NULL;
      indMe = which(fileMeID==cellNum)  # which current indices of cellID
      # cell ID and cell XY from the second file
      fileMe2ID <- as.matrix(read.table(paste0(dataDirectory,"/cellID_",kk-fileStep,".txt"),header = F),dimnames=NULL)
      colnames(fileMe2ID) <- NULL;
      fileMe2XY <- as.matrix(read.table(paste0(dataDirectory,"/cellXY_",kk-fileStep,".txt"),header = F),dimnames=NULL)
      colnames(fileMe2XY) <- NULL;
      indMe2 = which(fileMe2ID==cellNum)  # which current indices of cellID

      if (is.empty(indMe)){
      } else if (is.empty(indMe2)){
        while (kkStart<hist[mothNum,4]){ # which file with the grand-mother cell
          mothNum <- hist[mothNum,3]
        }
        fileMe2ID <- as.matrix(read.table(paste0(dataDirectory,"/cellID_",kkStart,".txt"),header = F),dimnames=NULL)
        colnames(fileMe2ID) <- NULL;
        fileMe2XY <- as.matrix(read.table(paste0(dataDirectory,"/cellXY_",kkStart,".txt"),header = F),dimnames=NULL)
        colnames(fileMe2XY) <- NULL;
        indMe2=which(fileMe2ID==mothNum)  # which current indices of mother cellID
        if (is.empty(indMe2)){
        } else {
          Nmatrix <- Nmatrix+1  # save branch to draw [x1,t1,y1,x2,t2,y2]
        }
      } else {
        Nmatrix <- Nmatrix+1  # save branch to draw [x1,t1,y1,x2,t2,y2]
      }
    }
}

if (Nmatrix>0) {  # needed to handle empty clones

# define matrix of line segments (3D branches) to draw
matrix_to_draw <- matrix(rep(0,Nmatrix*6), nrow = Nmatrix,ncol = 6) # [x1,k1,y1,x2,k2,y2]
Nmatrix <- 0

for (ii in 1:length(indLast)){# for every cell with index in indLast
  if (ii%%100==0) { print("... calculating"); }

  cellNum <- hist[indLast[ii],1]  # cell ID
  mothNum <- hist[indLast[ii],3]  # mother ID
  strtNum <- hist[indLast[ii],4]  # cell birth
  Num  <- hist[indLast[ii],5]
  Num <- max(tmax,min(Num,tmax))  # cell div/death/tmax

  # find all appearances of the cellNum
  kkStart <- fileStep*floor(strtNum/fileStep)  # initial file number
  kkEnd   <- fileStep*floor(Num/fileStep)  # final file number

  i <- kkEnd; vec <- c(); j <- 1
  while (i>=(kkStart+fileStep)) { vec[j] <- i; i <- i-fileStep; j <- j+1;}

  for (kk in vec) {
    # cell ID and cell XY from the first file
    fileMeID  <- as.matrix(read.table(paste0(dataDirectory,"/cellID_",kk,".txt"),header = F),dimnames=NULL)
    colnames(fileMeID) <- NULL;
    fileMeXY  <- as.matrix(read.table(paste0(dataDirectory,"/cellXY_",kk,".txt"),header = F),dimnames=NULL)
    colnames(fileMeXY) <- NULL;
    indMe = which(fileMeID==cellNum)  # which current indices of cellID
    # cell ID and cell XY from the second file
    fileMe2ID <- as.matrix(read.table(paste0(dataDirectory,"/cellID_",kk-fileStep,".txt"),header = F),dimnames=NULL)
    colnames(fileMe2ID) <- NULL;
    fileMe2XY <- as.matrix(read.table(paste0(dataDirectory,"/cellXY_",kk-fileStep,".txt"),header = F),dimnames=NULL)
    colnames(fileMe2XY) <- NULL;
    indMe2 = which(fileMe2ID==cellNum)  # which current indices of cellID

      if (is.empty(indMe)){
      } else if (is.empty(indMe2)){
      while (kkStart<hist[mothNum,4]){ # which file with the grand-mother cell
        mothNum <- hist[mothNum,3]
      }
      fileMe2ID <- as.matrix(read.table(paste0(dataDirectory,"/cellID_",kkStart,".txt"),header = F),dimnames=NULL)
      colnames(fileMe2ID) <- NULL;
      fileMe2XY <- as.matrix(read.table(paste0(dataDirectory,"/cellXY_",kkStart,".txt"),header = F),dimnames=NULL)
      colnames(fileMe2XY) <- NULL;
      indMe2=which(fileMe2ID==mothNum)  # which current indices of mother cellID
      if (is.empty(indMe2)){
      } else {
        Nmatrix <- Nmatrix+1  # save branch to draw [x1,t1,y1,x2,t2,y2]
        matrix_to_draw[Nmatrix,1] <- fileMeXY[indMe,1]
        matrix_to_draw[Nmatrix,2] <- kkStart+fileStep
        matrix_to_draw[Nmatrix,3] <- fileMeXY[indMe,2]
        matrix_to_draw[Nmatrix,4] <- fileMe2XY[indMe2,1]
        matrix_to_draw[Nmatrix,5] <- kkStart
        matrix_to_draw[Nmatrix,6] <- fileMe2XY[indMe2,2]
      }
      } else {
      Nmatrix <- Nmatrix+1  # save branch to draw [x1,t1,y1,x2,t2,y2]
      matrix_to_draw[Nmatrix,1] <- fileMe2XY[indMe2,1]
      matrix_to_draw[Nmatrix,2] <- kk-fileStep
      matrix_to_draw[Nmatrix,3] <- fileMe2XY[indMe2,2]
      matrix_to_draw[Nmatrix,4] <- fileMeXY[indMe,1]
      matrix_to_draw[Nmatrix,5] <- kk
      matrix_to_draw[Nmatrix,6] <- fileMeXY[indMe,2]
    }
  }
}

# drawing clones
NumCol <- (cloneNum%%Ncol)+1  # clone color

bgplot3d({ plot.new(); title(paste0(main = "clone = ",cloneNum), line = 0)
  text(x=0.09,y=0.122,"iterations/time x 200",srt=-55,cex=1.3) })

for (ii in 1:Nmatrix){
  lines3d(x=c(matrix_to_draw[ii,1],matrix_to_draw[ii,4]),
          y=c(matrix_to_draw[ii,2],matrix_to_draw[ii,5])/timeStep,
          z=c(matrix_to_draw[ii,3],matrix_to_draw[ii,6]),
          col=col[NumCol],lwd = 3, plot = TRUE, add = TRUE,bty="b",
          xlim=c(-100,100),ylim=c(0,tmax/timeStep),zlim=c(-100,100)) }
   }  # end Nmatrix
  } # end main for

bgplot3d({ plot.new();
  title(paste0(main = "final 3D traces of all clones"), line = 0,cex.main=2.5)
  text(x=0.2,y=0.122,"iterations/time x 200",srt=-41,cex=3) })

if (toPrint==1){
  rgl.snapshot(paste0(pathFigs,"/tree_clones_combined",".png"), fmt = "png", top = TRUE)}
} # end function
