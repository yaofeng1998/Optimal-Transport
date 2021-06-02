function [x, b] = dot_mark_data_set(m, n, type)
if type == 1
    x = rand(m, n);
    b = [sum(x, 2); sum(x, 1)'];
    x = reshape(x', [m * n, 1]);
end
end