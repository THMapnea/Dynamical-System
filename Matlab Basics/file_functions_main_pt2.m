clc, clear, close all;

%let's call the viscous force function we define before to solve our
%problem the problem itself is described in the function file

frequency = 2 * logspace(1, 4, 100);
omega = 2 * pi * frequency; % angular frequency
v = 1; %velocity of the fluid/fiber
ro = 1.2041; %density of air
mu = 1.8705e-5; %dynamic viscosity coefficient of air
r = 5e-6; %radius of the fiber

force = zeros(size(frequency));

for cnt = 1 : length(frequency)  
    %now we can call our function
    force(cnt) = viscous_force(r,omega(cnt),ro,mu,v);
end

figure("Position",[100,100,800,800]);
subplot(2,1,1);
loglog(frequency,real(force)); %both x and y logarithmic
subplot(2,1,2);
loglog(frequency, imag(force));