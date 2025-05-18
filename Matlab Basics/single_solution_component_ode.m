clc, clear, close all;

%let's try to solve some single solution component differential equation
%for example we want ot osolve d/dt y(t)  = 2t

% we first declare a timespan in wich we want to solve the ode 
t_span = [0, 5]; %5 second time span

%then we can specify the initial condition
y0 = 0;

%then we can write our differential equation as an anonymous function 
ode = @(t, y0)(2 * t);

%then we can call the ode45 function
[t, y] = ode45(ode, t_span, y0);

%we can in the end plot the solution
plot(t, y);