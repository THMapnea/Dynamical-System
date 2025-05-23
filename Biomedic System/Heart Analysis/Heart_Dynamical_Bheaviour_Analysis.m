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
params.mu1 = 0.1;    % Weight for SA node contribution
params.mu2 = 0.05;   % Weight for AV node contribution
params.mu3 = 0.4;    % Weight for Purkinje fibers contribution

% -------------------------------
% 2. SA Node Parameters (Sinoatrial Node)
% -------------------------------
params.alpha1 = 3.0;   % Nonlinear damping coefficient
params.v1 = 0.2;       % Potential parameter (previously eta1_SA)
params.v2 = -1.9;      % Potential parameter (previously eta2_SA)
params.c1 = 4.9;       % Stiffness coefficient
params.d1 = 3.0;       % Restoring force parameter
params.tau13_SA = 1e-6; % Delay from SA to AV node (must be >0)
params.k13 = 1.0;      % Coupling SA to AV
params.omega0_SA = 4.583; % Natural frequency (rad/s)
params.beta1 = 1.0;    % Amplitude of external stimulus
params.omega1 = 1.0;   % Frequency of SA node stimulus
params.F1 = @(t) params.beta1 * sin(params.omega1 * t);

% -------------------------------
% 3. AV Node Parameters (Atrioventricular Node)
% -------------------------------
params.alpha2 = 3.0;   % Nonlinear damping coefficient
params.v3 = 0.2;       % Potential parameter (previously eta1_AV)
params.v4 = -0.1;      % Potential parameter (previously eta2_AV)
params.c2 = 3.0;       % Stiffness coefficient
params.d2 = 3.0;       % Restoring force parameter
params.tau13_AV = 0.8; % Delay from AV to Purkinje
params.k31 = 1.0;      % Coupling AV to SA
params.omega0_AV = 3.0; % Natural frequency (rad/s)
params.beta2 = 1.0;    % Amplitude of AV stimulus
params.omega2 = 1.0;   % Frequency of AV node stimulus
params.F2 = @(t) params.beta2 * sin(params.omega2 * t);

% -------------------------------
% 4. Purkinje Fibers Parameters
% -------------------------------
params.alpha3 = 3.0;   % Nonlinear damping coefficient
params.v5 = 1.1;       % Potential parameter (previously eta1_PF)
params.v6 = -1.0;      % Potential parameter (previously eta2_PF)
params.c3 = 7.0;       % Stiffness coefficient
params.d3 = 3.0;       % Restoring force parameter
params.tau23_PF = 0.1; % Delay from Purkinje back to AV node
params.k53 = 1.0;      % Coupling Purkinje to AV
params.omega0_PF = 4.583; % Natural frequency (rad/s)
params.beta3 = 1.0;    % Amplitude of Purkinje stimulus
params.omega3 = 1.0;   % Frequency of Purkinje stimulus
params.F3 = @(t) params.beta3 * sin(params.omega3 * t);

% -------------------------------
% 5. Initial Conditions
% -------------------------------
initial_conditions = [0.01; 0.04;  % SA node (x1, x2)
                     0.01; 0.04;   % AV node (x3, x4)
                     0.01; 0.04];  % Purkinje fibers (x5, x6)

% -------------------------------
% 6. Delays (for dde23)
% -------------------------------
lags = [params.tau13_SA, params.tau13_AV, params.tau23_PF];

% -------------------------------
% 7. Time Span for Simulation
% -------------------------------
tspan = [0 100];  % Simulate for 100 seconds

% -------------------------------
% 8. Solution of the DDE
% -------------------------------
history = initial_conditions;
sol = dde23(@(t,y,Z) dde_equations(t,y,Z,params), lags, history, tspan);

% -------------------------------
% Result Plotting
% -------------------------------
% Define the cases we want to simulate
cases = {
    'normal',        ... % Healthy rhythm (baseline)
    'bradycardia',   ... % Atrioventricular block
    'pvc',           ... % Atrial fibrillation
    'tachycardia'    ... % Ventricular fibrillation
};

% Map case names to display titles
case_titles = containers.Map(...
    {'normal', 'bradycardia', 'pvc', 'tachycardia'}, ...
    {'Normal Sinus Rhythm', 'Bradycardia (AV Block)', ...
     'PVC / Atrial Fibrillation', 'Tachycardia / Ventricular Fibrillation'} ...
);

% Create figure for subplots
figure('Position', [100, 100, 1200, 800]);

% Simulate and plot each case
for i = 1:4
    % Generate parameters for this case
    [params, case_name] = generate_heart_parameters(cases{i});
    
    % Set initial conditions and time span
    initial_conditions = [0.01; 0.04; 0.01; 0.04; 0.01; 0.04];
    lags = [params.tau13_SA, params.tau13_AV, params.tau23_PF];
    
    % Solve the system
    sol = dde23(@(t,y,Z) dde_equations(t,y,Z,params), lags, initial_conditions, tspan);
    
    % Create subplot
    subplot(2, 2, i);
    plot(sol.x, sol.y(1,:), 'b', sol.x, sol.y(3,:), 'r', sol.x, sol.y(5,:), 'g');
    xlabel('Time (s)'); 
    ylabel('Activity');
    title(case_titles(cases{i}));
    legend('SA node', 'AV node', 'Purkinje');
    grid on;
    ylim([-2 2]);  % Consistent scale for comparison
    
    % Add annotation for key features
    switch cases{i}
        case 'bradycardia'
            annotation('textbox', [0.32, 0.75, 0.1, 0.1], ...
                       'String', 'Missing AV responses', 'EdgeColor', 'none');
        case 'pvc'
            annotation('textbox', [0.13, 0.43, 0.1, 0.1], ...
                       'String', 'Chaotic SA activity', 'EdgeColor', 'none');
        case 'tachycardia'
            annotation('textbox', [0.73, 0.25, 0.1, 0.1], ...
                       'String', 'Disorganized Purkinje', 'EdgeColor', 'none');
    end
end

% Super title for the figure
sgtitle('Comparison of Heart Rhythm Abnormalities', 'FontSize', 14);
