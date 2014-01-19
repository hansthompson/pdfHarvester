#' @export
Parse_Cells <- function(project){
  require(png)
  folders <- list.dirs(project, recursive = FALSE)
  for(z in seq(folders)) {
    main <- folders[z]
    CellImages <-  paste(main,sep="/", "CellImages")
    TableImages <- paste(main,sep="/", "TableImages")
    library(png)
    filenames <- list.files(TableImages, pattern = ".png")
    ## BEGIN LOOP
    for (k in 1:length(filenames)){
      
      ## Create Directories for each table
      dir.create(paste(CellImages, sep="/", sub(".png", "", filenames[k])))
      mygraph <- readPNG(paste(TableImages,sep="/",filenames[k]))
      dimmygraph <- dim(mygraph)
      dev.new(width=dimmygraph[2],height=dimmygraph[1])
      par(mar=c(0,0,0,0))
      x <- c(0,dimmygraph[2])
      y <- c(0,dimmygraph[1])
      ytot <- dim(mygraph)[1]
      xtot <- dim(mygraph)[2]
      plot(x,y, type = "n", xlab="", ylab="",xaxt='n',yaxt='n')
      rasterImage(mygraph, x[1],y[1],x[2],y[2],interpolate= FALSE)
      ##Find Columns and Rows
      # User Call for calling each rows.  click for the top of the first row and bottom of the last
      rows <- locator(type='p',pch=3,col='red',lwd=1.2,cex=1.2)
      # User Call for calling each column.  click for the left of the first row and right of the last.
      cols <- locator(type='p',pch=3,col='black',lwd=1.2,cex=1.2)
      ##BEGIN NEW###
      # User call for calling the main table title.
      title <- locator(type='p',pch=3,col='black',lwd=1.2,cex=1.2)
      dev.off()
      tabledim <- data.frame(x = title$x,y = title$y)
      png(paste(CellImages,sep="/",sub(".png","",filenames[k]),paste("title.png", filenames[k],sep = "_")),width=tabledim[2,1]-tabledim[1,1],
          height=(ytot-tabledim[2,2])-(ytot-tabledim[1,2]),units="px")
      par(mar=c(0,0,0,0))
      plot(x = c(tabledim[1,1],tabledim[2,1]),
           y = c(tabledim[2,2],tabledim[1,2]),
           type = "n", xlab="", ylab="",xaxt='n',yaxt='n')
      rasterImage(image =   mygraph[(ytot-tabledim[1,2]):(ytot-tabledim[2,2]), tabledim[1 ,1]:tabledim[2,1],],
                  xleft =   tabledim[1,1],
                  ybottom = tabledim[2,2], 
                  xright =  tabledim[2,1],
                  ytop =    tabledim[1 ,2],
                  interpolate = FALSE)
      dev.off()
      ##create data frame
      rows <- as.data.frame(rows)[,2]
      cols <- as.data.frame(cols)[,1]
      dim<- dim(mygraph)
      ##create a table of cells (called orederedcellsdf)
      rowstart <-  rep( sort(rows[1:length(rows)-1]) , length(cols)-1) 
      rowend <-  rep( sort(rows[2:length(rows)]) , length(cols)-1)
      colstart <-  sort(rep(cols[1:length(cols)-1] , length(rows)-1)) 
      colend <-  sort(rep(cols[2:length(cols)] , length(rows)-1))
      orderedcellsdf <- data.frame(rowstart,rowend,colstart,colend)
      ##names rows in the table of cells
      nrows <- length(rows)-1
      ncols <- length(cols)-1
      rowrep <-  rep(1:nrows, ncols) ; length(rowrep)
      colrep <-  rep(LETTERS[(1:(ncols))],
                     each = nrows) ;length(colrep)
      rownamesdf <- paste(rowrep,sep="", colrep)
      rownames(orderedcellsdf) <- rownamesdf
      for(i in 1:length(orderedcellsdf[,1])){
        cellfilenames <- paste(paste(rownames(orderedcellsdf[i,])),sep="_",filenames[k])
        dir <- paste(CellImages,sep="/",sub(".png","",filenames[k]))
        png(paste(dir,sep="/",cellfilenames),
            width = orderedcellsdf[i,4]-orderedcellsdf[i,3],
            height = orderedcellsdf[i,1]-orderedcellsdf[i,2])
        #dev.new(width=6,height=3)
        par(mar=c(0,0,0,0))
        plot(c(orderedcellsdf[i,3],orderedcellsdf[i,4]),c(orderedcellsdf[i,2],orderedcellsdf[i,1]) ,
             type = "n", xlab="", ylab="",xaxt='n',yaxt='n')
        ytot <- dim(mygraph)[1]
        xtot <- dim(mygraph)[2]
        rasterImage(image =  mygraph[(ytot-orderedcellsdf[i,1]):(ytot-orderedcellsdf[i,2]),orderedcellsdf[i,3]:orderedcellsdf[i,4],] ,
                    xleft =  orderedcellsdf[i,3] ,
                    ybottom = orderedcellsdf[i,2] , 
                    xright = orderedcellsdf[i,4] ,
                    ytop =  orderedcellsdf[i,1] ,
                    interpolate = FALSE)
        dev.off()
      }
    }
  }}
