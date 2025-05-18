clc, clear, close all;

%let's see how we can perform convolution in matlab, the convolution
%operation can be used to perform polynomial moltiplication so given two 
%vector we can multiply them and obtain a vector that stores the value of
%the coefficient of the product of the polynom for example we want to 
%perform (x^3 + x + 1)(x^2 + 2)

%declare the first vector
u = [1, 0, 1, 1];

%declare the second vector
v  = [1, 0, 2];


%we can now call the convolution the length of the returned vector is given
%by the sum of the length of the original vectors - 1
conv(u, v)
