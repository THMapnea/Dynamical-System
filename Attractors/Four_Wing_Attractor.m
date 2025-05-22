clc, clear, close all;


% We want to observe the trajectory of the Four-Wing Hyperchaotic Attractor
% for specific parameter values. The system is characterised by the following
% differential equations:
%
% x˙1 = a(x2 − x1) + x2x3 (2.1)
% x˙2 = b x1 + c x2 − x1x3 + k x4 (2.2)
% x˙3 = −d x3 + x1x2 (2.3)
% x˙4 = −e x1 − f x2 (2.4)
%
% This system generates a four-wing chaotic attractor for parameters:
% a = 10, b = 28, c = −1, d = 8/3, e = 5, f = 1, k = 0.5,
% with initial conditions typically near (1, 1, 1, 1)^T.
% Four-wing attractor system parameters from the paper


a = 0.2;
b = 0.01;
c = -0.4;

% Define the four-wing attractor system equations
FourWing_System = @(t, x) [
    a*x(1) + x(2)*x(3);
    b*x(1) + c*x(2) - x(1)*x(3);
    -x(3) - x(1)*x(2)
];

% Time span for simulation
t_span = [0 500];

% Define a range of initial conditions
initial_conditions = [
    1.0, 1.0, 1.0;    % Example starting point
    0.5, 0.5, 0.5;
    -1.0, -1.0, 1.0;
    1.0, -1.0, -1.0;
    -1.0, 1.0, -1.0;
    0.1, 0.1, 0.1;
    -0.1, -0.1, 0.1
];

% Create figure window
figure('Position', [100, 100, 1200, 900]);

% Subplot 1: 3D Phase Portrait
subplot(2, 2, 1);
hold on;
grid on;
title('3D Phase Trajectories of Four-Wing Attractor');
xlabel('x_1');
ylabel('x_2');
zlabel('x_3');
view(3);

colors = lines(size(initial_conditions, 1));

for i = 1:size(initial_conditions, 1)
    [~, X] = ode45(FourWing_System, t_span, initial_conditions(i,:));
    
    plot3(X(:,1), X(:,2), X(:,3), 'Color', colors(i,:), 'LineWidth', 1.2);

end

legend(arrayfun(@(k) sprintf('IC %d', k), 1:size(initial_conditions,1), 'UniformOutput', false));
axis tight;
rotate3d on;

% Subplot 2: 2D Phase Plane (x1 vs x2)
subplot(2, 2, 2);
hold on; grid on;
title('Phase Plane: x_1 vs x_2');
xlabel('x_1');
ylabel('x_2');

for i = 1:size(initial_conditions, 1)
    [~, X] = ode45(FourWing_System, t_span, initial_conditions(i,:));
    plot(X(:,1), X(:,2), 'Color', colors(i,:), 'LineWidth', 1);
end

% Subplot 3: Vector Field on x1-x2 slice at fixed x3
subplot(2, 2, 3);
title('Vector Field in x_1 - x_2 Plane (x3 = 0)');
xlabel('x_1'); ylabel('x_2'); grid on;

[x1_grid, x2_grid] = meshgrid(-2:0.2:2, -2:0.2:2);
x3_fixed = 0;  % slice value for x3
u = a*x1_grid + x2_grid*x3_fixed;  % dx1/dt
v = b*x1_grid + c*x2_grid - x1_grid*x3_fixed;  % dx2/dt
streamslice(x1_grid, x2_grid, u, v);

% Subplot 4: Time Evolution from a Representative Initial Condition
subplot(2, 2, 4);
initial_condition = [1.0, 1.0, 1.0]; % pick one initial condition
[T, X] = ode45(FourWing_System, t_span, initial_condition);

plot(T, X(:,1), 'Color', [0.4 0.4 0.4], 'LineWidth', 1.5, 'DisplayName', 'x_1(t)');
hold on;
plot(T, X(:,2), 'Color', [0 0.5 0.5], 'LineWidth', 1.5, 'DisplayName', 'x_2(t)');
plot(T, X(:,3), 'Color', [0.8 0.2 0.2], 'LineWidth', 1.5, 'DisplayName', 'x_3(t)');

xlabel('Time (s)');
ylabel('State Variables');
title('Time Evolution of x_1, x_2, x_3');
legend('show', 'Location', 'best');
grid on;