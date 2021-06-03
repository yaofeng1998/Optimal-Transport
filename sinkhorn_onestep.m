function [u, v] = sinkhorn_onestep(~, v, k, mu, nv, threshold)
u = mu ./ (k * v')';
u(isinf(u)) = threshold;
u(isnan(u)) = 1 / threshold;
u(u > threshold) = threshold;
u(u < 1 / threshold) = 1 / threshold;
v = nv ./ (k' * u')';
v(isinf(v)) = threshold;
v(isnan(v)) = 1 / threshold;
v(v < 1 / threshold) = 1 / threshold;
end