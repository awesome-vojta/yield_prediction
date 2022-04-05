The purpose of this project is to predict the true wheat yield value based on satellite images.

## data
- contains 8 csv files
- these are filtered, preprocessed harvester-gathered data, paired with calculated vegetation indices from satellite images

## models
- contains linear and tree regression models with their assessments

## preprocessing
- contains raw harvester-gathered data and satellite images
- raw data are preprocessed into tiffs
- tiffs are transformed into csv files inside **data** folder using the **read-rasters.R** script

## presentation
- includes some scripts for chart plotting
