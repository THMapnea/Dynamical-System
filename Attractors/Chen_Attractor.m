clc, clear, close all;

% We want to see the trajectory of the Chen attractor for certain values of
% a, b, and c. The Chen system is characterised by the following
% differential equations:
%
% x˙1 = a(x2 − x1) (2.1)
% x˙2 = (c − a)x1 − x1x3 + c x2 (2.2)
% x˙3 = x1x2 − b x3 (2.3)
%
% This system exhibits chaotic behavior for parameters a = 35, b = 3,
% c = 28, with initial conditions near the origin (e.g., (−10, 0, 37)^T).
% We will simulate the system for different starting conditions.
% Chen system parameters

a = 35;
b = 3;
c = 28;


% Define the Chen system equations
Chen_System = @(t, x) [
    a * (x(2) - x(1));             % dx/dt
    (c - a) * x(1) - x(1) * x(3) + c * x(2);  % dy/dt
    x(1) * x(2) - b * x(3)         % dz/dt
];


% Time span
t_span = [0 1];  % Longer time span for better visualization


% Define a set of initial conditions
x0_values = linspace(-10, 10, 5);   % Sweep over x-axis initial values
y0_values = linspace(-10, 10, 5);   % Sweep over y-axis initial values
z0_fixed = 10.0;                   % Fixed initial z for simplicity


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
title('3D Phase Trajectories of Chen Attractor');
xlabel('x');
ylabel('y');
zlabel('z');
view(3);


colors = lines(size(initial_conditions, 1));

for i = 1:size(initial_conditions, 1)
    [~, X] = ode45(Chen_System, t_span, initial_conditions(i,:));
    
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
    [~, X] = ode45(Chen_System, t_span, initial_conditions(i,:));
    plot(X(:,1), X(:,2), 'Color', colors(i,:), 'LineWidth', 1);
end


% Subplot 3: Vector Field on x-y slice at fixed z
subplot(2, 2, 3);
title('Vector Field in x-y Plane (z = 10)');
xlabel('x'); ylabel('y'); grid on;


[x_grid, y_grid] = meshgrid(-20:1:20, -20:1:20);
z_fixed = 10;  % Slice at z = 10
u = a * (y_grid - x_grid);                     % dx/dt
v = (c - a) * x_grid - x_grid * z_fixed + c * y_grid;  % dy/dt
streamslice(x_grid, y_grid, u, v);


% Subplot 4: Time Evolution from a Representative Initial Condition
subplot(2, 2, 4);
initial_condition = [-10; 0; 10]; % Example initial condition
[T, X] = ode45(Chen_System, t_span, initial_condition);


plot(T, X(:,1), 'Color', [0.4 0.4 0.4], 'LineWidth', 1.5, 'DisplayName', 'x(t)');
hold on;
plot(T, X(:,2), 'Color', [0 0.5 0.5], 'LineWidth', 1.5, 'DisplayName', 'y(t)');
plot(T, X(:,3), 'Color', [0.8 0.2 0.2], 'LineWidth', 1.5, 'DisplayName', 'z(t)');


xlabel('Time (s)');
ylabel('State Variables');
title('Time Evolution of x, y, z');
legend('show', 'Location', 'best');
grid on;