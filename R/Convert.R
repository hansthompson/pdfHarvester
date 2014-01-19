Convert <- function(project, convert.args1, convert.args2, convert.cmd){
  require(stringr)
  files <- list.files(project, pattern = ".pdf")
  filefolder <- paste(project, "/", gsub(".pdf", "", files), sep = "")
  
  newdirectories <- c("HighQuality", "LowQuality", "TableImages", "CellImages")
  
  for(i in seq(filefolder)) {
    dir.create(filefolder[i])
    for(j in 1:4) {
      dir.create(paste(filefolder[i], "/", newdirectories[j], sep = ""))
    }
  }
  
  for(i in seq(filefolder)) {
    filepaths <- list.files(project, pattern =".pdf", full.names = TRUE)[i]
    filepaths <-  gsub("/", "\\\\", filepaths)
    filepaths <- paste("identify", filepaths)
    pages <- system(as.character(filepaths),show.output.on.console = FALSE, intern= TRUE)
    pages <- str_split_fixed(pages, " ", 2)[,1]
    
    hq <- gsub("/", "\\\\", paste(filefolder[i], "\\", "HighQuality", sep = ""))
    lq <- gsub("/", "\\\\", paste(filefolder[i], "\\", "LowQuality", sep = ""))
    
    numberedfiles <- paste(gsub(".pdf", "", files[i]), "_", formatC(seq(pages), flag = 0, width = 4), ".png", sep = "")
    
    hqoutput <- paste(hq, "\\", numberedfiles, sep = "")
    hqoutput <- gsub(".pdf", ".png", hqoutput)
    
    firstset <- paste(convert.cmd, convert.args1, pages, convert.args2, hqoutput)
    
    for(j in seq(pages)) {
      shell(as.character(firstset[j]), shell=Sys.getenv("COMSPEC"))
    }
    
    lqoutput <- paste(lq, "\\", numberedfiles, sep = "")
    lqoutput <- gsub(".pdf", ".png", lqoutput)
    
    thirdset <- paste(convert.cmd, convert.args1, hqoutput, " -resize 25% ", convert.args2, lqoutput)
    
    for(j in seq(pages)) {
      shell(as.character(thirdset[j]), shell=Sys.getenv("COMSPEC"))
    }
  }
}