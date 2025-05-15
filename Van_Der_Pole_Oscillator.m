clc, clear, close all;  % Clear command window, workspace, and close all figures

% The circuit we're analyzing is a modified Van Der Pol oscillator system:
% 
%     _________________________
%    |       |       |         |
%    |       |       |         |
%    |       |       |         |
%    |       (      (|)      _____ 
%   (-)       )      |       _____
%    |       (       |         |
%    |       |       |         | 
%    |       |     |_\/_|      |
%    |_______|_______|_________|
%
% Where:
% x1(t) = VC(t) (capacitor voltage)
% x2(t) = iC(t) (circuit current)
% The system equations are:
% d/dt x1(t) = x2(t)
% d/dt x2(t) = (1/c)(alpha - 3*beta*x1(t)^2)*x2(t) - (1/L)*x1(t)

% System parameters
alpha = 1;      % Nonlinear damping coefficient
beta = 1/3;     % Nonlinearity parameter (set to 1/3 to simplify)
C = 1;          % Capacitance (Farads)
L = 1;          % Inductance (Henries)

% Define the system of differential equations
% Input: t - time, x - state vector [x1; x2]
% Output: dxdt - derivative of state vector
vdp = @(t,x) [x(2);                           % First equation: dx1/dt = x2
             (1/C)*(alpha - 3*beta*x(1)^2)*x(2) - (1/L)*x(1)]; % Second equation

% Time span for simulation (from 0 to 20 seconds)
t_span = [0 30];

% Initial condition ranges for x1 and x2
x1_0_vals = -3:1:3;  % Initial voltage values from -3 to 3 in steps of 1
x2_0_vals = -3:1:3;  % Initial current values from -3 to 3 in steps of 1

% Create a figure window (positioned at [100,100] with size 1400x600 pixels)
figure("Position", [100,100, 1000,800]);
hold on;  % Allow multiple plots on the same axes

% Configure plot appearance
title("Van Der Pol Oscillator Trajectories");
xlabel("x_1(t) = v_C(t) (Voltage)");
ylabel("x_2(t) = i_C(t) (Current)");
grid on;

% Loop through all initial conditions and plot trajectories
for x1_0 = x1_0_vals
    for x2_0 = x2_0_vals
        % Solve the ODE for this initial condition using ode45
        [~, X] = ode45(vdp, t_span, [x1_0, x2_0]);
        
        % Plot the phase portrait (x1 vs x2) in the first subplot
        subplot(2, 2, 1);
        hold on;
        plot(X(:,1), X(:,2));  % Plot trajectory in phase space
        title("Phase Portrait with Initial Condition Grid");
        xlabel("x_1(t) = v_C(t)");
        ylabel("x_2(t) = i_C(t)");
        grid on;
    end
end

% Create a second subplot for the vector field
subplot(2, 2, 2);
title("Phase Space Vector Field");

% Create a grid for the vector field (same dimensions as initial conditions)
[x1_grid, x2_grid] = meshgrid(-3:0.5:3, -3:0.5:3);  % Finer grid for smoother arrows

% Calculate derivatives at each grid point
u = x2_grid;  % dx1/dt = x2 (current)
v = (1/C)*(alpha - 3*beta*x1_grid.^2).*x2_grid - (1/L)*x1_grid;  % dx2/dt

% Plot the vector field using streamslice (shows both direction and magnitude)
streamslice(x1_grid, x2_grid, u, v);
xlabel("x_1(t) = v_C(t)");
ylabel("x_2(t) = i_C(t)");
grid on;

% Time evolution of state variables from x1(0) = 0.01, x2(0) = 0
initial_condition = [0.01; 0]; % [x1(0); x2(0)]
[T, X] = ode45(vdp, t_span, initial_condition);

% Create a new figure for the time evolution
subplot(2,2,3);
hold on;

% Plot x1(t) vs time
plot(T, X(:,1), "color", [0.4 0.4 0.4], "LineWidth", 1.5, "DisplayName", "x_1(t) = v_C(t)");

% Plot x2(t) vs time
plot(T, X(:,2), "color", [0 0.5 0.5], "LineWidth", 1.5, "DisplayName", "x_2(t) (Current)");

% Configure plot appearance
title("Time Evolution of State Variables");
xlabel("Time (s)");
ylabel("State Variables");
legend("show", "Orientation","vertical","Location","southwest");
legend("boxoff");
grid on;
hold off;
