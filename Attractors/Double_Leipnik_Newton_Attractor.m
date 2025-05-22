clc, clear, close all;

%we want to see the trajectory of the double Lepkin-Newton attractor for a
%certain values of alpha, beta Newton Leipnik system is characterised by the following differential equations.
% x˙1 = −αx1 + x2 + 10x2x3 (2.1)
% x˙2 = −x1 − 0.4x2 + 5x1x3 (2.2)
% x˙3 = βx3 − 5x1x2 (2.3)
% This system has two strange attractors originating from the initial
% states (0.349, 0.0, −0.160)T,(0.349, 0.0, −0.180)T and system parameters
%α = 0.4, β = 0.175. we will simulate for different starting condition


% System parameters
alpha = 0.4;
beta = 0.175;


% Define the Newton-Leipnik system equations
NL_System = @(t, x) [
    -alpha*x(1) + x(2) + 10*x(2)*x(3);
    -x(1) - 0.4*x(2) + 5*x(1)*x(3);
    beta*x(3) - 5*x(1)*x(2)
];


% Time span
t_span = [0 200];


% Define a set of initial conditions:
x1_0 = 0.349;
x2_0 = 0.0;
x3_values = linspace(-0.22, -0.14, 10);  % Sweep over z-axis initial values


% Store all initial conditions
initial_conditions = [repmat(x1_0, length(x3_values), 1), ...
                      repmat(x2_0, length(x3_values), 1), ...
                      x3_values'];


% Create figure window
figure('Position', [100, 100, 1200, 900]);


%Subplot 1: 3D Phase Portrait ===
subplot(2, 2, 1);
hold on;
grid on;
title('3D Phase Trajectories');
xlabel('x_1 = v_C');
ylabel('x_2 = i_C');
zlabel('x_3');
view(3);

colors = lines(length(x3_values));


for i = 1:size(initial_conditions, 1)
    [~, X] = ode45(NL_System, t_span, initial_conditions(i,:));
    

    plot3(X(:,1), X(:,2), X(:,3), 'Color', colors(i,:), 'LineWidth', 1.2);
    scatter3(initial_conditions(i,1), initial_conditions(i,2), initial_conditions(i,3), ...
        50, 'filled', 'MarkerFaceColor', colors(i,:), 'MarkerEdgeColor', 'k');
end


legend(arrayfun(@(z) sprintf('x_3 = %.3f', z), x3_values, 'UniformOutput', false));
axis tight;
rotate3d on;


%Subplot 2: 2D Phase Plane (x1 vs x2) for multiple initial conditions ===
subplot(2, 2, 2);
hold on; grid on;
title('Phase Plane: x_1 vs x_2');
xlabel('x_1 (Voltage)');
ylabel('x_2 (Current)');


for i = 1:size(initial_conditions, 1)
    [~, X] = ode45(NL_System, t_span, initial_conditions(i,:));
    plot(X(:,1), X(:,2), 'Color', colors(i,:), 'LineWidth', 1);
end


%Subplot 3: Vector Field on x1-x2 slice at fixed x3 ===
subplot(2, 2, 3);
title('Vector Field in x_1 - x_2 Plane');
xlabel('x_1'); ylabel('x_2'); grid on;


[x1_grid, x2_grid] = meshgrid(-3:0.5:3, -3:0.5:3);
x3_fixed = -0.17;  % slice value for x3
u = x2_grid;
v = (-x1_grid - 0.4*x2_grid + 5*x1_grid*x3_fixed);  % dx2/dt
streamslice(x1_grid, x2_grid, u, v);


%Subplot 4: Time Evolution from a Representative Initial Condition ===
subplot(2, 2, 4);
initial_condition = [0.349; 0; -0.17]; % pick one near attractor
[T, X] = ode45(NL_System, t_span, initial_condition);


plot(T, X(:,1), 'Color', [0.4 0.4 0.4], 'LineWidth', 1.5, 'DisplayName', 'x_1(t)');
hold on;
plot(T, X(:,2), 'Color', [0 0.5 0.5], 'LineWidth', 1.5, 'DisplayName', 'x_2(t)');
plot(T, X(:,3), 'Color', [0.8 0.2 0.2], 'LineWidth', 1.5, 'DisplayName', 'x_3(t)');


xlabel('Time (s)');
ylabel('State Variables');
title('Time Evolution of x_1, x_2, x_3');
legend('show', 'Location', 'best');
grid on;