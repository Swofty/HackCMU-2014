def factorial(x):
    if(x==0):
        return 1
    else:
        return (x*factorial(x-1))
def fib(x):
    if(x==0):
        return 1
    elif(x==1):
        return 0
    else:
        return (fib(x-1))+(fib(x-2))

