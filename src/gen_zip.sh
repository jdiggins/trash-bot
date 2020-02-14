#!/bin/bash
# 1/31/2020
# John Diggins
# Little script to zip up your python to prepare it for AWS Lambda
# 
# App needs to be set up in a virtual env for this to work!  

files_to_zip='handler.py data/data_manager.py data/day.py data/static_data.py'
zip_file='function.zip'
python_version='python3.8'

# Package and deploy to AWS Lambda
source ./bin/activate
pip install Pillow
deactivate
cd lib/$python_version/site-packages/
zip -r9 ../../../$zip_file .
cd ../../../
zip -g $zip_file $files_to_zip
