function [output] = linprog_gurobi(c, m, n, A, b)
% Copyright 2019, Gurobi Optimization, LLC
time = -cputime;
c = c / max(max(c));
model.A = sparse(A);
model.obj = c;
model.rhs = b;
model.l = zeros(m * n,1);
model.sense = '=';
model.modelsense = 'min';
params.OutputFlag = 0;
%params.DisplayInterval = 1;
%params.LogToConsole = 1;
%params.IterationLimit = iter;
result = gurobi(model, params);
output.x = result.x;
output.val = result.objval;
output.iter = result.itercount;
output.time = result.runtime;
output.gap = abs((c * result.x - b * result.pi) / (b * result.pi));
output.alg = 'Gurobi';
end