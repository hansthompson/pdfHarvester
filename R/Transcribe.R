Transcribe <- function(project) {
  
  require(png)
  windows.options(restoreConsole = T)
  
  transcriptions_to_do <- read.csv(paste(project, "alltranscriptions_to_do.csv", sep = "/"))
  
  transcriptions_to_do <- transcriptions_to_do[transcriptions_to_do$done == FALSE,]
  
  nfiles  <-dim(transcriptions_to_do)[1]
  tasks_at_a_time <- 5
  if(length(transcriptions_to_do) == 0) {break()}
  if(length(transcriptions_to_do$fullname) < tasks_at_a_time) { tasks_at_a_time <- 1}
  
  groups <- ceiling(nfiles/tasks_at_a_time)
  
  tasks <- as.character(sample(transcriptions_to_do$fullname, nfiles, replace = F))
  groups <-(seq(groups) - 1) * tasks_at_a_time
  for(j in groups) {
    transcriptionsdone <- matrix("", ncol = 5, nrow = tasks_at_a_time)
    for(i in seq(tasks_at_a_time)){
      mygraph <- readPNG(tasks[j + i ])        
      dimmygraph <- dim(mygraph)
      dev.new(width=dimmygraph[2],height=dimmygraph[1])
      par(mar=c(0,0,0,0))
      x <- c(0,dimmygraph[2])
      y <- c(0,dimmygraph[1])
      ytot <- dim(mygraph)[1]
      xtot <- dim(mygraph)[2]
      plot(x,y, type = "n", xlab="", ylab="",xaxt='n',yaxt='n')
      rasterImage(mygraph, x[1],y[1],x[2],y[2],interpolate= FALSE)
      transcription_to_add <- readline("")  
      user_to_add <- as.character(Sys.info()[7])
      time_to_add <- format(Sys.time(), "%a %b %d %X %Y")
      filename_to_add <- as.character(tasks[j + i ])
      fullname_to_add <- as.character(tasks[j + i ])
      transcriptionsdone[i,] <- c(transcription_to_add, user_to_add, time_to_add, filename_to_add, fullname_to_add)
      dev.off()
    }
    alltranscriptions <- as.matrix(read.csv(paste(project, "transcriptionsdone.csv", sep = "/"), stringsAsFactors = FALSE))
    output <- rbind(alltranscriptions, transcriptionsdone)
    write.csv(output,paste(project, "transcriptionsdone.csv", sep = "/"), row.names = FALSE)
  }
}
