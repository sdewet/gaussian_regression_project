#!/usr/bin/python

# This file assumes that timestamps are always increasing
import os
import sys
import numpy

def convert2regdata():

    if len ( sys.argv ) < 3 :
        print ("Usage: yhat-file msecs_diff [trainingSampleSize] [testSampleSize] [strategytype]")
        sys.exit()

    # expect format of yhat-file: 
    # MFM-disc TARGETPRICE BIDPX BIDSZ ASKPX ASKSZ VAR1 ...
    # 39706307 4779.455624 4779. 50.00 4780. 40.00 ...

    msecs_diff = int(sys.argv[2])
    if len ( sys.argv ) == 5 :
    	train_sample_size = int(sys.argv[3])
    	test_sample_size = int(sys.argv[4])
        strategy_type = 0
        print "Using default strategy type of 0"
    elif len ( sys.argv ) == 6 :
	train_sample_size = int(sys.argv[3])
    	test_sample_size = int(sys.argv[4])
        strategy_type = int(sys.argv[5])        
    else :
	train_sample_size = -100
    	test_sample_size = -100
        strategy_type = -100

    # Strategy 0 : No strategy used (default, if training sample size and test sample size are passed)
    # Strategy 1 : Keep the inliers
    # Strategy 2 : Keep the outliers
    
    # Initialize the file handle for the processed_data.txt file
    path = "../data"    
    outputfilename_ = "processed_data.txt"
    pathname_outputfile = os.path.join(path, outputfilename_)
    _outfile_handle_ = open ( pathname_outputfile, 'w+') # open file for writing the targetprice file
    
    line_vec_ = []

    change_in_price = []
    input_data = []

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
		    prc_chng = tgtpx_ - current_px_
                    out_line_ = ( "%f " % (tgtpx_ - current_px_) )	#out_line is a string
                    out_line_ += " ".join(oldest_yhat_line_words_[6:])
                    #print ( "%s" %(out_line_) )	
	    	    _outfile_handle_.write(out_line_ + "\n")

		    input_data.append(oldest_yhat_line_words_)		# list of lists
		    change_in_price.append(prc_chng)

                    line_vec_.pop(0)
                    if not line_vec_ :
                        break
                    else :
                        oldest_yhat_line_ = line_vec_[0]
                        oldest_yhat_line_words_ = oldest_yhat_line_.strip().split()


                
    #print ("%d" % (len(input_data)))
    #print ("%d" % (len(change_in_price)))
    std_y = numpy.std(change_in_price)
    mean_y = numpy.mean(change_in_price)
    print "{0} is the std and {1} is the mean".format(std_y, mean_y)
    
    if (train_sample_size > 0 and test_sample_size > 0 ) :   # Sample sizes have been passed by the user
        if (strategy_type == 0) :
            checkSampleSize(input_data, train_sample_size, test_sample_size)
        elif (strategy_type == 1) :            
            input_data = compress(input_data, map(lambda y: (mean_y - std_y) <= y and y <= (mean_y + std_y), change_in_price))
            checkSampleSize(input_data, train_sample_size, test_sample_size)
        elif (strategy_type == 2) :            
            input_data = compress(input_data, map(lambda y: (mean_y - std_y) >= y and y >= (mean_y + std_y), change_in_price))
            checkSampleSize(input_data, train_sample_size, test_sample_size)
        else :
            print "Incorrect Strategy type"
            sys.exit()
    
def write2file(data, filename):
    path = "../data"    
    pathname_file = os.path.join(path, filename)
    _file_handle_ = open ( pathname_file, 'w+') # open file for writing 
    for line in data:
        test_line_ = "" + " ".join(line[:])
        _file_handle_.write(test_line_ + "\n")
    _file_handle_.close()

def checkSampleSize(data, train_size, test_size):
    if ( len(data) >= (train_size + test_size)) :
        test_data = data[train_size:train_size + test_size]
        output_target_data = [elem[:6] for elem in test_data]
        write2file(test_data,"prod_test_data.txt") 
        write2file(output_target_data, "prod_data_origprice.txt")
    else :
        print ("The training size or testing size passed is bigger than the size of the data file. Please check!")
        sys.exit()

def compress(data, selectors):
    # compress('ABCDEF', [1,0,1,0,1,1]) --> A C E F
    return [d for d, s in zip(data, selectors) if s]

if __name__ == "__main__":
    convert2regdata()
