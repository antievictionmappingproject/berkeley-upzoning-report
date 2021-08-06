library(tidyverse)
library(googledrive)

drive_auth(path = 'src/utils/drive-service-token.json')

get_fileInfo <- function(){
  id <- '1JtVxTi4Dfa3Eo32FP03TWKp7bjamMhtb'
  local_drive_quiet()
  
  # for some reason recursive=TRUE doesn't work 
  getIDs <- function(fileInfo, name = fileInfo$name){
    if(fileInfo$mimeType != drive_mime_type('folder')) return(tibble(id = fileInfo$id, name = name))
    
    resources <- as_id(fileInfo$id) %>% 
      drive_ls() %>% 
      '[['('drive_resource')
    
    if(length(resources) == 0) return( tibble(id = fileInfo$id, name = fileInfo$name))
    
    tibble(fileInfo = resources, 
           name = unlist(map(resources, ~paste0(name, '/', .$name)))) %>% 
      pmap_dfr(getIDs)
  }
  
  message('getting Google Drive metadata...')
  files <- as_id(id) %>%
    drive_get() %>% '[['('drive_resource') %>% '[['(1) %>% 
    getIDs() %>% 
    mutate(resources = map(as_id(id), ~drive_get(.)$drive_resource),
           resources = flatten(resources))
}

drive_pull <- function(force_all = F){
  local_drive_quiet()
  fileInfo <- get_fileInfo()
  
  pwalk(fileInfo, function(id, name, resources){
    sizeDifferent <- !isTRUE(file.info(name)$size == as.numeric(resources$size))
    timeOutdated <- lubridate::as_datetime(resources$modifiedTime) > lubridate::as_datetime(file.info(name)$mtime)
    if(!(sizeDifferent || timeOutdated)) return(invisible(NULL))
    
    message('downloading ', name, '...')
    
    dir <- dirname(name)
    dir.create(dir, recursive = T, showWarnings = F)
    suppressMessages(drive_download(as_id(id), path = name, overwrite = TRUE))
  })
  message('all files pulled successfully! check out the "data" folder :)')
}

drive_push <- function(force = FALSE){
  mainID <- '1JtVxTi4Dfa3Eo32FP03TWKp7bjamMhtb'
  local_drive_quiet()
  
  fileInfo <- get_fileInfo()
  if(!file.exists('data')) stop('no data folder detected locally :0 make sure to use drive_pull() first?')
  list.files('data', recursive = T, full.names = T) %>% 
    walk(function(filename){

      fileInfo_single <- filter(fileInfo, name == filename)
      
      if(nrow(fileInfo_single) >= 1){
        resources <- fileInfo_single$resources[[1]]
        sizeDifferent <- !isTRUE(file.info(filename)$size == as.numeric(resources$size))
        hasChanged <- lubridate::as_datetime(resources$modifiedTime) < 
          lubridate::as_datetime(file.info(filename)$mtime)

        shouldPush <- sizeDifferent
        if(force){
          shouldPush <-  sizeDifferent || hasChanged
        } else if(!sizeDifferent & hasChanged){
          message(filename, 
          " has been modified locally but is the same size as the online version.",
          "I'll skip it for now, but you can force it with 'force=TRUE'\n\n")
        }
      } else {
        shouldPush <- TRUE
      }
      
      if(!shouldPush) return(invisible(NULL))
      
      if(nrow(fileInfo_single) == 0 ) {
        dir <- dirname(filename) %>% 
          str_remove("data/") %>% 
          str_split('/') %>% '[['(1)
        
        recurse_mkdir <- function(dirVec, id = mainID){
          
          targetInfo <- drive_ls(as_id(id))
          if(!any(targetInfo$name == dirVec[1])){
            result <- drive_mkdir(dirVec[1], path = as_id(id), overwrite = F)
          } else {
            result <- filter(targetInfo, name == dirVec[1]) 
          }
          
          if(length(dirVec) == 1) return(result)
          newID <- result$id 
          recurse_mkdir(dirVec[-1], id = newID)
        }
        mainID <- recurse_mkdir(dir)$id
      }
      message("Pushing ", filename)
      drive_put(media = filename,
                path = as_id(mainID),
                name = basename(filename)
                )
    })
  message('all files pushed successfully!')
}


