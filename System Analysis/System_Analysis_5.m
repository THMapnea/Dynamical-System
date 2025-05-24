clc, clear, close all;

% Consider the continuous-time LTI dynamic system modeled by the following transfer function:
% G(s) = -200 * s*(s-5) / [(s^2 + 0.02s + 1)*(s + 10)^2]
% 
% Tasks:
% 1. Draw the Bode plots of the system
% 2. Determine the static gain
% 3. Determine a state-space representation of the system
% 
% Now consider another continuous-time LTI dynamic system modeled by:
% G(s) = (s^2 + 100) / [(s + 1)*(s + 18)]
% 
% Tasks for this system:
% 1. Compute a state-space representation
% 2. Calculate the static gain
% 3. Represent its Bode plots
% 4. Compute the free response of the output considering an initial state x0 = [1 -1 1]'
% 5. For a simulation time of 10 seconds, compute the forced output when the system is subjected to:
%    - A step input with amplitude 2
%    - A unit slope ramp input
%    - An input signal u(t) = (-4 + 2*cos(7t - π/3))*δ_{-1}(t)


%first thing we define the transfer function
num1 = -200 * conv([1 0], [1 -5]); 
den1 = conv([1 0.02 1], conv([1 10], [1 10]));
G1 = tf(num1, den1);


%we then want to know the static gain that is G(0)
static_gain1 = dcgain(G1);


%the i-s-u model can be easily extracted trough the ss function another
%approach would be tf2ss
sys1 = ss(G1);


%we can proceed with the second system
num2 = [1, 0, 100];
den2 = conv([1, 1], [1, 18]);
G2 = tf(num2, den2);


%we can get the static gain like we did before
static_gain2 = dcgain(G2);

%we can extract the i-s-u form as before
sys2 = ss(G2);


%now we define all the paramteres necessary for the simulation
initial_condition = [1; -1;];
t_span = 0 : 0.01 : 10; 
u1 = 2 .* heaviside(t_span);
u2 = t_span .* heaviside(t_span);
u3 = (-4 + 2 * cos(7 * t_span - pi / 3)) .* heaviside(t_span);


%to get the free evolution we call initial
[y_free, t_free, x_free] = initial(sys2, initial_condition);


%to get the forced response we call the lsim for each input
[y1, t1, x1] = lsim(sys2, u1, t_span);
[y2, t2, x2] = lsim(sys2, u1, t_span);
[y3, t3, x3] = lsim(sys2, u1, t_span);


%plotting the results
fprintf("the static gain of the first system is %.f \n", static_gain1);
fprintf("the i-s-u model is the following: \n");
disp(sys1);
fprintf("the static gain of the second system is %.f \n", static_gain2);
fprintf("the i-s-u model is the following: \n");
disp(sys2);
figure("Position",[100,100,1200,800]);
subplot(3, 2, 1);
bode(G1);
grid on;
subplot(3, 2, 2)
bode(G2);
grid on;
subplot(3, 2, 3);
plot(t_free, y_free, "LineWidth", 1.5);
grid on;
title("free evolution")
xlabel("t(s)");
ylabel("y_free(t)");
ylim([-5, 1]);
subplot(3, 2, 4);
plot(t1, y1, "LineWidth", 1.5);
grid on;
title("u = 2 .* heaviside(t_span)")
xlabel("t(s)");
ylabel("y1(t)");
subplot(3, 2, 5);
plot(t2, y2, "LineWidth", 1.5);
grid on;
title("u = t_span .* heaviside(t_span)")
xlabel("t(s)");
ylabel("y1(t)");
subplot(3, 2, 6);
plot(t3, y3, "LineWidth", 1.5);
grid on;
title("u = (-4 + 2 * cos(7 * t_span - pi / 3)) .* heaviside(t_span);")
xlabel("t(s)");
ylabel("y1(t)");
