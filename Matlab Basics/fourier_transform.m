clc, clear, close all;

%we want to perform the fourier transform on a signal to move ourselves
%from the time domain to the frequency domain 

% Signal parameters
fs = 150;        % Sampling frequency (Hz) ususally 5 or 10 times the frequency
Ts = 1 /  fs;      % Sampling period
t = 0 : Ts : 10 - Ts; % Time vector

% Create a clean sine wave at 15 Hz for better visualization
f0 = 15;         % Signal frequency (Hz)
x = sin(2 * pi * f0 *t); % Signal to process

% Perform FFT
N = length(x);
X = fft(x);

% Frequency vector
f = (0 : N - 1)*(fs / N); % Frequency range (0 to fs)

% For two-sided spectrum, we should shift zero frequency to center
f_shift = (-N / 2 : N / 2 - 1) * (fs / N);
X_shift = fftshift(X);

% Magnitude and phase
magnitude = abs(X_shift);
phase = angle(X_shift);

% Clean up phase for small magnitudes (remove noise)
phase_threshold = 1e-6; % Adjust as needed
phase(magnitude < phase_threshold) = 0;

% Plotting
figure("Position", [100, 100, 800, 600]);

% Time domain
subplot(2, 2, [1, 2]);
plot(t, x);
xlabel("Time (s)");
ylabel("Amplitude");
title("Time Domain Signal");
xlim([0, 1]); % Show just 1 second for clarity
grid on;

% Magnitude spectrum (shifted)
subplot(2, 2, 3);
stem(f_shift, magnitude);
xlabel("Frequency (Hz)");
ylabel("Magnitude");
title("Magnitude Spectrum");
xlim([-fs / 2 fs / 2]);
grid on;

% Phase spectrum (cleaned)
subplot(2, 2, 4);
stem(f_shift, phase);
xlabel("Frequency (Hz)");
ylabel("Phase (rad)");
title("Phase Spectrum");
xlim([-fs / 2 fs / 2]);
grid on;