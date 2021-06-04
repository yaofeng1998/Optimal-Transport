function [output] = newton_entropy(c, m, n, A, b, ~, lambda, iter, eps)
init_time = tic;
threshold = 1e+40;
epsilon = 1 / lambda;
A = sparse(A(1:1:m + n - 1, :));
b = b(1:1:m + n - 1);
c = c / max(max(c));
y = zeros(m + n - 1, 1);
x = exp((A' * y - c') * lambda);
x(isinf(x)) = threshold;
x(x > threshold) = threshold;
x(x < 1 / threshold) = 1 / threshold;
if eps == 0
    output.iter = iter;
    output.gap = zeros(iter, 1);
    output.time = zeros(iter, 1);
    for i=1:1:iter
        [x, y] = newton_onestep(c, A, b, x, y, lambda, threshold);
        primal_value = c * x + sum(epsilon * x .* (log(x) - 1));
        dual_value = b' * y - epsilon * sum(x);
        output.gap(i) = abs((primal_value - dual_value) / dual_value);
        output.time(i) = toc(init_time);
    end
else
    gap = zeros(iter, 1);
    time = zeros(iter, 1);
    for i=1:1:iter
        [x, y] = newton_onestep(c, A, b, x, y, lambda, threshold);
        primal_value = c * x + sum(epsilon * x .* (log(x) - 1));
        dual_value = b' * y - epsilon * sum(x);
        gap(i) = abs((primal_value - dual_value) / dual_value);
        time(i) = toc(init_time);
        if (gap(i) < eps)
            break;
        end
    end
    output.iter = i;
    output.time = time(1:1:i, 1);
    output.gap = gap(1:1:i, 1);
end
output.x = x;
output.primal_val = c * x + sum(epsilon * x .* (log(x) - 1));
output.dual_val = b' * y - epsilon * sum(x);
output.total_time = output.time(output.iter);
output.final_gap = output.gap(output.iter);
output.alg = string(['Newton-\epsilon=' num2str(epsilon, '%.2e')]);
end