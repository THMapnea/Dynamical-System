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
u_exp = exp(-t_span) .* heaviside(t_span);
[y_exp, t_exp, x_exp] = lsim(sys, u_exp, t_span);


%we can also see how it reacts to a rectangular impulse of amplitude 1
u_rect = heaviside(t_span  + 0.5) - heaviside(t_span -0.5);
[y_rect, t_rect, x_rect] = lsim(sys, u_rect, t_span);


%we can also compute the response to a ramp signal
u_ramp = t_span .* heaviside(t_span);
[y_ramp, t_ramp, x_ramp] = lsim(sys, u_ramp, t_span);


%we can also compute the response to a parabola
u_parab = 0.5 * t_span.^2;
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
figure("Position", [50, 10, 1200, 800]);


% Define plot data and titles
response_plots = {
    {'Free Evolution', t_free, y_free}, 
    {'Impulse Response', t_imp, y_imp},
    {'Step Response', t_step, y_step},
    {'Sinusoidal Response', t_sin, y_sin},
    {'Exponential Response', t_exp, y_exp},
    {'Rectangular Response', t_rect, y_rect},
    {'Ramp Response', t_ramp, y_ramp},
    {'Parabolic Response', t_parab, y_parab},
    {'Hyperbolic Response', t_hyp, y_hyp}
};


% Plot all responses
for i = 1:9
    subplot(3, 3, i);
    plot(response_plots{i}{2}, response_plots{i}{3}, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
    grid on;
    title(response_plots{i}{1}, 'FontSize', 12);
    xlabel('Time (seconds)', 'FontSize', 10);
    ylabel('Amplitude', 'FontSize', 10);
    xlim([0 response_plots{i}{2}(end)]);
end


sgtitle('System Responses to Different Inputs', 'FontSize', 16, 'FontWeight', 'bold');
set(gcf, 'Color', 'w');


% State Trajectories with custom colors
state_colors = [
    0.00 0.45 0.74;  % x1 - Blue
    0.85 0.33 0.10;  % x2 - Orange
    0.93 0.69 0.13;  % x3 - Yellow
    0.49 0.18 0.56;  % x4 - Purple
    0.47 0.67 0.19   % x5 - Green
];


figure("Position", [50, 10, 1200, 1000]);


trajectory_data = {
    {'Free Evolution', t_free, x_free},
    {'Impulse Response', t_imp, x_imp},
    {'Step Response', t_step, x_step},
    {'Sinusoidal Response', t_sin, x_sin},
    {'Exponential Response', t_exp, x_exp},
    {'Rectangular Response', t_rect, x_rect},
    {'Ramp Response', t_ramp, x_ramp},
    {'Parabolic Response', t_parab, x_parab},
    {'Hyperbolic Response', t_hyp, x_hyp}
};


for i = 1:9
    subplot(3, 3, i);
    hold on;
    for state = 1:5
        plot(trajectory_data{i}{2}, trajectory_data{i}{3}(:,state), ...
             'LineWidth', 2, 'Color', state_colors(state,:));
    end
    hold off;
    
    grid on;
    title(trajectory_data{i}{1}, 'FontSize', 12);
    xlabel('Time (seconds)', 'FontSize', 10);
    ylabel('State Value', 'FontSize', 10);
    xlim([0 trajectory_data{i}{2}(end)]);
    
    if i == 1
        legend({'x_1','x_2','x_3','x_4','x_5'}, 'Location', 'best');
    end
end


sgtitle('State Trajectories for Different Inputs', 'FontSize', 16, 'FontWeight', 'bold');
set(gcf, 'Color', 'w');
