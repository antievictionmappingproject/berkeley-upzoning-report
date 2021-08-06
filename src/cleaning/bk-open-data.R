library(tidyverse)
library(RSocrata)

import <- function(id){
  read.socrata(paste0('https://data.cityofberkeley.info/resource/', 
                      id, '.csv'))
}

taxable_sqft <- import('9a47-nj4i')
business_licenses <- import('rwnf-bu3w')

write_csv(taxable_sqft, 'data/bk-open-data/taxable_sqft.csv')
write_csv(business_licenses, 'data/bk-open-data/business_licenses.csv')