import boto3
import json
from string import Template
from datetime import tzinfo, datetime
from data.data_manager import Data_Manager
from data.day import Day
import dateutil.tz

eastern = dateutil.tz.gettz('US/Eastern')
today = Day(datetime.now(tz=eastern).weekday())
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
    print(str(today))

    # Get holiday message. Returns None if it is not a holiday
    if (holiday_message := data.get_holiday_msg()) is not None:
        print("It's a holiday week.")
        if today is trashday:
            print("It's Thursday: sending message that it is not trashday")
            notify_recipients(data.recipients, Template(holiday_message))
        elif today is trashday_holiday:
            print("It's Friday: sending message it is trashday (holiday)")
            notify_recipients(data.recipients,Template(message), data.joke)
    elif today is trashday:
        print("It is not a holiday week.")
        print("It's Thursday: sending message it is trashday")
        notify_recipients(data.recipients, Template(message), data.joke)

if __name__ == '__main__':
    lambda_handler(None, None)



