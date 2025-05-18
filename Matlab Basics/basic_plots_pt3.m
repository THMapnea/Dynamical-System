clc, clear, close all;

%helping variables
T = 2;
t = linspace(0, 5, 500);
x = sin(2 * pi * t / T);


%we create a second function
y = cos(2 * pi * t/ T);

%we create a third function
z = tan(2 * pi * t / T);

%we will now work with multiplot

figure('position', [100,100,800,400]);
plot(t,x, "r--", "LineWidth",1.5);


%we can write hold on to avoid the plot disappearing
hold on;
plot(t, y, "g--", "LineWidth",1.5);


% remember the plot properties must be after the hold on
xlabel("time(sec)");
ylabel("value(m)");
title("myPlot");
grid on;
set(gca, "fontsize", 12);
set(gca, "fontweight", "bold");

%we can also implement a legend trough the legend() function location best
%sets the leegend in the graphical place that doesnt bother but it's better
%to just use outside the three dots tell's the compiler that we are
%continuing to provide options on the line under. the orientation selects
%how the legend is listed
legend("sin(2pit/T)", "cos(2pit/T)", "Location", "southoutside", ...
    "Orientation","horizontal");

%we can then not call figure and put the graph one on top of the other or
%just create a new figure
figure('position', [100,100,800,400]);


%then we can plot another function
plot(t,z, "b", "LineWidth",1.5);

