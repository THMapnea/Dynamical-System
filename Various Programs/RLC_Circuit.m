clc, clear, close all;  % Clear command window, workspace, and close all figures

% The circuit we're analyzing the evolution of RLC system for various
% values of resistance and different input values:
%
%      _______/\/\/\/\_______()()()()_______
%     |           R             L           |
%     |                                     |
%     |                                   _____
%    (|) V                              C _____                                 
%     |                                     |
%     |                                     |
%     |_____________________________________|
%
%
% Where:
% x1(t) = VC(t) (capacitor voltage)
% x2(t) = iC(t) (circuit current)
% The system equations are:
% d/dt x1(t) = -R/L x1(t) -1/L x2(t) + 1/L u(t)
% d/dt x2(t) = 1/c x1(t)
% y(t) = x2(t)


%global values used outside of the sessions

%sample value of the component
R=1;
L=5e-3;
c=1e-6;


%write the matrix that will help us define the system for the free
%evolution
Cx=eye(2);
Dx=zeros(2,1);

%% Free evolution of the system

%then we can create the matrix of the resistence that we want to test
R_list = [1, 25, 100, 500];

%since we want to evaluate for different resistence we will need to
%simulate in a for loop for every resistence
figure("Position",[100,100,1200,600])
for i = 1 : length(R_list)
    %we first take the resistence value we want to use+
    R = R_list(i);
    

    %write the matrix expression for each R value
    A = [-R/L, -1/L;
      1/c, 0];%dynamic matrix
    B = [1/L;
         0]; %input matrix
    C = [0, 1]; %exit state matrix
    D = 0; %dynamic coupling matrix
    

    %then we can get the natural frequency and the period to simulate with more
    %efficiency
    wn=abs(eig(A)); %natural frequency
    T=1/wn(1)/10; %period
    

    %set the time span where we want to analyze
    t_span = 0: T : 3e-3;


    %then we can declare some initial condition
    initial_condition = [0, 10];
       
    %we create an empty vector for the free evolution since to be in free
    %evolution we need in input a zero vector
    u = t_span * 0;
    

    %then we can finally simulate the system trough lsim, lsim takes as
    %input the matrices that define the system the input values the time
    %span and the initial condition we create the system that we want to
    %pass torughg the ss function otherwise we can directly input the
    %various matrices
    sys = ss(A, B, Cx, Dx);
    y = lsim(sys, u, t_span, initial_condition);


    %to properly show the values we build a grid containing the various
    %free evolution in regard to the resistence we used to do so we create
    %a grid that get's updated as we loop trough the first one is the
    %current the second one will be the voltage
    subplot(2, length(R_list), i);
    plot(t_span, y(:,2), 'LineWidth', 1.5);
    title(['R = ', num2str(R), ' \Omega']);
    xlabel('Time [s]');
    ylabel('i_C(t) [A]');
    grid on;
    
    subplot(2, length(R_list), length(R_list) + i);
    plot(t_span, y(:,1), 'LineWidth', 1.5);
    title(['R = ', num2str(R), ' \Omega']);
    xlabel('Time [s]');
    ylabel('VC(t) [V]');
    grid on;

end

%we can then set a general title for this plots
sgtitle("free evolution for different values of R(\Omega)");


%% Reaction to the system to Heavside function
%sample value of the component
R=1;
L=5e-3;
c=1e-6;


%write the matrix that will help us define the system for the free
%evolution
Cx=eye(2);
Dx=zeros(2,1);


%then we can create the matrix of the resistence that we want to test
R_list = [1, 25, 100, 500];

%since we want to evaluate for different resistence we will need to
%simulate in a for loop for every resistence
figure("Position",[100,100,1200,600])
for i = 1 : length(R_list)
    %we first take the resistence value we want to use+
    R = R_list(i);
    

    %write the matrix expression for each R value
    A = [-R/L, -1/L;
      1/c, 0];%dynamic matrix
    B = [1/L;
         0]; %input matrix
    C = [0, 1]; %exit state matrix
    D = 0; %dynamic coupling matrix
    

    %then we can get the natural frequency and the period to simulate with more
    %efficiency
    wn=abs(eig(A)); %natural frequency
    T=1/wn(1)/10; %period
    

    %set the time span where we want to analyze
    t_span = 0: T : 3e-3;


    %then we can declare some initial condition
    initial_condition = [0, 10];
       
    %we create an empty vector for the free evolution since to be in free
    %evolution we need in input a zero vector
    u = t_span * 0;
    

    %then we can finally simulate the system trough lsim, lsim takes as
    %input the matrices that define the system the input values the time
    %span and the initial condition we create the system that we want to
    %pass to the ss function otherwise we can directly input the
    %various matrices
    sys = ss(A, B, Cx, Dx);
    %we add 1 to the null vector to simulate a Heavside function and
    %multiply the initial condition by 0 since we want a forced response
    %from the system
    y = lsim(sys, u + 1, t_span, initial_condition * 0);


    %to properly show the values we build a grid containing the various
    %evolution in regard to the resistence we used to do so we create
    %a grid that get's updated as we loop trough the first one is the
    %current the second one will be the voltage
    subplot(2, length(R_list), i);
    plot(t_span, y(:,2), 'LineWidth', 1.5);
    title(['R = ', num2str(R), ' \Omega']);
    xlabel('Time [s]');
    ylabel('i_C(t) [A]');
    grid on;
    
    subplot(2, length(R_list), length(R_list) + i);
    plot(t_span, y(:,1), 'LineWidth', 1.5);
    title(['R = ', num2str(R), ' \Omega']);
    xlabel('Time [s]');
    ylabel('VC(t) [V]');
    grid on;

end

%we can then set a general title for this plots
sgtitle("Heavside evolution for different values of R(\Omega)");


%% Now we want to see the response to sinusoidal signal
% this time we will consider fixed values of resistance and variable values
% of frequency

% define the various constants
R = 25;
L = 5e-3;
c = 1e-6;

% define system matrices
A = [-R/L, -1/L;
      1/c, 0]; % dynamic matrix
B = [1/L;
     0];      % input matrix
C = [0, 1];   % output matrix
D = 0;

% define time span
t_span = 0 : 1e-6 : 1.2 * 4e-3;

% initial condition
initial_condition = [0; 0];

% frequencies list in Hz
f_list = [2.25e3, 3e3, 7e3, 4e4];

% prepare figure
figure("Position", [100, 100, 1200, 600])
for i = 1:length(f_list)
    f = f_list(i);

    % input sinusoid
    u = sin(2 * pi * f * t_span);

    % define system
    sys = ss(A, B, Cx, Dx);

    % simulate response
    y = lsim(sys, u, t_span, initial_condition);

    % subplot: current iC(t)
    subplot(2, length(f_list), i);
    plot(t_span, y(:, 2), 'LineWidth', 1.5);
    title(['f = ', num2str(f/1000), ' kHz']);
    xlabel('Time [s]');
    ylabel('i_C(t) [A]');
    grid on;

    % subplot: voltage VC(t)
    subplot(2, length(f_list), length(f_list) + i);
    plot(t_span, y(:, 1), 'LineWidth', 1.5);
    title(['f = ', num2str(f/1000), ' kHz']);
    xlabel('Time [s]');
    ylabel('VC(t) [V]');
    grid on;
end

sgtitle(['Sinusoidal evolution for R = ', num2str(R), ' \Omega']);


%% Frequency response (Bode magnitude) of the system for different R values

% Component values
L = 5e-3;
C = 1e-6;
R_list = [500, 100, 25, 1]; % Ohm, from overdamped to underdamped

% Frequency vector (rad/s)
f = logspace(2, 5, 3000);      % Frequency in Hz
omega = 2 * pi * f;           % Convert to rad/s

% Figure to plot
figure('Position', [100, 100, 1200, 600]);

for i = 1:length(R_list)
    R = R_list(i);

    % System matrices for state-space
    A = [-R/L, -1/L;
          1/C, 0];
    B = [1/L;
         0];
    Cx = eye(2); % We want both x1 = V_C and x2 = i_C
    D = zeros(2, 1);

    % Convert to transfer function from u(t) to x1(t)=VC and x2(t)=iC
    [num, den] = ss2tf(A, B, Cx, D);

    % Compute frequency response for both outputs trough the frequency
    % function
    H_vc = freqs(num(1,:), den, omega); % Transfer function for V_C
    H_ic = freqs(num(2,:), den, omega); % Transfer function for i_C

    % Plot magnitude response in dB
    subplot(2, length(R_list), i);
    semilogx(f, 20*log10(abs(H_ic)), 'LineWidth', 1.5);
    title(['i_C(t), R = ', num2str(R), ' \Omega']);
    xlabel('Frequency [Hz]');
    ylabel('|H(j\omega)| [dB]');
    grid on;

    subplot(2, length(R_list), length(R_list) + i);
    semilogx(f, 20*log10(abs(H_vc)), 'LineWidth', 1.5);
    title(['V_C(t), R = ', num2str(R), ' \Omega']);
    xlabel('Frequency [Hz]');
    ylabel('|H(j\omega)| [dB]');
    grid on;
end

% General title
sgtitle('Frequency Response Magnitude |H(j\omega)| for Different R Values');
