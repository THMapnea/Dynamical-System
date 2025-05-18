clc, clear, close all;

%we want to see how we can solve linear ordinary differential equation of
%the first order
%first we can create the function we want to differentiate trough symbols
syms y(t);


%then we can call the diff function to differentiate it so we assign the
%equation to the ode variable trough the single = and to put the equal in
%the equation itself we can use the ==
ode = diff(y, t) == t * y;


%then to solve it numerically we call dsolve in this case since we havent
%specified some initial condition we will receive as a output a certain
%constant
y_sol(t) = dsolve(ode);


%if for example we specify our initial condition by assigning it's value to
%our symbol as an equation
initial_condition  = y(0) == 1;


%then we can solve the relative cauchy problem
y_cond(t) = dsolve(ode, initial_condition);