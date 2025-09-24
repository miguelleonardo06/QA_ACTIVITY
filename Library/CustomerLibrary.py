# customer_library.py
import requests
import random
import datetime

class CustomerLibrary:
    def get_users(self):
        response = requests.get("https://jsonplaceholder.typicode.com/users", verify=False)
        users = response.json()
        first_five = users[:5]
       
        return first_five
    
    def generate_birthday(self):
        year = random.randint(1950, 2010)
        month = random.randint(1, 12)
        day = random.randint(1, 28)
        birthday = datetime.date(year, month, day)
        return birthday.strftime("%Y-%m-%d")