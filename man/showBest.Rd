% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/showBest.R
\name{showBest}
\alias{showBest}
\title{View highly prioritized bioactives grouped by modules.}
\usage{
showBest(
  mac.result,
  priority_threshold = 0.9,
  per_module = 10,
  per_phenotype = 1000,
  only_characterizable = TRUE
)
}
\arguments{
\item{mac.result}{the output of Macarron::Macarron() or Macarron::prioritize().}

\item{priority_threshold}{cut-off of priority score. Default = 0.9.}

\item{per_module}{show first n highly prioritized features in a module. Default = 10}

\item{per_phenotype}{show highly prioritized n features per phenotype/condition. Default = 1000}

\item{only_characterizable}{show highly prioritized features in modules which contain at least one annotated metabolite. Default = TRUE}
}
\value{
best.mets -highly-prioritized bioactives in each module in each phenotype
}
\description{
Modules are listed in the order of priority. Only the top-ranked n features in each module 
are shown. The priority of a module is the ratio of number of features in it that are ranked higher than
the cut-off and the size of the module. This utility function makes it easier to understand default
prioritization results of large datasets where a few hundred metabolic features are highly-prioritized.
}
\examples{
prism_abundances = system.file("extdata", "demo_abundances.csv", package="Macarron")
abundances_df = read.csv(file = prism_abundances, row.names = 1)
prism_annotations = system.file("extdata", "demo_annotations.csv", package="Macarron")
annotations_df = read.csv(file = prism_annotations, row.names = 1)
prism_metadata = system.file("extdata", "demo_metadata.csv", package="Macarron")
metadata_df = read.csv(file = prism_metadata, row.names = 1)
met_taxonomy = system.file("extdata", "demo_taxonomy.csv", package="Macarron")
taxonomy_df = read.csv(file = met_taxonomy)
mbx <- Macarron::prepInput(input_abundances = abundances_df,
                            input_annotations = annotations_df,
                            input_metadata = metadata_df)
w <- Macarron::makeDisMat(se = mbx)
modules.assn <- Macarron::findMacMod(se = mbx, 
                                     w = w,
                                     input_taxonomy = taxonomy_df)
mets.ava <- Macarron::calAVA(se = mbx,
                             mod.assn = modules.assn)                                     
mets.qval <- Macarron::calQval(se = mbx,
                               mod.assn = modules.assn)
mets.es <- Macarron::calES(se = mbx,
                           mac.qval = mets.qval)
mets.prioritized <- Macarron::prioritize(se = mbx,
                                         mod.assn = modules.assn,
                                         mac.ava = mets.ava,
                                         mac.qval = mets.qval,
                                         mac.es = mets.es)  
best.mets <- Macarron::showBest(mac.result = mets.prioritized)
                                                                

}
