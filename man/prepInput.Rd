% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepInput.R
\name{prepInput}
\alias{prepInput}
\title{Create a SummarizedExperiment object}
\usage{
prepInput(input_abundances, input_annotations, input_metadata)
}
\arguments{
\item{input_abundances}{a dataframe (features x samples) containing metabolic feature intensities (abundances).}

\item{input_annotations}{a dataframe (features x annotations) containing the available feature annotations.
^^Column 1 must contain standard annotations such as HMDB ID or Pubchem CID for 
the subset of identified/annotated features. 
^^Column 2 must contain metabolite name.
^^Column 3 must contain a continuous numeric chemical property such as m/z or shift/ppm.}

\item{input_metadata}{a dataframe (samples x metadata) containing sample metadata.
^^Row names must identify samples.
^^Column 1 must identify phenotypes or conditions (categorical metadata) associated with the samples. 
Must not contain NA. Rows with no specified phenotype/condition will be removed.}
}
\value{
SummarizedExperiment object
}
\description{
Create a SummarizedExperiment object
}
\examples{
prism_abundances = system.file("extdata", "demo_abundances.csv", package="Macarron")
abundances_df = read.csv(file = prism_abundances, row.names = 1)
prism_annotations = system.file("extdata", "demo_annotations.csv", package="Macarron")
annotations_df = read.csv(file = prism_annotations, row.names = 1)
prism_metadata = system.file("extdata", "demo_metadata.csv", package="Macarron")
metadata_df = read.csv(file = prism_metadata, row.names = 1)
mbx <- Macarron::prepInput(input_abundances = abundances_df,
                            input_annotations = annotations_df,
                            input_metadata = metadata_df)

}
