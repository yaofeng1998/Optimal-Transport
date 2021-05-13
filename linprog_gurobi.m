function [x,output] = linprog_gurobi(c,m,n,A,b)
% Copyright 2019, Gurobi Optimization, LLC
model.A = sparse(A);
model.obj = c;
model.rhs = b;
model.l = zeros(m*n,1);
model.sense = '=';
%model.vtype = 'B';
model.modelsense = 'min';
% model.varnames = names;
%gurobi_write(model, 'mip1.lp');
params.outputflag = 0;
result = gurobi(model, params);
x = result.x;
output = result.objval;
end