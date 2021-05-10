function [x,output] = linprog_mosek(c,m,n)
%linear programming method to solve the problem
% c X_ij
% m length of X
% n depth of X
A = zeros(m+n,m*n);
for i=1:m
    A(i,((i-1)*n+1):i*n) = 1;
end
for i=1:n
    A(m+i,i:n:end) = 1;
end
b = zeros(m+n,1);
b(1:m) = 1;
b(m+1:m+n) = m/n;
[x,output] =linprog(c,[],[],A,b,zeros(m*n,1));
end

