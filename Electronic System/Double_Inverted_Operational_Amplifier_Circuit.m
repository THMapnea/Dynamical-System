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
%    |                     + |/   _____________________________________+ |/                                      |   
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
