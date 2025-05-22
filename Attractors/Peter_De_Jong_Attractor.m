clc, clear, close all;

% We want to see the trajectory of the De Jong Attractor.
% The system is defined by the following iterative equations:
% x_{n+1} = sin(a * y_n) - cos(b * x_n) (4.1)
% y_{n+1} = sin(c * x_n) - cos(d * y_n) (4.2)
% This system produces beautiful fractal-like chaotic patterns depending on parameters:
% a = -2.24, b = 0.43, c = -0.65, d = -2.43 (Classic De Jong attractor)
% The attractor is sensitive to initial conditions and parameter choices
% De Jong Attractor parameters 


a = -2.0;
b = -2.0;
c = -1.2;
d = 2.0;


% Number of iterations
n_points = 100000;


% Initialize arrays to store trajectory
x = zeros(n_points, 1);
y = zeros(n_points, 1);


% Initial condition
x(1) = 0.1;
y(1) = 0.1;


% Generate the De Jong attractor
for i = 2:n_points
    x(i) = sin(a * y(i-1)) - cos(b * x(i-1));
    y(i) = sin(c * x(i-1)) - cos(d * y(i-1));
end


% Create figure
figure('Position', [100, 100, 1200, 900]);


% 2D Phase Portrait (Full View)
subplot(2, 2, 1);
scatter(x, y, 1, 1:n_points, 'filled');
colormap(jet);
title('De Jong Attractor (Full View)');
xlabel('x'); ylabel('y');
axis equal tight;
colorbar;


% Zoomed-In View
subplot(2, 2, 2);
scatter(x, y, 1, 1:n_points, 'filled');
colormap(jet);
title('De Jong Attractor (Zoomed View)');
xlabel('x'); ylabel('y');
xlim([-2 2]); ylim([-2 2]); % Adjust zoom as needed
axis equal tight;
colorbar;


% Time Evolution of x and y (First 1000 points)
subplot(2, 2, 3);
plot(1:1000, x(1:1000), 'Color', [0.4 0.4 0.4], 'LineWidth', 1.5, 'DisplayName', 'x(n)');
hold on;
plot(1:1000, y(1:1000), 'Color', [0 0.5 0.5], 'LineWidth', 1.5, 'DisplayName', 'y(n)');
title('Time Evolution (First 1000 Steps)');
xlabel('Iteration'); ylabel('Value');
legend('show', 'Location', 'best');
grid on;


% Histogram of x-values
subplot(2, 2, 4);
histogram(x, 200, 'FaceColor', [0.6 0.2 0.2], 'EdgeColor', 'none');
title('Distribution of x-values');
xlabel('x'); ylabel('Frequency');
grid on;


sgtitle(['De Jong Attractor (a = ', num2str(a), ', b = ', num2str(b), ...
         ', c = ', num2str(c), ', d = ', num2str(d), ')'], 'FontSize', 12);