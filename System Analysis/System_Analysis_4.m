clc, clear, close all;

% Consider the continuous-time dynamic system represented by the following matrices with h ∈ R
% A = [0      1;
%     -h    -h-1];
% b = [0;
%      1];
% c = [-h -h-1];
% d = 1;
%
%  Vary the values of h in the interval [-5 5] and display a message about the system's stability 
%   property (stable, unstable, asymptotically stable).
%
%  For h = 3, write the transfer function of the system and plot the asymptotic Bode diagrams 
%   of this system.
%
%  For h = 3 when t ≤ 0 and h = 2 when t > 0, plot the forced output response in the time interval 
%   [-5 10] seconds, when the input signal to the system is u(t) = 1 + sin(t), ∀t ∈ R. 
%   [Hint: Consider the response for t ≤ 0 and save it in one vector. Consider the response for t > 0 
%   and save it in another vector. Combine the plot using both vectors.]






%first we define the h paramter than we compute the stability for each h in
%the list
h_vals = -5 : 1: 5;

for i = 1:length(h_vals)
    h = h_vals(i);
    A = [0, 1;
     -h, -h-1];
    eigenvalues = eig(A);
    if all(real(eigenvalues) < 0)
        fprintf('h = %.1f: System is asymptotically stable (eigenvalues: %.2f, %.2f)\n',...
                h, eigenvalues(1), eigenvalues(2));
    elseif any(real(eigenvalues) > 0)
        fprintf('h = %.1f: System is unstable (eigenvalues: %.2f, %.2f)\n',...
                h, eigenvalues(1), eigenvalues(2));
    else
        fprintf('h = %.1f: System is marginally stable (eigenvalues: %.2f, %.2f)\n',...
                h, eigenvalues(1), eigenvalues(2));
    end
end


%now let's set h = 3 define the system and it's transfer function to plot
%the bode diagram
h = 3;
A = [0, 1;
     -h, -h-1];
B = [0;
     1];
C = [-h, -h-1];
D = 1;

sys_h3 = ss(A, B, C, D);
G = tf(sys_h3);

%for the last part of the analysis first we define the input and the time
%span and the various constant
t_neg = -5 : 0.01 : 0;
t_pos = 0.01 : 0.01 : 10;
u_neg = 1 + sin(t_neg);
u_pos  = 1 + sin(t_pos);
D = 1;
B_ = [0;
     1];


%define the positive and negative part
h_neg = 3;
h_pos = 2;
A_neg = [0, 1;
         -h_neg, -h_neg-1];
C_neg = [-h_neg, -h_neg-1];
sys_neg = ss(A_neg, B, C_neg, D);

A_pos = [0, 1;
        -h_pos, -h_pos-1];
C_pos = [-h_pos, -h_pos-1];
sys_pos = ss(A_pos, B, C_pos, D);



%simulate the two systems
[y_neg, t1, x_neg] = lsim(sys_neg,u_neg, t_neg);
% Simulate positive time with initial condition from end of negative time
initial_state = x_neg(end,:)';
[y_pos, t2, x_pos] = lsim(sys_pos,u_pos, t_pos, initial_state);

y = [y_neg; y_pos]';
t = [t1; t2];



%plotting the results
figure("Position",[100, 100, 800, 600]);
bode(G)
grid on;


figure("Position",[900,100, 800,600]);
plot(t, y);
title("system response")
xlabel("t(s)");
ylabel("y(t)");
grid  on;