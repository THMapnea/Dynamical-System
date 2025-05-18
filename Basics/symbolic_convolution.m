clc, clear, close all;

%we will see how to perform symbolic convolution between function in this
%case we will convolute two rect function and will obtain a triangle
%function without passing in the frequency(Fourier) domain


%first we declare the symbols
syms t tau real;


%we can now define the rect function trough it's relationship with the
%heavside function
rect = @(t)(heaviside(t + 0.5) - heaviside(t - 0.5));


%then we define the two function we want to process
x_t = rect(t);
h_t = rect(t);


%then create the version to pass to the integral
x_tau = rect(tau);
h_tau = rect(t- tau);


%now we can perform the convolution symbolically by using the int()
%function to perform the integral and not by passing for the conv function
convolution = int(x_tau * h_tau, tau, -inf, inf);
simplify(convolution);


%now we can proceed by plotting  it trough fplot
figure("position", [100,100, 800,600]);
subplot(2,2,1);
fplot(x_t, [-2, 2], "LineWidth", 1.5);%we specified an interval for plotting of symbolic value
xlabel("t");
ylabel("x(t)");
ylim([-0.1, 1.1]);
grid on;
title("first rect");
subplot(2,2,2);
fplot(h_t, [-2, 2], "LineWidth", 1.5);%we specified an interval for plotting of symbolic value
xlabel("t");
ylabel("h(t)");
ylim([-0.1, 1.1]);
grid on;
title("second rect");
subplot(2,2,[3,4]);
fplot(convolution, [-2, 2]);%we specified an interval for plotting of symbolic value
xlabel("t");
ylabel("x(t)");
ylim([-0.1, 1.1]);
grid on;
title("convolution");

