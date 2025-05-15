clc, clear, close all;

%to create an anonymus function we  will wirte
               
func1 = @(x, y) (x + y);  %@(input paramters) (algorithm definition)

%to call the function we do like always name = func(parameters)
result = func1(2,1);

%we can also make it more complex
func2 = @(decay, time, omega) (exp(-decay * time) .* sin(omega * time));

time = linspace(0, 2, 2001);
decay = 3;
frequency = 100;
omega = 2 * pi  * frequency;
p = func2(decay,time,omega);
plot(time,p);
