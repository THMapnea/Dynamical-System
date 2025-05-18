clc, clear, close all; 

%we want to see how to animate in matlab so first let's animate our previous
%three dimensional plot
%helping variables
x = linspace(0,1,100);
y = linspace(0,2,200);
t = linspace(0,1,20); %one second distributed on 20 points
%for the z we create a matrices that contains the x,y nd t value that we
%will need to plot the animation
z = zeros(length(x), length(y), length(t)); 

for cnt = 1:length(t)
    %we add a temporal dependecy to the function
    z(:,:,cnt) = sin(2 * pi * x' / 0.5) * cos(2* pi * y / 0.33) * t(cnt);
end

[Y, X] = meshgrid(y,x);
figure("Position",[100,100,1500,750]);
subplot(1,2,1);
% we passed the z array fully for x and y and then a certain moment in time that we wanted to evaluate
surf(X,Y,z(:, :, 3));
colormap jet;
colorbar;
title("surf");

subplot(1,2,2);
% we passed the z array fully for x and y and then a certain moment in time that we wanted to evaluate
contour(X,Y,z(:, :, 3));
colormap jet;
colorbar;
title("contour")