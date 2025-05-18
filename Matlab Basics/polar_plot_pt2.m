clc, clear, close all;

%we want to solve the same problem of linear differential microphone but
%with polar plots and for multiple frequencies
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
f = [10, 100, 1000, 10000]; %create the frequency array
figure("Position",[100,100,900,900]);


for cnt = 1: length(f)
    ind = find(freq == f(cnt)); %find the frequencies 
    %plot for every frequencies in a grid
    subplot(2,2,cnt);
    polarplot(theta, abs(pg(ind, :)./omega(ind)), "LineWidth",1.5);
    %graphic
    title(num2str(f(cnt),"freq. = %d Hz"));
    set(gca,"FontSize",12)
    set(gca, "FontWeight","bold")
end
rlim([0, 5e-3]);


