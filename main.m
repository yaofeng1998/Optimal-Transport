clear all;
close all;
clc;
m = 5;
n = 4;
c = rand(1,m*n);
[x,output] = linprog_initial(c,m,n)
%initial linear programming using matlab
setenv('PATH', [getenv('PATH') ';C:\Users\username\mosek\9.0\tools\platform\win64x86\bin']);
[x,output] = linprog_mosek(c,m,n)
%using mosek