%%
clear;
clc;
% close all;
% mosek
% setenv('PATH', [getenv('PATH') ';D:mosek\9.2\tools\platform\win64x86\bin']);
save_dir = './results/';
rng(0);
if ~exist(save_dir, 'dir')
	mkdir(save_dir);
end
%%
m = 2000;
n = 2000;
iter = 1000;
eps = 1e-6;
type = 1;
c = ones(1 ,m * n);
[x, b] = dot_mark(m, n, type);
A = get_constraint_matrix(m, n);

output1 = linprog_mosek(c, m, n, A, b);
output2 = linprog_gurobi(c, m, n, A, b);
output3 = admm(c, m, n, A, b, x, 0.1, iter, eps);
output4 = sinkhorn(c, m, n, A, b, x, 1e-3, iter, eps);
outputs = [output1, output2, output3, output4];
draw(outputs, 'time', "DOTmark", [save_dir, 'test']);
%%
load('./data/shift_of_Ricker.mat');
m = 500;
n = 500;
iter = 1000;
eps = 0;
c = reshape(C, [1, m * n]) / max(max(C));
x = zeros(m * n, 1);
b = [fx, fy];
A = get_constraint_matrix(m, n);
output1 = linprog_mosek(c, m, n, A, b);
output2 = linprog_gurobi(c, m, n, A, b);
output3 = admm(c, m, n, A, b, x, 0.1, iter, eps);
output4 = sinkhorn(c, m, n, A, b, x, 1e-3, iter, eps);
outputs = [output1, output2, output3, output4];
draw(outputs, 'time', "Ricker", [save_dir, 'Ricker']);