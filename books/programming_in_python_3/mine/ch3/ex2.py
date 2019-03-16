#!/usr/bin/python3
#
import sys
import collections
#
Sale = collections.namedtuple("Sale", 
                              "productid "
                              "customerid "
                              "date "
                              "quantity "
                              "price")
print(Sale)
#
sales = []
sales.append(Sale(432, 921, "2008-09-14", 3, 7.99))
sales.append(Sale(419, 874, "2008-09-15", 1, 18.49))
#
total = 0
for sale in sales:
    total += sale.quantity*sale.price
print("Total ${0:.2f}".format(total))
#
Aircraft = collections.namedtuple("Aircraft","manufacturer model seating")
Seating = collections.namedtuple("Seating", "minimum maximum")
aircraft = Aircraft("Airbus", "A320-200", Seating(100, 220))
#
print(aircraft.seating.maximum)
print("{0} {1}".format(aircraft.manufacturer, aircraft.model))
#
exit(0);

