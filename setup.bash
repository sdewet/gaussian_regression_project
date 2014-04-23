# !/bin/bash

if [ ! -d workdir ]
then
	if [ -e workdir.zip ]
	then
		echo "Unzip contest data files should be in this folder"
		unzip workdir.zip
		echo ""
		echo "Unzipping complete."
	else
		echo "Error:  workdir.zip should be in this folder"
		exit
	fi
fi

echo "Create processed data file."
./code/create_processed_data.bash
echo "Done."
echo "Run readProcessedData in matlab to get the data we will use in our models."
