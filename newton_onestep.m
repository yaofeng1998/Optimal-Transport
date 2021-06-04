function [x, y] = newton_onestep(c, A, b, x, y, lambda, threshold)
jacobi = -lambda * A * diag(sparse(x)) * A';
residual = b - A * x;
direction = (residual \ jacobi)';
t = 1;
for i=1:1:100
    y_temp = y - t * direction;
    x_temp = exp((A' * y_temp - c') * lambda);
    x_temp(isinf(x_temp)) = threshold;
    x_temp(x_temp > threshold) = threshold;
    x_temp(x_temp < 1 / threshold) = 1 / threshold;
    if norm(b - A * x_temp) < norm(residual)
        break;
    else
        t = t / 2;
    end
end
x = x_temp;
y = y_temp;
end