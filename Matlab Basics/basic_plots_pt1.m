clc, clear, close all;
%we will now dive in the big world of plots
T = 2; %period of my function in this case 2 seconds

%then we will use Linspace to create an array for the time
%linspace takes as argument linspace(start,stop, num_points)
t = linspace(0, 5, 500);

%then we can declare the function using t as the variable
x = sin(2 * pi * t / T);

%we can now plot in this case x versus t by calling the plot function with
%the x axis and then the y axis
plot(t,x)
