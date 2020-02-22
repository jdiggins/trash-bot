import datetime
from datetime import datetime, tzinfo, timedelta, date
from data.static_data import holidays, messages, recipients
import requests
import random

class Data_Manager(object):
    def __init__(self):
        self.joke = self.get_dad_joke()
        self.recipients = recipients()
        self.messages = messages()
        self.holidays = holidays()

    def load_random_message(self):
        rand = random.randint(0, (len(self.messages)- 1) )
        return self.messages[rand]

    def get_holiday_msg(self):
        today = date.today()
        for i in range(-5,1):
            if (msg := self.holidays.get(today + timedelta(days=i))) is not None:
                return msg
        return None

    def get_dad_joke(self):
        response = requests.get('https://icanhazdadjoke.com', headers={"Accept":"text/plain"})
        if response.status_code != 200:
            return "How does Moses make his cup of tea? Hebrews it"
        else:
            return response.content.decode('utf-8')
        