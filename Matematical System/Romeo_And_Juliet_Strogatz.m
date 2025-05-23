clc, clear, close all;

% We want to show the trajectory of Romeo and Juliet based on Strogatz
% problem of 1988 (https://ai.stanford.edu/~rajatr/articles/SS_love_dEq.pdf)
% where we have that R(t) > 0 is love and R(t) < 0 is hate
% we have the following state vector x(t) = [R(t), J(t)] where R is Romeo
% and J is Juliet we will analyze all the necessary cases

%% first case
% here the system is defined as d/dtR(t) = alpha * J(t) and 
% d/dt J(t) = -beta * R(t) with alpha and beta > 0 here we will use x1 for
% Romeo and x2 for juliet therefore we can write our system:

alpha = 1;
beta = 1;

raj = @(t, x)[alpha * x(2);
              -beta * x(1)];

% declare the timespan in which we work for the resolution of the ode
t_span = [0, 30];

% set the initial condition values
x1_0_vals = -3:1:3;
x2_0_vals = -3:1:3;

% Create a figure window
figure("Position", [100, 100, 1000, 800]);

% First subplot: Phase portrait
subplot(2, 2, 1);
hold on;
title("Phase Plot with Initial Condition Grid");
xlabel("x_1(t) = R(t)");
ylabel("x_2(t) = J(t)");
grid on;

% loop through all the initial conditions
for x1_0 = x1_0_vals
    for x2_0 = x2_0_vals
        % solve the ode for the initial conditions
        [~, X] = ode45(raj, t_span, [x1_0, x2_0]);
        
        % Plot the phase portrait (x1 vs x2)
        plot(X(:,1), X(:,2));  % Plot trajectory in phase space
    end
end
hold off;

% Create a second subplot for the vector field
subplot(2, 2, 2);
hold on;
title("Phase Space Vector Field");
xlabel("x_1(t) = R(t)");
ylabel("x_2(t) = J(t)");
grid on;

% Create a grid for the vector field
[x1_grid, x2_grid] = meshgrid(-3:0.5:3, -3:0.5:3);  % Finer grid for smoother arrows

% Calculate derivatives at each grid point
u = alpha * x2_grid;  % dx1/dt = alpha*x2
v = -beta * x1_grid;  % dx2/dt = -beta*x1

% Plot the vector field using quiver
streamslice(x1_grid, x2_grid, u, v);
hold off;

% Time evolution of state variables from x1(0) = 0.01, x2(0) = 0
initial_condition = [0.01; 0]; % [x1(0); x2(0)]
[T, X] = ode45(raj, t_span, initial_condition);

% Create a new subplot for the time evolution
subplot(2, 2, [3, 4]); % This will use the bottom half of the figure
hold on;

% Plot x1(t) vs time
plot(T, X(:,1), "color", [0.4 0.4 0.4], "LineWidth", 1.5, "DisplayName", "x_1(t) = R(t)");

% Plot x2(t) vs time
plot(T, X(:,2), "color", [0 0.5 0.5], "LineWidth", 1.5, "DisplayName", "x_2(t) = J(t)");

% Configure plot appearance
title("Time Evolution of State Variables");
xlabel("Time (s)");
ylabel("State Variables");
legend("show", "Orientation", "vertical", "Location", "southwest");
legend("boxoff");
grid on;
hold off;


%% Second case
clc, clear, close all;
% here the system is defined as d/dtR(t) = alpha * R(t) + beta * J(t) and 
% d/dt J(t) = beta * R(t) + alpha * J(t) with alpha < 0 and beta > 0 and 
%|alpha| > |beta| with alpha != beta
% therefore they are cautious lover
% here we will use x1 for Romeo and x2 for juliet therefore we can 
% write our system:
alpha = -3;
beta = 1;

raj = @(t, x)[alpha * x(1) + beta * x(2);
              beta * x(1) + alpha * x(2)];

% declare the timespan in which we work for the resolution of the ode
t_span = [0, 30];

% set the initial condition values
x1_0_vals = -3:1:3;
x2_0_vals = -3:1:3;

% Create a figure window
figure("Position", [100, 100, 1000, 800]);

% First subplot: Phase portrait
subplot(2, 2, 1);
hold on;
title("Phase Plot with Initial Condition Grid");
xlabel("x_1(t) = R(t)");
ylabel("x_2(t) = J(t)");
grid on;

% loop through all the initial conditions
for x1_0 = x1_0_vals
    for x2_0 = x2_0_vals
        % solve the ode for the initial conditions
        [~, X] = ode45(raj, t_span, [x1_0, x2_0]);
        
        % Plot the phase portrait (x1 vs x2)
        plot(X(:,1), X(:,2));  % Plot trajectory in phase space
    end
end
hold off;

% Create a second subplot for the vector field
subplot(2, 2, 2);
hold on;
title("Phase Space Vector Field");
xlabel("x_1(t) = R(t)");
ylabel("x_2(t) = J(t)");
grid on;

% Create a grid for the vector field
[x1_grid, x2_grid] = meshgrid(-3:0.5:3, -3:0.5:3);  % Finer grid for smoother arrows

% Calculate derivatives at each grid point
u = alpha * x2_grid;  % dx1/dt = alpha*x2
v = -beta * x1_grid;  % dx2/dt = -beta*x1

% Plot the vector field using quiver
streamslice(x1_grid, x2_grid, u, v);
hold off;

% Time evolution of state variables from x1(0) = 0.01, x2(0) = 0
initial_condition = [0.01; 0]; % [x1(0); x2(0)]
[T, X] = ode45(raj, t_span, initial_condition);

% Create a new subplot for the time evolution
subplot(2, 2, [3, 4]); % This will use the bottom half of the figure
hold on;

% Plot x1(t) vs time
plot(T, X(:,1), "color", [0.4 0.4 0.4], "LineWidth", 1.5, "DisplayName", "x_1(t) = R(t)");

% Plot x2(t) vs time
plot(T, X(:,2), "color", [0 0.5 0.5], "LineWidth", 1.5, "DisplayName", "x_2(t) = J(t)");

% Configure plot appearance
title("Time Evolution of State Variables");
xlabel("Time (s)");
ylabel("State Variables");
legend("show", "Orientation", "vertical", "Location", "southwest");
legend("boxoff");
grid on;
hold off;


%% third case
clc, clear, close all;
% here the system is defined as d/dtR(t) = alpha * R(t) + beta * J(t) and 
% d/dt J(t) = beta * R(t) + alpha * J(t) with alpha < 0 and beta > 0 and 
%|alpha| < |beta| with alpha != beta
% therefore they are cautious lover
% here we will use x1 for Romeo and x2 for juliet therefore we can 
% write our system:

alpha = -1;
beta = 3;

raj = @(t, x)[alpha * x(1) + beta * x(2);
              beta * x(1) + alpha * x(2)];

% declare the timespan in which we work for the resolution of the ode
t_span = [0, 30];

% set the initial condition values
x1_0_vals = -3:1:3;
x2_0_vals = -3:1:3;

% Create a figure window
figure("Position", [100, 100, 1000, 800]);

% First subplot: Phase portrait
subplot(2, 2, 1);
hold on;
title("Phase Plot with Initial Condition Grid");
xlabel("x_1(t) = R(t)");
ylabel("x_2(t) = J(t)");
grid on;

% loop through all the initial conditions
for x1_0 = x1_0_vals
    for x2_0 = x2_0_vals
        % solve the ode for the initial conditions
        [~, X] = ode45(raj, t_span, [x1_0, x2_0]);
        
        % Plot the phase portrait (x1 vs x2)
        plot(X(:,1), X(:,2));  % Plot trajectory in phase space
    end
end
hold off;

% Create a second subplot for the vector field
subplot(2, 2, 2);
hold on;
title("Phase Space Vector Field");
xlabel("x_1(t) = R(t)");
ylabel("x_2(t) = J(t)");
grid on;

% Create a grid for the vector field
[x1_grid, x2_grid] = meshgrid(-3:0.5:3, -3:0.5:3);  % Finer grid for smoother arrows

% Calculate derivatives at each grid point
u = alpha * x2_grid;  % dx1/dt = alpha*x2
v = -beta * x1_grid;  % dx2/dt = -beta*x1

% Plot the vector field using quiver
streamslice(x1_grid, x2_grid, u, v);
hold off;

% Time evolution of state variables from x1(0) = 0.01, x2(0) = 0
initial_condition = [0.01; 0]; % [x1(0); x2(0)]
[T, X] = ode45(raj, t_span, initial_condition);

% Create a new subplot for the time evolution
subplot(2, 2, [3, 4]); % This will use the bottom half of the figure
hold on;

% Plot x1(t) vs time
plot(T, X(:,1), "color", [0.4 0.4 0.4], "LineWidth", 1.5, "DisplayName", "x_1(t) = R(t)");

% Plot x2(t) vs time
plot(T, X(:,2), "color", [0 0.5 0.5], "LineWidth", 1.5, "DisplayName", "x_2(t) = J(t)");

% Configure plot appearance
title("Time Evolution of State Variables");
xlabel("Time (s)");
ylabel("State Variables");
legend("show", "Orientation", "vertical", "Location", "southwest");
legend("boxoff");
grid on;
hold off;

