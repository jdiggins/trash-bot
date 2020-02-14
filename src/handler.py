import boto3
import json
from string import Template
from data.data_manager import Data_Manager
from data.day import Day

trashday = Day.THURSDAY
trashday_holiday = Day.FRIDAY

def notify_recipients(recipients, template_msg, joke=""):
    client = boto3.client('sns')
    for name, phone in recipients.items():
        _send_msg(client, phone, template_msg.safe_substitute(name=name, joke=joke))

def _send_msg(client, number, msg):
    client.publish(PhoneNumber=number, Message=msg)

def lambda_handler(event, context):
    data = Data_Manager()
    message = data.load_random_message()

    # Get holiday message. Returns None if it is not a holiday
    if (holiday_message := data.get_holiday_msg()) is not None:
        if date.today().weekday() is trashday:
            notify_recipients(data.recipients, Template(holiday_message))
        elif date.today().weekday() is trashday_holiday:
            notify_recipients(data.recipients,Template(message), data.joke)
    elif date.today().weekday() is trashday:
        notify_recipients(data.recipients, Template(message), data.joke)

if __name__ == '__main__':
    lambda_handler(None, None)



