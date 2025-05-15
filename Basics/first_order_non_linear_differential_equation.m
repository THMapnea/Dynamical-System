clc, clear, close all;

%we will now see how to solve non linear differential equation with initial
%condition
%the procedure is the same as the linear

syms y(t); %declare the symbol

ode = (diff(y,t) + y)^2 == 1; %create the ordinary differential equation

initial_condition = y(0) == 0;

y_sol(t) = dsolve(ode, initial_condition); %solve for the initial condition