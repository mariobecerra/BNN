library(stringi)
library(reticulate)
library(keras)
library(tidyverse)
library(here)

# Not the best practice, but this is so I don't have to change all files.
setwd(here("code"))


out_dir = "../out/cats_dogs/"

out_subdirs = list.dirs(out_dir)

folder_names = grep("random|freq", out_subdirs, value = T, perl = T)





for(folder_name in folder_names){
  aux_filename = stri_replace_first(fixed = out_dir, replacement = "", str = folder_name) %>% 
    stri_replace_first(fixed = "/", replacement = "", str = .)
  
  cat("Acquisition function folder:", aux_filename, "\n")
  
  probs_filename = paste0("probs_iter_", aux_filename, ".rds")
  probs_filename_final = paste0(out_dir, probs_filename)
  
  if(file.exists(probs_filename_final)){
    cat("\tFile exists.\n\n")
  } else {
    if(!exists("x_test")){
      # Load data if it doesn't exist
      cat("\tReading RDS file with dataset.\n\n")
      cats_dogs <- readRDS("../out/cats_dogs/dat_train_64x64.rds")
      
      n_pics = nrow(cats_dogs$x)
      
      set.seed(2018)
      ix_train = sample(1:n_pics, size = 20000)
      ix_test = setdiff(1:n_pics, ix_train)
      x_test <- cats_dogs$x[ix_test,,,]
      rm(cats_dogs)
      gc()
    }
    
    model_filenames = grep("model", list.files(folder_name), value = T)
    
    n_filenames = length(model_filenames)
    
    probs_iter = map_df(1:n_filenames, function(i){
      cat("\tIter:", i, "of", n_filenames)
      fn = model_filenames[i]
      cat("\n\t\tLoading model", fn, "...")
      model = load_model_hdf5(paste0(folder_name, "/", fn))
      cat("loaded.\n\t\tMaking predictions...")
      out = predict(model, x_test, batch_size = 128) %>% 
        as_tibble() %>% 
        set_names(c("p1", "p2")) %>% 
        mutate(iter = as.integer(i))
      cat("predictions ready.\n\n")
      return(out)
    })
    saveRDS(probs_iter, probs_filename_final)  
  }
}





# dat_probs = map_df(folder_names, function(folder_name){
#   aux_filename = stri_replace_first(fixed = "../out/cats_dogs/", replacement = "", str = folder_name) %>% 
#     stri_replace_first(fixed = "/", replacement = "", str = .)
#   
#   cat("Acquisition function folder:", aux_filename, "\n")
#   
#   probs_filename = paste0("probs_iter_", aux_filename, ".rds")
#   df_temp = readRDS(paste0("../out/cats_dogs/", probs_filename)) %>% 
#     mutate(acq_func = aux_filename,
#            max_prob = pmax(p1, p2))
#   
#   return(df_temp)
# })
# 
# 
# dat_probs %>% 
#   group_by(iter, acq_func) %>% 
#   summarize(prob_q10 = quantile(max_prob, 0.1),
#             median = median(max_prob),
#             prob_q90 = quantile(max_prob, 0.9)) %>% 
#   ggplot() +
#   geom_hline(yintercept = 0.5) +
#   geom_errorbar(aes(x = iter, 
#                     ymin = prob_q10, 
#                     ymax = prob_q90), 
#                 width = 0.4, size = 0.3) + 
#   geom_point(aes(x = iter, y = median),
#              size = 0.7) +
#   ylab("prob") +
#   facet_wrap(~acq_func)