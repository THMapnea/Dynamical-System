clc, clear, close all;

%we want to pass to our ode solver now multiple initial conditions
%we first define the usual things like timespan the ode etc

t_span  = [0, 30];
ode = @(t, y)(-2 * y + 2 * sin(t) .* cos(2 * t) * exp(-t));

%then we create a span of initial condition so that we can get the family
%of result out of our equation and see how it bheaves to different inputs
initialCondition = -5:1:5;

%then we can solve for the ode45
[T, Y] = ode45(ode, t_span, initialCondition);

%we can then plot the result
plot(T,Y)
grid on
xlabel('t')
ylabel('y')
title('Solutions')