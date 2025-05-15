clc, clear, close all;

%we want to solve the same problem of linear differential microphone but
%with polar plots for one frequency for the problem itself look at the
%logarithmic plot pt1 file
freq =  logspace(1,4,100); 
omega = 2 * pi * freq;
theta = linspace(0, 2* pi, 361); 
distance = 5e-3;
c = 343;
p1 = ones(length(freq), length(theta));
p2 = exp(1i * distance * omega' * cos(theta) / c);
pg = (p2 - p1) / distance;
pg_db = 20 * log10(abs(pg));

%% polar plot
figure("Position",[100,100,800,600]); %create the figure

%create the polar plot
% we selected only one frequency the 45th the division is for better
% visualization
polarplot(theta, abs(pg(45, :)./omega(45)), "LineWidth",1.5);

%we can set a radial limit
rlim([0, 5e-3]);


