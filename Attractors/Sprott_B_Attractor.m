clc, clear, close all;

% We want to see the trajectory of the Sprott B attractor for the standard
% parameter values. The Sprott B system is characterised by the following
% differential equations:
%
% x˙1 = x2*x3 (2.1)
% x˙2 = x1 − x2 (2.2)
% x˙3 = 1 − x1*x2 (2.3)
%
% This system exhibits chaotic behavior with no adjustable parameters,
% typically starting from initial conditions near (0.1, 0.1, 0.1)^T.
% Define the Sprott B system equations


SprottB_System = @(t, x) [
    x(2) * x(3);      % dx/dt = y*z
    x(1) - x(2);      % dy/dt = x - y
    1 - x(1)*x(2)     % dz/dt = 1 - x*y
];


% Time span
t_span = [0 20];


% Define a set of initial conditions (sweep over z-axis)
x0_values = linspace(-1, 1, 10);  % Sweep over x initial values
y0 = 0.5;                         % Fixed y initial value
z0 = 0.5;                         % Fixed z initial value


% Store all initial conditions
initial_conditions = [x0_values', repmat(y0, length(x0_values), 1), repmat(z0, length(x0_values), 1)];


% Create figure window
figure('Position', [100, 100, 1200, 900]);


% Subplot 1: 3D Phase Portrait
subplot(2, 2, 1);
hold on;
grid on;
title('3D Phase Trajectories (Sprott B)');
xlabel('x');
ylabel('y');
zlabel('z');
view(3);

colors = lines(length(x0_values));

for i = 1:size(initial_conditions, 1)
    [~, X] = ode45(SprottB_System, t_span, initial_conditions(i,:));
    
    plot3(X(:,1), X(:,2), X(:,3), 'Color', colors(i,:), 'LineWidth', 1.2);
end

legend(arrayfun(@(x) sprintf('x_0 = %.1f', x), x0_values, 'UniformOutput', false));
axis tight;
rotate3d on;


% Subplot 2: 2D Phase Plane (x vs y)
subplot(2, 2, 2);
hold on; grid on;
title('Phase Plane: x vs y (Sprott B)');
xlabel('x');
ylabel('y');


for i = 1:size(initial_conditions, 1)
    [~, X] = ode45(SprottB_System, t_span, initial_conditions(i,:));
    plot(X(:,1), X(:,2), 'Color', colors(i,:), 'LineWidth', 1);
end


% Subplot 3: Vector Field on x-y slice at fixed z
subplot(2, 2, 3);
title('Vector Field in x-y Plane (z = 0.5)');
xlabel('x'); ylabel('y'); grid on;


[x_grid, y_grid] = meshgrid(-2:0.2:2, -2:0.2:2);
z_fixed = 0.5;  % Slice value for z
u = y_grid * z_fixed;                     % dx/dt = y*z
v = x_grid - y_grid;                      % dy/dt = x - y
streamslice(x_grid, y_grid, u, v);


% Subplot 4: Time Evolution from a Representative Initial Condition
subplot(2, 2, 4);
initial_condition = [0.5; 0.5; 0.5]; % Example initial condition
[T, X] = ode45(SprottB_System, t_span, initial_condition);


plot(T, X(:,1), 'Color', [0.4 0.4 0.4], 'LineWidth', 1.5, 'DisplayName', 'x(t)');
hold on;
plot(T, X(:,2), 'Color', [0 0.5 0.5], 'LineWidth', 1.5, 'DisplayName', 'y(t)');
plot(T, X(:,3), 'Color', [0.8 0.2 0.2], 'LineWidth', 1.5, 'DisplayName', 'z(t)');


xlabel('Time (s)');
ylabel('State Variables');
title('Time Evolution of x, y, z (Sprott B)');
legend('show', 'Location', 'best');
grid on;