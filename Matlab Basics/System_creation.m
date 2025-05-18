clc, clear, close all;

%let's see how we can declare dynamic system in matlab

%if we want to create a space state model the equivalent of the I-S-U 
%representation we can use the ss function and pass it the matrices
%the dynamic matrix, the input matrix, the output matrix and the 
%coupling matrix 

A = [1, 2;
     3, 4];

B = [2, 4;
     4*1i, 3];

C = [1, 0];

D  = [0, 0];

% we can also pass a lot of other parameter but for now this will suffice
sys1 = ss(A, B, C, D); 

%if instead we want to convert a transfer function in to a space state
%model we can use the tf function to create the transfer function and then
%we can pass it to the ss function, the argument of the tf function are the
%coefficient of the s term in the laplace domain with the first being the
%numerator and the second being the denominator 
H = [tf([1, 2, 3], [2, 4, 7, 3]);
     tf([2,9],[3, 4, 5])];

%we then convert the system trough the ss function if we also add the
%minimal parameter we take the minimum number of state to represent that
%system
sys2 = ss(H, 'minimal');

%the size gives back the number of input-output-state
size(sys2)

