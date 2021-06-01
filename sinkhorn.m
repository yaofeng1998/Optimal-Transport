function [output] = sinkhorn(c, m, n, ~, b, ~, lambda, iter, eps)
init_time = -cputime;
c = reshape(c, [m, n]);
c = c / max(max(c));
x = exp(-lambda * c);
x = x / sum(sum(x));
mu = b(1:1:m);
nv = b(m + 1:1:m + n);
if eps == 0
    output.iter = iter;
    output.gap = zeros(iter + 1, 1);
    output.time = zeros(iter + 1, 1);
    output.gap(1) = 0;
    for i=1:1:iter
        x = sinkhorn_onestep(x, mu, nv, 1);
        output.gap(i + 1) = 0;
        output.time(i + 1) = cputime + init_time;
    end
else
    gap = zeros(iter + 1, 1);
    time = zeros(iter + 1, 1);
    output.gap(1) = 0;
    for i=1:1:iter
        x = sinkhorn_onestep(x, mu, nv, 1);
        gap(i + 1) = 0;
        time(i + 1) = cputime + init_time;
        if (gap(i + 1) < eps)
            break;
        end
    end
    output.iter = i;
    output.time = time(1:1:(i + 1), 1);
    output.gap = gap(1:1:(i + 1), 1);
end
output.x = reshape(x, [m * n, 1]);
output.val = sum(sum(c .* x));
output.alg = 'Sinkhorn';
end