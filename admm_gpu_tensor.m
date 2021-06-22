function [output] = admm_gpu_tensor(c, b, x, t, iter, eps, tmin, decay, gamma)
problem_size = size(x);
index_positions = [0, cumsum(problem_size)];
inverse_prod_problem_size = 1 / prod(problem_size);
k = length(problem_size);
x = gpuArray(x);
b = gpuArray(b);
c = gpuArray(c);
lambda = gpuArray(zeros(size(x)));
y = gpuArray(ones(size(b)));
alpha = 1 ./ (sum(1 ./ problem_size) * problem_size);
w = x / t;
if eps == 0
    output.iter = iter;
    output.gap = gpuArray(zeros(iter, 1));
    output.time = zeros(iter, 1);
    init_time = tic;
    for i = 1:1:iter
        c_lambda_w = c - lambda - w;
        for j = 1:1:k
            sum_indexes = [1:1:(j - 1), (j + 1):1:k];
            sj = reshape(sum(c_lambda_w, sum_indexes), [problem_size(j), 1]);
            sj = sj + b(index_positions(j) + 1:1:index_positions(j + 1)) / t;
            y(index_positions(j) + 1:1:index_positions(j + 1)) = inverse_prod_problem_size * (problem_size(j) * sj - (1 - alpha(j)) * sum(sj));
        end
        ATy_c_minus = c;
        for j = 1:1:k
            shape_yj = ones(k, 1);
            shape_yj(j) = problem_size(j);
            ATy_c_minus = ATy_c_minus - reshape(y(index_positions(j) + 1:1:index_positions(j + 1)), shape_yj);
        end
        lambda = max(ATy_c_minus - w, 0);
        w = w + gamma * (lambda - ATy_c_minus);
        primal_value = t * sum(c .* w, 1:1:k);
        dual_value = b' * y;
        output.gap(i) = abs((primal_value - dual_value) / dual_value);
        output.time(i) = toc(init_time);
        t = max(tmin, t * decay);
    end
else
    gap = gpuArray(zeros(iter, 1));
    time = zeros(iter, 1);
    init_time = tic;
    for i = 1:1:iter
        c_lambda_w = c - lambda - w;
        for j = 1:1:k
            sum_indexes = [1:1:(j - 1), (j + 1):1:k];
            sj = reshape(sum(c_lambda_w, sum_indexes), [problem_size(j), 1]);
            sj = sj + b(index_positions(j) + 1:1:index_positions(j + 1)) / t;
            y(index_positions(j) + 1:1:index_positions(j + 1)) = inverse_prod_problem_size * (problem_size(j) * sj - (1 - alpha(j)) * sum(sj));
        end
        ATy_c_minus = c;
        for j = 1:1:k
            shape_yj = ones(k, 1);
            shape_yj(j) = problem_size(j);
            ATy_c_minus = ATy_c_minus - reshape(y(index_positions(j) + 1:1:index_positions(j + 1)), shape_yj);
        end
        lambda = max(ATy_c_minus - w, 0);
        w = w + gamma * (lambda - ATy_c_minus);
        primal_value = t * sum(c .* w, 1:1:k);
        dual_value = b' * y;
        gap(i) = abs((primal_value - dual_value) / dual_value);
        time(i) = toc(init_time);
        t = max(tmin, t * decay);
        if (gap(i) < eps)
            break;
        end
    end
    output.iter = i;
    output.time = time(1:1:i, 1);
    output.gap = gap(1:1:i, 1);
end
output.x = gather(t * w);
output.primal_val = gather(t * sum(c .* w, 1:1:k));
output.dual_val = gather(b' * y);
output.total_time = output.time(output.iter);
output.gap = gather(output.gap);
output.final_gap = output.gap(output.iter);
output.alg = "ADMM-GPU";
end