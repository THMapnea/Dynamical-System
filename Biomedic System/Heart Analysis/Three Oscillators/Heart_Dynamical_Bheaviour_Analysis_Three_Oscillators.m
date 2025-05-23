clc, clear, close all;

% =========================================================================
% PROJECT: NONLINEAR HEART MODELING WITH DELAYED COUPLED OSCILLATORS
% =========================================================================
% This script implements a nonlinear dynamical system model of the heart's 
% electrical conduction system, based on the publication:
%   https://www.sciencedirect.com/science/article/pii/S2405844023000944
%
% Key Features:
% - Three coupled Grudzinsky-Zebrowsky type oscillators (SA node, AV node, Purkinje fibers)
% - Nonlinear damping and stiffness terms
% - Time-delayed coupling between components
% - Direct numerical simulation using DDEs (no linearization)
%
% Medical context is out of scope except where it informs model behavior 
% I also do not have biomedical knowledge to correctly address the model
% bheaviour so this is more of a fun project with some paper basis bheind.
% =========================================================================

% =========================================================================
% MATHEMATICAL MODEL
% =========================================================================
% The system consists of three second-order nonlinear DDEs:
%
% Oscillator 1 (SA Node):
%   dx1/dt = x2
%   dx2/dt = F1(t) - α1*(x1-v1)*(x1-v2)*x2 - (ωa^4)/(ε1*d1)*x1*(x1+d1)*(x1+ε1) 
%            + k13*(x3(t-τ13)-x1) + k15*(x5(t-τ15)-x1)
%
% Oscillator 2 (AV Node):
%   dx3/dt = x4
%   dx4/dt = F2(t) - α2*(x3-v3)*(x3-v4)*x4 - (ωa^4)/(ε2*d2)*x3*(x3+d2)*(x3+ε2) 
%            + k31*(x1(t-τ31)-x3) + k35*(x5(t-τ35)-x3)
%
% Oscillator 3 (Purkinje Fibers):
%   dx5/dt = x6
%   dx6/dt = F3(t) - α3*(x5-v5)*(x5-v6)*x6 - (ωa^4)/(ε3*d3)*x5*(x5+d3)*(x5+ε3) 
%            + k53*(x3(t-τ53)-x5) + k51*(x1(t-τ51)-x5)
%
% Variable Definitions:
%   x1,x3,x5: Position-like states (electrical potentials)
%   x2,x4,x6: Velocity-like states (rate of change)
%   Fi(t):    External stimuli (sinusoidal pacemaker inputs)
%   αi:       Nonlinear damping coefficients
%   vi:       Potential shift parameters
%   ωa,εi,di: Stiffness parameters for cubic nonlinearities
%   ki-j:     Coupling strengths between oscillators
%   τi-j:     Time delays in coupling
%
% Numerical Approach:
% - Solved using MATLAB's dde23 solver
% - Preserves nonlinear/chaotic behavior by avoiding equilibrium linearization
% =========================================================================

% =========================================================================
% PARAMETER INITIALIZATION
% =========================================================================
% All parameters are organized in a structure 'params' for clean passing to
% the DDE function. Values are from the referenced paper's Table 1.
% =========================================================================


% -------------------------------
% 1. General Constants
% -------------------------------
params.mu1 = 0.4;    % Weight for SA node contribution (CHANGED from 0.1)
params.mu2 = 0.3;    % Weight for AV node contribution (CHANGED from 0.05)
params.mu3 = 0.2;    % Weight for Purkinje fibers contribution (CHANGED from 0.4)

% -------------------------------
% 2. SA Node Parameters (Sinoatrial Node)
% -------------------------------
params.alpha1 = 1.2;   % Nonlinear damping coefficient (CHANGED from 3.0)
params.v1 = 0.2;       % Potential parameter (previously eta1_SA)
params.v2 = -0.1;      % Potential parameter (CHANGED from -1.9)
params.c1 = 1.0;       % Stiffness coefficient (CHANGED from 4.9)
params.d1 = 1.0;       % Restoring force parameter (CHANGED from 3.0)
params.tau13_SA = 0.1; % Delay from SA to AV node (CHANGED from 1e-6)
params.k13 = 0.5;      % Coupling SA to AV (CHANGED from 1.0)
params.omega0_SA = 1.0; % Natural frequency (CHANGED from 4.583)
params.beta1 = 0.5;    % Amplitude of external stimulus (CHANGED from 1.0)
params.omega1 = 0.8;   % Frequency of SA node stimulus (CHANGED from 1.0)
params.F1 = @(t) params.beta1 * sin(params.omega1 * t);

% -------------------------------
% 3. AV Node Parameters (Atrioventricular Node)
% -------------------------------
params.alpha2 = 1.0;   % Nonlinear damping coefficient (CHANGED from 3.0)
params.v3 = 0.15;      % Potential parameter (CHANGED from 0.2)
params.v4 = -0.05;     % Potential parameter (CHANGED from -0.1)
params.c2 = 1.0;       % Stiffness coefficient (CHANGED from 3.0)
params.d2 = 1.0;       % Restoring force parameter (CHANGED from 3.0)
params.tau13_AV = 0.2; % Delay from AV to Purkinje (CHANGED from 0.8)
params.k31 = 0.3;      % Coupling AV to SA (CHANGED from 1.0)
params.omega0_AV = 0.6; % Natural frequency (CHANGED from 3.0)
params.beta2 = 0.3;    % Amplitude of AV stimulus (CHANGED from 1.0)
params.omega2 = 0.6;   % Frequency of AV node stimulus (CHANGED from 1.0)
params.F2 = @(t) params.beta2 * sin(params.omega2 * t);

% -------------------------------
% 4. Purkinje Fibers Parameters
% -------------------------------
params.alpha3 = 0.8;   % Nonlinear damping coefficient (CHANGED from 3.0)
params.v5 = 0.1;       % Potential parameter (CHANGED from 1.1)
params.v6 = -0.08;     % Potential parameter (CHANGED from -1.0)
params.c3 = 1.0;       % Stiffness coefficient (CHANGED from 7.0)
params.d3 = 1.0;       % Restoring force parameter (CHANGED from 3.0)
params.tau23_PF = 0.1; % Delay from Purkinje back to AV node
params.k53 = 0.2;      % Coupling Purkinje to AV (CHANGED from 1.0)
params.omega0_PF = 0.4; % Natural frequency (CHANGED from 4.583)
params.beta3 = 0.2;    % Amplitude of Purkinje stimulus (CHANGED from 1.0)
params.omega3 = 0.4;   % Frequency of Purkinje stimulus (CHANGED from 1.0)
params.F3 = @(t) params.beta3 * sin(params.omega3 * t);

% -------------------------------
% 5. Initial Conditions
% -------------------------------
initial_conditions = [0.1; 0.0;   % SA node (x1, x2) (CHANGED from [0.01; 0.04])
                     0.05; 0.0;   % AV node (x3, x4) (CHANGED from [0.01; 0.04])
                     0.02; 0.0];  % Purkinje fibers (x5, x6) (CHANGED from [0.01; 0.04])


% -------------------------------
% 6. Delays (for dde23)
% -------------------------------
lags = [params.tau13_SA, params.tau13_AV, params.tau23_PF];

% -------------------------------
% 7. Time Span for Simulation
% -------------------------------
tspan = 0 : 0.5 : 10;  % Simulate for 100 seconds

% -------------------------------
% 8. Solution of the DDE
% -------------------------------
history = initial_conditions;
sol = dde23(@(t,y,Z) dde_equations_three_oscillators(t,y,Z,params), lags, history, tspan);

% -------------------------------
% Result Plotting
% -------------------------------
% Define the cases we want to simulate
cases = {
    'normal',        ... % Healthy rhythm (baseline)
    'bradycardia',   ... % Atrioventricular block)
    'pvc',           ... % Atrial fibrillation)
    'tachycardia'    ... % Ventricular fibrillation)
};

% Map case names to display titles and line styles
case_titles = containers.Map(...
    {'normal', 'bradycardia', 'pvc', 'tachycardia'}, ...
    {'Normal Sinus Rhythm', 'Bradycardia (AV Block)', ...
     'PVC / Atrial Fibrillation', 'Tachycardia / Ventricular Fibrillation'} ...
);

case_colors = containers.Map(...
    {'normal', 'bradycardia', 'pvc', 'tachycardia'}, ...
    {'b', 'r', 'm', 'k'} ...
);

case_linewidths = containers.Map(...
    {'normal', 'bradycardia', 'pvc', 'tachycardia'}, ...
    {1.5, 1.2, 1.2, 1.5} ...
);

% Create figure for time traces comparison
figure('Position', [100, 100, 1200, 800]);
for i = 1:4
    [params, case_name] = generate_heart_parameters_three_oscillators(cases{i});
    initial_conditions = [0.01; 0.04; 0.01; 0.04; 0.01; 0.04];
    lags = [params.tau13_SA, params.tau13_AV, params.tau23_PF];
    sol = dde23(@(t,y,Z) dde_equations_three_oscillators(t,y,Z,params), lags, initial_conditions, tspan);
    
    subplot(2, 2, i);
    plot(sol.x, sol.y(1,:), 'b', sol.x, sol.y(3,:), 'r', sol.x, sol.y(5,:), 'g');
    xlabel('Time (s)'); ylabel('Activity');
    title(case_titles(cases{i}));
    legend('SA node', 'AV node', 'Purkinje');
    grid on; ylim([-2 2]);
end
sgtitle('Comparison of Heart Rhythm Abnormalities', 'FontSize', 14);

% Create figures for each case (individual analysis)
for i = 1:4
    [params, case_name] = generate_heart_parameters_three_oscillators(cases{i});
    initial_conditions = [0.01; 0.04; 0.01; 0.04; 0.01; 0.04];
    lags = [params.tau13_SA, params.tau13_AV, params.tau23_PF];
    sol = dde23(@(t,y,Z) dde_equations_three_oscillators(t,y,Z,params), lags, initial_conditions, tspan);
    
    figure('Position', [100+(i-1)*50, 100+(i-1)*50, 1000, 800], ...
           'Name', case_titles(cases{i}));
    
    % Time Traces
    subplot(2,2,1);
    plot(sol.x, sol.y(1,:), 'b', 'LineWidth', 1.5); hold on;
    plot(sol.x, sol.y(3,:), 'r', 'LineWidth', 1.5);
    plot(sol.x, sol.y(5,:), 'g', 'LineWidth', 1.5);
    xlabel('Time (s)'); ylabel('Activity');
    title(['Time Traces: ' case_titles(cases{i})]);
    legend('SA node', 'AV node', 'Purkinje');
    grid on; ylim([-2 2]);
    
    % Phase Portraits
    subplot(2,2,2);
    plot(sol.y(1,:), sol.y(2,:), 'b', 'LineWidth', 1.5);
    xlabel('SA Potential'); ylabel('SA Velocity');
    title('SA Node Phase Portrait'); grid on;
    
    subplot(2,2,3);
    plot(sol.y(3,:), sol.y(4,:), 'r', 'LineWidth', 1.5);
    xlabel('AV Potential'); ylabel('AV Velocity');
    title('AV Node Phase Portrait'); grid on;
    
    subplot(2,2,4);
    plot(sol.y(5,:), sol.y(6,:), 'g', 'LineWidth', 1.5);
    xlabel('Purkinje Potential'); ylabel('Purkinje Velocity');
    title('Purkinje Phase Portrait'); grid on;
    
    sgtitle(case_titles(cases{i}), 'FontSize', 14);
end

% Create comparison figure for phase portraits
figure('Position', [200, 200, 1400, 900], 'Name', 'Phase Portrait Comparison');

% SA Node Comparison
subplot(2,2,1); hold on; grid on;
for i = 1:4
    [params, case_name] = generate_heart_parameters_three_oscillators(cases{i});
    initial_conditions = [0.01; 0.04; 0.01; 0.04; 0.01; 0.04];
    lags = [params.tau13_SA, params.tau13_AV, params.tau23_PF];
    sol = dde23(@(t,y,Z) dde_equations_three_oscillators(t,y,Z,params), lags, initial_conditions, tspan);
    
    plot(sol.y(1,:), sol.y(2,:), ...
         'Color', case_colors(cases{i}), ...
         'LineWidth', case_linewidths(cases{i}), ...
         'DisplayName', case_titles(cases{i}));
end
xlabel('SA Node Potential (x1)'); 
ylabel('SA Node Velocity (x2)');
title('SA Node Phase Portraits (All Cases)');
legend('Location', 'bestoutside');
axis tight;

% AV Node Comparison
subplot(2,2,2); hold on; grid on;
for i = 1:4
    [params, ~] = generate_heart_parameters_three_oscillators(cases{i});
    sol = dde23(@(t,y,Z) dde_equations_three_oscillators(t,y,Z,params), lags, initial_conditions, tspan);
    
    plot(sol.y(3,:), sol.y(4,:), ...
         'Color', case_colors(cases{i}), ...
         'LineWidth', case_linewidths(cases{i}), ...
         'DisplayName', case_titles(cases{i}));
end
xlabel('AV Node Potential (x3)'); 
ylabel('AV Node Velocity (x4)');
title('AV Node Phase Portraits (All Cases)');
legend('Location', 'bestoutside');
axis tight;

% Purkinje Fibers Comparison
subplot(2,2,3); hold on; grid on;
for i = 1:4
    [params, ~] = generate_heart_parameters_three_oscillators(cases{i});
    sol = dde23(@(t,y,Z) dde_equations_three_oscillators(t,y,Z,params), lags, initial_conditions, tspan);
    
    plot(sol.y(5,:), sol.y(6,:), ...
         'Color', case_colors(cases{i}), ...
         'LineWidth', case_linewidths(cases{i}), ...
         'DisplayName', case_titles(cases{i}));
end
xlabel('Purkinje Potential (x5)'); 
ylabel('Purkinje Velocity (x6)');
title('Purkinje Fibers Phase Portraits (All Cases)');
legend('Location', 'bestoutside');
axis tight;

% Combined Phase Space (3D)
subplot(2,2,4); hold on; grid on;
for i = 1:4
    [params, ~] = generate_heart_parameters_three_oscillators(cases{i});
    sol = dde23(@(t,y,Z) dde_equations_three_oscillators(t,y,Z,params), lags, initial_conditions, tspan);
    
    plot3(sol.y(1,:), sol.y(3,:), sol.y(5,:), ...
          'Color', case_colors(cases{i}), ...
          'LineWidth', case_linewidths(cases{i}), ...
          'DisplayName', case_titles(cases{i}));
end
xlabel('SA Node'); ylabel('AV Node'); zlabel('Purkinje');
title('3D Phase Space (All Cases)');
legend('Location', 'bestoutside');
view(3); axis tight;
rotate3d on;

sgtitle('Phase Portrait Comparison Across Heart Rhythm Conditions', 'FontSize', 16);