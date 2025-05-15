clc, clear, close all;

% We will now try to solve a non-stiff differential equation.
% The equation we will explore is the Van Der Pol equation for mu = 1.

% Declare a timespan in which we want to solve this equation
t_span = [0, 20];

% Create the initial condition (since the Van der Pol Equation is 2nd order)
initial_condition  = [2; 0];

% Define the ODE system
ode_system = @(t, y)[y(2); (1 - y(1)^2) * y(2) - y(1)];

% Use ode45 to solve it
[T, X] = ode45(ode_system, t_span, initial_condition);

% Plot the solution
plot(T, X(:,1), T, X(:,2));
title('Solution of van der Pol Equation (\mu = 1) with ODE45');
xlabel('Time t');
ylabel('Solution y');
legend('y_1','y_2');
