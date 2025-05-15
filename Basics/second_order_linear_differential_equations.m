clc, clear, close all;

%we are going to solve second order differential equation with two initial
%condition

syms y(x); %create the symbol
Dy = diff(y); %generate the first derivative for the initial conditions

%the third parameter is the order of the derivative/partial derivative
ode = diff(y, x, 2) == cos(2 * x) - y; %write the differential equation

%set the cauchy problem for the two initial condition
initial_condition = [y(0) == 1; 
                     Dy(0) == 0]; 

%solve numerically
y_sol(x) = dsolve(ode,initial_condition);

%we can also simplify it
y_sol_simp(x) = simplify(y_sol(x));