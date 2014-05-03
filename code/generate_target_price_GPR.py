#!/usr/bin/python

# This generates a file in the format expected by
# simulate_signal.py using a multiple linear regression
#
# this program takes 3 arguments.
# 1st arg:
# predicted y values obtained by using the GPReg
#
# 2nd arg:
# "inputdatafilename" ( The data on which to generate target prices )
#
# "outputfilename" ( The file on which simulate_signal.py will operate )

import os;
import os.path;
import sys;

def __main__():

    if len ( sys.argv ) < 4 :
        print ("Usage: predictedvaluesfilename inputdatafilename output_target_file")
        sys.exit()

    predictedvaluesfilename_ = sys.argv[1]  # Predicted_yValues.txt
    inputdatafilename_ = sys.argv[2]  # prod_data_origprice.txt
    outputfilename_ = sys.argv[3]  # prod_data_targetprice.txt

    path = "../data" 
    
    pathname_outputfile = os.path.join(path, outputfilename_)
    pathname_inputfile = os.path.join(path, inputdatafilename_)  
    pathname_predictedvaluesfile = os.path.join(path, predictedvaluesfilename_)

            
    if os.path.isfile ( pathname_predictedvaluesfile ) :          
	predictedvalues_file_handle_ = open ( pathname_predictedvaluesfile, 'r') 
	output_target_file_handle_ = open ( pathname_outputfile, 'w+') # open file for writing
	with open(pathname_inputfile) as input_data_file_handle_:
	    for input_data_line_ in input_data_file_handle_: # this is one of the most efficient ways of reading files from a big data file, line by line
		input_data_line_words_ = input_data_line_.strip().split() # returns a list of words in the line
		if ( len ( input_data_line_words_ ) == 6 ) :
			this_target_price_ = float(input_data_line_words_[1])			
			predicted_yval_line = predictedvalues_file_handle_.readline()	# Assumption: Predicted_yValues.txt and prod_data_origprice.txt will have the same no. of rows
			predicted_yval_words_ = predicted_yval_line.strip().split()  
			this_target_price_ = this_target_price_ + float( predicted_yval_words_[0] ) 
			output_target_file_handle_.write ( "" + str(input_data_line_words_[0]) + " " + str(this_target_price_) + " " + input_data_line_words_[2] + " " + input_data_line_words_[3] + " " + input_data_line_words_[4] + " " + input_data_line_words_[5] + "\n" ) # write used to output to the file

        output_target_file_handle_.close()
	input_file_handle_.close()
	predictedvalues_file_handle_.close()
    
    #os.remove(pathname_inputfile)

__main__();
