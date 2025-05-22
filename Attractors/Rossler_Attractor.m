clc, clear, close all;

% We want to see the trajectory of the Rössler attractor for certain values
% of a, b, and c. The Rössler system is characterised by the following
% differential equations:
%
% x˙1 = −x2 − x3 (2.1)
% x˙2 = x1 + a x2 (2.2)
% x˙3 = b + x3(x1 − c) (2.3)
%
% This system exhibits chaotic behavior for parameters a = 0.2, b = 0.2,
% c = 5.7, with initial conditions near the origin (e.g., (0.1, 0.1, 0.1)^T).
% We will simulate the system for different starting conditions.
% Rössler system parameters


a = 0.2;
b = 0.2;
c = 5.7;


% Define the Rössler system equations
Rossler_System = @(t, x) [
    -x(2) - x(3);             % dx/dt
    x(1) + a * x(2);          % dy/dt
    b + x(3) * (x(1) - c)     % dz/dt
];


% Time span
t_span = [0 10];


% Define a set of initial conditions
x0_values = linspace(-5, 5, 5);   % Sweep over x-axis initial values
y0_values = linspace(-5, 5, 5);   % Sweep over y-axis initial values
z0_fixed = 0.0;                   % Fixed initial z for simplicity


% Store all initial conditions
initial_conditions = [];
for i = 1:length(x0_values)
    for j = 1:length(y0_values)
        initial_conditions = [initial_conditions; x0_values(i), y0_values(j), z0_fixed];
    end
end


% Create figure window
figure('Position', [100, 100, 1200, 900]);


% Subplot 1: 3D Phase Portrait
subplot(2, 2, 1);
hold on;
grid on;
title('3D Phase Trajectories of Rössler Attractor');
xlabel('x');
ylabel('y');
zlabel('z');
view(3);

colors = lines(size(initial_conditions, 1));


for i = 1:size(initial_conditions, 1)
    [~, X] = ode45(Rossler_System, t_span, initial_conditions(i,:));
    
    plot3(X(:,1), X(:,2), X(:,3), 'Color', colors(i,:), 'LineWidth', 1.2);
    
end


legend(arrayfun(@(k) sprintf('IC %d', k), 1:size(initial_conditions, 1), 'UniformOutput', false));
axis tight;
rotate3d on;


% Subplot 2: 2D Phase Plane (x vs y)
subplot(2, 2, 2);
hold on; grid on;
title('Phase Plane: x vs y');
xlabel('x');
ylabel('y');


for i = 1:size(initial_conditions, 1)
    [~, X] = ode45(Rossler_System, t_span, initial_conditions(i,:));
    plot(X(:,1), X(:,2), 'Color', colors(i,:), 'LineWidth', 1);
end


% Subplot 3: Vector Field on x-y slice at fixed z
subplot(2, 2, 3);
title('Vector Field in x-y Plane (z = 0)');
xlabel('x'); ylabel('y'); grid on;


[x_grid, y_grid] = meshgrid(-10:0.5:10, -10:0.5:10);
z_fixed = 0;  % Slice at z = 0
u = -y_grid - z_fixed;                     % dx/dt
v = x_grid + a * y_grid;                   % dy/dt
streamslice(x_grid, y_grid, u, v);


% Subplot 4: Time Evolution from a Representative Initial Condition
subplot(2, 2, 4);
initial_condition = [1; 1; 0]; % Example initial condition
[T, X] = ode45(Rossler_System, t_span, initial_condition);


plot(T, X(:,1), 'Color', [0.4 0.4 0.4], 'LineWidth', 1.5, 'DisplayName', 'x(t)');
hold on;
plot(T, X(:,2), 'Color', [0 0.5 0.5], 'LineWidth', 1.5, 'DisplayName', 'y(t)');
plot(T, X(:,3), 'Color', [0.8 0.2 0.2], 'LineWidth', 1.5, 'DisplayName', 'z(t)');


xlabel('Time (s)');
ylabel('State Variables');
title('Time Evolution of x, y, z');
legend('show', 'Location', 'best');
grid on;