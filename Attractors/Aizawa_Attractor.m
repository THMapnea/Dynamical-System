clc, clear, close all;

% We investigate the trajectory of the Aizawa attractor, a chaotic system
% characterized by elegant spiral chaos. The Aizawa equations are defined as:
%
% x˙1 = (x3 - b)x1 - d x2 (2.1)
% x˙2 = d x1 + (x3 - b)x2 (2.2)
% x˙3 = c + a x3 - (x3^3)/3 - x1^2 (2.3)
% - e x2^2(1 + f x3) + g x3 x1^3
%
% Standard chaotic parameters:
% a = 0.95, b = 0.7, c = 0.6, d = 3.5, e = 0.25, f = 0.1, g = 0.1
% Initial conditions: (0.1, 0.0, 0.0)^T
% Aizawa attractor parameters


a = 0.95;
b = 0.7;
c = 0.6;
d = 3.5;
e = 0.25;
f = 0.1;


% Define the Aizawa system equations
Aizawa_System = @(t, x) [
    (x(3) - b)*x(1) - d*x(2);
    d*x(1) + (x(3) - b)*x(2);
    c + a*x(3) - (x(3)^3)/3 - (x(1)^2 + x(2)^2)*(1 + e*x(3)) + f*x(3)*x(1)^3
];


% Time span
t_span = [0 50];


% Initial conditions (sweep along z-axis)
x0 = 0.1;
y0 = 0.0;
z_values = linspace(-0.5, 0.5, 10);  % Range of z initial conditions


% Store all initial conditions
initial_conditions = [repmat(x0, length(z_values), 1), ...
                     repmat(y0, length(z_values), 1), ...
                     z_values'];


% Create figure
figure('Position', [100, 100, 1200, 900]);


%Subplot 1: 3D Phase Portrait
subplot(2, 2, 1);
hold on;
grid on;
title('3D Phase Trajectories of Aizawa Attractor');
xlabel('x');
ylabel('y');
zlabel('z');
view(3);

colors = lines(length(z_values));

for i = 1:size(initial_conditions, 1)
    [~, X] = ode45(Aizawa_System, t_span, initial_conditions(i, :));
    plot3(X(:,1), X(:,2), X(:,3), 'Color', colors(i,:), 'LineWidth', 1.2);
end


legend(arrayfun(@(z) sprintf('z_0 = %.2f', z), z_values, 'UniformOutput', false));
axis tight;
rotate3d on;


%Subplot 2: 2D Phase Plane (x vs y)
subplot(2, 2, 2);
hold on; grid on;
title('Phase Plane: x vs y');
xlabel('x');
ylabel('y');


for i = 1:size(initial_conditions, 1)
    [~, X] = ode45(Aizawa_System, t_span, initial_conditions(i, :));
    plot(X(:,1), X(:,2), 'Color', colors(i,:), 'LineWidth', 1);
end


%Subplot 3: Vector Field (x-y plane at fixed z) 
subplot(2, 2, 3);
hold on; grid on;
title('Vector Field in x-y Plane (z = 0)');
xlabel('x');
ylabel('y');


% Create grid for vector field
[x_grid, y_grid] = meshgrid(linspace(-2, 2, 20), linspace(-2, 2, 20));
z_fixed = 0;


% Compute derivatives (dx/dt and dy/dt)
u = (z_fixed - b)*x_grid - d*y_grid;
v = d*x_grid + (z_fixed - b)*y_grid;


% Normalize vectors for better visualization
magnitude = sqrt(u.^2 + v.^2);
u = u ./ (magnitude + 1e-5);  % Avoid division by zero
v = v ./ (magnitude + 1e-5);

quiver(x_grid, y_grid, u, v, 'Color', [0.5 0.5 0.5]);


%Subplot 4: Time Evolution
subplot(2, 2, 4);
initial_condition = [0.1; 0; 0];  % Representative initial condition
[T, X] = ode45(Aizawa_System, t_span, initial_condition);


plot(T, X(:,1), 'Color', [0.4 0.4 0.4], 'LineWidth', 1.5, 'DisplayName', 'x(t)');
hold on;
plot(T, X(:,2), 'Color', [0 0.5 0.5], 'LineWidth', 1.5, 'DisplayName', 'y(t)');
plot(T, X(:,3), 'Color', [0.8 0.2 0.2], 'LineWidth', 1.5, 'DisplayName', 'z(t)');


xlabel('Time');
ylabel('State Variables');
title('Time Evolution of x, y, z');
legend('show', 'Location', 'best');
grid on;