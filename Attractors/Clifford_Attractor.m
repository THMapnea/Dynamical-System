clc, clear, close all;

% We want to see the trajectory of the Clifford Attractor.
% The system is defined by the following iterative equations:
%    x_{n+1} = sin(a * y_n) + c * cos(a * x_n)    (4.1)
%    y_{n+1} = sin(b * x_n) + d * cos(b * y_n)    (4.2)
% This system produces fractal-like chaotic patterns depending on parameters:
%    a = -1.4, b = 1.6, c = 1.0, d = 0.7 (Classic Clifford attractor)
% The attractor is sensitive to initial conditions and parameter choices


% Clifford attractor parameters (play with these for different patterns)
a = -1.4;
b = 1.6;
c = 1.0;
d = 0.7;


% Number of iterations
n_points = 100000;


% Initialize arrays to store trajectory
x = zeros(n_points, 1);
y = zeros(n_points, 1);

% Initial condition
x(1) = 0.1;
y(1) = 0.1;


% Generate the Clifford attractor
for i = 2:n_points
    x(i) = sin(a * y(i-1)) + c * cos(a * x(i-1));
    y(i) = sin(b * x(i-1)) + d * cos(b * y(i-1));
end


% Create figure
figure('Position', [100, 100, 1200, 900]);


%2D Phase Portrait (Full View)
subplot(2, 2, 1);
scatter(x, y, 1, 1:n_points, 'filled');
colormap(jet);
title('Clifford Attractor (Full View)');
xlabel('x'); ylabel('y');
axis equal tight;
colorbar;


%Zoomed-In View
subplot(2, 2, 2);
scatter(x, y, 1, 1:n_points, 'filled');
colormap(jet);
title('Clifford Attractor (Zoomed View)');
xlabel('x'); ylabel('y');
xlim([-1.5 1.5]); ylim([-1.5 1.5]); % Adjust zoom as needed
axis equal tight;
colorbar;


%Time Evolution of x and y (First 1000 points)
subplot(2, 2, 3);
plot(1:1000, x(1:1000), 'Color', [0.4 0.4 0.4], 'LineWidth', 1.5, 'DisplayName', 'x(n)');
hold on;
plot(1:1000, y(1:1000), 'Color', [0 0.5 0.5], 'LineWidth', 1.5, 'DisplayName', 'y(n)');
title('Time Evolution (First 1000 Steps)');
xlabel('Iteration'); ylabel('Value');
legend('show', 'Location', 'best');
grid on;


%Histogram of x-values
subplot(2, 2, 4);
histogram(x, 200, 'FaceColor', [0.6 0.2 0.2], 'EdgeColor', 'none');
title('Distribution of x-values');
xlabel('x'); ylabel('Frequency');
grid on;


sgtitle(['Clifford Attractor (a = ', num2str(a), ', b = ', num2str(b), ...
         ', c = ', num2str(c), ', d = ', num2str(d), ')'], 'FontSize', 12);