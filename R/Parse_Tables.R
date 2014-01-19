
Parse_Tables <- function(project) {
  require(png)
  folders <- list.dirs(project, recursive = FALSE)
  for(z in seq(folders)) {
    filefolder <- folders[z]
    filevector <- list.files(paste(filefolder, "/LowQuality", sep = ""), pattern = ".png", full.names = T)
    if(is.na(filevector)) {next()}
    nfiles <- length(filevector)
    
    tablecoordinates <- list()
    ##create a concatenation for the pages with tables in the for loop below.
    pagenumber <- c()
    for (i in seq(nfiles)) {
      jpegpagesub <- readPNG(paste(filevector[i]))
      dimmygraph <- dim(jpegpagesub)
      dev.new(width = dimmygraph[2], height = dimmygraph[1])
      par(mar = c(0, 0, 0, 0))
      x <- c(0, dimmygraph[2])
      y <- c(0, dimmygraph[1])
      plot(x,y, type = "n", xlab="", ylab="",xaxt='n',yaxt='n')
      rasterImage(jpegpagesub, x[1],y[1],x[2],y[2],interpolate= FALSE)
      coord <- locator(type='p',pch=3,col='red',lwd=1.2,cex=1.2)
      tablecoordinates[[i]] <- data.frame(x = coord$x, y = coord$y)
      dev.off()
    }
    
    noTables     <-  which(unlist(lapply(tablecoordinates, length)) == 0)
    properPages  <- which(unlist(lapply(tablecoordinates, function(q) length(q$x) %% 2 == 0 )))
    
    
    
    ifelse(length(noTables) != 0, tablePages <- properPages[-noTables], tablePages <- properPages)
    
    tablecoordinates <- tablecoordinates[tablePages]
    names(tablecoordinates) <- paste(tablePages)
    
    pages <- as.numeric(names(tablecoordinates))
    for (i in 1:length(tablecoordinates)) {
      tabledim <- data.frame(x = tablecoordinates[[i]]$x, y = tablecoordinates[[i]]$y)
      write.csv(tablecoordinates, "tablecoordinates.csv")
      for (j in 0:((length(tablecoordinates[[i]]$x) / 2) - 1)) {
        start <- j*2 + 1
        stop <- j*2 + 2
        imag <- readPNG(gsub("LowQuality", "HighQuality", filevector[pages[i]]))
        dimChange <- dim(imag)/dim(readPNG(filevector[1]))
        tabledim$x <- tabledim$x * dimChange[1]
        tabledim$y <- tabledim$y * dimChange[2]
        ytot <- dim(imag)[1]
        xtot <- dim(imag)[2]
        png(gsub("LowQuality", "TableImages", gsub(".png", paste( "_",j+1, ".png", sep =""), filevector[i])),
            width= tabledim[stop,1]-tabledim[start ,1],
            height = (ytot-tabledim[stop,2]) - (ytot-tabledim[start,2]), units = "px")
        par(oma = c(0, 0, 0, 0))
        par(mar = c(0, 0, 0, 0))
        plot(x = c(tabledim[start,1],tabledim[stop,1]),
             y = c(tabledim[stop,2],tabledim[start,2]),
             type = "n", xlab="", ylab="",xaxt='n',yaxt='n')
        rasterImage(image = imag[(ytot-tabledim[start,2]):(ytot-tabledim[stop,2]), tabledim[start ,1]:tabledim[stop,1],],
                    xleft = tabledim[start,1],
                    ybottom = tabledim[stop,2],
                    xright = tabledim[stop,1],
                    ytop = tabledim[start ,2] ,
                    interpolate = FALSE)
        dev.off()
      }
    }
  }
}
