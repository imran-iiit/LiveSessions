'''
>>> evens = evens_up_to(8)
>>> type(evens)
<class 'generator'>
>>> for even in evens:
...     print(even)
2
4
6
8

>>> squares = squares_up_to(16)
>>> type(squares)
<class 'generator'>
>>> for square in squares:
...     print(square)
1
4
9
16

>>> for square in squares_up_to(15):
...     print(square)
1
4
9

>>> counter = countdown(3)
>>> type(counter)
<class 'generator'>
>>> for count in countdown(3):
...     print(count)
3
2
1
BLASTOFF!

>>> for count in countdown(10):
...     print(count)
10
9
8
7
6
5
4
3
2
1
BLASTOFF!

'''

# Write your code here:

def evens_up_to(num):
    for i in range(2, num+1, 2):
        yield i

def squares_up_to(num):
    for i in range(1, 100):
        if i ** 2 <= num:
            yield i**2
        else:
            break

def countdown(num):
    for i in range(num, 0, -1):
        yield i
    yield 'BLASTOFF!'


# Do not edit any code below this line!

if __name__ == '__main__':
    import doctest
    count, _ = doctest.testmod()
    if count == 0:
        print('*** ALL TESTS PASS ***\nGive someone a HIGH FIVE!')

# Copyright 2015-2018 Aaron Maxwell. All rights reserved.
