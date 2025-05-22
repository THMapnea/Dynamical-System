clc, clear, close all;

%we want to see the trajectory of the Lorentz Attractor for a
%the system is characterised by the following differential equations.
%dx/dt = σ(y - x)       (3.1)
% dy/dt = x(ρ - z) - y   (3.2)
% dz/dt = xy - βz        (3.3)
% This system has two strange attractors originating from the initial
% The system exhibits the "butterfly effect" with parameters:
% σ = 10 (Prandtl number), ρ = 28 (Rayleigh number), β = 8/3 (aspect ratio)


% Lorenz system parameters
sigma = 10;
rho = 28;
beta = 8/3;


% Define the Lorenz system as a function handle
Lorenz_System = @(t, x) [
    sigma*(x(2) - x(1));
    x(1)*(rho - x(3)) - x(2);
    x(1)*x(2) - beta*x(3)
];


% Time span for simulation
t_span = [0 10];


% Only 4 distinct, well-spaced initial conditions
initial_conditions = [
    -10, -10, 20;
     10,  10, 25;
    -10,  10, 30;
     10, -10, 35
];


% Precompute solutions
solutions = cell(size(initial_conditions,1), 1);
for i = 1:size(initial_conditions,1)
    [~, X] = ode45(Lorenz_System, t_span, initial_conditions(i,:));
    solutions{i} = X;
end


% Prepare color map
colors = lines(length(solutions));


% Create figure window
figure('Position', [100, 100, 1200, 900]);


%Phase Portrait
subplot(2, 2, 1);
hold on; grid on;
title('3D Phase Trajectories of Lorenz Attractor');
xlabel('x'); ylabel('y'); zlabel('z');
view(3);


for i = 1:length(solutions)
    X = solutions{i};
    plot3(X(:,1), X(:,2), X(:,3), 'Color', colors(i,:), 'LineWidth', 1.5);
    plot3(X(1,1), X(1,2), X(1,3), 'o', 'Color', colors(i,:), ...
        'MarkerSize', 6, 'MarkerFaceColor', colors(i,:)); % Start marker
end
axis tight;
rotate3d on;


%2D Phase Plane (x vs y)
subplot(2, 2, 2);
hold on; grid on;
title('Phase Plane: x vs y');
xlabel('x'); ylabel('y');


for i = 1:length(solutions)
    X = solutions{i};
    plot(X(:,1), X(:,2), 'Color', colors(i,:), 'LineWidth', 1.2);
end


%Vector Field in x-y at z = 25
subplot(2, 2, 3);
title('Vector Field in x-y Plane at z = 25');
xlabel('x'); ylabel('y'); grid on;


[x_grid, y_grid] = meshgrid(-20:2:20, -25:2:25);
z_fixed = 25;


% Vector field components
u = sigma * (y_grid - x_grid);                      % dx/dt
v = x_grid .* (rho - z_fixed) - y_grid;             % dy/dt


streamslice(x_grid, y_grid, u, v);
xlim([-20 20]);
ylim([-25 25]);

%Time Evolution from One Initial Condition
subplot(2, 2, 4);
title('Time Evolution of x, y, z');
xlabel('Time'); ylabel('State Variables'); grid on;

% Choose a representative trajectory
initial_condition = [1; 1; 20];
[T, X] = ode45(Lorenz_System, [0 20], initial_condition);

plot(T, X(:,1), 'Color', [0.4 0.4 0.4], 'LineWidth', 1.5, 'DisplayName', 'x(t)');
hold on;
plot(T, X(:,2), 'Color', [0 0.5 0.5], 'LineWidth', 1.5, 'DisplayName', 'y(t)');
plot(T, X(:,3), 'Color', [0.8 0.2 0.2], 'LineWidth', 1.5, 'DisplayName', 'z(t)');
legend('show', 'Location', 'best');
