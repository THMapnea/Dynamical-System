clc, clear, close all;

%Consider the following continuous-time LTI system characterized by the matrices:
% A = [  0   1
%       -2  -2 ], 
% B = [ 0
%       1 ], 
% C = [ 1  1 ], 
% D = 1.
%
% 1. First, compute the equilibrium states of the system.
% 2. Then, compute the transfer function of the system and plot the Bode diagram.
% 3. In a separate figure, plot the output response to the input signal:
%       u(t) = 3*cos(t)*δ₋₁(2−t), for t ∈ [−10, 10] s.
% 4. Then, given the input signal u(t) = δ₋₁(t), compute and plot in another figure:
%       - the output response
%       - the state response
%    using the initial condition x0 = [1; -1] over the time interval t ∈ [0, 10] s.
%
% 5. Finally, in another figure, plot the state trajectory in the phase plane:
%    plot x1(t) on the x-axis and x2(t) on the y-axis.


%let's first declare the matrices
 A = [  0,   1;
       -2,  -2 ]; 
 B = [ 0;
       1 ]; 
 C = [ 1,  1 ]; 
 D = 1;


%we prepare a constant value in input we will generalize with a certain
%interval but we will work only on the state of equilibrium for 0 since we
%can just obtain the others by shifting
u_e = 0;


%first we find the equilibrium states(general formula)
x_e = -inv(A) * B * u_e;


%then we can find the transfer function we know that 
% G(s) = C * (s * I - A)^-1 * B + D so we can use the tf function to
% extract it instead of manually writing the formula
sys = ss(A, B, C, D);
G = tf(sys);


%now we will simulate the output given the function:
% u(t) = 3*cos(t)*δ₋₁(2−t), for t ∈ [−10, 10] s.

%first we create the time span in wich we simulate
t_span = -10 : 0.1 : 10;


%then we create the input
%the argument
u1 = 3 * cos(t_span) .* heaviside(2 - t_span);


%we now simulate the system and store the result
[y1, t1, x1] = lsim(sys, u1, t_span);


%then we simulate the step response given some initial condition to do so
%we can call the step function and pass some initial condition or use lsim
%bot are equal solution we will do it fron 0 -> 10s
t_span = 0 : 0.1: 10;
u2 = 1 .* (t_span >= 0);
initial_condition = [1, -1];
[y2, t2, x2] = lsim(sys, u2, t_span , initial_condition);



% 1. Bode Plot
figure('Position', [1000, 100, 900, 700]);
bode(G);
grid on;
title('Bode Diagram of System');
set(findall(gcf,'type','line'),'linewidth',1.5);  % Thicker lines

figure('Position', [100, 100, 900, 700]);
% 2. Response to u(t) = 3cos(t)*u_{-1}(2-t)
subplot(2, 2, 1);
plot(t1, y1, 'b', 'LineWidth', 1.5);
grid on;
title('Response to u(t) = 3cos(t) for t ≤ 2');
xlabel('Time (s)');
ylabel('Output');
xlim([-10 10]);  % Explicit limits matching your time span

% 3. Step Response (Heaviside)
subplot(2, 2, 2);
plot(t2, y2, 'r', 'LineWidth', 1.5);
grid on;
title('Step Response (x_0 = [1; -1])');
xlabel('Time (s)');
ylabel('Output');
xlim([0 10]);  % Match your time span

% 4. State Variables Evolution
subplot(2, 2, 3);
plot(t2, x2(:,1), 'g', t2, x2(:,2), 'm', 'LineWidth', 1.5);
grid on;
title('State Variables vs Time');
xlabel('Time (s)');
ylabel('States');
legend('x_1(t)', 'x_2(t)');
xlim([0 10]);

% 5. Phase Plane Trajectory
subplot(2, 2, 4);
plot(x2(:,1), x2(:,2), 'k', 'LineWidth', 1.5);
hold on;
plot(x2(1,1), x2(1,2), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');  % Start point
plot(x2(end,1), x2(end,2), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');  % End point
grid on;
title('Phase Plane Trajectory');
xlabel('x_1(t)');
ylabel('x_2(t)');
legend('Trajectory', 'Start', 'End');

