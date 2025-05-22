clc, clear, close all;

% We want to see the trajectory of the Duffing oscillator for certain values of
% alpha, beta, delta, and gamma. The forced Duffing system is characterised by
% the following differential equations:
%
% x˙1 = x2 (2.1)
% x˙2 = -delta*x2 - alpha*x1 - beta*x1^3 + gamma*cos(omega*t) (2.2)
%
% This system exhibits chaotic behavior for parameters alpha = -1, beta = 1,
% delta = 0.3, gamma = 0.5, omega = 1.4, with initial conditions (0.1, 0.1)^T.
% Duffing system parameters


delta = 0.3;   % damping coefficient
alpha = -1.0;  % linear stiffness
beta = 1.0;    % nonlinear stiffness coefficient
gamma = 0.5;   % forcing amplitude
omega = 1.2;   % forcing frequency


% Define the Duffing system equations
Duffing_System = @(t, x) [
    x(2);
    -delta*x(2) - alpha*x(1) - beta*x(1)^3 + gamma*cos(omega*t);
];


% Time span (long enough to see chaotic behavior)
t_span = [0 10];


% Define a set of initial conditions (focusing on the chaotic regime)
x1_values = linspace(-1, 1, 8);
x2_values = linspace(-1, 1, 8);


% Store all initial conditions
initial_conditions = [];
for i = 1:length(x1_values)
    for j = 1:length(x2_values)
        initial_conditions = [initial_conditions; x1_values(i), x2_values(j)];
    end
end


% Create figure window
figure('Position', [100, 100, 1200, 900]);


% Subplot 1: 3D Phase Portrait (using time-delay embedding for 3D view)
subplot(2, 2, 1);
hold on;
grid on;
title('3D Phase Trajectories (Time-Delay Embedded)');
xlabel('x(t)');
ylabel('dx/dt');
zlabel('x(t+\tau)');
view(3);


colors = lines(size(initial_conditions, 1));


for i = 1:size(initial_conditions, 1)
    [~, X] = ode45(Duffing_System, t_span, initial_conditions(i,:));
    
    % Create time-delay embedding for 3D plot
    tau = 5; % time delay
    n = length(X(:,1));
    x = X(1:n-tau,1);
    y = X(1:n-tau,2);
    z = X(1+tau:n,1);
    
    plot3(x, y, z, 'Color', colors(i,:), 'LineWidth', 1);
end


axis tight;
rotate3d on;


% Subplot 2: 2D Phase Plane (x vs dx/dt)
subplot(2, 2, 2);
hold on; grid on;
title('Phase Plane: x vs dx/dt');
xlabel('x (Displacement)');
ylabel('dx/dt (Velocity)');


for i = 1:size(initial_conditions, 1)
    [~, X] = ode45(Duffing_System, t_span, initial_conditions(i,:));
    plot(X(:,1), X(:,2), 'Color', colors(i,:), 'LineWidth', 1);
end


% Subplot 3: Poincaré Section (stroboscopic map at forcing frequency)
subplot(2, 2, 3);
hold on; grid on;
title('Poincaré Section (Stroboscopic Map)');
xlabel('x');
ylabel('dx/dt');


% Sample at the forcing period (T = 2π/ω)
forcing_period = 2*pi/omega;
t_span_poincare = 0:forcing_period:200;


for i = 1:size(initial_conditions, 1)
    [~, X] = ode45(Duffing_System, t_span_poincare, initial_conditions(i,:));
    plot(X(20:end,1), X(20:end,2), '.', 'Color', colors(i,:), 'MarkerSize', 10);
end


% Subplot 4: Time Evolution from a Representative Initial Condition
subplot(2, 2, 4);
initial_condition = [0.5; 0]; % pick one in the chaotic regime
[T, X] = ode45(Duffing_System, [0 50], initial_condition);


plot(T, X(:,1), 'Color', [0.4 0.4 0.4], 'LineWidth', 1.5, 'DisplayName', 'x(t)');
hold on;
plot(T, X(:,2), 'Color', [0 0.5 0.5], 'LineWidth', 1.5, 'DisplayName', 'dx/dt(t)');


xlabel('Time (s)');
ylabel('State Variables');
title('Time Evolution of x and dx/dt');
legend('show', 'Location', 'best');
grid on;