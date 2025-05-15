clc, clear, close all;

%let's see how to do some symbolic analysis

%first we create one symbol trough the syms keyword
syms x;

y = sin(x);

%now for example we can integrate the function indefinetly
Y = int(y, x);

%we can also specify some values to do the definite integral
Z = int(y, x, 0, pi);

%to evaluate a symbol we use the eval function
x = pi / 2;
result = eval(y);
