import numpy as np
m = 5
n = 4
c = np.random.rand(m * n)
mu = np.ones(m)
nu = np.ones(n) / n * m
Condition_hang = np.zeros((0,m*n))
Condition_lie = np.zeros((0,m*n))
for i in range(m):
    temp = np.zeros((m,n))
    temp[i,:] = 1
    temp = temp.reshape(1,m*n)
    Condition_hang = np.vstack((Condition_hang,temp))
for i in range(n):
    temp = np.zeros((m,n))
    temp[:,i] = 1
    temp = temp.reshape(1,m*n)
    Condition_lie = np.vstack((Condition_lie,temp))
A = np.vstack((Condition_hang,Condition_lie))
b = np.hstack((mu,nu))
print(A)
print(b)
#print(x)
def projection_step(x,A,b):
    #TODO: calculate the distance between every simplex and take projections
    #Difficulty: distance and direction in projection is hard
    return x_projected
eta = 0.01
for i in range(100):
    x = projection_step(x-eta*c,A,b)
    print(sum(c*x))



