clc, clear, close all;

%the circuit of wich we want to search the trajectory is a sort of modified
%Van Der Pole Oscillator System
%     _________________________
%    |       |       |         |
%    |       |       |         |
%    |       |       |         |
%    |       (      (|)      _____ 
%   (-)       )      |       _____
%    |       (       |         |
%    |       |       |         | 
%    |       |     |_\/_|      |
%    |_______|_______|_________|




% where: 
%x1(t) = VC(t)
%x2(t) = iC(t)
%d/dt x1(t) = x2(t)
%d/dt x2(t) = (1/c)(alpha - 3betax1(t)^2)x2(t) - x1(t)

alpha = 1; %alpha parameter
beta = 1 / 3; %beta parameter
C = 1; %capacitance
L = 1; %inductance

%define the system it takes as input the timespane and the state vector
vdp = @(t,x)[x(2);
             (1 / C) * (alpha - (3 * beta * (x(1) ^ 2))) * x(2) - (1/L)*x(1)];

%now we define the time interval in wich we work 
t_span = [0 20];

%then we define the initial condition
x1_0_vals = -3:1:3;
x2_0_vals = -3:1:3;

figure("Position", [100,100, 1000,500]);
hold on;
title('Van Der Pole Oscillator Trajectory');
xlabel('x_1(t) = v_C(t)');
ylabel('x_2(t) = i_C(t)');
grid on;


%loop trough all the initial conditions

for x1_0 = x1_0_vals
    for x2_0 = x2_0_vals
        %solve the associated ode
        [T, X] = ode45(vdp,t_span,[x1_0,x2_0]);

        %plot all the ode result
        subplot(1, 2, 1);
        hold on;
        plot(X(:, 1), X(:, 2));
        title(" Result With Initial Condition Grid")
    end
end

%plot the states
subplot(1, 2, 2);
title("Flux Field");

%create a grid that is the same dimension as the initial states
[x1_grid, x2_grid] = meshgrid(-3:1:3, -3:1:3);
u = x2_grid; %arrow for the first state vector
v = (1/C)*(alpha - 3*beta*x1_grid.^2).*x2_grid - (1/L)*x1_grid;%arrow for the second state vector
streamslice(x1_grid, x2_grid, u, v); %add the arrows
