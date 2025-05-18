%we are creating a second function 
%this function the viscous force on a circular fiber in air
%basically stokes equation

% the parameters are:
    %r -> radius of the fiber
    %omega -> angle of frequency
    %ro ->density
    %mu -> viscosity
    %v -> velocity

function result = viscous_force(r, omega, ro, mu, v)
    
    m = sqrt(1i * omega * ro / mu);
    result = v * ro * r * 1i * omega * pi / m * ...
        (4 * besselk(1,m * r)) / besselk(0, m * r);
end
