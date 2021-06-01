function [x] = sinkhorn_onestep(x, mu, nv, threshold)
row_factor = mu ./ (sum(x, 2)');
row_factor(isinf(row_factor)) = threshold;
row_factor(row_factor > threshold) = threshold;
row_factor(isnan(row_factor)) = 0;
x = x * diag(row_factor);
col_factor = nv ./ sum(x, 1);
col_factor(isinf(col_factor)) = threshold;
col_factor(col_factor > threshold) = threshold;
col_factor(isnan(col_factor)) = 0;
x = diag(col_factor) * x;
end