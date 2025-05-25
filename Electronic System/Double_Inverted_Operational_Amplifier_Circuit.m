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


%then we can see the response to an impulse
[y_imp, t_imp, x_imp] = impulse(sys);









%plotting the results
% Plotting the impulse response
figure("Position", [100, 100, 1200, 800]);
subplot(2, 2, [1 2]);
plot(t_imp, y_imp, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
grid on;
title('Impulse Response of 5th-Order RLC Network', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Time (seconds)', 'FontSize', 12);
ylabel('Amplitude', 'FontSize', 12);
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
xlim([0 t_imp(end)]); % Show full time range


% Improve overall figure appearance
sgtitle('Dynamic Analysis of 5th-Order RLC Network', 'FontSize', 16, 'FontWeight', 'bold');
set(gcf, 'Color', 'w');
