function y = karmarkar(f, A, b, inq, minimize, k)
 
%{
Input:-   1)f : The cost vector or the (row) vector containing co-eficients
                of deceision variables in the objective function. It is a
                required parameter.
          2)A : The coefficient matrix of the left hand side of the
                constraints. it is a required parameter.
          3)b : The (row) vector containing right hand side constant of
                the constraints. It is a required parameter.
          4)inq : A (row) vector indicating the type of constraints as 1
                for >=, -1 for <= constraints.
          5)minimize : This parameter indicates whether the objective
                function is to be minimized. minimized = 1 indicates
                a mimization problem and minimization = 0 stands for a
                maximization problem. By default it is taken as 0. It is an
                optional parameter.
%}
if minimize == 0
    f = f;
else
    f = -f;
end
 
for i = 1: length(inq)
    if inq(i) == 1
        A(i, :) = -A(i, :)
        b(i) = -b(i)
    end
end
 
%dual quetion
f_dual = b;
A_dual = A';
b_dual = f;
 
%change <= to = ---add s---
mn = size(A);
m = mn(1);
n = mn(2);
A = [A, eye(m)];
 
%change dual >= to =  ----minus s----
A_dual = [A_dual, -1 *  eye(n)];
mn = size(A);
m = mn(1);
n = mn(2);
mn_dual = size(A_dual);
m_dual = mn_dual(1);
n_dual = mn_dual(2);
 
A = [A, zeros(m, n)];
A_dual = [zeros(m_dual, 2 * n - n_dual), A_dual];
%add k and s
%num_pri_dual = 2 * n;
add_k_s = [ones(1, 2 * n), 1, -k];
 
%add constraint
num_pri = size(f);
num_dual = size(f_dual);
c_1 = [f, zeros(1, n - num_pri(2)), -1* f_dual, zeros(1, n - num_dual(2)), 0, 0];
 
%add d
add_d = [ones(1, 2 * n), 1, 1];
 
%homogenized & add object variable
A = [A, zeros(m, 1), -b', -sum([A, -b'], 2); A_dual, zeros(m_dual, 1), -b_dual', -sum([A_dual, -b_dual'], 2);
    c_1, -sum(c_1); add_k_s, -sum(add_k_s); add_d, -sum(add_d)];
A(end, end) = 1;
disp('The Karmarkar standard form is:')
disp(A)
 
num_y = 2 *n + 3;
D = [1: num_y; A; ];
 
C = [zeros(num_y - 1, 1); 1];
E = ones(1, num_y);
 
  
mn =size(A);
m=mn(1);
n=mn(2);
 
 
format short e;
X1= ([E]/n)';
I=eye (n);
r=1/sqrt(n*(n-1));
alpha=(n-1)/(3*n);
X= ([E]/n)';
tol=10^(-5);
k_iteration = 0;
%while(C'*X > tol)
for i = 1:1400
    D=diag(X);
    T=A*D;
    P= [T;E];
    Q=C'*D;
    R= (I-P'/(P*P')*P)*Q';
    RN=norm (R);
    Y=X1-(r*alpha)*(R/RN);
    X=(D*Y)/(E*D*Y);
    Z=C'*X;
    k_iteration=k_iteration+1;
end
opti_x = (k+1)*X;
mn = size(f);
n = mn(2);
disp('The optimum solution is given by:')
x = opti_x(1: n, 1)
if minimize == 0
    disp(['with the maximum z = ', num2str(f*x)])
else
    disp(['with the minimum z = ', num2str(-f*x)])
end
end