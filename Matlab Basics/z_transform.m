clc, clear, close all;

%let's see how we can perform the Z transform in the discrete domain in
%matlab


% Declare symbolic variables
syms n z;
assume(n, 'integer'); % Since we're dealing with discrete time

% Define the shifted unit impulse function δ[n-2]
f = kroneckerDelta(n - 2); % Discrete equivalent of dirac()

% Compute the Z-transform
F = ztrans(f, n, z);

% Display the results symbolically
disp('Original function (discrete time domain):');
disp(f);
disp('Z-transform (frequency domain):');
disp(F);

% Create a visualization
figure("Position", [100, 100, 800, 600]);

% Subplot 1: Discrete impulse function
subplot(2,1,1);
stem(-2:5, double(subs(f, n, -2:5)), 'filled', 'LineWidth', 2);
title('Discrete Unit Impulse \delta[n-2]');
xlabel('Discrete time (n)');
ylabel('Amplitude');
xlim([-2 5]);
ylim([0 1.1]);
grid on;

% Subplot 2: Z-transform (z^-2)
subplot(2,1,2);
% Since the Z-transform is z^-2, we'll visualize its magnitude
fplot(abs(z^-2), [0.5 2]); % Plot magnitude for |z| > 0
title('Magnitude of Z-transform: z^{-2}');
xlabel('|z|');
ylabel('Magnitude');
grid on;