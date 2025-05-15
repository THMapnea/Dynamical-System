clc, clear, close all; 

%we want to see how to animate in matlab so first let's animate our previous
%three dimensional plot
%helping variables
x = linspace(0,1,100);
y = linspace(0,2,200);
t = linspace(0,1,20); 
z = zeros(length(x), length(y), length(t)); 

for cnt = 1:length(t)
    z(:,:,cnt) = sin(2 * pi * x' / 0.5) * cos(2* pi * y / 0.33) * t(cnt);
end

[Y, X] = meshgrid(y,x);
figure("Position",[100,100,1500,750]);
%we can put the building of the plot in a for loop to see how it evolves
for cnt = 1:length(t)
    subplot(1,2,1);
    surf(X,Y,z(:, :, cnt));
    xlabel("X[m]");
    ylabel("Y[m]");
    zlabel("Z[m]");
    zlim([-1,1]);
    clim([-1,1]);%limits the color used
    colormap jet;
    colorbar;
    title("surf");
    
    subplot(1,2,2);
    if cnt ~= 0
        contour(X,Y,z(:, :, cnt));
        xlabel("X[m]");
        ylabel("Y[m]");
        zlabel("Z[m]");
        zlim([-1,1]);
        clim([-1,1]);%limits the color used
        colormap jet;
        colorbar;
        title("contour");
    end

    %we can add a pause and hold off to get a animation
    pause(0.05);
    hold off;
end

