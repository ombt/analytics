#!/usr/bin/python3

# dates are easily constructed and formatted

from datetime import date

now = date.today()
print(now)

print(datetime.date(2003, 12, 2))

print(now.strftime("%m-%d-%y. %d %b %Y is a %A on the %d day of %B."))

# dates support calendar arithmetic

birthday = date(1964, 7, 31)
print(birthday)

age = now - birthday
print(age.days)

exit()
