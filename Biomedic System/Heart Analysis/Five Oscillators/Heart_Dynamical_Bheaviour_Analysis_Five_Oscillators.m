clc, clear, close all;

% =========================================================================
% PROJECT: NONLINEAR HEART MODELING WITH DELAYED COUPLED OSCILLATORS
% =========================================================================
% This script implements a nonlinear dynamical system model of the heart's 
% electrical conduction system, based on the publication:
%   https://www.sciencedirect.com/science/article/pii/S2405844023000944
%
% Key Features:
% - FIVE coupled Grudzinsky-Zebrowsky type oscillators (SA node, AV node, His bundle, 
%   left and right bundle branches) as per the original paper
% - Nonlinear damping and stiffness terms
% - Time-delayed coupling between components
% - Direct numerical simulation using DDEs (no linearization)
%
% Medical context is out of scope except where it informs model behavior 
% I also do not have biomedical knowledge to correctly address the model
% behaviour so this is more of a fun project with some paper basis behind.
% =========================================================================

% =========================================================================
% MATHEMATICAL MODEL (UPDATED FOR 5 OSCILLATORS)
% =========================================================================
% The system consists of five second-order nonlinear DDEs:
%
% Oscillator 1 (SA Node):
%   dx1/dt = x2
%   dx2/dt = F1(t) - α1*(x1-v1)*(x1-v2)*x2 - (ωa^4)/(ε1*d1)*x1*(x1+d1)*(x1+ε1) 
%            + k12*(x3(t-τ12)-x1) + k13*(x5(t-τ13)-x1)
%
% Oscillator 2 (AV Node):
%   dx3/dt = x4
%   dx4/dt = F2(t) - α2*(x3-v3)*(x3-v4)*x4 - (ωa^4)/(ε2*d2)*x3*(x3+d2)*(x3+ε2) 
%            + k21*(x1(t-τ21)-x3) + k23*(x5(t-τ23)-x3)
%
% Oscillator 3 (His Bundle):
%   dx5/dt = x6
%   dx6/dt = F3(t) - α3*(x5-v5)*(x5-v6)*x6 - (ωa^4)/(ε3*d3)*x5*(x5+d3)*(x5+ε3) 
%            + k32*(x3(t-τ32)-x5) + k34*(x7(t-τ34)-x5) + k35*(x9(t-τ35)-x5)
%
% Oscillator 4 (Left Bundle Branch):
%   dx7/dt = x8
%   dx8/dt = F4(t) - α4*(x7-v7)*(x7-v8)*x8 - (ωa^4)/(ε4*d4)*x7*(x7+d4)*(x7+ε4) 
%            + k43*(x5(t-τ43)-x7)
%
% Oscillator 5 (Right Bundle Branch):
%   dx9/dt = x10
%   dx10/dt = F5(t) - α5*(x9-v9)*(x9-v10)*x10 - (ωa^4)/(ε5*d5)*x9*(x9+d5)*(x9+ε5) 
%            + k53*(x5(t-τ53)-x9)
%
% Variable Definitions:
%   x1,x3,x5,x7,x9: Position-like states (electrical potentials)
%   x2,x4,x6,x8,x10: Velocity-like states (rate of change)
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
% PARAMETER INITIALIZATION (UPDATED FOR 5 OSCILLATORS)
% =========================================================================
% All parameters are organized in a structure 'params' for clean passing to
% the DDE function. Values are adjusted from the referenced paper's Table 1.
% =========================================================================

% -------------------------------
% 1. General Constants
% -------------------------------
params.mu1 = 0.4;    % Weight for SA node contribution
params.mu2 = 0.3;    % Weight for AV node contribution
params.mu3 = 0.15;   % Weight for His bundle contribution
params.mu4 = 0.1;    % Weight for left bundle branch
params.mu5 = 0.1;    % Weight for right bundle branch

% -------------------------------
% 2. SA Node Parameters
% -------------------------------
params.alpha1 = 1.2;   
params.v1 = 0.2;      
params.v2 = -0.1;     
params.c1 = 1.0;      
params.d1 = 1.0;      
params.tau12 = 0.1;   % Delay from SA to AV node
params.tau13 = 0.15;  % Delay from SA to His bundle
params.k12 = 0.5;     % Coupling SA to AV
params.k13 = 0.3;     % Coupling SA to His
params.omega0_SA = 1.0; 
params.beta1 = 0.5;    
params.omega1 = 0.8;   
params.F1 = @(t) params.beta1 * sin(params.omega1 * t);

% -------------------------------
% 3. AV Node Parameters
% -------------------------------
params.alpha2 = 1.0;   
params.v3 = 0.15;      
params.v4 = -0.05;     
params.c2 = 1.0;       
params.d2 = 1.0;       
params.tau21 = 0.1;    % Delay from AV to SA node
params.tau23 = 0.2;    % Delay from AV to His bundle
params.k21 = 0.3;      % Coupling AV to SA
params.k23 = 0.4;      % Coupling AV to His
params.omega0_AV = 0.6; 
params.beta2 = 0.3;    
params.omega2 = 0.6;   
params.F2 = @(t) params.beta2 * sin(params.omega2 * t);

% -------------------------------
% 4. His Bundle Parameters
% -------------------------------
params.alpha3 = 0.8;   
params.v5 = 0.1;       
params.v6 = -0.08;     
params.c3 = 1.0;       
params.d3 = 1.0;       
params.tau32 = 0.15;   % Delay from His to AV node
params.tau34 = 0.1;    % Delay from His to left bundle
params.tau35 = 0.1;    % Delay from His to right bundle
params.k32 = 0.2;      % Coupling His to AV
params.k34 = 0.3;      % Coupling His to left bundle
params.k35 = 0.3;      % Coupling His to right bundle
params.omega0_His = 0.4; 
params.beta3 = 0.2;    
params.omega3 = 0.4;   
params.F3 = @(t) params.beta3 * sin(params.omega3 * t);

% -------------------------------
% 5. Left Bundle Branch Parameters
% -------------------------------
params.alpha4 = 0.6;   
params.v7 = 0.08;      
params.v8 = -0.06;     
params.c4 = 0.8;       
params.d4 = 0.8;       
params.tau43 = 0.1;    % Delay from left bundle to His
params.k43 = 0.2;      % Coupling left bundle to His
params.omega0_LBB = 0.3; 
params.beta4 = 0.15;    
params.omega4 = 0.3;   
params.F4 = @(t) params.beta4 * sin(params.omega4 * t);

% -------------------------------
% 6. Right Bundle Branch Parameters
% -------------------------------
params.alpha5 = 0.6;   
params.v9 = 0.08;      
params.v10 = -0.06;     
params.c5 = 0.8;       
params.d5 = 0.8;       
params.tau53 = 0.1;    % Delay from right bundle to His
params.k53 = 0.2;      % Coupling right bundle to His
params.omega0_RBB = 0.3; 
params.beta5 = 0.15;    
params.omega5 = 0.3;   
params.F5 = @(t) params.beta5 * sin(params.omega5 * t);

% -------------------------------
% 7. Initial Conditions
% -------------------------------
initial_conditions = [0.1; 0.0;   % SA node (x1, x2)
                     0.05; 0.0;   % AV node (x3, x4)
                     0.02; 0.0;   % His bundle (x5, x6)
                     0.01; 0.0;   % Left bundle branch (x7, x8)
                     0.01; 0.0];  % Right bundle branch (x9, x10)

% -------------------------------
% 8. Delays (for dde23)
% -------------------------------
lags = [params.tau12, params.tau13, params.tau21, params.tau23, ...
        params.tau32, params.tau34, params.tau35, params.tau43, params.tau53];

% -------------------------------
% 9. Time Span for Simulation
% -------------------------------
tspan = 0:0.01:30;  % Simulate for 30 seconds with 0.01s steps

% -------------------------------
% 10. Solution of the DDE
% -------------------------------
history = initial_conditions;
sol = dde23(@(t,y,Z) dde_equations_five_oscillators(t,y,Z,params), lags, history, tspan);

% =========================================================================
% OPTIMIZED RESULT VISUALIZATION 
% =========================================================================

% Define the cases we want to simulate
cases = {
    'normal',        ... % Healthy rhythm (baseline)
    'bradycardia',   ... % Slow heart rate
    'pvc',           ... % Premature ventricular contraction
    'tachycardia'    ... % Fast heart rate
};

% Map case names to display titles
case_titles = containers.Map(...
    {'normal', 'bradycardia', 'pvc', 'tachycardia'}, ...
    {'Normal Sinus Rhythm', 'Bradycardia (AV Block)', ...
     'PVC / Atrial Fibrillation', 'Tachycardia / Ventricular Fibrillation'} ...
);
% Define color scheme for consistent visualization
osc_colors = lines(5); % Distinct colors for each oscillator
ecg_color = [0 0.5 0]; % Dark green for ECG
case_colors = [0 0.447 0.741;   % Normal - blue
               0.85 0.325 0.098; % Bradycardia - red
               0.929 0.694 0.125; % PVC - yellow
               0.494 0.184 0.556]; % Tachycardia - purple

% Set default figure properties for better rendering
set(0, 'DefaultAxesFontSize', 10, 'DefaultAxesFontWeight', 'bold', ...
    'DefaultLineLineWidth', 1.5);

% 1. MAIN COMPARISON FIGURE (Time Traces + ECG)
mainFig = figure('Position', [100, 100, 1400, 900], 'Name', 'Heart Rhythm Comparison', ...
    'Color', 'w');
tiledlayout(4, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

for i = 1:4
    [params, case_name] = generate_heart_parameters_five_oscillators(cases{i});
    sol = dde23(@(t,y,Z) dde_equations_five_oscillators(t,y,Z,params), lags, initial_conditions, tspan);
    
    % Create synthetic ECG with realistic morphology
    ecg_signal = generate_realistic_ecg(sol, params);
    
    % Time Traces Plot
    nexttile;
    hold on;
    plot(sol.x, sol.y(1,:), 'Color', osc_colors(1,:)); % SA node
    plot(sol.x, sol.y(3,:), 'Color', osc_colors(2,:)); % AV node
    plot(sol.x, sol.y(5,:), 'Color', osc_colors(3,:)); % His bundle
    plot(sol.x, sol.y(7,:), 'Color', osc_colors(4,:)); % Left bundle
    plot(sol.x, sol.y(9,:), 'Color', osc_colors(5,:)); % Right bundle
    hold off;
    
    title(['Time Traces: ' case_titles(cases{i})], 'FontSize', 12);
    xlabel('Time (s)'); ylabel('Potential (mV)');
    legend({'SA node', 'AV node', 'His bundle', 'LBB', 'RBB'}, 'Location', 'best');
    grid on; ylim([-1.2 1.2]);
    set(gca, 'FontWeight', 'bold');
    
    % ECG Plot
    nexttile;
    plot(sol.x, ecg_signal, 'Color', ecg_color);
    title(['Synthetic ECG: ' case_titles(cases{i})], 'FontSize', 12);
    xlabel('Time (s)'); ylabel('Amplitude (mV)');
    grid on; ylim([-2 2]);
    set(gca, 'FontWeight', 'bold');
end

% 2. PHASE PORTRAIT COMPARISON (All cases)
phaseFig = figure('Position', [200, 200, 1200, 800], 'Name', 'Phase Portrait Comparison', ...
    'Color', 'w');
tiledlayout(2, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

% SA Node Phase Portrait
nexttile; hold on;
for i = 1:4
    [params, ~] = generate_heart_parameters_five_oscillators(cases{i});
    sol = dde23(@(t,y,Z) dde_equations_five_oscillators(t,y,Z,params), lags, initial_conditions, tspan);
    plot(sol.y(1,:), sol.y(2,:), 'Color', case_colors(i,:), ...
        'DisplayName', case_titles(cases{i}));
end
title('SA Node Phase Portrait');
xlabel('Potential (mV)'); ylabel('Velocity');
legend('Location', 'best'); grid on;

% AV Node Phase Portrait
nexttile; hold on;
for i = 1:4
    [params, ~] = generate_heart_parameters_five_oscillators(cases{i});
    sol = dde23(@(t,y,Z) dde_equations_five_oscillators(t,y,Z,params), lags, initial_conditions, tspan);
    plot(sol.y(3,:), sol.y(4,:), 'Color', case_colors(i,:));
end
title('AV Node Phase Portrait');
xlabel('Potential (mV)'); ylabel('Velocity');
grid on;

% His Bundle Phase Portrait
nexttile; hold on;
for i = 1:4
    [params, ~] = generate_heart_parameters_five_oscillators(cases{i});
    sol = dde23(@(t,y,Z) dde_equations_five_oscillators(t,y,Z,params), lags, initial_conditions, tspan);
    plot(sol.y(5,:), sol.y(6,:), 'Color', case_colors(i,:));
end
title('His Bundle Phase Portrait');
xlabel('Potential (mV)'); ylabel('Velocity');
grid on;

% Left Bundle Phase Portrait
nexttile; hold on;
for i = 1:4
    [params, ~] = generate_heart_parameters_five_oscillators(cases{i});
    sol = dde23(@(t,y,Z) dde_equations_five_oscillators(t,y,Z,params), lags, initial_conditions, tspan);
    plot(sol.y(7,:), sol.y(8,:), 'Color', case_colors(i,:));
end
title('Left Bundle Phase Portrait');
xlabel('Potential (mV)'); ylabel('Velocity');
grid on;

% Right Bundle Phase Portrait
nexttile; hold on;
for i = 1:4
    [params, ~] = generate_heart_parameters_five_oscillators(cases{i});
    sol = dde23(@(t,y,Z) dde_equations_five_oscillators(t,y,Z,params), lags, initial_conditions, tspan);
    plot(sol.y(9,:), sol.y(10,:), 'Color', case_colors(i,:));
end
title('Right Bundle Phase Portrait');
xlabel('Potential (mV)'); ylabel('Velocity');
grid on;

% 3D Phase Space
nexttile; hold on;
for i = 1:4
    [params, ~] = generate_heart_parameters_five_oscillators(cases{i});
    sol = dde23(@(t,y,Z) dde_equations_five_oscillators(t,y,Z,params), lags, initial_conditions, tspan);
    plot3(sol.y(1,:), sol.y(3,:), sol.y(5,:), 'Color', case_colors(i,:));
end
title('3D Phase Space (SA-AV-His)');
xlabel('SA'); ylabel('AV'); zlabel('His');
grid on; view(3);
rotate3d on;

% 3. ECG COMPARISON FIGURE (All cases)
ecgFig = figure('Position', [300, 300, 1000, 600], 'Name', 'ECG Signal Comparison', ...
    'Color', 'w');
hold on;

% Create shaded error regions for each ECG
for i = 1:4
    [params, ~] = generate_heart_parameters_five_oscillators(cases{i});
    sol = dde23(@(t,y,Z) dde_equations_five_oscillators(t,y,Z,params), lags, initial_conditions, tspan);
    ecg_signal = generate_realistic_ecg(sol, params);
    
    % Plot with thicker lines for main cases
    p(i) = plot(sol.x, ecg_signal, 'Color', case_colors(i,:), ...
        'LineWidth', 2.5, 'DisplayName', case_titles(cases{i}));
end

title('Comparison of ECG Signals Across Conditions', 'FontSize', 14);
xlabel('Time (s)', 'FontWeight', 'bold');
ylabel('ECG Amplitude (mV)', 'FontWeight', 'bold');
legend(p, 'Location', 'northeast');
grid on; 
xlim([0 5]); % Focus on first 5 seconds for clarity
ylim([-2 2]);
set(gca, 'FontWeight', 'bold', 'LineWidth', 1.5);

