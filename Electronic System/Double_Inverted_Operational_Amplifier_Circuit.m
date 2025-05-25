clc; clear; close all;

%
%
%                                     R2                                         R4                                          
%                          ________/\/\/\/\_________                  ________/\/\/\/\_________
%                          |                       |                  |                       |
%                          |                       |                  |                       |
%                          |          L1           |                  |          L2           |
%                          |_______()()()()________|                  |_______()()()()________|
%                          |                       |                  |                       |
%                          |                       |                  |                       |
%          R1              | |\                    |                  |  |\                   |
%    ___/\/\/\/\___| |_____|_| \                   |           R3     |  | \                  |           R5
%    |             | |     - |  \__________________|__| |___/\/\/\/\__|__|  \_________________|__| |___/\/\/\/\__
%   (|)u(t)         C1       |  /                     | |              - |  /                    | |             |
%    |_______________________| /                       C2                | /                      C3             |   
%    |                     + |/   _____________________________________+_|/                                      |   
%    |___________________________|                                                                               |
%    |                                                                                                           |   
%    |___________________________________________________________________________________________________________|
%  _____ 
%   ___
%    _
%
%we want to anlayze the following circuit that contains two inverted
%operational amplifiers, five resistances, three, capacitators and three
%inductors. The i-s-u representation of the system is the following:
% ẋ1(t) = -1/(R1*C1)*x1(t) + 1/(R1*C1)*u(t)
% ẋ2(t) = -R2/(R1*L1)*x1(t) - R2/L1*x2(t) + R2/(R1*L1)*u(t)
% ẋ3(t) = R2/(R1*R3*C2)*x1(t) + R2/(R3*C2)*x2(t) - 1/(R3*C2)*x3(t) - R2/(R1*R3*C2)*u(t)
% ẋ4(t) = R2*R4/(R1*R3*L2)*x1(t) + R2*R4/(R3*L2)*x2(t) - R4/(R3*L2)*x3(t) - R4/L2*x4(t) - R2*R4/(R1*R3*L2)*u(t)
% ẋ5(t) = -R2*R4/(R1*R3*R5*C3)*x1(t) - R2*R4/(R3*R5*C3)*x2(t) + R4/(R3*R5*C3)*x3(t) + R4/(R5*C3)*x4(t) - 1/(R5*C3)*x5(t) + R2*R4/(R1*R3*R5*C3)*u(t)
% y(t) = -R2*R4/(R1*R3)*x1(t) - R2*R4/R3*x2(t) + R4/R3*x3(t) + R4*x4(t) - x5(t) + R2*R4/(R1*R3)*u(t)
% The resulting system is dynamic, continuous-time, LTI, SISO, proper, of fifth order
%we will proceed with a quick analysis of the circuit

%we first define some values for the resistence inductance etc
R1 = 1e3;    % 1 kΩ
R2 = 2.2e3;  % 2.2 kΩ
R3 = 4.7e3;  % 4.7 kΩ
R4 = 3.3e3;  % 3.3 kΩ
R5 = 1e3;    % 1 kΩ

C1 = 10e-6;  % 10 μF
C2 = 22e-9;  % 22 nF
C3 = 100e-9; % 100 nF

L1 = 10e-3;  % 10 mH
L2 = 4.7e-3; % 4.7 mH

%we create the various matrices
A = [ -1/(R1*C1),            0,                 0,                 0,                 0;
      -R2/(R1*L1),        -R2/L1,               0,                 0,                 0;
      R2/(R1*R3*C2),    R2/(R3*C2),      -1/(R3*C2),               0,                 0;
      R2*R4/(R1*R3*L2), R2*R4/(R3*L2), -R4/(R3*L2),          -R4/L2,                 0;
     -R2*R4/(R1*R3*R5*C3), -R2*R4/(R3*R5*C3), R4/(R3*R5*C3), R4/(R5*C3), -1/(R5*C3)];

B = [ 1/(R1*C1);
      R2/(R1*L1);
     -R2/(R1*R3*C2);
     -R2*R4/(R1*R3*L2);
      R2*R4/(R1*R3*R5*C3)];

C = [ -R2*R4/(R1*R3), -R2*R4/R3, R4/R3, R4, -1 ];

D = R2*R4/(R1*R3);


%then we can define the system
sys = ss(A, B, C, D);

%we can also define the initial condition
initial_condition = [1, 1, 1, 1, 1];


%we can also search the free evolution of the system
[y_free, t_free, x_free] = initial(sys, initial_condition);


%then we can see the response to an impulse
[y_imp, t_imp, x_imp] = impulse(sys);


%we can then compute the step response
t_span = -10 : 1e-3 : 10;
[y_step, t_step, x_step] = step(sys);


%we can also see it's response to a sinusoidal input
u_sin = sin(t_span);
[y_sin, t_sin, x_sin] = lsim(sys, u_sin, t_span);


%we can see the response to a monolateral exponential
u_exp = exp(t_span) .* heaviside(t_span);
[y_exp, t_exp, x_exp] = lsim(sys, u_exp, t_span);


%we can also see how it reacts to a rectangular impulse of amplitude 1
u_rect = heaviside(t_span  + 0.5) - heaviside(t_span -0.5);
[y_rect, t_rect, x_rect] = lsim(sys, u_rect, t_span);


%we can also compute the response to a ramp signal
u_ramp = t_span .* heaviside(t_span);
[y_ramp, t_ramp, x_ramp] = lsim(sys, u_ramp, t_span);


%we can also compute the response to a parabola
u_parab = 0.5 * t_span.^2 .* heaviside(t_span);
[y_parab, t_parab, x_parab] = lsim(sys, u_parab, t_span);


%we can also compute the response to a hyperbolical signal
t_span_hyp = 1e-6 : 0.01 : 10;
u_hyp = 1 ./ t_span_hyp;
[y_hyp, t_hyp, x_hyp] = lsim(sys, u_hyp, t_span_hyp);

%we can now compute the transfer function and observe it's bode and nyquist plot
G = tf(sys);
static_gain = dcgain(G);




%we can now study the stability of the circuit
eigenvalues = eig(A);
if all(real(eigenvalues) < 0)
    fprintf("the circuit is asymptotically stable\n");
elseif any(real(eigenvalues) > 0)
    fprintf("the system is unstable\n");
else
    fprintf("the system is marginally stable\n");
end


%we will now study the reachability(controllability) and the observability
CM = ctrb(A, B);
CM_rank = rank(CM);
OM = obsv(A, C);
OM_rank = rank(OM);
if CM_rank == size(A, 1)
    fprintf("the system is reachable(controllable)\n");
else
    fprintf("the system is not rechable(not controllable)\n");
end


if OM_rank == size(A, 1)
    fprintf("the system is observable\n");
else
    fprintf("the system is not observable\n");
end  
    

%plotting the results
figure("Position", [100, 100, 1200, 800]);
subplot(3, 3, 1);
plot(t_free, y_free, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
grid on;
title('Free evolution of 5th-Order RLC Network', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Time (seconds)', 'FontSize', 12);
ylabel('Amplitude', 'FontSize', 12);
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
xlim([0 t_free(end)]); % Show full time range


%impulse response
subplot(3, 3, 2);
plot(t_imp, y_imp, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
grid on;
title('Impulse Response of 5th-Order RLC Network', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Time (seconds)', 'FontSize', 12);
ylabel('Amplitude', 'FontSize', 12);
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
xlim([0 t_imp(end)]); % Show full time range


%step response
subplot(3, 3, 3);
plot(t_step, y_step, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
grid on;
title('Step Response of 5th-Order RLC Network', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Time (seconds)', 'FontSize', 12);
ylabel('Amplitude', 'FontSize', 12);
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
xlim([0 t_step(end)]); % Show full time range


%sin response
subplot(3, 3, 4);
plot(t_sin, y_sin, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
grid on;
title('Sinusoidal Response of 5th-Order RLC Network', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Time (seconds)', 'FontSize', 12);
ylabel('Amplitude', 'FontSize', 12);
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
xlim([0 t_sin(end)]); % Show full time range


%exponential response
subplot(3, 3, 5);
plot(t_exp, y_exp, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
grid on;
title('Exponential Response of 5th-Order RLC Network', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Time (seconds)', 'FontSize', 12);
ylabel('Amplitude', 'FontSize', 12);
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
xlim([0 t_exp(end)]); % Show full time range


%rect response
subplot(3, 3, 6);
plot(t_rect, y_rect, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
grid on;
title('Rect Response of 5th-Order RLC Network', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Time (seconds)', 'FontSize', 12);
ylabel('Amplitude', 'FontSize', 12);
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
xlim([0 t_rect(end)]); % Show full time range


%ramp response
subplot(3, 3, 7);
plot(t_ramp, y_ramp, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
grid on;
title('Ramp Response of 5th-Order RLC Network', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Time (seconds)', 'FontSize', 12);
ylabel('Amplitude', 'FontSize', 12);
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
xlim([0 t_ramp(end)]); % Show full time range

%parabola response
subplot(3, 3, 8);
plot(t_parab, y_parab, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
grid on;
title('Parabola Response of 5th-Order RLC Network', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Time (seconds)', 'FontSize', 12);
ylabel('Amplitude', 'FontSize', 12);
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
xlim([0 t_parab(end)]); % Show full time range


%Hyperbole response
subplot(3, 3, 9);
plot(t_hyp, y_hyp, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
grid on;
title('Hyperbole Response of 5th-Order RLC Network', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Time (seconds)', 'FontSize', 12);
ylabel('Amplitude', 'FontSize', 12);
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
xlim([0 t_hyp(end)]); % Show full time range


% Improve overall figure appearance
sgtitle('Dynamic Analysis of 5th-Order RLC Network', 'FontSize', 16, 'FontWeight', 'bold');
set(gcf, 'Color', 'w');

figure("Position", [200,200, 600, 800]);
subplot(2, 1, 1);
bode(G);
grid on;
subplot(2,1,2);
nyquist(G);
grid on;
fprintf("the static gain of the circuit is: %.2f\n",static_gain);
