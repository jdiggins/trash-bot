#!/bin/bash
# 1/31/2020
# John Diggins
# Little script to upload your python app to aws lambda
# AWS Lambda function must already be created
# 
# App needs to be set up in a virtual env for this to work!  

lambda_name='trash-bot'
python_version='python3.8'
files_to_zip='handler.py data/data_manager.py data/day.py data/static_data.py'
zip_file='function.zip'

# Package and deploy to AWS Lambda
source ./bin/activate
pip install Pillow
deactivate
cd lib/$python_version/site-packages/
zip -r9 ../../../$zip_file .
cd ../../../
zip -g $zip_file $files_to_zip

# Upload zip to aws lambda
aws lambda update-function-code --function-name $lambda_name --zip-file fileb://$zip_file

# Cleanup!
rm $zip_file