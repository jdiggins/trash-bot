# trash-bot
Trash Bot is a service that sends sns (text) reminders to a list of recipients to take the trash out. Trash bot can compensate for holidays and send the occational dad joke.

## Requirements
- python 3.8
- pip3
- virtualenv
- terraform 0.12

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

## Set up AWS infrastructure with terraform
1) Make sure you have modified src/data/static_data.py with your own data. I recommend testing this locally before deploying!
2) Run src/gen_zip.sh: `cd src && sh gen_zip.sh`. This will zip up the python source so it can be uploaded to the AWS Lambda.
3) Modify terraform/main.tf to fit your needs. The main thing you may need to change is the cron expression (scheduler_cron_expr). It is currently set up to run twice on Thursday and Friday. Note it will only send a text on Friday's if there was a holiday.
4) Run the terraform plan command: `terraform plan -out planfile`
5) Inspect the output for errors
6) Run the terraform apply command: `terraform apply "planfile"`
7) That's it! The terraform should have created an AWS Lambda, uploaded the source code and created a CloudWatch Event Rule to execute the lambda automatically

- If you need to update the code or infrastructure at all, just repeat these steps! Terraform will pick up on any changes to the zip file and update accordingly. 


## Deploy code to AWS Lambda

To deploy the script to AWS Lambda without terraform, modify the variables in the top of deploy.sh and then run:
```
sh deploy.sh
```

- I don't see why this is needed since Terraform will do the work for us, but perhaps someone will find this script useful.

