function [output] = admm(c, m, n, A, b, x, t, iter, eps)
init_time = -cputime;
A = sparse(A(1:1:m + n - 1, :));
b = b(1:1:m + n - 1);
c = c / max(max(c));
invAAT = (A * A')^(-1);
lambda = zeros(m * n, 1);
y = ones(m + n - 1, 1);
if eps == 0
    output.iter = iter;
    output.gap = zeros(iter + 1, 1);
    output.time = zeros(iter + 1, 1);
    output.gap(1) = abs((c * x - b' * y) / (b' * y));
    for i=1:1:iter
        [x, y, lambda] = admm_onestep(invAAT, c', A, b, x, lambda, t);
        output.gap(i + 1) = abs((c * x - b' * y) / (b' * y));
        output.time(i + 1) = cputime + init_time;
    end
else
    gap = zeros(iter + 1, 1);
    time = zeros(iter + 1, 1);
    output.gap(1) = abs((c * x - b' * y) / (b' * y));
    for i=1:1:iter
        [x, y, lambda] = admm_onestep(invAAT, c', A, b, x, lambda, t);
        gap(i + 1) = abs((c * x - b' * y) / (b' * y));
        time(i + 1) = cputime + init_time;
        if (gap(i + 1) < eps)
            break;
        end
    end
    output.iter = i;
    output.time = time(1:1:(i + 1), 1);
    output.gap = gap(1:1:(i + 1), 1);
end
output.x = x;
output.val = c * x;
output.alg = "ADMM";
end