%%
clear;
clc;
m = 500;
n = m;
iter = 1082;
eps = 0;
t = 1;
seed = 0;
postfix = [num2str(m) '_' num2str(n) '_' num2str(iter) '_' num2str(seed)];
save_dir = 'results/admm/';
load('./data/shift_of_Ricker.mat');
c = reshape(C', [1, m * n]) / max(max(C));
b = ([fx, fy])';
% A = get_constraint_matrix(m, n);
A = [];
x = zeros(m * n, 1);
output1 = admm_matrix(c, m, n, A, b, x, t, iter, eps, 1.2e-5, 0.85, 1.3);
output2 = admm_gpu_matrix(c, m, n, A, b, x, t, iter, eps, 1.2e-5, 0.85, 1.3);
draw([output1, output2], 'time', "Ricker", [save_dir, 'Ricker_time', postfix]);
draw([output1, output2], 'iteration', "Ricker", [save_dir, 'Ricker_iter', postfix]);
%%
m = 500;
n = m;
iter = 1082;
eps = 0;
t = 1;
seed = 0;
postfix = [num2str(m) '_' num2str(n) '_' num2str(iter) '_' num2str(seed)];
save_dir = 'results/admm/';
load('./data/shift_of_Ricker.mat');
c = C / max(max(C));
b = ([sum(sum(output1.x)), sum(sum(output1.x)), 2 * fx, 2 * fy])';
% A = get_constraint_matrix(m, n);
A = [];
c2 = zeros(2, m, n);
c2(1, :, :) = c;
c2(2, :, :) = c;
x = zeros(2, m, n);
% output1 = admm_matrix(c, m, n, A, b, x, t, iter, eps, 1.2e-5, 0.85, 1.3);
output2 = admm_gpu_tensor(c2, b, x, t, iter, eps, 1.2e-5, 0.85, 1.3);
%%
n1 = 50;
n2 = n1;
n3 = n2;
iter = 20000;
eps = 1e-8;
t = 1;
seed = 0;
postfix = [num2str(n1) '_' num2str(n2) '_' num2str(n3) '_' num2str(iter) '_' num2str(seed)];
save_dir = 'results/admm/';
c = rand(n1, n2, n3); 
c = c / max(max(max(c)));
x = rand(n1, n2, n3);
b = ([reshape(sum(x, [2, 3]), [1, n1]), reshape(sum(x, [1, 3]), [1, n2]), reshape(sum(x, [1, 2]), [1, n3])])';
A = get_constraint_matrix_tensor([n1, n2, n3]);
c_flatten = reshape(permute(c, [3, 2, 1]), [n1 * n2 * n3, 1]);
x_flatten = reshape(permute(x, [3, 2, 1]), [n1 * n2 * n3, 1]);
output1 = linprog_mosek(c_flatten, n1 * n2 * n3, 1, A, b, 'interior point');
output2 = admm_gpu_tensor(c, b, zeros(n1, n2, n3), t, iter, eps, 1.2e-4, 0.85, 1);
draw([output1, output2], 'time', "Random", [save_dir, 'Random_time', postfix]);
%%
xxx=permute(reshape(output1.x, [n3, n2, n1]), [3, 2, 1]);
b2 = ([reshape(sum(xxx, [2, 3]), [1, n1]), reshape(sum(xxx, [1, 3]), [1, n2]), reshape(sum(xxx, [1, 2]), [1, n3])])';
norm(b2 - b) / norm(b)
b3 = ([reshape(sum(output2.x, [2, 3]), [1, n1]), reshape(sum(output2.x, [1, 3]), [1, n2]), reshape(sum(output2.x, [1, 2]), [1, n3])])';
norm(b3 - b) / norm(b)
norm(output1.x) / norm(reshape(output2.x, [n1 * n2 * n3, 1]))
max(output1.x) / max(reshape(output2.x, [n1 * n2 * n3, 1]))