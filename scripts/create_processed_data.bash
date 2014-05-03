#!/usr/bin/env bash

# Creates new processed data files with the information we actually want.
# New data file has the following format:
# <Difference in stock value in future> <27 parameters' values at present (this does not include time, current price, or ask/bid data)>


SOURCE="${BASH_SOURCE[0]}"
DIR="$(dirname $SOURCE)"

# 120000 is how far ahead we want to predict for (120 seconds)
python $DIR/convert_to_regdata_GPR.py $DIR/../workdir/prod_data_v.txt 40 20000 1000 > $DIR/../data/processed_data.txt
