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
m = 500;
n = 500;
iter = 1000;
eps = 1e-6;
c = ones(1 ,m * n);
c = c + 3 * reshape((eye(m, n))', [1, m * n]);
c = c / max(max(c));
x = abs(randn(m, n));
b = [sum(x, 2); sum(x, 1)'];
x = reshape(x', [m * n, 1]);
A = get_constraint_matrix(m, n);

% output1 = linprog_mosek(c, m, n, A, b, 'simplex');
output2 = linprog_mosek(c, m, n, A, b, 'interior point');
output3 = linprog_gurobi(c, m, n, A, b, 'simplex');
output4 = linprog_gurobi(c, m, n, A, b, 'concurrent');
output5 = admm(c, m, n, A, b, x, 1e-5, iter, eps);
outputs = [output2, output3, output4, output5];
draw(outputs, 'time', "Random", [save_dir, 'Random_time']);
pause(1);
close;
draw(outputs, 'iteration', "Random", [save_dir, 'Random_iter']);
%%
m = 256;
n = 256;
iter = 1000;
eps = 1e-5;
type = 1;
c = ((1:1:m) .* (1:1:m))' +  ((1:1:n) .* (1:1:n)) - 2 * ((1:1:m)' * (1:1:n));
c = c / max(max(c));
c = reshape(c', [1, m * n]);
[x, b] = dot_mark_data_set(m, n, type);
A = get_constraint_matrix(m, n);

% output1 = linprog_mosek(c, m, n, A, b, 'simplex');
output2 = linprog_mosek(c, m, n, A, b, 'interior point');
output3 = linprog_gurobi(c, m, n, A, b, 'simplex');
output4 = linprog_gurobi(c, m, n, A, b, 'concurrent');
output5 = admm(c, m, n, A, b, x, 1e-5, iter, eps);
% output6 = sinkhorn(c, m, n, A, b, x, 1e-3, iter, eps);
outputs = [output2, output3, output4, output5];
draw(outputs, 'time', "DOTmark", [save_dir, 'DOTmark_time']);
pause(1);
close;
draw(outputs, 'iteration', "DOTmark", [save_dir, 'DOTmark_iter']);
%%
m = 500;
n = m;
iter = 1000;
eps = 1e-12;
[c, b] = caffarelli_data_set(n);
A = get_constraint_matrix(m, n);
x = ones(m * n, 1) / m;

% output1 = linprog_mosek(c, m, n, A, b, 'simplex');
output2 = linprog_mosek(c, m, n, A, b, 'interior point');
output3 = linprog_gurobi(c, m, n, A, b, 'simplex');
output4 = linprog_gurobi(c, m, n, A, b, 'concurrent');
output5 = admm(c, m, n, A, b, x, 1e-5, iter, eps);
% output6 = sinkhorn(c, m, n, A, b, x, 1e-3, iter, eps);
outputs = [output2, output3, output4, output5];
draw(outputs, 'time', "Caffarelli", [save_dir, 'Caffarelli_time']);
pause(1);
close;
draw(outputs, 'iteration', "Caffarelli", [save_dir, 'Caffarelli_iter']);
%%
load('./data/shift_of_Ricker.mat');
m = 500;
n = 500;
iter = 1000;
eps = 1e-6;
c = reshape(C', [1, m * n]) / max(max(C));
x = ones(m * n, 1) / m;
b = ([fx, fy])';
A = get_constraint_matrix(m, n);

% output1 = linprog_mosek(c, m, n, A, b, 'simplex');
output2 = linprog_mosek(c, m, n, A, b, 'interior point');
output3 = linprog_gurobi(c, m, n, A, b, 'simplex');
output4 = linprog_gurobi(c, m, n, A, b, 'concurrent');
output5 = admm(c, m, n, A, b, x, 1e-5, iter, eps);
% output6 = sinkhorn(c, m, n, A, b, x, 1e-3, iter, eps);
outputs = [output2, output3, output4, output5];
draw(outputs, 'time', "Ricker", [save_dir, 'Ricker_time']);
pause(1);
close;
draw(outputs, 'iteration', "Ricker", [save_dir, 'Ricker_iter']);