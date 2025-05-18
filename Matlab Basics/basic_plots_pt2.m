clc, clear, close all;

%helping variables
T = 2;
t = linspace(0, 5, 500);
x = sin(2 * pi * t / T);

%we can create the figure that will hod our plot by calling the figure
%method that will receive as parameters first the position in wich the size
%must be specified as the second parameter that is an array [left_corner, right_corner, length, height]
figure('position', [100,100,800,400]);

%call the plot function
%we can modify the thickness of the line, the color the symbol and so on
plot(t,x, "r--", "LineWidth",1.5);


%we can also add labels to our axis
xlabel("time(sec)");
ylabel("value(m)");

%we can also add a title
title("myPlot");

%we can also show a grid
grid on;

%we can also add a decorator that is a GCA
set(gca, "fontsize", 12);
set(gca, "fontweight", "bold");

%if we want to save our fig trough code we can write
savefig("plot_01.fig");