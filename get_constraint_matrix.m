function [A] = get_constraint_matrix(m, n)
A = zeros(m + n,m * n);
for i=1:m
    A(i, ((i - 1) * n + 1):i * n) = 1;
end
for i=1:n
    A(m + i, i:n:end) = 1;
end
end