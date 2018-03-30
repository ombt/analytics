#!/usr/bin/python3

def cheeseshop(kind, *arguments, **keywords):
    print("--- Do you have any", kind, "?")
    print("--- Sorry, we're all out of", kind)

    print("="*40)

    for arg in arguments:
        print(arg)

    print("-"*40)

    for kw in keywords:
        print(kw,"==>>", keywords[kw])

cheeseshop("Limburger", 
           "It's very runny, sir.",
           "It's really very, VERY runny, sir.",
           shopkeeper="Michael Palin",
           client="John Cleese",
           sketch="Cheese Shop Sketch")

exit()
