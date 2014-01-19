#' @export
Tesseract <- function(project) {
  transcriptions_to_do <- read.csv(paste(project, "alltranscriptions_to_do.csv", sep = "/"))
  
  output <- gsub(".png", "", transcriptions_to_do$fullname)
  cmds <- paste("tesseract", transcriptions_to_do$fullname, output, "-psm 7")
  for (i in seq(cmds)) {
    shell(cmds[i])
  }
  
  transcriptionsdone <- matrix("", ncol = 5, nrow = length(output))
  colnames(transcriptionsdone ) <- c("transcription", "user", "date", "filename", "fullname")
  txtfiles <- paste(output, ".txt", sep = "")
  
  for(i in seq(txtfiles)) {
    transcription_to_add <- readLines(txtfiles[i], n = 1)
    if(length(transcription_to_add) == 0) transcription_to_add <- "" 
    user_to_add <- "tesseract"
    time_to_add <- format(Sys.time(), "%a %b %d %X %Y")
    filename_to_add <- as.character(transcriptions_to_do$filename[i])
    fullname_to_add <- as.character(transcriptions_to_do$fullname[i])
    transcriptionsdone[i,] <- c(transcription_to_add, user_to_add, 
                                time_to_add, filename_to_add, fullname_to_add)
  }
  write.csv(transcriptionsdone, paste(project, "transcriptionsdone.csv", sep = "/"), row.names = FALSE)
}
