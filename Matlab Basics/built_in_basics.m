clc, clear, close all;

%let's explore some built in functions
x = pi;
y = cos(x); %radians
z = sin(y); %radians
w = tan(x); %radians
s = cosd(180); %degrees
l = sind(90); %degrees
k = tand(180); %degrees
j = asin(0); %radians
u = asind(0); %degrees
e = acosd(180); %degrees
p = acos(x); %radians
h = atan(1); %radians
g = atand(1);%degrees

%we can also convert from degrees to radians and backwards as it follows
dr = deg2rad(180);
rd = rad2deg(x);

%we can also work with complex numbers we put the one near the i, otherwise it doesnt
%work as intended
cmplx_x = 2 +1i * 3;

real_x = real(cmplx_x); % real part
img_x = imag(cmplx_x); % imaginary part
abs_x = abs(cmplx_x); %module
phase_x = angle(cmplx_x); % phase angle of the complex numebr

%we can also create exponential and complex numbers fromt he said
%exponential from wich we can extract all the necessary relationship like 
%euler's formula

e_x = exp(2);

e_cmplx_x = exp(2i);