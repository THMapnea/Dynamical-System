clc, clear, close all;

%let's get the exponential of a matrix
%first we declare a matrix 
A = [0, 1, 0;
    -1, 0, 0;
     0, 0, 2];

%to get the eigenvalue of a matrix we call eig(matrix)
[A_eigenvector, A_eigenvalues] = eig(A);

%then we can create the diagonalizing matrix
T_D = A_eigenvector;

%then we can get the inverse of this matrix
T_D_inv = inv(T_D);

%let's check if we did everything right and compute the diagonal matrix
%A_D = T_D_inv * A * T_D; <- slow way
A_D = T_D \ A * T_D; %<- fast way by substituting T_D_inv * A with TD \ A

%now we can search for the exponentiated matrix e^At
syms t; %declare a symbol for the t parameter

%exponentiate the diagonal matrix
exp_A_Dt = diag(exp(diag(A_D) * t));

%finally get the exponentiated matrix
exp_At = T_D * exp_A_Dt / T_D;

result = simplify(exp_At);

