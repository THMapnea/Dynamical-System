clc, clear, close all;

%helping variables
T = 2;
t = linspace(0, 5, 501);
x = sin(2 * pi * t / T);
y = cos(2 * pi * t/ T);

%another way of taking care of the values passed to our plot is trough
%matrices for example we could do 
m = zeros(2, length(t)); %create a matrices of 0
m(1, :) = x; %assign to the first row all the values of the first function
m(2, :) = y; %assign to the second row all the values of the second function

%this way of declaring allows us to use a for loop to create our plots
figure('position', [150,150,800,400]);

for cnt = 1 : 2
    % create a grid of plots of fixed dimension but with variable position given by the for loop count
    subplot(2,1,cnt)
    plot(t,m(cnt,:),"r-", "LineWidth",1.5);
    
    %to add labels etc it's useful to create object storing those values
end