#!/usr/bin/python3
#
# template for console programs and modules.
#
x = "blue"
y = "green"
z = x;
#
print("x is ...", x);
print("y is ...", y);
print("z is ...", z);
#
y = x
#
print("x is ...", x);
print("y is ...", y);
print("z is ...", z);
#
route = 866
print(route, type(route));
print(str(route), type(str(route)));
#
print(len(("one",)))
print(len([3,5,1,2,"puase",5]))
#
x = [ "zebra", 49, -189, "aardvark", 200 ]
print("x before ... ", x)
x.append("more")
#
print("x after ... ", x)
print("x[4]", x[4])
#
x[1] = 'forty nine'
#
a = [ "retention", 3, None]
b = [ "retention", 3, None]
#
print("a is b", a is b)
#
b = a
print("a is b", a is b)
#
a = "something"
b = None
print(a is not None, b is None)
#
a = 2
b = 6
print("a == b", a==b)
print("a < b", a<b)
print(a<=b,a!=b,a>=b, a>b)
#
a = "many paths"
b = "many paths"
#
print("a is b", a is b)
print("a == b", a==b)
print("a < b", a<b)
print(a<=b,a!=b,a>=b, a>b)
#
# chaining ...
#
a = "a"
b = "b"
c = "c"
#
print("a < b < c", a < b < c)
#
p = ( 4, 'frog', 9, 33, 9, 2 )
print("2 in p", 2 in p)
print("dog in p", 'dog' in p)
print("dog not in p", "dog" not in p)
#
phrase = "Wild Swans by Jung Change"
print("J" in phrase)
#
# and, or return the operand that determined the value, not true or false
#
five = 5
two = 2
zero = 0
nought = 0
#
# not a boolean context
#
print("five and two", five and two)
print("two and five", two and five)
print("five and zero", five and zero)
#
# a boolean context
#
print("not(five and two)", not(five and two))
print("not(two and five)", not(two and five))
print("not(not(five and zero))", not(not(five and zero)))
print("not(nought or zero)", not(nought or zero))
#
exit(0);

