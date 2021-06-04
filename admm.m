function [output] = admm(c, m, n, A, b, x, t, iter, eps)
init_time = tic;
A = sparse(A(1:1:m + n - 1, :));
b = b(1:1:m + n - 1);
c = c / max(max(c));
invAAT = (A * A')^(-1);
lambda = zeros(m * n, 1);
y = ones(m + n - 1, 1);
if eps == 0
    output.iter = iter;
    output.gap = zeros(iter, 1);
    output.time = zeros(iter, 1);
    for i = 1:1:iter
        [x, y, lambda] = admm_onestep(invAAT, c', A, b, x, lambda, t);
        primal_value = c * x;
        dual_value = b' * y;
        output.gap(i) = abs((primal_value - dual_value) / dual_value);
        output.time(i) = toc(init_time);
    end
else
    gap = zeros(iter, 1);
    time = zeros(iter, 1);
    for i = 1:1:iter
        [x, y, lambda] = admm_onestep(invAAT, c', A, b, x, lambda, t);
        primal_value = c * x;
        dual_value = b' * y;
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
output.primal_val = c * x;
output.dual_val = b' * y;
output.total_time = output.time(output.iter);
output.final_gap = output.gap(output.iter);
output.alg = "ADMM";
end