clc, clear, close all;

%I want to see complex physics value who are related in exponential manners
%for example here we are working to simulate two microphone interacting
%with each other


%to do so we  create a logaritmic space the logspace takes as input power
%of 10. logspace(lower bound, upper bound, number of columns)
freq = logspace(1,4,100); %this is a 10000 frequency for 100 frequency

%now we create an angle of frequency
omega = 2 * pi * freq;

%we create the angle of rotation of the sound source in respect to the
%array, basically the orientation of the source
theta = linspace(0, 2* pi, 361); % we use 361 to get all 360 degrees

%distance between the two microphone
distance = 5e-3;

%then we can put the speed of sound [m/s]
c = 343;

%the first microphone pressure will be the reference
p1 = ones(length(freq), length(theta));

%the second microphone pressure is define from the first as it follows
p2 = exp(1i * distance * omega' * cos(theta) / c);

%we can now cmopute the gradient of the pressure
pg = (p2 - p1) / distance;

%we work with decibel in signal processing so we convert the gradient in
%decibel gradient we take  X_rif = 1 tha is the max of the exponential
pg_db = 20 * log10(abs(pg));

%% Logarithmic plot
figure("Position",[100,100,800,600]); % create the figure
%then we use the semilogx plot that use logarithmic scale on the x and
%normal on the y
semilogx(freq,pg_db(:, 1)); %plots only one angle of rotation





