function [c, b] = caffarelli_data_set(n)
p = zeros(n, 2);
q = zeros(n, 2);
size_p = 0;
size_q = 0;
while size_p < n
   point = rand(1, 2);
   if norm(point) <=1
       size_p = size_p + 1;
       p(size_p, :) = point;
   end
end
while size_q < n
   point = rand(1, 2);
   if norm(point) <=1
       size_q = size_q + 1;
       q(size_q, :) = point;
       q(size_q, 1) = q(size_q, 1) + 2 * sign(point(1));
   end
end
c = zeros(n, n);
for i = 1:1:n
    for j = 1:1:n
        c(i, j) = norm(p(i) - q(j));
    end
end
c = c / max(max(c));
c = reshape(c', [1, n * n]);
b = ones(2 * n, 1);
end