function [output] = sinkhorn(c, m, n, ~, b, ~, lambda, iter, eps)
init_time = -cputime;
c = (reshape(c, [n, m]))';
c = c / max(max(c));
k = exp(-lambda * c);
mu = b(1:1:m)';
nv = b(m + 1:1:m + n)';
u = ones(1, m);
v = ones(1, n);
if eps == 0
    output.iter = iter;
    output.gap = zeros(iter + 1, 1);
    output.time = zeros(iter + 1, 1);
    output.gap(1) = 0;
    for i=1:1:iter
        [u, v] = sinkhorn_onestep(u, v, k, mu, nv, 1);
        output.gap(i + 1) = 0;
        output.time(i + 1) = cputime + init_time;
    end
else
    gap = zeros(iter + 1, 1);
    time = zeros(iter + 1, 1);
    output.gap(1) = 0;
    for i=1:1:iter
        [u, v] = sinkhorn_onestep(u, v, k, mu, nv, 1);
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
output.x = reshape((diag(u) * k * diag(v))', [m * n, 1]);
output.val = reshape(c', [1, m * n]) * output.x;
output.alg = "Sinkhorn";
end