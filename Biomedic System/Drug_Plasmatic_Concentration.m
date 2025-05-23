clc, clear, close all;
% Define the transfer function (3-compartment pharmacokinetic model)
% Numerator: 0.7s + 1 (absorption dynamics)
% Denominator: (0.1s+1)(0.5s+1)(36s+1) (fast/medium/slow phases)
sys = tf([0.7, 1], conv([0.1, 1], conv([0.5, 1], [36, 1])));

% Time vector (7 days, 0.01-hour resolution)
t_span = 0 : 0.01 : 24 * 7;  % 0 to 168 hours (steps of 0.01h)
u = zeros(size(t_span));      % Initialize input (no dose)

% Scenario 1: One dose per day (24-hour intervals)
T1 = 1 : 2400 : 24 * 7 * 100;  % Dosing indices (every 2400 steps = 24h)
u(T1) = 1;                      % Unit dose at each interval
y1 = lsim(sys, u, t_span);      % Simulate concentration

% Scenario 2: Two doses per day (12-hour intervals)
u = zeros(size(t_span));        % Reset input
T2 = 1 : 1200 : 24 * 7 * 100;   % Dosing indices (every 1200 steps = 12h)
u(T2) = 1;                      % Unit dose every 12h
y2 = lsim(sys, u, t_span);      % Simulate concentration

% Scenario 3: Double dose once daily
u = zeros(size(t_span));        % Reset input
u(T1) = 2;                      % Double dose (2 units) every 24h
y3 = lsim(sys, u, t_span);      % Simulate concentration

% Scenario 4: Two half-doses daily (custom regimen)
u = zeros(size(t_span));        % Reset input
u(T2) = 0.5;                    % Half-dose (0.5 units) every 12h
y4 = lsim(sys, u, t_span);      % Simulate concentration

% Convert time to days for plotting
t_days = t_span / 24;           % Hours → days
T1_days = T1 / 24 / 100;        % Dosing times (days) for Scenario 1
T2_days = T2 / 24 / 100;        % Dosing times (days) for Scenario 2

% Plot all scenarios in a 2x2 grid
figure('Position', [100, 100, 1200, 800]);

% Subplot 1: One dose per day
subplot(2, 2, 1);
plot(t_days, y1, T1_days, zeros(size(T1_days)), '.'); 
grid on;
title('1 dose/day (24h interval)');
xlabel('Days'); ylabel('Concentration');
axis([0 7 0 1.2e-3]);

% Subplot 2: Two doses per day
subplot(2, 2, 2);
plot(t_days, y2, T2_days, zeros(size(T2_days)), '.'); 
grid on;
title('2 doses/day (12h interval)');
xlabel('Days'); ylabel('Concentration');
axis([0 7 0 1.2e-3]);

% Subplot 3: Double dose once daily
subplot(2, 2, 3);
plot(t_days, y3, T1_days, zeros(size(T1_days)), '.'); 
grid on;
title('Double dose (24h interval)');
xlabel('Days'); ylabel('Concentration');
axis([0 7 0 2.5e-3]);  % Higher y-axis for double dose

% Subplot 4: Two half-doses daily
subplot(2, 2, 4);
plot(t_days, y4, T2_days, zeros(size(T2_days)), '.'); 
grid on;
title('Two half-doses/day (12h interval)');
xlabel('Days'); ylabel('Concentration');
axis([0 7 0 0.7e-3]);  % Lower y-axis for half-doses