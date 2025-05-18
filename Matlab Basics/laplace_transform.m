clc, clear, close all;


%we will n ow see how we can perform the Laplace transform of a function 


% Declare symbolic variables
syms t s;


% Define the shifted Dirac delta function (δ(t-2))
f = dirac(t - 2);


% Compute the Laplace transform
F = laplace(f, t, s);


% Create a visualization that makes sense
figure("Position", [100, 100, 800, 600]);


% Subplot 1: Represent the Dirac delta (conceptual)
subplot(2, 1, 1);
title('Conceptual Representation of \delta(t-2)');
xline(2, 'r', 'LineWidth', 2); % Show impulse at t=2
xlabel('Time (t)');
ylabel('Amplitude');
xlim([0 4]);
ylim([0 1]);
grid on;


% Subplot 2: Plot the Laplace transform (e^{-2s})
subplot(2, 1, 2);
fplot(F, [0 5]); % Plot the exponential decay
title('Laplace Transform');
xlabel('Complex frequency (s)');
ylabel('Magnitude');
grid on;