clc, clear, close all;

%we want to solve a differential equation of the third order in respect to
%it's initial condition

syms y(t); %create the symbol
Dy = diff(y,t); %create the first derivative
D2y = diff(y,t,2); %create the second derivative

%write the ode
ode = diff(y,t,3) == y;

%create the three initial condition
initial_condition = [y(0) == 1;
                     Dy(0) == -1;
                     D2y(0) == pi];

%now we can solve
y_sol(t) = dsolve(ode, initial_condition);
