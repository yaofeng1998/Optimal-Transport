function [output] = linprog_mosek_tensor(c, size, A, b, optimizer)
%linear programming method to solve the problem
% c X_ij
% m length of X
% n depth of X
% c = c / max(max(c));
prob.c = c;
prob.a = A;
% Specify lower bounds of the constraints.
prob.blc = b;
% Specify  upper bounds of the constraints.
prob.buc = b;
% Specify lower bounds of the variables.
prob.blx = zeros(size, 1);
% Specify upper bounds of the variables.
prob.bux = inf * ones(size, 1);
param.MSK_IPAR_LOG = 0;
if strcmpi(optimizer, 'simplex')
    param.MSK_IPAR_OPTIMIZER = 'MSK_OPTIMIZER_PRIMAL_SIMPLEX';
    [~, res] = mosekopt('minimize info', prob, param); 
    output.x = res.sol.bas.xx;
    output.primal_val = res.sol.bas.pobjval;
    output.dual_val = res.sol.bas.dobjval;
    output.iter = res.info.MSK_IINF_SIM_PRIMAL_ITER;
    output.time = res.info.MSK_DINF_OPTIMIZER_TIME;
    output.gap = abs((res.sol.bas.pobjval - res.sol.bas.dobjval) / res.sol.bas.dobjval);
else
    param.MSK_IPAR_OPTIMIZER = 'MSK_OPTIMIZER_INTPNT';
    [~, res] = mosekopt('minimize info', prob, param); 
    output.x = res.sol.itr.xx;
    output.primal_val = res.sol.itr.pobjval;
    output.dual_val = res.sol.itr.dobjval;
    output.iter = res.info.MSK_IINF_INTPNT_ITER;
    output.time = res.info.MSK_DINF_OPTIMIZER_TIME;
    output.gap = abs((res.sol.itr.pobjval - res.sol.itr.dobjval) / res.sol.itr.dobjval);
end
output.total_time = output.time;
output.final_gap = output.gap;
output.alg = string(['Mosek-' optimizer]);
end