%%
clear;
close all;
clc;
m = 5;
n = 4;
c = rand(1,m * n);
b = zeros(m + n,1);
b(1:m) = 1;
b(m + 1:m + n) = m / n;
A = zeros(m + n,m * n);
for i=1:m
    A(i, ((i - 1) * n + 1):i * n) = 1;
end
for i=1:n
    A(m + i, i:n:end) = 1;
end
%%
% initial linear programming using matlab
% [x1,output1] = linprog_initial(c,m,n,b);
% mosek
% setenv('PATH', [getenv('PATH') ';C:\Users\username\mosek\9.0\tools\platform\win64x86\bin']);
tic;
[x1, output1] = linprog_mosek(c,m,n,A,b);
toc
tic;
[x2, output2] = linprog_gurobi(c,m,n,A,b);
toc
norm(x2 - x1)

[x3, output3] = admm(c,m,n,A,b,0.1,1000);