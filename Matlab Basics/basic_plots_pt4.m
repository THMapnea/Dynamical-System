clc, clear, close all;

%helping variables
T = 2;
t = linspace(0, 5, 501);
x = sin(2 * pi * t / T);
y = cos(2 * pi * t/ T);
z = tan(2 * pi * t / T);
w = exp(sin(cos(tan(2 * pi * t /T))));


figure('position', [150,150,800,400]);
%for another visualization we can create a grid with the subplot command
% subplot(number of rows, number of columns, number of the plot)
subplot(2,2,1);
plot(t,z, "b", "LineWidth",1.5);
subplot(2,2,2);
plot(t,x, "r", "LineWidth",1.5);
subplot(2,2,3);
plot(t, y, "g", "LineWidth",1.5);
subplot(2,2,4);
plot(t,w,"c","LineWidth",1);

%we can also personalized it as we already did it before