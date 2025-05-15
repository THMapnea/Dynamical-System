clc, clear, close all;

%let's start to solve some differential equation system, let's start with a
%first order system of linear diffrential equations

syms x(t) u(t); %declare the symbols

%now we create the systemas an array of ode
ode_system = [diff(x) == 3 * x + 4 * u;
              diff(u) == -3 * u + 5 * x];

%we can now solve as we always did and get back an array of solution
%we need to be careful we will get back a struct and not a classic matrix 
sol = dsolve(ode_system);

%to access since we have a structure we can write
x_s_sol = sol.x;
u_s_sol = sol.u;

%or if we want a vector as output we can save as a vector like it follows
[x_sol(t), u_sol(t)] = dsolve(ode_system);


%same as we did for the singular linear differential equation we can write 
%the initial condition to compute the constants
initial_condition  = [x(0) == 1, u(0) == 1];

[condition_x_sol(t), condition_u_sol(t)] = dsolve(ode_system, initial_condition);


%if we want to look at the bheaviour of our solution we can use fplots
fplot(condition_x_sol)
hold on
fplot(condition_u_sol)
grid on
legend("xSol","uSol",Location="best")