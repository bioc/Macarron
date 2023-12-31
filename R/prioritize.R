#' Rank metabolic features and prioritize based on predicted bioactivity.
#' 
#' Metabolic features are ranked based on AVA, and q-value and effect size of
#' differential abundance. The harmonic mean of these three ranks is calculated and used as 
#' the meta-rank to prioritize potentially bioactive features in a phenotype (or condition). 
#' Top-ranked features have good relative abundance, and are significantly perturbed 
#' in the specified environment/phenotype.
#' 
#' @param se SummarizedExperiment object created using Macarron::prepInput()
#' @param mod.assn the output of Macarron::findMacMod()
#' @param mac.ava the output of Macarron::calAVA()
#' @param mac.qval the output of Macarron::calQval()
#' @param mac.es the output of Macarron::calES()
#' 
#' @return mac.result - metabolic features listed according to priority 
#' 
#' @examples 
#' prism_abundances = system.file("extdata", "demo_abundances.csv", package="Macarron")
#' abundances_df = read.csv(file = prism_abundances, row.names = 1)
#' prism_annotations = system.file("extdata", "demo_annotations.csv", package="Macarron")
#' annotations_df = read.csv(file = prism_annotations, row.names = 1)
#' prism_metadata = system.file("extdata", "demo_metadata.csv", package="Macarron")
#' metadata_df = read.csv(file = prism_metadata, row.names = 1)
#' met_taxonomy = system.file("extdata", "demo_taxonomy.csv", package="Macarron")
#' taxonomy_df = read.csv(file = met_taxonomy)
#' mbx <- Macarron::prepInput(input_abundances = abundances_df,
#'                             input_annotations = annotations_df,
#'                             input_metadata = metadata_df)
#' w <- Macarron::makeDisMat(se = mbx)
#' modules.assn <- Macarron::findMacMod(se = mbx, 
#'                                      w = w,
#'                                      input_taxonomy = taxonomy_df)
#' mets.ava <- Macarron::calAVA(se = mbx,
#'                              mod.assn = modules.assn)                                     
#' mets.qval <- Macarron::calQval(se = mbx,
#'                                mod.assn = modules.assn)
#' mets.es <- Macarron::calES(se = mbx,
#'                            mac.qval = mets.qval)
#' mets.prioritized <- Macarron::prioritize(se = mbx,
#'                                          mod.assn = modules.assn,
#'                                          mac.ava = mets.ava,
#'                                          mac.qval = mets.qval,
#'                                          mac.es = mets.es)                         
#' 
#' 
#' @export

prioritize <- function(se,
                       mod.assn,
                       mac.ava,
                       mac.qval,
                       mac.es)
{
  mod.assn <- as.data.frame(mod.assn[[1]])
  # Test phenotypes
  test.phenotypes <- unique(mac.qval$value)
  
  # Prioritize for each phenotype
  prioritize.each <- function(p){
    sub.qval <- mac.qval[which(mac.qval$value == p),]
    rownames(sub.qval) <- sub.qval$feature
    all.params <- as.data.frame(cbind(rownames(mac.ava),
                                      mac.ava[,"ava"],
                                      sub.qval[rownames(mac.ava),"qvalue"],
                                      mac.es[rownames(mac.ava),p]))
    colnames(all.params) <- c("feature","ava","qval","es")
    
    
    all.params$es <- as.numeric(as.character(all.params$es))
    all.params$ava <- as.numeric(as.character(all.params$ava))
    all.params$qval <- as.numeric(as.character(all.params$qval))
    
    # Assigning direction of perturbation
    all.params$status <- ""
    all.params[which(all.params$es < 0),"status"] <- paste0("depleted in ", p)
    all.params[which(all.params$es > 0),"status"] <- paste0("enriched in ", p)
    all.params$es <- abs(all.params$es)
    
    # Ranks
    all.params$ava_rank_percentile <- rank(all.params$ava)/nrow(all.params)
    all.params$qval_rank_percentile <- rank(-all.params$qval)/nrow(all.params)
    all.params$es_rank_percentile <- rank(all.params$es)/nrow(all.params)
    
    # Meta-rank
    message("Calculating meta-rank and prioritizing metabolic features")
    all.params$meta_rank <- psych::harmonic.mean(t(all.params[,6:8]))
    ranked.features <- all.params[order(-all.params$meta_rank),]
    ranked.features <- as.data.frame(ranked.features)
  }
  prioritized.features <- as.data.frame(do.call(rbind, lapply(test.phenotypes, prioritize.each)))
  prioritized.features$module <- mod.assn[prioritized.features$feature,"module"]
  prioritized.features$anchor <- mac.ava[prioritized.features$feature,"anchor"]
  prioritized.features$module_composition <- mod.assn[prioritized.features$feature,"classes"]
  prioritized.features$characterizable <- 0
  prioritized.features[which(prioritized.features$anchor != ""),"characterizable"] <- "1"
  anno <- as.data.frame(SummarizedExperiment::rowData(se))
  prioritized.features$annotation1 <- anno[prioritized.features$feature, 1]
  prioritized.features$annotation2 <- anno[prioritized.features$feature, 2]
  prioritized.features$annotation3 <- anno[prioritized.features$feature, 3]
  prioritized.features$ava <- round(prioritized.features$ava, 4)
  prioritized.features$es <- round(prioritized.features$es, 4)
  prioritized.features$meta_rank <- round(prioritized.features$meta_rank, 4)
  
  # Final table of results
  all.prioritized <- cbind(prioritized.features[,c("feature",
                                              "annotation1",
                                              "annotation2",
                                              "annotation3",
                                              "meta_rank",
                                              "status",
                                              "module",
                                              "anchor",
                                              "module_composition",
                                              "characterizable",
                                              "ava",
                                              "qval",
                                              "es")],
                      anno[prioritized.features$feature, c(4:ncol(anno))])
  all.prioritized$feature <- gsub("F","",all.prioritized$feature)
  char.prioritized <- all.prioritized[which(all.prioritized$characterizable == 1),]
  colnames(all.prioritized) <- c("Feature_index",
                            names(anno)[1],
                            names(anno)[2],
                            names(anno)[3],
                            "Priority_score",
                            "Status",
                            "Module",
                            "Anchor",
                            "Related_classes",
                            "Covaries_with_standard",
                            "AVA",
                            "qvalue",
                            "effect_size",
                            names(anno)[4:ncol(anno)])
  colnames(char.prioritized) <- names(all.prioritized)
  mac.result <- list(all.prioritized, char.prioritized)
  mac.result
}
