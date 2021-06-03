function [output] = linprog_mosek(c, m, n, A, b, optimizer)
%linear programming method to solve the problem
% c X_ij
% m length of X
% n depth of X
c = c / max(max(c));
prob.c = c;
prob.a = A;
% Specify lower bounds of the constraints.
prob.blc = b;
% Specify  upper bounds of the constraints.
prob.buc = b;
% Specify lower bounds of the variables.
prob.blx = zeros(m * n,1);
% Specify upper bounds of the variables.
prob.bux = inf * ones(m * n,1);
param.MSK_IPAR_LOG = 0;
if strcmpi(optimizer, 'simplex')
    param.MSK_IPAR_OPTIMIZER = 'MSK_OPTIMIZER_PRIMAL_SIMPLEX';
    [~, res] = mosekopt('minimize info', prob, param); 
    output.x = res.sol.bas.xx;
    output.val = res.sol.bas.pobjval;
    output.iter = res.info.MSK_IINF_SIM_PRIMAL_ITER;
    output.time = res.info.MSK_DINF_OPTIMIZER_TIME;
    output.gap = abs((res.sol.bas.pobjval - res.sol.bas.dobjval) / res.sol.bas.dobjval);
else
    param.MSK_IPAR_OPTIMIZER = 'MSK_OPTIMIZER_INTPNT';
    [~, res] = mosekopt('minimize info', prob, param); 
    output.x = res.sol.itr.xx;
    output.val = res.sol.itr.pobjval;
    output.iter = res.info.MSK_IINF_INTPNT_ITER;
    output.time = res.info.MSK_DINF_OPTIMIZER_TIME;
    output.gap = abs((res.sol.itr.pobjval - res.sol.itr.dobjval) / res.sol.itr.dobjval);
end
% Perform the optimization.
output.alg = string(['Mosek-' optimizer]);
end