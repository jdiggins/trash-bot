from datetime import datetime, date, timedelta

# List of recipients. Add as many / few as needed!
def recipients():
    return {
        'Name1' : '+13431234567',
        'Name2' : '+12321235678',
        'Name3' : '+12859876543'
        }

def holidays():
    return {
        date(month=1,day=1,year=2020): "Happy new year! No trash today!,
        date(month=1, day=20,year = 2020): "We had a holiday! No trash today!",
        date(month=2, day=17,year = 2020): "We had a holiday! No trash today!",
        date(month=4, day=20,year = 2020): "We had a holiday! No trash today!",
        date(month=5, day=25,year = 2020): "We had a holiday! No trash today!",
        date(month=9, day=7,year = 2020): "We had a holiday! No trash today!",
        date(month=10, day=12,year = 2020): "We had a holiday! No trash today!",
        date(month=11, day=11,year = 2020): "We had a holiday! No trash today!",
        date(month=11, day=26,year = 2020): "Happy Thanksgiving! No trash today!",
        date(month=11, day=27,year = 2020): "We had a holiday! No trash today!",
        date(month=12, day=24,year = 2020): "Merry Christmas! No trash today!",
        date(month=12, day=25,year = 2020): "Merry Christmas! No trash today!" 
        }
def messages():
    return ["Hi $name \U0001F920 This is your friendly reminder that the trash needs assistance getting to the curb today!",
            "Hi $name \U0001F920 We need to talk. About trash. It needs to go out today \U0001F5D1",
            "Hi $name \U0001F920! I would take the trash out if I could...I have jokes though! $joke",
            "Hi $name \U0001F920 Hope you are have a lovely trash day \U0001F618!",
            "Hi $name \U0001F920! Happy Trash Day! To celebrate, here is a joke: $joke",
            "Hi $name \U0001F920 $joke Oh, and it's trash day. ",
            "Hi $name \U0001F920! Oh, I love trash! Anything dirty or dingy or dusty! Anything ragged or rotten or rusty! Yes, I love trash!",
            "Hi $name \U0001F920 Just because you're trash doesn't mean you can't do great things. It is called garbage can, not garbage cannot. ",
            "Hi $name \U0001F920 There is no such thing as garbage, just useful stuff in the wrong place. Except the garbage we need to take out, that is garbage.",
            "Hi $name \U0001F920 I don't talk trash often, but when I do, I tell you to take it out.",
            "Hi $name \U0001F920 I'm thinking of being a joke bot instead of a trash bot, here's a new one: $joke",
            ]