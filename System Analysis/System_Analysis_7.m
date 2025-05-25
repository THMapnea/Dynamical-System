clc; clear; close all;

% 1. Continuous-time LTI system:
% Given the transfer function G(s) = (2500/9) * s(s^2 + 9) / ((s^2 - 100s + 2500)(s^2 + 1)),
% plot the Bode diagrams and Nyquist plot in separate windows. Derive the state-space
% representation (i-s-u form) and analyze stability, observability, and controllability.
%
% 2. Discrete-time LTI system (T = 1):
% Given the system matrices:
% A = [0.15 0; 0.75 0.05], b = [1 0; 0 1], c = [500 500], d = 0.
% Plot the output response to inputs u1(k) = 100 + 10*sin(k) and u2(k) = 1 + sin(k)
% for k in [0, 20].
%
% 3. Continuous-time LTI system:
% Given the system matrices:
% A = [0 1; -1 -2], b = [1; -1], c = [1 0], d = 1.
% Plot the output response to input u(t) = (-2 + sin(5t)) * delta_{-1}(-t)
% for t in [-20, 20].

%first we define the transfer function
num = 2500 * conv([1, 0], [1, 0, 9]);
den = 9 * conv([1, -100, 2500], [1, 0, 1]);
G = tf(num, den);


%then we can get the system in the i-s-u form
sys1 = ss(G);


%to study the stability osservability and reachability(controllability)
%we follow the usual process
eigenvalues  = eig(sys1.A);
if all(real(eigenvalues) < 0)
    fprintf("the system is asymptotically stable (eigenvalues: %.2f, %.2f %.2f %.2f)\n",...
             eigenvalues(1), eigenvalues(2), eigenvalues(3), eigenvalues(4));
elseif any(real(eigenvalues) > 0)
    fprintf("the system is unstable (eigenvalues: %.2f, %.2f %.2f %.2f)\n",...
             eigenvalues(1), eigenvalues(2), eigenvalues(3), eigenvalues(4));
else
    fprintf("the system is marginally stable (eigenvalues: %.2f, %.2f %.2f %.2f)\n",...
             eigenvalues(1), eigenvalues(2), eigenvalues(3), eigenvalues(4));
end

CC = ctrb(sys1.A, sys1.B);
CC_rank = rank(CC);
if CC_rank == size(sys1.A, 1)
    fprintf("  System is fully reachable (controllable).\n");
else
    fprintf("  System is PARTIALLY REACHABLE (rank=%d). Unreachable modes:\n", CC_rank);
     % PBH test to identify unreachable eigenvalues
    for k = 1:length(eigenvalues)
        pb_matrix = [sys1.A - eigenvalues(k)*eye(2), sys1.B];
        if rank(pb_matrix) < size(sys1.A, 1)
            fprintf("    λ=%.2f is UNREACHABLE (PBH rank deficient)\n", eigenvalues(k));
        end
    end
end

O = obsv(sys1.A, sys1.C);
O_rank = rank(O);
if O_rank == size(sys1.A, 1)
    fprintf("  System is fully observable.\n");
else
    fprintf("  System is PARTIALLY OBSERVABLE (rank=%d). Unobservable modes:\n", O_rank);
            

    % PBH test to identify unobservable eigenvalues
    for k = 1:length(eigenvalues)
        pb_matrix = [sys1.A - eigenvalues(k)*eye(2); sys1.C];
        if rank(pb_matrix) < size(sys1.A, 1)
            fprintf("λ=%.2f is UNOBSERVABLE (PBH rank deficient)\n", eigenvalues(k));
        end
    end
end

%we can now define the second system in discrete time
A = [0.15, 0;
  0.75, 0.05];
B = [1, 0;
  0, 1];
C = [500 500];
D = 0;
T = 1;
sys2 = ss(A, B, C, D, T);


%we now define the parameters for the simulation
k = 0:20;
u1 = 100 + 10*sin(k);
u2 = 1 + sin(k);
U = [u1' u2'];  % Combine inputs as columns


% Simulation
[y2, k2, x2] = lsim(sys2, U, k);


%we can now define the third system
A = [0 1; -1 -2];
B = [1; -1];
C = [1 0];
D = 1;
sys3 = ss(A, B, C, D);


%define the parameter for the simulation
t_span = -20 : 0.1 : 20;
u3 = (-2 + sin(5 * t_span)) .* heaviside(-t_span);
[y3, t3, x3] = lsim(sys3, u3, t_span);

%plotting the results
figure("Position", [100,100,800, 600]);
bode(G);
grid on;
figure("Position", [150,100,800, 600]);
nyquist(G);
grid on;
figure("Position", [200,100,800, 600]);
plot(k2, y2, "LineWidth", 1.5);
grid on;
xlabel("k(s)");
ylabel("y(k)");
title("discrete system response");
figure("Position", [250,100,800, 600]);
plot(t3, y3, "LineWidth", 1.5);
grid on;
xlabel("t(s)");
ylabel("y(t)");
title("third system response");