%%
clear;
clc;
m = 500;
n = m;
iter = 100;
eps = 1e-12;
t = 1e-6;
seed = 0;
outputs_original = main_original(m, n, iter, eps, t, seed, 'results/original/');
outputs_entropy = main_entropy(m, n, iter, eps, seed, 'results/entropy/');