%%
clear;
clc;
m = 500;
n = m;
iter = 1000;
eps = 1e-12;
t = 1e-6;
seed = 0;
%%
outputs_original = main_original(m, n, iter, eps, t, seed, 'results/original/');
output_size_original = size(outputs_original);
time_original = zeros(output_size_original);
gap_original = zeros(output_size_original);
iter_original = zeros(output_size_original);
for i = 1:1:output_size_original(1)
    for j = 1:1:output_size_original(2)
        time_original(i, j) = outputs_original(i, j).total_time;
        gap_original(i, j) = outputs_original(i, j).final_gap;
        iter_original(i, j) = outputs_original(i, j).iter;
    end
end
total_data_original = ([time_original, gap_original, iter_original])';
%%
outputs_entropy = main_entropy(m, n, iter, eps, seed, 'results/entropy/');
output_size_entropy = size(outputs_entropy);
time_entropy = zeros(output_size_entropy);
gap_entropy = zeros(output_size_entropy);
iter_entropy = zeros(output_size_entropy);
for i = 1:1:output_size_entropy(1)
    for j = 1:1:output_size_entropy(2)
        time_entropy(i, j) = outputs_entropy(i, j).total_time;
        gap_entropy(i, j) = outputs_entropy(i, j).final_gap;
        iter_entropy(i, j) = outputs_entropy(i, j).iter;
    end
end
total_data_entropy = ([time_entropy, gap_entropy, iter_entropy])';
%%
outputs_admm = main_admm(m, n, iter, eps, t, seed, 'results/admm/');
output_size_admm = size(outputs_admm);
time_admm = zeros(output_size_admm);
gap_admm = zeros(output_size_admm);
iter_admm = zeros(output_size_admm);
for i = 1:1:output_size_admm(1)
    for j = 1:1:output_size_admm(2)
        time_admm(i, j) = outputs_admm(i, j).total_time;
        gap_admm(i, j) = outputs_admm(i, j).final_gap;
        iter_admm(i, j) = outputs_admm(i, j).iter;
    end
end
total_data_admm = ([time_admm, gap_admm, iter_admm])';
%%
clear;
clc;
m = 1000;
n = m;
iter = 1000;
eps = 1e-12;
t = 1e-6;
seed = 0;
%%
outputs_original = main_original(m, n, iter, eps, t, seed, 'results/original/');
output_size_original = size(outputs_original);
time_original = zeros(output_size_original);
gap_original = zeros(output_size_original);
iter_original = zeros(output_size_original);
for i = 1:1:output_size_original(1)
    for j = 1:1:output_size_original(2)
        time_original(i, j) = outputs_original(i, j).total_time;
        gap_original(i, j) = outputs_original(i, j).final_gap;
        iter_original(i, j) = outputs_original(i, j).iter;
    end
end
total_data_original = ([time_original, gap_original, iter_original])';
%%
outputs_entropy = main_entropy(m, n, iter, eps, seed, 'results/entropy/');
output_size_entropy = size(outputs_entropy);
time_entropy = zeros(output_size_entropy);
gap_entropy = zeros(output_size_entropy);
iter_entropy = zeros(output_size_entropy);
for i = 1:1:output_size_entropy(1)
    for j = 1:1:output_size_entropy(2)
        time_entropy(i, j) = outputs_entropy(i, j).total_time;
        gap_entropy(i, j) = outputs_entropy(i, j).final_gap;
        iter_entropy(i, j) = outputs_entropy(i, j).iter;
    end
end
total_data_entropy = ([time_entropy, gap_entropy, iter_entropy])';