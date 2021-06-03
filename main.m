%%
clear;
clc;
% close all;
% mosek
% setenv('PATH', [getenv('PATH') ';D:mosek\9.2\tools\platform\win64x86\bin']);
save_dir = './results/';
if ~exist(save_dir, 'dir')
	mkdir(save_dir);
end
%%
rng(0);
m = 500;
n = m;
iter = 2000;
eps = 0;
c = ones(1 ,m * n);
c = c + reshape((rand(m, n))', [1, m * n]);
c = c / max(max(c));
x = abs(randn(m, n));
b = [sum(x, 2); sum(x, 1)'];
x = reshape(x', [m * n, 1]);
A = get_constraint_matrix(m, n);

output1 = linprog_mosek(c, m, n, A, b, 'simplex');
output2 = linprog_mosek(c, m, n, A, b, 'interior point');
output3 = linprog_gurobi(c, m, n, A, b, 'simplex');
output4 = linprog_gurobi(c, m, n, A, b, 'interior point');
output5 = admm(c, m, n, A, b, x, 1e-7, iter, eps);
output6 = sinkhorn(c, m, n, A, b, x, 1e+2, iter, eps);
output7 = sinkhorn(c, m, n, A, b, x, 1e+3, iter, eps);
output8 = sinkhorn(c, m, n, A, b, x, 1e+4, iter, eps);
outputs_random = [output1, output2, output3, output4, output5, output6, output7, output8];
draw(outputs_random, 'time', "Random", [save_dir, 'Random_time']);
pause(1);
close;
draw(outputs_random, 'iteration', "Random", [save_dir, 'Random_iter']);
pause(1);
close;
%%
rng(0);
m = 500;
n = m;
iter = 2000;
eps = 0;
type = 1;
c = ((1:1:m) .* (1:1:m))' +  ((1:1:n) .* (1:1:n)) - 2 * ((1:1:m)' * (1:1:n));
c = c / max(max(c));
c = reshape(c', [1, m * n]);
[x, b] = dot_mark_data_set(m, n, type);
A = get_constraint_matrix(m, n);

output1 = linprog_mosek(c, m, n, A, b, 'simplex');
output2 = linprog_mosek(c, m, n, A, b, 'interior point');
output3 = linprog_gurobi(c, m, n, A, b, 'simplex');
output4 = linprog_gurobi(c, m, n, A, b, 'interior point');
output5 = admm(c, m, n, A, b, x, 1e-7, iter, eps);
output6 = sinkhorn(c, m, n, A, b, x, 1e+2, iter, eps);
output7 = sinkhorn(c, m, n, A, b, x, 1e+3, iter, eps);
output8 = sinkhorn(c, m, n, A, b, x, 1e+4, iter, eps);
outputs_DoTmark = [output1, output2, output3, output4, output5, output6, output7, output8];
draw(outputs_DoTmark, 'time', "DOTmark", [save_dir, 'DOTmark_time']);
pause(1);
close;
draw(outputs_DoTmark, 'iteration', "DOTmark", [save_dir, 'DOTmark_iter']);
pause(1);
close;
%%
rng(0);
m = 500;
n = m;
iter = 2000;
eps = 0;
[c, b] = caffarelli_data_set(n);
A = get_constraint_matrix(m, n);
x = zeros(m * n, 1);

output1 = linprog_mosek(c, m, n, A, b, 'simplex');
output2 = linprog_mosek(c, m, n, A, b, 'interior point');
output3 = linprog_gurobi(c, m, n, A, b, 'simplex');
output4 = linprog_gurobi(c, m, n, A, b, 'interior point');
output5 = admm(c, m, n, A, b, x, 1e-7, iter, eps);
output6 = sinkhorn(c, m, n, A, b, x, 1e+2, iter, eps);
output7 = sinkhorn(c, m, n, A, b, x, 1e+3, iter, eps);
output8 = sinkhorn(c, m, n, A, b, x, 1e+4, iter, eps);
outputs_Caffarelli = [output1, output2, output3, output4, output5, output6, output7, output8];
draw(outputs_Caffarelli, 'time', "Caffarelli", [save_dir, 'Caffarelli_time']);
pause(1);
close;
draw(outputs_Caffarelli, 'iteration', "Caffarelli", [save_dir, 'Caffarelli_iter']);
pause(1);
close;
%%
rng(0);
load('./data/shift_of_Ricker.mat');
m = 500;
n = m;
iter = 2000;
eps = 0;
c = reshape(C', [1, m * n]) / max(max(C));
x = ones(m * n, 1) / m;
b = ([fx, fy])';
A = get_constraint_matrix(m, n);

output1 = linprog_mosek(c, m, n, A, b, 'simplex');
output2 = linprog_mosek(c, m, n, A, b, 'interior point');
output3 = linprog_gurobi(c, m, n, A, b, 'simplex');
output4 = linprog_gurobi(c, m, n, A, b, 'interior point');
output5 = admm(c, m, n, A, b, x, 1e-6, iter, eps);
output6 = sinkhorn(c, m, n, A, b, x, 1e+2, iter, eps);
output7 = sinkhorn(c, m, n, A, b, x, 1e+3, iter, eps);
output8 = sinkhorn(c, m, n, A, b, x, 1e+4, iter, eps);
outputs_Ricker = [output1, output2, output3, output4, output5, output6, output7, output8];
draw(outputs_Ricker, 'time', "Ricker", [save_dir, 'Ricker_time']);
pause(1);
close;
draw(outputs_Ricker, 'iteration', "Ricker", [save_dir, 'Ricker_iter']);
pause(1);
close;