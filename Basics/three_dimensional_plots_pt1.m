clc, clear, close all;

%helping variables
x = linspace(0,1,100);
y = linspace(0,2,200);
z = sin(2 * pi * x' / 0.5) * cos(2* pi * y / 0.33);

%we will now take a look at three dimensional plots
%the first we want to see it's the mesh method
figure("Position",[100,100,1000,500])
subplot(1,2,1);
mesh(z);
title("mesh");
%then we have surf
subplot(1,2,2);
surf(z);
title("surf");