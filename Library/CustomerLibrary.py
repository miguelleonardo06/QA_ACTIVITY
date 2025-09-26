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

    def last_five_users(self):
        response = requests.get("https://jsonplaceholder.typicode.com/users", verify=False)
        users = response.json()
        last_five = users[5:10]

        return last_five


    def generate_birthday(self):
        month = str(random.randint(1,12)).zfill(2)
        day = str(random.randint(1,28)).zfill(2)
        year = str(random.randint(1950, 2020)).zfill(4)
       
        return month + "-" + day + "-" + year