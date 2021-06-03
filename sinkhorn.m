function [output] = sinkhorn(c, m, n, ~, b, ~, lambda, iter, eps)
init_time = tic;
threshold = 1e+40;
epsilon = 1 / lambda;
c = (reshape(c, [n, m]))';
c = c / max(max(c));
k = exp(-lambda * c);
k(k < 1 / threshold) = 1 / threshold;
mu = b(1:1:m)';
nv = b(m + 1:1:m + n)';
u = ones(1, m);
v = ones(1, n);
if eps == 0
    output.iter = iter;
    output.gap = zeros(iter, 1);
    output.time = zeros(iter, 1);
    for i=1:1:iter
        [u, v] = sinkhorn_onestep(u, v, k, mu, nv, threshold);
        f = log(u) * epsilon;
        g = log(v) * epsilon;
        x = diag(u) * k * diag(v);
        primal_value = sum(sum(c .* x + epsilon * x .* (log(x) - 1)));
        dual_value = f * mu' + g * nv' - epsilon * sum(sum(x));
        output.gap(i) = abs((primal_value - dual_value) / dual_value);
        output.time(i) = toc(init_time);
    end
else
    gap = zeros(iter, 1);
    time = zeros(iter, 1);
    for i=1:1:iter
        [u, v] = sinkhorn_onestep(u, v, k, mu, nv, threshold);
        f = log(u) * epsilon;
        g = log(v) * epsilon;
        x = diag(u) * k * diag(v);
        primal_value = sum(sum(c .* x + epsilon * x .* (log(x) - 1)));
        dual_value = f * mu' + g * nv' - epsilon * sum(sum(x));
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
output.x = reshape((diag(u) * k * diag(v))', [m * n, 1]);
output.val = reshape(c', [1, m * n]) * output.x;
output.alg = string(['Sinkhorn-\epsilon=' num2str(epsilon, '%.2e')]);
end