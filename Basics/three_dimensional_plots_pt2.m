clc, clear, close all;

%helping variables
x = linspace(0,1,100);
y = linspace(0,2,200);
z = sin(2 * pi * x' / 0.5) * cos(2* pi * y / 0.33);

%we will now take a look at three dimensional plots with more control and
%precision 

%to have more control over the parameters we can create a meshgrid 
[Y, X] = meshgrid(y,x);

%so instead of giving only z, we give the meshgrid and the z 
%to the surf we can better see the values
figure("Position",[100,100,1500,750]);
subplot(1,2,1);
surf(X,Y,z);
title("surf");

%we can personalize them like we did for all the other type of plots
%one property that we can change are the used color by the colormap
%parameter and describing it trough the colorbar
colormap jet;
colorbar;

%another interesting thing is the contour basically if you've done some bit
%of advanced calculus you can remember that this are level lines of the
%function the same used for the lagrangian moltiplicators
subplot(1,2,2);
contour(X,Y,z);
colormap jet;
colorbar;
title("contour");