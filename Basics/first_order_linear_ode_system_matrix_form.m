clc, clear, close all;

%let' see how we can solve differential equation system in the matrix form 

syms x1(t) x2(t); %first we declare the symbol

%we then write the matrices of the system
A = [1, 1; 
     2, 3];

B = [1; t];

X = [x1; x2];

%define the differential equation
ode = diff(X) == A*X + B;

%we then solve the ode trough the dsolve method
[x1_sol(t), x2_sol(t)] = dsolve(ode);

%we can also simplify the result
x1_sol(t)  = simplify(x1_sol(t));
x2_sol(t) =  simplify(x2_sol(t));


%again if we want to solve for certain initial condition we must specify
%them in this case however we need to write them in matrix form
initial_condition = X(0) == [1; -2];

%then we can solve for this initial condition
[condition_x1_sol(t), condition_x2_sol(t)] = dsolve(ode, initial_condition);

%then we can show them trough fplots
figure
fplot(condition_x1_sol)
hold on
fplot(condition_x2_sol)
grid on
legend("ySol","xSol",Location="best")