#' @export
Publish <- function(project) {
  require(stringr)
  require(xlsx)
  require(RJSONIO)
  require(plyr)
  done <- read.csv(paste(project, "transcriptionsdone.csv", sep = "/"))
  ## Split-Apply-Combine.  Split by table folder name, apply matrix building function, combine into list, write to .csv's, .xlsx, or .json
  
  done <- ddply(done, .(fullname),
                function(x){as.character(unique(x$transcription[x$transcription==
                                                                  names(which.max(table(x$transcription)))]))})
  
  
  ## location format coordinate_file_page_tablenumber
  fullnames <- gsub(".png", "", done$fullname)
  
  ids <- str_split_fixed(fullnames, "_", 8)[,3:6]
  ids[,1] <- str_split_fixed(ids[,1], "/", 2)[,2]
  
  colnames(ids) <- c("coord", "file", "page", "inpage")
  
  dat <- cbind(value=  done$V1, ids)
  
  dat <- data.frame(dat)
  
  dl <- dlply(dat, .(file, page))
  
  for (k in seq(dl)) {
    
    temp <- dl[[k]]
    substrRight <- function(x, n){
      substr(x, nchar(x)-n+1, nchar(x))
    }
    title <-  as.character(temp$value[temp$coord == "title"])
    temp <- temp[!temp$coord == "title",]
    row <- rep(NA, length(temp$coord))
    
    row[nchar(as.character(temp$coord)) == 2] <- substr(temp$coord[nchar(as.character(temp$coord)) == 2], 0,1)
    row[nchar(as.character(temp$coord)) == 3] <- substr(temp$coord[nchar(as.character(temp$coord)) == 3], 0,2)
    row <- row[!is.na(row)]  
    rowOrder <- order(as.numeric(row))
    
    column <- substrRight(as.character(temp$coord), 1)
    column <- column[!column == "e"]
    column <- factor(column) 
    
    dat <- matrix(NA, nrow = length(levels(factor(row))), 
                  ncol = length(levels(column)))
    
    for(i in seq(levels(factor(column)))) {
      col <- row[column == column[i]]      
      colOrder    <- order(as.numeric(col))
      dat[,i] <- rev(as.character(temp$value[column == column[i]][colOrder]))
    }
    
    if(nchar(title) > 0) {
      
      rownames(dat) <- dat[,1]
      dat <- dat[,-1]
      
      colnames(dat) <- dat[1,]
      dat <- dat[-1,]
    }
    final <- list(title, dat)    
    names(final) <- c("title","table")    
    dl[[k]] <- final  
  }
  return(dl)
}