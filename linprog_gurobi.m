function [output] = linprog_gurobi(c, m, n, A, b, optimizer)
% Copyright 2019, Gurobi Optimization, LLC
c = c / max(max(c));
model.A = sparse(A);
model.obj = c;
model.rhs = b;
model.l = zeros(m * n,1);
model.sense = '=';
model.modelsense = 'min';
params.OutputFlag = 0;
if strcmpi(optimizer, 'simplex')
    params.Method = 1;
else
    params.Method = 2;
end
%params.DisplayInterval = 1;
%params.LogToConsole = 1;
%params.BarIterLimit = 20000;
%params.IterationLimit = 20000;
result = gurobi(model, params);
output.x = result.x;
output.primal_val = c * result.x;
output.dual_val = b' * result.pi;
output.iter = result.itercount;
output.time = result.runtime;
output.gap = abs((c * result.x - b' * result.pi) / (b' * result.pi));
output.total_time = output.time;
output.final_gap = output.gap;
output.alg = string(['Gurobi-' optimizer]);
end