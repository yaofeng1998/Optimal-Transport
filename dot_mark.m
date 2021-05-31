function [x, b] = dot_mark(m, n, type)
if type == 1
    x = rand(m, n);
    b = [sum(x, 1), sum(x, 2)'];
    x = reshape(x, [m * n, 1]);
end
end