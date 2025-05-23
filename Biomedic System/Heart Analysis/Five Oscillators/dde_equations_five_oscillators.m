function dydt = dde_equations_five_oscillators(t, y, Z, params)
    % Extract current states
    x1 = y(1); x2 = y(2);  % SA node
    x3 = y(3); x4 = y(4);  % AV node
    x5 = y(5); x6 = y(6);  % His bundle
    x7 = y(7); x8 = y(8);  % Left bundle branch
    x9 = y(9); x10 = y(10); % Right bundle branch

    % Extract delayed states (Z has columns corresponding to lags)
    % Mapping of delays to Z columns:
    % 1: tau12 (SA to AV)
    % 2: tau13 (SA to His)
    % 3: tau21 (AV to SA)
    % 4: tau23 (AV to His)
    % 5: tau32 (His to AV)
    % 6: tau34 (His to LBB)
    % 7: tau35 (His to RBB)
    % 8: tau43 (LBB to His)
    % 9: tau53 (RBB to His)
    
    x3_delayed_SA_AV = Z(3,1);  % x3(t - tau12)
    x5_delayed_SA_His = Z(5,2);  % x5(t - tau13)
    x1_delayed_AV_SA = Z(1,3);   % x1(t - tau21)
    x5_delayed_AV_His = Z(5,4);  % x5(t - tau23)
    x3_delayed_His_AV = Z(3,5);  % x3(t - tau32)
    x7_delayed_His_LBB = Z(7,6); % x7(t - tau34)
    x9_delayed_His_RBB = Z(9,7); % x9(t - tau35)
    x5_delayed_LBB_His = Z(5,8); % x5(t - tau43)
    x5_delayed_RBB_His = Z(5,9); % x5(t - tau53)

    % Oscillator 1 (SA Node)
    dx1dt = x2;
    dx2dt = params.F1(t) - params.alpha1*(x1 - params.v1)*(x1 - params.v2)*x2 ...
            - (params.omega0_SA^4)/(params.c1*params.d1)*x1*(x1 + params.d1)*(x1 + params.c1) ...
            + params.k12*(x3_delayed_SA_AV - x1) + params.k13*(x5_delayed_SA_His - x1);

    % Oscillator 2 (AV Node)
    dx3dt = x4;
    dx4dt = params.F2(t) - params.alpha2*(x3 - params.v3)*(x3 - params.v4)*x4 ...
            - (params.omega0_AV^4)/(params.c2*params.d2)*x3*(x3 + params.d2)*(x3 + params.c2) ...
            + params.k21*(x1_delayed_AV_SA - x3) + params.k23*(x5_delayed_AV_His - x3);

    % Oscillator 3 (His Bundle)
    dx5dt = x6;
    dx6dt = params.F3(t) - params.alpha3*(x5 - params.v5)*(x5 - params.v6)*x6 ...
            - (params.omega0_His^4)/(params.c3*params.d3)*x5*(x5 + params.d3)*(x5 + params.c3) ...
            + params.k32*(x3_delayed_His_AV - x5) ...
            + params.k34*(x7_delayed_His_LBB - x5) ...
            + params.k35*(x9_delayed_His_RBB - x5);

    % Oscillator 4 (Left Bundle Branch)
    dx7dt = x8;
    dx8dt = params.F4(t) - params.alpha4*(x7 - params.v7)*(x7 - params.v8)*x8 ...
            - (params.omega0_LBB^4)/(params.c4*params.d4)*x7*(x7 + params.d4)*(x7 + params.c4) ...
            + params.k43*(x5_delayed_LBB_His - x7);

    % Oscillator 5 (Right Bundle Branch)
    dx9dt = x10;
    dx10dt = params.F5(t) - params.alpha5*(x9 - params.v9)*(x9 - params.v10)*x10 ...
             - (params.omega0_RBB^4)/(params.c5*params.d5)*x9*(x9 + params.d5)*(x9 + params.c5) ...
             + params.k53*(x5_delayed_RBB_His - x9);

    dydt = [dx1dt; dx2dt; dx3dt; dx4dt; dx5dt; dx6dt; dx7dt; dx8dt; dx9dt; dx10dt];
end