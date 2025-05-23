function [params, case_name] = generate_heart_parameters(case_type)
% GENERATE_HEART_PARAMETERS Returns parameter sets for different heart rhythm cases
%   Input: case_type (string) - can be:
%       'normal'    : Healthy heart rhythm
%       'tachycardia': Fast SA node firing
%       'bradycardia': Slow SA node firing
%       'av_block'  : Atrioventricular block
%       'afib'      : Atrial fibrillation (chaotic SA node)
%       'vfib'      : Ventricular fibrillation (chaotic Purkinje)
%       'pvc'       : Premature ventricular contractions
%   Output: params (struct) - parameter structure for dde_equations
%           case_name (string) - descriptive case name

% Base parameters (normal healthy heart)
params = struct();
params.mu1 = 0.1;    params.mu2 = 0.05;   params.mu3 = 0.4;

% SA Node
params.alpha1 = 3.0; params.v1 = 0.2; params.v2 = -1.9;
params.c1 = 4.9; params.d1 = 3.0; params.tau13_SA = 1e-6;
params.k13 = 1.0; params.omega0_SA = 4.583; params.beta1 = 1.0;

% AV Node
params.alpha2 = 3.0; params.v3 = 0.2; params.v4 = -0.1;
params.c2 = 3.0; params.d2 = 3.0; params.tau13_AV = 0.8;
params.k31 = 1.0; params.omega0_AV = 3.0; params.beta2 = 1.0;

% Purkinje Fibers
params.alpha3 = 3.0; params.v5 = 1.1; params.v6 = -1.0;
params.c3 = 7.0; params.d3 = 3.0; params.tau23_PF = 0.1;
params.k53 = 1.0; params.omega0_PF = 4.583; params.beta3 = 1.0;

% Default frequencies (normal sinus rhythm)
params.omega1 = 1.0;   % SA node
params.omega2 = 1.0;   % AV node
params.omega3 = 1.0;   % Purkinje

% Default force functions
params.F1 = @(t) params.beta1 * sin(params.omega1 * t);
params.F2 = @(t) params.beta2 * sin(params.omega2 * t);
params.F3 = @(t) params.beta3 * sin(params.omega3 * t);

% Modify parameters based on case type
switch lower(case_type)
    case 'normal'
        case_name = 'Normal sinus rhythm';
        % No changes needed - use defaults
        
    case 'tachycardia'
        case_name = 'Sinus tachycardia (fast SA node)';
        params.omega1 = 2.0;  % Faster SA node firing
        
    case 'bradycardia'
        case_name = 'Sinus bradycardia (slow SA node)';
        params.omega1 = 0.5;  % Slower SA node firing
        
    case 'av_block'
        case_name = 'AV block (delayed conduction)';
        params.k13 = 0.1;     % Weak SA-AV coupling
        params.tau13_AV = 2.0; % Long AV-Purkinje delay
        
    case 'afib'
        case_name = 'Atrial fibrillation (chaotic SA)';
        params.alpha1 = 0.1;  % Reduced damping -> instability
        params.F1 = @(t) params.beta1 * (sin(params.omega1*t) + 0.5*randn());
        
    case 'vfib'
        case_name = 'Ventricular fibrillation (chaotic Purkinje)';
        params.alpha3 = 0.1;  % Reduced damping
        params.F3 = @(t) 2*randn(); % Random forcing
        params.k53 = 0.01;    % Isolate Purkinje
        
    case 'pvc'
        case_name = 'Premature ventricular contractions';
        % Add occasional extra spikes to Purkinje
        params.F3 = @(t) params.beta3 * sin(params.omega3*t) + ...
                        3.0*(mod(t,5) < 0.1); % Extra beat every ~5 sec
        
    otherwise
        warning('Unknown case type - using normal parameters');
        case_name = 'Normal sinus rhythm (default)';
end

% Update force functions if frequencies were changed
if ~contains(lower(case_type), {'afib','vfib','pvc'})
    params.F1 = @(t) params.beta1 * sin(params.omega1 * t);
    params.F2 = @(t) params.beta2 * sin(params.omega2 * t);
    params.F3 = @(t) params.beta3 * sin(params.omega3 * t);
end
end