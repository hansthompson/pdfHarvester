#' @export
Update_Project <- function(project) {
  require(plyr)
  
  all_transcriptions_done <- read.csv(paste(project, "transcriptionsdone.csv", sep = "/"))
  
  Mode <- function(x) {
    ux <- unique(x)
    ux[which.max(tabulate(match(x, ux)))]    
  }
  
  
  ## split by fullname
  n_tasks_performed <- ddply(all_transcriptions_done, .(fullname), function(x) length(x$fullname)) 
  similar_entries   <- ddply(all_transcriptions_done, .(fullname), function(x) max(table(x$transcription)))
  
  answers_shared = 2
  similar_enough <- similar_entries[,2] >= answers_shared
  
  tasks_needed = 2
  enough_tasks <- n_tasks_performed[,2] >= tasks_needed 
  
  proportion_needed = 0.1
  high_enough_proportion <- similar_entries[,2]/n_tasks_performed[,2] >=  proportion_needed     
  
  to_remove_from_task_list <- similar_enough & enough_tasks & high_enough_proportion
  
  
  tasks_df <- read.csv(paste(project, "alltranscriptions_to_do.csv", sep = "/"))
  tasks_df$done <- to_remove_from_task_list
  write.csv(tasks_df, paste(project, "alltranscriptions_to_do.csv", sep = "/"), row.names = FALSE)     
}
