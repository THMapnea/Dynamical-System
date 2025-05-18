clc, clear, close all;

%we will now see how we can get the response of a certain system to some
%known input

%first we declare the matrix of the system and the system itself, and the
%initial condition

A = [1, 2;
     2, 9];
B = [1, 3; 
     9, 6];
C = [22, 3];
D = 0;
initial_condition = [1, 0];
sys = ss(A, B, C, D);

% Free evolution
[y1, t1, x1] = initial(sys, initial_condition);

% Impulse response
[y2, t2, x2] = impulse(sys);

% Step response
[y3, t3, x3] = step(sys);

% Forced response with initial condition
t_span = 0:0.01:10;  
u = [sin(2 * pi * 0.5 * t_span);  
     cos(2 * pi * 0.5 * t_span)]; 
[y4, t4, x4] = lsim(sys, u, t_span, initial_condition);

% Plot results
figure("Position",[100, 100, 800, 600]);

subplot(2, 2, 1);
plot(t1, y1);
title("Free evolution of the system");
xlabel('Time'); ylabel('Output');
grid on;

subplot(2, 2, 2);
% Plot impulse response from first input to output
plot(t2, y2(:,1,1)); % Output from input 1
hold on;
plot(t2, y2(:,1,2)); % Output from input 2
title("System response to impulse");
xlabel('Time'); ylabel('Output');
legend('From input 1', 'From input 2');
grid on;

subplot(2, 2, 3);
% Plot step response from first input to output
plot(t3, y3(:,1,1)); % Output from input 1
hold on;
plot(t3, y3(:,1,2)); % Output from input 2
title("System response to step");
xlabel('Time'); ylabel('Output');
legend('From input 1', 'From input 2');
grid on;

subplot(2, 2, 4);
plot(t4, y4);
title("General system response");
xlabel('Time'); ylabel('Output');
grid on;