clc, clear, close all;

freq =  logspace(1,4,100); 
omega = 2 * pi * freq;
theta = linspace(0, 2* pi, 361); 
distance = 5e-3;
c = 343;
p1 = ones(length(freq), length(theta));
p2 = exp(1i * distance * omega' * cos(theta) / c);
pg = (p2 - p1) / distance;
pg_db = 20 * log10(abs(pg));

%% Logarithmic plot
%we want to plot for more angle of rotation so we create an array for every
%angle in wich we are interested
ang = deg2rad([0, 15 30, 45, 60, 75]); %we want them in radians

%we create a for loop 
figure("Position",[100,100,800,600]); 
for cnt = 1 : length(ang)
    %we search for the index where the angle we are interested in resides
    ind = find(theta == ang(cnt));
     %we plot for very index where the index is the column
    semilogx(freq,pg_db(:, ind), "LineWidth",1.5);
    hold on
end
xlabel("frequency [Hz]");
ylabel("pres. grad. [db]");
title("logarithmic plot");
set(gca, "fontsize", 12);
set(gca, "FontWeight", "bold");
%here i use latex to put the theta symbol
legend("\theta = 0 deg", "\theta = 15 deg", "\theta = 30 deg",...
       "\theta = 45 deg", "\theta = 60 deg","\theta = 75 deg", ...
        "Location", "southeast");

%we can also set the limits for my x and y axis
xlim([min(freq),max(freq)]);

%another type of grid
grid minor;


