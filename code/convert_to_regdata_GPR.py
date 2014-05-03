#!/usr/bin/python

# This file assumes that timestamps are always increasing
import os
import sys

def __main__():

    if len ( sys.argv ) < 3 :
        print ("Usage: yhat-file msecs_diff [trainingSampleSize] [testSampleSize]")
        sys.exit()

    # expect format of yhat-file: 
    # MFM-disc TARGETPRICE BIDPX BIDSZ ASKPX ASKSZ VAR1 ...
    # 39706307 4779.455624 4779. 50.00 4780. 40.00 ...

    msecs_diff = int(sys.argv[2])
    if len ( sys.argv ) == 5 :
    	train_sample_size = int(sys.argv[3])
    	test_sample_size = int(sys.argv[4])
    else :
	train_sample_size = -100
    	test_sample_size = -100
    line_vec_ = []

    # Initialize the file handles for the test file and targetprice file
    path = "../data"    
    outputfilename_ = "prod_data_origprice.txt"
    pathname_outputfile = os.path.join(path, outputfilename_)
    output_target_file_handle_ = open ( pathname_outputfile, 'w+') # open file for writing the targetprice file
    testfilename_ = "prod_test_data.txt"	# test file for comparing GPReg with linear regression / pca regression
    pathname_testfile = os.path.join(path, testfilename_)
    test_file_handle_ = open ( pathname_testfile, 'w+') # open file for writing

    num_lines = 0
    with open(sys.argv[1]) as input_yhat_file_handle_ :		#argv[1] is prod_data_v.txt
        for input_yhat_line_ in input_yhat_file_handle_ :
            input_yhat_line_words_ = input_yhat_line_.strip().split()
            if len ( input_yhat_line_words_ ) >= 6 :
                timeval_ = (int)(input_yhat_line_words_[0])
                tgtpx_ = (float)(input_yhat_line_words_[1])
                #                bidpx_ = (float)(input_yhat_line_words_[2])
                #                bidsz_ = (float)(input_yhat_line_words_[3])
                #                askpx_ = (float)(input_yhat_line_words_[4])
                #                asksz_ = (float)(input_yhat_line_words_[5])
                
                line_vec_.append ( input_yhat_line_ )
                oldest_yhat_line_ = line_vec_[0]
                oldest_yhat_line_words_ = oldest_yhat_line_.strip().split()

                while ( len(oldest_yhat_line_words_) >= 6 ) and ( timeval_ - ( int(oldest_yhat_line_words_[0]) ) > msecs_diff ) :
                    #print ( "OLDLINE: %s" %(oldest_yhat_line_) )
                    #print ( "NEWLINE: %s" %(input_yhat_line_) )
                    current_px_ = float(oldest_yhat_line_words_[1])
                    out_line_ = ( "%f " % (tgtpx_ - current_px_) )
                    out_line_ += " ".join(oldest_yhat_line_words_[6:])
                    print ( "%s" %(out_line_) )
		    num_lines += 1
		    if ( train_sample_size > 0 and test_sample_size > 0 ) :	# Control goes inside iff the train sample size and test sample size was passed by the user
			if ( num_lines > train_sample_size and num_lines <= ( train_sample_size + test_sample_size )) :	
			    # Write line to testfilename
		            test_line_ = "" + " ".join(oldest_yhat_line_words_[:])
		            test_file_handle_.write(test_line_ + "\n")
		            # Write line to outputfilename
			    output_target_file_handle_.write ( "" + str(oldest_yhat_line_words_[0]) + " " + str(oldest_yhat_line_words_[1]) + " " + oldest_yhat_line_words_[2] + " " + oldest_yhat_line_words_[3] + " " + oldest_yhat_line_words_[4] + " " + oldest_yhat_line_words_[5] + "\n" )

                    line_vec_.pop(0)
                    if not line_vec_ :
                        break
                    else :
                        oldest_yhat_line_ = line_vec_[0]
                        oldest_yhat_line_words_ = oldest_yhat_line_.strip().split()

 	output_target_file_handle_.close()
 	test_file_handle_.close()
	input_yhat_file_handle_.close()
                

__main__();
