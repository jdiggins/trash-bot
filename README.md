# trash-bot
Trash Bot is a service that sends sns (text) reminders to a list of recipients to take the trash out. Trash bot can compensate for holidays and send the occational dad joke.

## Requirements
- python 3.7
- pip3
- virtualenv

### Setup (required) - From inside the trash-bot folder, run the following

```
cd src
python -m venv .
source bin/activate
pip install -r requirements.txt
```

### Setting up your data
To make life simple and the AWS bill slightly lower, the data is stored internally in a python file (data as python). 
Modify the src/data/static_data.py file to add the recipients, holidays, and messages that work for you.

Python string Templates are used to populate a joke and name for each message:
- To add a recipients name to your message, use '$name' as a placeholder
- To add a random joke to your message, use $joke as a placeholder
The placeholders will be replaced before the message is sent out (as long as you follow the format of the sample data)

## Run script locally

Note: You will need aws credentials with proper permissions set up prior to running trash-bot

Make sure you are inside trash-bot/src folder

```
source bin/activate
python handler.py
```

## Run script as AWS Lambda

To deploy the script to AWS Lambda, modify the variables in the top of deploy.sh and then run
```
./deploy.sh
```
Note: If you get a permissions error, try `chmod u+x ./deploy.sh` and then `./deploy.sh` 

To run ona regular schedule, use AWS CloudWatch and set up a schedule job on the lambda