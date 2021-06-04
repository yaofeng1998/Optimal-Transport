function [outputs] = main_entropy(m, n, iter, eps, seed, save_dir)
if ~exist(save_dir, 'dir')
	mkdir(save_dir);
end
rng(seed);
postfix = [num2str(m) '_' num2str(n) '_' num2str(iter) '_' num2str(seed)];
if (n == 500) && (m == 500)
    titles = ["Random", "DOTmark", "Caffarelli", "Ricker"];
else
    titles = ["Random", "DOTmark", "Caffarelli"];
end
A = get_constraint_matrix(m, n);
x = sparse(m * n, 1);

c = reshape((rand(m, n))', [1, m * n]);
c = c / max(max(c));
b = [ones(m, 1); ones(n, 1) / n * m];
output1 = sinkhorn(c, m, n, A, b, x, 1e+0, iter, eps);
output2 = sinkhorn(c, m, n, A, b, x, 1e+2, iter, eps);
output3 = sinkhorn(c, m, n, A, b, x, 1e+4, iter, eps);
output4 = gd_entropy(c, m, n, A, b, x, 1e+0, 1e-5, iter, eps);
output5 = gd_entropy(c, m, n, A, b, x, 1e+2, 1e-5, iter, eps);
output6 = gd_entropy(c, m, n, A, b, x, 1e+4, 1e-5, iter, eps);
output7 = newton_entropy(c, m, n, A, b, x, 1e+0, iter, eps);
output8 = newton_entropy(c, m, n, A, b, x, 1e+2, iter, eps);
output9 = newton_entropy(c, m, n, A, b, x, 1e+4, iter, eps);
outputs_random = [output1, output2, output3, output4, output5, output6, output7, output8, output9];
draw(outputs_random, 'time', "Random", [save_dir, 'Random_time', postfix]);
pause(1);
close;
draw(outputs_random, 'iteration', "Random", [save_dir, 'Random_iter', postfix]);
pause(1);
close;

type = 1;
c = ((1:1:m) .* (1:1:m))' +  ((1:1:n) .* (1:1:n)) - 2 * ((1:1:m)' * (1:1:n));
c = c / max(max(c));
c = reshape(c', [1, m * n]);
[~, b] = dot_mark_data_set(m, n, type);
output1 = sinkhorn(c, m, n, A, b, x, 1e+0, iter, eps);
output2 = sinkhorn(c, m, n, A, b, x, 1e+2, iter, eps);
output3 = sinkhorn(c, m, n, A, b, x, 1e+4, iter, eps);
output4 = gd_entropy(c, m, n, A, b, x, 1e+0, 1e-5, iter, eps);
output5 = gd_entropy(c, m, n, A, b, x, 1e+2, 1e-5, iter, eps);
output6 = gd_entropy(c, m, n, A, b, x, 1e+4, 1e-5, iter, eps);
output7 = newton_entropy(c, m, n, A, b, x, 1e+0, iter, eps);
output8 = newton_entropy(c, m, n, A, b, x, 1e+2, iter, eps);
output9 = newton_entropy(c, m, n, A, b, x, 1e+4, iter, eps);
outputs_DoTmark = [output1, output2, output3, output4, output5, output6, output7, output8, output9];
draw(outputs_DoTmark, 'time', "DOTmark", [save_dir, 'DOTmark_time', postfix]);
pause(1);
close;
draw(outputs_DoTmark, 'iteration', "DOTmark", [save_dir, 'DOTmark_iter', postfix]);
pause(1);
close;

[c, b] = caffarelli_data_set(n);
output1 = sinkhorn(c, m, n, A, b, x, 1e+0, iter, eps);
output2 = sinkhorn(c, m, n, A, b, x, 1e+2, iter, eps);
output3 = sinkhorn(c, m, n, A, b, x, 1e+4, iter, eps);
output4 = gd_entropy(c, m, n, A, b, x, 1e+0, 1e-5, iter, eps);
output5 = gd_entropy(c, m, n, A, b, x, 1e+2, 1e-5, iter, eps);
output6 = gd_entropy(c, m, n, A, b, x, 1e+4, 1e-5, iter, eps);
output7 = newton_entropy(c, m, n, A, b, x, 1e+0, iter, eps);
output8 = newton_entropy(c, m, n, A, b, x, 1e+2, iter, eps);
output9 = newton_entropy(c, m, n, A, b, x, 1e+4, iter, eps);
outputs_Caffarelli = [output1, output2, output3, output4, output5, output6, output7, output8, output9];
draw(outputs_Caffarelli, 'time', "Caffarelli", [save_dir, 'Caffarelli_time', postfix]);
pause(1);
close;
draw(outputs_Caffarelli, 'iteration', "Caffarelli", [save_dir, 'Caffarelli_iter', postfix]);
pause(1);
close;

if (m == 500) && (n == 500)
    load('./data/shift_of_Ricker.mat');
    c = reshape(C', [1, m * n]) / max(max(C));
    b = ([fx, fy])';
    A = get_constraint_matrix(m, n);
    output1 = sinkhorn(c, m, n, A, b, x, 1e+0, iter, eps);
    output2 = sinkhorn(c, m, n, A, b, x, 1e+2, iter, eps);
    output3 = sinkhorn(c, m, n, A, b, x, 1e+4, iter, eps);
    output4 = gd_entropy(c, m, n, A, b, x, 1e+0, 1e-5, iter, eps);
    output5 = gd_entropy(c, m, n, A, b, x, 1e+2, 1e-5, iter, eps);
    output6 = gd_entropy(c, m, n, A, b, x, 1e+4, 1e-5, iter, eps);
    output7 = newton_entropy(c, m, n, A, b, x, 1e+0, iter, eps);
    output8 = newton_entropy(c, m, n, A, b, x, 1e+2, iter, eps);
    output9 = newton_entropy(c, m, n, A, b, x, 1e+4, iter, eps);
    outputs_Ricker = [output1, output2, output3, output4, output5, output6, output7, output8, output9];
    draw(outputs_Ricker, 'time', "Ricker", [save_dir, 'Ricker_time', postfix]);
    pause(1);
    close;
    draw(outputs_Ricker, 'iteration', "Ricker", [save_dir, 'Ricker_iter', postfix]);
    pause(1);
    close;
    outputs = [outputs_random; outputs_DoTmark; outputs_Caffarelli; outputs_Ricker];
else
    outputs = [outputs_random; outputs_DoTmark; outputs_Caffarelli];
end
draw(outputs, 'time', titles, [save_dir, postfix]);
pause(1);
close;
draw(outputs, 'iteration', titles, [save_dir, postfix]);
pause(1);
close;
end