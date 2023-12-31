% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Macarron.R
\name{Macarron}
\alias{Macarron}
\title{Macarron}
\usage{
Macarron(
  input_abundances,
  input_annotations,
  input_metadata,
  input_taxonomy,
  output = "Macarron_output",
  metadata_variable = 1,
  min_prevalence = 0.7,
  execution_mode = "serial",
  standard_identifier = 1,
  anchor_annotation = 2,
  min_module_size = NULL,
  fixed_effects = NULL,
  random_effects = NULL,
  reference = NULL,
  cores = 1,
  plot_heatmap = TRUE,
  plot_scatter = FALSE,
  heatmap_first_n = 50,
  show_best = TRUE,
  priority_threshold = 0.9,
  per_module = 10,
  per_phenotype = 1000,
  only_characterizable = TRUE
)
}
\arguments{
\item{input_abundances}{a comma-delimited file or dataframe (features x samples) containing metabolic feature intensities (abundances).}

\item{input_annotations}{a comma-delimited file or dataframe (features x annotations) containing available feature annotations.}

\item{input_metadata}{a comma-delimited file or dataframe (samples x metadata) containing sample metadata.}

\item{input_taxonomy}{a comma-delimited file or dataframe containing the chemical class and subclass information of annotated features.}

\item{output}{name of the folder where Macarron output files will be written. Default: "Macarron_output".}

\item{metadata_variable}{Name or index of the column that identifies the phenotypes/conditions in the study. Default: Column 1 of metadata dataframe.}

\item{min_prevalence}{prevalence threshold (percentage). Default = 0.7.}

\item{execution_mode}{BiocParallel execution mode. Options: "serial" or "multi" Default = "serial".}

\item{standard_identifier}{Name or index of column containing HMDB or PubChem IDs. Default: Column 1 in annotation dataframe.}

\item{anchor_annotation}{Name or index of column containing common names of the annotated metabolite. Default: Column 2 of annotation dataframe.}

\item{min_module_size}{Integer that defines the size of the smallest covariance module. Default: Cube root of number of prevalent metabolic features.}

\item{fixed_effects}{Covariates for linear modeling with MaAsLin2. Default: All columns of metadata dataframe.}

\item{random_effects}{Random effects for linear modeling with MaAsLin2. Default: NULL.}

\item{reference}{Reference category (factor) in categorical metadata covariates containing three or more levels. Must be provided as a string of 'covariate,reference' semi-colon delimited for multiple covariates.}

\item{cores}{MaAsLin2 option-The number of R processes to be run in parallel.}

\item{plot_heatmap}{MaAslin2 option-Generate a heatmap for the significant associations. Default: TRUE}

\item{plot_scatter}{MaAslin2 option-Generate scatter plots for the significant associations. Default: FALSE}

\item{heatmap_first_n}{MaAslin2 option-Generate heatmap for top n significant associations. Default = 50}

\item{show_best}{write 1000 or fewer highly prioritized metabolic features into a separate file. Default: TRUE}

\item{priority_threshold}{cut-off of priority score for showing highly prioritized features. Default = 0.9}

\item{per_module}{show first n highly prioritized features in a module. Default = 10}

\item{per_phenotype}{show highly prioritized n features per phenotype/condition. Default = 1000}

\item{only_characterizable}{show highly prioritized features in modules which contain at least one annotated metabolite. Default = TRUE}
}
\value{
mac.result dataframes containing metabolic features listed according to their priority (potential bioactivity) in a phenotype of interest.
}
\description{
Macarron
}
\examples{
prism_abundances = system.file("extdata", "demo_abundances.csv", package="Macarron")
prism_annotations = system.file("extdata", "demo_annotations.csv", package="Macarron")
prism_metadata = system.file("extdata", "demo_metadata.csv", package="Macarron")
met_taxonomy = system.file("extdata", "demo_taxonomy.csv", package="Macarron")
mets.prioritized <- Macarron::Macarron(input_abundances = prism_abundances,
                                       input_annotations = prism_annotations,
                                       input_metadata = prism_metadata,
                                       input_taxonomy = met_taxonomy)

}
