library(tidyverse)
library(neuralnet)
library(GGally)

url <- 'http://archive.ics.uci.edu/ml/machine-learning-databases/00243/yacht_hydrodynamics.data'

Yacht_Data <- read_table(file = url,
                         col_names = c('LongPos_COB', 'Prismatic_Coeff',
                                       'Len_Disp_Ratio', 'Beam_Draut_Ratio',
                                       'Length_Beam_Ratio','Froude_Num',
                                       'Residuary_Resist')) %>%
  na.omit()

ggpairs(Yacht_Data, title = "Scatterplot Matrix of the Features of the Yacht Data Set")

