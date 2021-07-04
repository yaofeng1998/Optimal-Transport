function [A] = get_constraint_matrix_tensor(problem_size)
A = sparse(sum(problem_size),prod(problem_size));
k = length(problem_size);
index_positions = [0, cumsum(problem_size)];
% cumprod_problem_size = [1, cumprod(problem_size)];
flip_cumprod_problem_size = [1, cumprod(fliplr(problem_size))];
for i = 1:1:k
    block_size = flip_cumprod_problem_size(k + 1 - i);
    block_interval = flip_cumprod_problem_size(k + 2 - i);
    for j = 1:1:problem_size(i)
        offset = (j - 1) * block_size;
        for q = 1:1:block_size
            A(index_positions(i) + j, (offset + q):block_interval:end) = 1;
        end
    end
end
end