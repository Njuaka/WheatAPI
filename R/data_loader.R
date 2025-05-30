
#' Title  Load data
#' load and prepare wheat data
#' @returns both individual and combined datasets for the three wheat data tables

load_wheat_data <- function(){
  if(!requireNamespace("BGLR", quietly = TRUE)) install.packages("BGLR")
     data("wheat", package="BGLR")

  # label genotype
  genotype<- as.data.frame(wheat.A)
  colnames(genotype)<-  paste0("Line", colnames(genotype))
  rownames(genotype) <-  paste0("Line", rownames(genotype))

  # label phenotype
  phenotype <- as.data.frame(wheat.Y)
  rownames(phenotype) <- paste0("Line", rownames(phenotype))
  colnames(phenotype) <- paste0("yield_env", colnames(phenotype))

  # marker
  marker <- as.data.frame(wheat.X)

  # full data; return all datasets in a list
  Combined = list(
      Genotypes = genotype,
      Phenotypes = phenotype,
      marker = marker
  )
}
