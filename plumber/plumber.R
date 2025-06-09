
library(plumber)
#* @apiTitle Wheat Data API
#* @apiDescription Flexible API for accessing wheat dataset.

r <- plumb(file.path("..", "R", "api_core.R"))
r$run(port = 8000)
