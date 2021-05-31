function [output] = linprog_mosek(c, m, n, A, b)
%linear programming method to solve the problem
% c X_ij
% m length of X
% n depth of X
time = -cputime;
c = c / max(max(c));
[output.x, output.val] = linprog(c,[],[],A,b,zeros(m * n,1));
output.iter = -1;
output.time = time + cputime;
output.gap = -1;
end