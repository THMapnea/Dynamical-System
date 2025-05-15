clc, clear, close all; 

%we want to save our animation
%helping variables
x = linspace(0,1,100);
y = linspace(0,2,200);
t = linspace(0,1,100); %this defines the length of the animation
z = zeros(length(x), length(y), length(t)); 

for cnt = 1:length(t)
    z(:,:,cnt) = sin(2 * pi * x' / 0.5) * cos(2* pi * y / 0.33) * t(cnt);
end


%create the video writer object the extension is .avi and it takes as
%parameter the name of the output file
obj = VideoWriter("animation.avi");

%the quality
obj.Quality = 100;

%so if we have 60 point in our timeline we will get 3 seconds and so on
obj.FrameRate = 20; 

%always remember to open and close the object
open(obj);

[Y, X] = meshgrid(y,x);
figure("Position",[100,100,1500,750]);
for cnt = 1:length(t)
    subplot(1,2,1);
    surf(X,Y,z(:, :, cnt));
    xlabel("X[m]");
    ylabel("Y[m]");
    zlabel("Z[m]");
    zlim([-1,1]);
    clim([-1,1]);
    colormap jet;
    colorbar;
    title("surf");
    
    subplot(1,2,2);
    contour(X,Y,z(:, :, cnt));
    xlabel("X[m]");
    ylabel("Y[m]");
    zlabel("Z[m]");
    zlim([-1,1]);
    clim([-1,1]);
    colormap jet;
    colorbar;
    title("contour");
    %we removed the pause
    hold off;
    
    %we then save the various frame, each frame is the render of one plot
    frame = getframe(gcf);

    %we write each frame in the object 
    writeVideo(obj,frame);
end

%then we close the video object 
obj.close;


