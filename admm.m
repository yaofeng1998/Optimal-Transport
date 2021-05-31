function [output] = admm(c, m, n, A, b, x, t, iter, eps)
init_time = -cputime;
A = A(1:1:m + n - 1, :);
b = b(1:1:m + n - 1);
c = c / max(max(c));
invAAT = (A * A')^(-1);
lambda = zeros(m * n, 1);
if eps == 0
    output.iter = iter;
    output.gap = zeros(iter, 1);
    output.time = zeros(iter, 1);
    for i=1:1:iter
        [x, y, lambda] = admm_onestep(invAAT, c', A, b', x, lambda, t);
        output.gap(i) = (c * x - b * y) / (b * y);
        output.time(i) = cputime + init_time;
    end
else
    gap = zeros(iter, 1);
    time = zeros(iter, 1);
    for i=1:1:iter
        [x, y, lambda] = admm_onestep(invAAT, c', A, b', x, lambda, t);
        gap(i) = abs((c * x - b * y) / (b * y));
        time(i) = cputime + init_time;
        if (gap(i) < eps)
            break;
        end
    end
    output.iter = i;
    output.time = time(1:1:i, 1);
    output.gap = gap(1:1:i, 1);
end
output.x = x;
output.val = c * x;
end