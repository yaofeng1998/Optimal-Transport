%%
max_dim = 5;
for k=2:1:max_dim
    size = randperm(max_dim, k) + 1;
    rank(full(get_constraint_matrix_tensor(size))) - (sum(size) - k + 1)
end
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
clear;
n1 = 80;
n2 = 80;
n3 = 80;
seed = 0;
rng(seed);
postfix = [num2str(n1) '_' num2str(n2) '_' num2str(n3) '_' num2str(iter) '_' num2str(seed)];
save_dir = 'results/admm/';
c = rand(n1, n2, n3); 
c = c / max(max(max(c)));
x = rand(n1, n2, n3);
b = ([reshape(sum(x, [2, 3]), [1, n1]), reshape(sum(x, [1, 3]), [1, n2]), reshape(sum(x, [1, 2]), [1, n3])])';
c_flatten = reshape(permute(c, [3, 2, 1]), [n1 * n2 * n3, 1]);
x_flatten = reshape(permute(x, [3, 2, 1]), [n1 * n2 * n3, 1]);
%%
tic
A = get_constraint_matrix_tensor([n1, n2, n3]);
toc
%%
output1 = linprog_mosek_tensor(c_flatten, n1 * n2 * n3, A, b, 'interior point');
output1.x = permute(reshape(output1.x, [n3, n2, n1]), [3, 2, 1]);
sum(output1.x .* c, [1, 2, 3])
b2 = ([reshape(sum(output1.x, [2, 3]), [1, n1]), reshape(sum(output1.x, [1, 3]), [1, n2]), reshape(sum(output1.x, [1, 2]), [1, n3])])';
norm(b2 - b) / norm(b)
%%
iter = 20000;
eps = 0;
output2 = admm_gpu_tensor(c, b, zeros(n1, n2, n3), 1e-7, iter, eps, 1e+3, 1.1, 1.2);
sum(output2.x .* c, [1, 2, 3])
b3 = ([reshape(sum(output2.x, [2, 3]), [1, n1]), reshape(sum(output2.x, [1, 3]), [1, n2]), reshape(sum(output2.x, [1, 2]), [1, n3])])';
norm(b3 - b) / norm(b)
output2.final_gap
%%
draw([output1, output2], 'time', "Random", [save_dir, 'Random_time', postfix]);
%%
norm(reshape(output1.x, [n1 * n2 * n3, 1])) / norm(reshape(output2.x, [n1 * n2 * n3, 1]))
max(reshape(output1.x, [n1 * n2 * n3, 1])) / max(reshape(output2.x, [n1 * n2 * n3, 1]))