clc; clear; close all;
% Consider the following continuous-time LTI dynamical system:
% 
% x_dot(t) = A*x(t) + b*u(t) = [0      1    ] * x(t) + [1  ] * u(t)
%                               [-α^2   -β^2 2α]         [α  ]
% 
% y(t) = c*x(t) + d*u(t) = [1 0] * x(t) + u(t),
% 
% where α, β ∈ ℝ. Vary the parameters α and β over a meaningful range and 
% automatically classify the system's stability. Repeat the same for 
% observability and reachability.
% From now on, set α = -1 and β = 1. 
% Plot the forced output of the system when the input is u(t) = (-2 + sin(5t))·u_{-1}(t) 
% (where u_{-1}(t) is the unit step function) over t ∈ [-20, 20].
% Plot the Bode and Nyquist diagrams of the system in two separate figures.


% First, declare the alpha and beta range in which we will work 
alpha_values = -3 : 1 : 3;
beta_values = -3 : 1 : 3;


% Define output matrices (constant for all cases)
C = [1, 0];
D = 1;


% Loop to check stability, reachability, and observability for each (α,β) pair
for i = 1 : length(alpha_values)
    alpha = alpha_values(i);
    for j = 1 : length(beta_values)
        beta = beta_values(j);

        % Build system matrices
        A = [0,                       1;
             -alpha^2 - beta^2,    2*alpha];  
        B = [1; 
             alpha];


        % Check eigenvalues to determine stability
        eigenvalues = eig(A);
        if all(real(eigenvalues) < 0)
            fprintf("α=%.f, β=%.f: System is asymptotically stable (eigenvalues: %.2f, %.2f)\n", ...
                    alpha, beta, eigenvalues(1), eigenvalues(2));
        elseif any(real(eigenvalues) > 0)
            fprintf("α=%.f, β=%.f: System is unstable (eigenvalues: %.2f, %.2f)\n", ...
                    alpha, beta, eigenvalues(1), eigenvalues(2));
        else
            fprintf("α=%.f, β=%.f: System is marginally stable (eigenvalues: %.2f, %.2f)\n", ...
                    alpha, beta, eigenvalues(1), eigenvalues(2));
        end


        % Compute controllability matrix and its rank
        CC = ctrb(A, B);
        CC_rank = rank(CC);
        if CC_rank == size(A, 1)
            fprintf("  System is fully reachable (controllable).\n");
        else
            fprintf("  System is PARTIALLY REACHABLE (rank=%d). Unreachable modes:\n", CC_rank);
            

            % PBH test to identify unreachable eigenvalues
            for k = 1:length(eigenvalues)
                pb_matrix = [A - eigenvalues(k)*eye(2), B];
                if rank(pb_matrix) < size(A, 1)
                    fprintf("    λ=%.2f is UNREACHABLE (PBH rank deficient)\n", eigenvalues(k));
                end
            end
        end


        % Compute observability matrix and its rank
        O = obsv(A, C);
        O_rank = rank(O);
        if O_rank == size(A, 1)
            fprintf("  System is fully observable.\n");
        else
            fprintf("  System is PARTIALLY OBSERVABLE (rank=%d). Unobservable modes:\n", O_rank);
            

            % PBH test to identify unobservable eigenvalues
            for k = 1:length(eigenvalues)
                pb_matrix = [A - eigenvalues(k)*eye(2); C];
                if rank(pb_matrix) < size(A, 1)
                    fprintf("    λ=%.2f is UNOBSERVABLE (PBH rank deficient)\n", eigenvalues(k));
                end
            end
        end


        % Eliminate unreachable/unobservable states
        sys = ss(A, B, C, D);
        sys_min = minreal(sys);
        if order(sys_min) < order(sys)
            fprintf("  Minimal realization order: %d (original: %d)\n", ...
                    order(sys_min), order(sys));
        end
        fprintf("----------------------------------------\n");
    end
end


%now we can set alpha and beta and create the system and it's transfer
%function
alpha = -1; 
beta = 1; 
t_span = -20 : 0.1 : 20;
A = [0,                       1;
     -alpha^2 - beta^2,    2*alpha];
B = [1; 
     alpha];
C = [1, 0];
D = 1;
sys = ss(A, B, C, D);
G = tf(sys);
u = (-2 + sin(5 * t_span)) .* heaviside(t_span);


%we can now simulate to get the forced response
[y, t, x] = lsim(sys, u, t_span);


%plotting the result
figure("Position",[100,100,1000,600]);
bode(G);
grid on;
figure("Position",[200,100,1000,600]);
nyquist(G);
grid on;
figure("Position",[300,100,1000,600]);
plot(t, y, "LineWidth", 1.5);
grid on;
title("forced response to u = (-2 + sin(5 * t_span)) .* heaviside(t_span)")
xlim([-20, 20]);
ylabel("y(t)");
xlabel("t(s)");

