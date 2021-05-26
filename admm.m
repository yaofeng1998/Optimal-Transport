function [x, output] = admm(c,m,n,A,b,t,iterations)
A = A(1:1:m + n -1, :);
b = b(1:1:m + n -1, :);
c = c / max(max(c));
invAAT = (A * A')^(-1);
x = 0.1 * zeros(m * n, 1);
lambda = zeros(m * n, 1);
for i=1:1:iterations
    [x, y, lambda] = admm_onestep(invAAT,c',A,b,x,lambda,t);
    c * x - b' * y
end
output=0;
end