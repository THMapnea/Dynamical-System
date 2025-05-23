function dydt = dde_equations(t, y, Z, params)
    % Extract current states
    x1 = y(1); x2 = y(2);  % SA node
    x3 = y(3); x4 = y(4);  % AV node
    x5 = y(5); x6 = y(6);  % Purkinje fibers

    % Extract delayed states (Z has 3 columns corresponding to lags)
    % Column 1: tau13_SA (SA to AV delay)
    x3_delayed = Z(3,1);  % x3(t - tau13_SA)
    
    % Column 2: tau13_AV (AV to PF delay)
    x5_delayed = Z(5,2);  % x5(t - tau13_AV)
    
    % Column 3: tau23_PF (PF to AV delay)
    x1_delayed = Z(1,3);  % x1(t - tau23_PF)

    % Define external forces
    F1 = params.F1(t);
    F2 = params.F2(t);
    F3 = params.F3(t);

    % Oscillator 1 (SA Node)
    dx1dt = x2;
    dx2dt = F1 - params.alpha1*(x1 - params.v1)*(x1 - params.v2)*x2 ...
            - (params.omega0_SA^4)/(params.c1*params.d1)*x1*(x1 + params.d1)*(x1 + params.c1) ...
            + params.k13*(x3_delayed - x1);

    % Oscillator 2 (AV Node)
    dx3dt = x4;
    dx4dt = F2 - params.alpha2*(x3 - params.v3)*(x3 - params.v4)*x4 ...
            - (params.omega0_AV^4)/(params.c2*params.d2)*x3*(x3 + params.d2)*(x3 + params.c2) ...
            + params.k31*(x1_delayed - x3);

    % Oscillator 3 (Purkinje Fibers)
    dx5dt = x6;
    dx6dt = F3 - params.alpha3*(x5 - params.v5)*(x5 - params.v6)*x6 ...
            - (params.omega0_PF^4)/(params.c3*params.d3)*x5*(x5 + params.d3)*(x5 + params.c3) ...
            + params.k53*(x3_delayed - x5);

    dydt = [dx1dt; dx2dt; dx3dt; dx4dt; dx5dt; dx6dt];
end