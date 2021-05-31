%%
clear;
close all;
clc;
% mosek
% setenv('PATH', [getenv('PATH') ';C:\Users\username\mosek\9.0\tools\platform\win64x86\bin']);
m = 50;
n = 50;
iter = 1000;
eps = 1e-6;
type = 1;
save_dir = './results/';
rng(0);
c = ones(1 ,m * n);
[x, b] = dot_mark(m, n, type);
A = get_constraint_matrix(m, n);

output1 = linprog_mosek(c, m, n, A, b);
output2 = linprog_gurobi(c, m, n, A, b);
output3 = admm(c, m, n, A, b, x, 0.1, iter, eps);
outputs = [output1, output2, output3];