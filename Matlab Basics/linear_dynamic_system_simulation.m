clc, clear, close all;

%let's see how we can simulate a dynamic system in matlab


%to simulate a system we first create a system 
sys = tf([1, 2], [3, 4, 6]);


%if we want to simulate we need a certain timespan in wich the simulation
%will run 
t_span = 0 : 0.05 : 10;


%then we will also need to provide an input to the system
u = t_span.^2 +1;


%then we can call the linear simulation function passing all three of this,
%this function will simulate the system and provide the response plot we
%can modify the plot as usual
lsim(sys, u, t_span)