function [output] = admm_matrix(c, m, n, ~, b, x, t, iter, eps, tmin, decay, gamma)
x = reshape(x', [n, m])';
b1 = b(1:1:m);
b2 = b(m + 1:1:m + n);
c = reshape(c / max(max(c)), [n, m])';
lambda = zeros(m, n);
y1 = ones(m, 1);
y2 = ones(n, 1);
alpha = 0.5  + 1 / (4 * m) - 1 / (4 * n);
beta = 1 - alpha;
alpha = alpha / (2 * m);
beta = beta / (2 * n);
w = x / t;
if eps == 0
    output.iter = iter;
    output.gap = zeros(iter, 1);
    output.time = zeros(iter, 1);
    init_time = tic;
    for i = 1:1:iter
        c_lambda_w = c - lambda - w;
        s1 = b1 / t + sum(c_lambda_w, 2);
        s2 = b2 / t + sum(c_lambda_w, 1)';
        sum_s = 2 * sum(s1);
        y1 = (s1 - alpha * sum_s) / n;
        y2 = (s2 - beta * sum_s) / m;
        ATy_c_minus = c - y1 - y2';
        lambda = max(ATy_c_minus - w, 0);
        w = w + gamma * (lambda - ATy_c_minus);
        primal_value = t * sum(sum(c .* w));
        dual_value = b' * [y1; y2];
        output.gap(i) = abs((primal_value - dual_value) / dual_value);
        output.time(i) = toc(init_time);
        t = max(tmin, t * decay);
    end
else
    gap = zeros(iter, 1);
    time = zeros(iter, 1);
    init_time = tic;
    for i = 1:1:iter
        c_lambda_w = c - lambda - w;
        s1 = b1 / t + sum(c_lambda_w, 2);
        s2 = b2 / t + sum(c_lambda_w, 1)';
        sum_s = 2 * sum(sum(s1));
        y1 = (s1 - alpha * sum_s) / n;
        y2 = (s2 - beta * sum_s) / m;
        ATy_c_minus = c - y1 - y2';
        lambda = max(ATy_c_minus - w, 0);
        w = w + gamma * (lambda - ATy_c_minus);
        primal_value = t * sum(sum(c .* w));
        dual_value = b' * [y1; y2];
        gap(i) = abs((primal_value - dual_value) / dual_value);
        time(i) = toc(init_time);
        t = max(tmin, t * decay);
        if (gap(i) < eps)
            break;
        end
    end
end
output.x = reshape((t * w)', [n, m])';
output.primal_val = t * sum(sum(c .* w));
output.dual_val = b' * [y1; y2];
output.total_time = output.time(output.iter);
output.gap = gather(output.gap);
output.final_gap = output.gap(output.iter);
output.alg = "ADMM";
end