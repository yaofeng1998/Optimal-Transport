function [output] = admm_gpu(c, m, n, A, b, x, t, iter, eps)
init_time = tic;
A = sparse(A(1:1:m + n - 1, :));
b = gpuArray(b(1:1:m + n - 1));
c = gpuArray(c / max(max(c)));
invAAT = gpuArray((A * A')^(-1));
A = gpuArray(A);
lambda = gpuArray(zeros(m * n, 1));
y = gpuArray(ones(m + n - 1, 1));
if eps == 0
    output.iter = iter;
    output.gap = zeros(iter, 1);
    output.time = zeros(iter, 1);
    for i = 1:1:iter
        [x, y, lambda] = admm_onestep(invAAT, c', A, b, x, lambda, t);
        primal_value = gather(c * x);
        dual_value = gather(b' * y);
        output.gap(i) = abs((primal_value - dual_value) / dual_value);
        output.time(i) = toc(init_time);
    end
else
    gap = zeros(iter, 1);
    time = zeros(iter, 1);
    for i = 1:1:iter
        [x, y, lambda] = admm_onestep(invAAT, c', A, b, x, lambda, t);
        primal_value = gather(c * x);
        dual_value = gather(b' * y);
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
output.x = gather(x);
output.primal_val = gather(c * x);
output.dual_val = gather(b' * y);
output.total_time = output.time(output.iter);
output.final_gap = output.gap(output.iter);
output.alg = "ADMM-GPU";
end