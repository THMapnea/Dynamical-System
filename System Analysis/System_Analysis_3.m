clc, clear, close all;


%we have a linear sistem expressed in the Laplace domain and we want to
%know  an i-s-u representation,the impulse, it's bode diagram response 
% the free evolution of the system given in input initial condition of all 
% 1s, and another response to a rect wave of period 3s and amplitude 0.5,
% the equation of the linear system is the following : 
% 10(s - 5)/(s^2 + s + 1)(s + 10)

%first thing we define the system in the frequenvy domain
sys = tf([10, -50], conv([1, 1, 1], [1, 10]));


%then we can convert to space time model
sys_isu = ss(sys); 


%get for future use if necessary the various matrices of the system 
A = sys_isu.A;
B = sys_isu.B;
C = sys_isu.C;
D = sys_isu.D;


%since we need to get the response to the impulse without considering the
%initial condition we can call the impulse function to get the response
[y1, t1, x1] = impulse(sys_isu);


%if we want to get the free evolution of our system we need first to get a
%time span in wich we want to simulate the system, the initial condition 
%and the input
t_span = 0 : 0.01 : 10;
u = 0 * t_span;
initial_condition = [1, 1, 1];
[y2, t2, x2] = lsim(sys_isu, u, t_span, initial_condition);



%then we want to know the response to a rect wave of amplitude 0.5 and
%period 3 seconds we generate it trough the gensign function, where tau is
%the period, we will se the response for the same initial condition and
%time span of the free evolution for simplicity
tau = 3; % period
amplitude = 0.5; %amplitude
T = t_span(end); % total time
Ts = t_span(2) - t_span(1); % sampling time (0.01)
[square_wave, t_sw] = gensig("square", tau, T, Ts);
square_wave = amplitude * square_wave;
[y3, t3, x3] = lsim(sys_isu, square_wave', t_sw, initial_condition);



%plot the values

%impulse response
figure("Position", [100, 100, 1200, 800])
subplot(2, 2, 1);
plot(t1,y1);
title("Impulse response");
xlabel("time");
ylabel("amplitude");
grid on;


%bode diagrams
subplot(2, 2, 2);
bode(sys);
grid on;

%free evolution
subplot(2, 2, 3);
plot(t2,y2);
title("Free evolution");
xlabel("time");
ylabel("evolution");
grid on;


%square wave response
subplot(2, 2, 4);
plot(t3,y3);
title("Square wave response");
xlabel("time");
ylabel("response");
grid on;


