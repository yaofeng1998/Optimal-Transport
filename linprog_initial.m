function [x,output] = linprog_initial(c,m,n,A,b)
%linear programming method to solve the problem
% c X_ij
% m length of X
% n depth of X
[x,output] =linprog(c,[],[],A,b,zeros(m*n,1));
end

