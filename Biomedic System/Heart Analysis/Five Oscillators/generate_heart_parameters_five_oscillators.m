function [params, case_name] = generate_heart_parameters_five_oscillators(case_type)
% GENERATE_HEART_PARAMETERS Returns parameter sets for different heart rhythm cases
%   Updated for 5-oscillator model with all required delay parameters

% Base parameters (normal healthy heart)
params = struct();

% -------------------------------
% 1. General Constants
% -------------------------------
params.mu1 = 0.4;    params.mu2 = 0.3;   
params.mu3 = 0.15;   params.mu4 = 0.1;  
params.mu5 = 0.1;    

% -------------------------------
% 2. SA Node Parameters
% -------------------------------
params.alpha1 = 1.2;   params.v1 = 0.2;      
params.v2 = -0.1;      params.c1 = 1.0;      
params.d1 = 1.0;       params.tau12 = 0.1;   
params.tau13 = 0.15;   params.k12 = 0.5;     
params.k13 = 0.3;      params.omega0_SA = 1.0; 
params.beta1 = 0.5;    params.omega1 = 0.8;   

% -------------------------------
% 3. AV Node Parameters
% -------------------------------
params.alpha2 = 1.0;   params.v3 = 0.15;      
params.v4 = -0.05;     params.c2 = 1.0;       
params.d2 = 1.0;       params.tau21 = 0.1;    
params.tau23 = 0.2;    params.k21 = 0.3;      
params.k23 = 0.4;      params.omega0_AV = 0.6; 
params.beta2 = 0.3;    params.omega2 = 0.6;   

% -------------------------------
% 4. His Bundle Parameters
% -------------------------------
params.alpha3 = 0.8;   params.v5 = 0.1;       
params.v6 = -0.08;     params.c3 = 1.0;       
params.d3 = 1.0;       params.tau32 = 0.15;   
params.tau34 = 0.1;    params.tau35 = 0.1;    
params.k32 = 0.2;      params.k34 = 0.3;      
params.k35 = 0.3;      params.omega0_His = 0.4; 
params.beta3 = 0.2;    params.omega3 = 0.4;   

% -------------------------------
% 5. Left Bundle Branch Parameters
% -------------------------------
params.alpha4 = 0.6;   params.v7 = 0.08;      
params.v8 = -0.06;     params.c4 = 0.8;       
params.d4 = 0.8;       params.tau43 = 0.1;    
params.k43 = 0.2;      params.omega0_LBB = 0.3; 
params.beta4 = 0.15;   params.omega4 = 0.3;   

% -------------------------------
% 6. Right Bundle Branch Parameters
% -------------------------------
params.alpha5 = 0.6;   params.v9 = 0.08;      
params.v10 = -0.06;    params.c5 = 0.8;       
params.d5 = 0.8;       params.tau53 = 0.1;    
params.k53 = 0.2;      params.omega0_RBB = 0.3; 
params.beta5 = 0.15;   params.omega5 = 0.3;   

% Force functions
params.F1 = @(t) params.beta1 * sin(params.omega1 * t);
params.F2 = @(t) params.beta2 * sin(params.omega2 * t);
params.F3 = @(t) params.beta3 * sin(params.omega3 * t);
params.F4 = @(t) params.beta4 * sin(params.omega4 * t);
params.F5 = @(t) params.beta5 * sin(params.omega5 * t);

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
        params.k12 = 0.1;     % Weak SA-AV coupling
        params.tau23 = 2.0;   % Long AV-His delay
        
    case 'pvc'
        case_name = 'Premature ventricular contractions';
        % Add occasional extra spikes to bundle branches
        params.F4 = @(t) params.beta4 * sin(params.omega4*t) + ...
                        3.0*(mod(t,5) < 0.1); % Extra beat every ~5 sec
        params.F5 = @(t) params.beta5 * sin(params.omega5*t) + ...
                        3.0*(mod(t,5) < 0.1); % Extra beat every ~5 sec
        
    otherwise
        warning('Unknown case type - using normal parameters');
        case_name = 'Normal sinus rhythm (default)';
end

% Update force functions if frequencies were changed
if ~contains(lower(case_type), {'pvc'})
    params.F1 = @(t) params.beta1 * sin(params.omega1 * t);
    params.F2 = @(t) params.beta2 * sin(params.omega2 * t);
    params.F3 = @(t) params.beta3 * sin(params.omega3 * t);
    params.F4 = @(t) params.beta4 * sin(params.omega4 * t);
    params.F5 = @(t) params.beta5 * sin(params.omega5 * t);
end
end