clc; clear; close all;

%Given the continuous-time LTI system:
%x_dot = A*x(t) + b*u(t) = 
%(1/3)*[3k -1 -1; -2 3k -2]*x(t) + [k; 1]*u(t),
%y(t) = c*x(t) + u(t) = [1 -1]*x(t) + u(t),
%where k ∈ ℝ is a parameter and x(t) = [x1(t); x2(t)].
%  Vary the parameter k over some significant ranges (user's choice) 
%  and display a message regarding the system's stability properties 
%  (stable, unstable, asymptotically stable).
%  Set k = -2. If possible, compute the equilibrium state of the system. 
%  Calculate the transfer function and plot the Bode diagrams. 
%  Then, plot the output response when the system is subjected to the input 
%  u(t) = (3 - cos(3t + π/4)) * heaviside(t)
%  Set k = -3. Plot the output response over the time interval [-10, 10] s 
%  when the system is subjected to the input u(t) = -2*sin(t)*heaviside(-t).


%first we declare the matrices of the system and the k values we do so by
%looping trough all the possible k values

k_vals = -3 : 0.5 : 3;

% we will analyze for the eignevalues here 
for i = 1 : length(k_vals)
    %set the value of the k
    k = k_vals(i);

    A = 1/3 * [(3 * k - 1), -1;
               -2, (3 * k - 2)];
    B = [k;
         1];
    C = [1, -1];
    D = 1;
    
    
    %we now create the system from the matrices
    sys = ss(A, B, C, D);


    %we get the eigenevalues 
    eig_vals = eig(A);
    
    %then we check for the stability we use the all function to work on all
    %the values of the array then we check if the eignevalues are
    %respecting the criteria of stability
    if all(real(eig_vals) < 0)
        fprintf('k = %.1f: System is asymptotically stable (eigenvalues: %.2f, %.2f)\n',...
                k, eig_vals(1), eig_vals(2));
    elseif any(real(eig_vals) > 0)
        fprintf('k = %.1f: System is unstable (eigenvalues: %.2f, %.2f)\n',...
                k, eig_vals(1), eig_vals(2));
    else
        fprintf('k = %.1f: System is marginally stable (eigenvalues: %.2f, %.2f)\n',...
                k, eig_vals(1), eig_vals(2));
    end
end

%set k to be equal to -two and rewrite the matrices
k = -2;
A = 1/3 * [(3 * k - 1), -1;
               -2, (3 * k - 2)];
B = [k;
     1];
C = [1, -1];
D = 1;


%we know that to get the equilibrum we need to set u_equ = 0 and then
%solve the equation for x_equilibrium since our system is LTI we can solve
%by the classic formula x_equilibrium = (A^-1*B)*u_equilibrium
u_equilibrium = 0;
x_equilibrium = -(A \ B)*u_equilibrium;
disp("the equilibrium state is:");
disp(x_equilibrium);


%then we can create the system for k = -2
sys_k2 = ss(A, B, C, D);


%and create the transfer function to plot the bode diagram
G_k2 = tf(sys_k2);


%we now create the input and simulate for the output for a certain time
%span
t_span = -10 : 0.1 : 10;
u1 = (3 - cos(3 * t_span + pi / 4)) .* heaviside(t_span);
[y1, t1, x1_max] = lsim(sys_k2, u1, t_span);


%set k to be equal to -three and rewrite the matrices
k = -3;
A = 1/3 * [(3 * k - 1), -1;
               -2, (3 * k - 2)];
B = [k;
     1];
C = [1, -1];
D = 1;


%then we can create the system for k = -3
sys_k3 = ss(A, B, C, D);


%and create the transfer function to plot the bode diagram
G_k3 = tf(sys_k2);


%we now create the input and simulate for the output 
u2 = -2 * sin(t_span) .*heaviside(-t_span);
[y2, t2, x2_max] = lsim(sys_k3, u2, t_span);



%we can now plot the results
figure("Position",[100,100,1000,800]);
subplot(2,2,[1,2]);
bode(G_k2);
grid on;

subplot(2,2,3);
plot(t1, y1)
grid on;
title("System response to u(t) = (3 - cos(3t + π/4)) * heaviside(t) ")
xlabel("t(s)");
ylabel("y(t)");

subplot(2,2,4);
plot(t2, y2)
grid on;
title("System response to u(t) = (3 - cos(3t + π/4)) * heaviside(t) ")
xlabel("t(s)");
ylabel("y(t)");