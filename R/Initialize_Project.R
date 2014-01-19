Initialize_Transcription <- function(project) {
  
  all_folders <- list.dirs(project, recursive = FALSE)
  alltranscriptions <- data.frame(filenames = character(), fullnames = character(), done = logical())
  for(j in seq(all_folders))
    table_folders <- list.dirs(paste(all_folders[j], "CellImages", sep = "/"), recursive = FALSE)
  for(i in seq(table_folders)) {
    fullnames <- list.files(table_folders[i], pattern = ".png", full.names = T)
    filenames <- list.files(table_folders[i], pattern = ".png", full.names = F)
    totranscribe <- data.frame(filenames , fullnames)
    alltranscriptions <- rbind(alltranscriptions, totranscribe)    
  }
  alltranscriptions <- cbind(alltranscriptions, done = FALSE)
  write.csv(alltranscriptions, paste(project, "alltranscriptions_to_do.csv", sep = "/"), row.names = FALSE)
}
