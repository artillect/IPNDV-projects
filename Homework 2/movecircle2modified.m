fileName = 'movecircle.avi';
frameRate = 5;
movieLength = 20;

num_obs = 16;
vel = 32; % 4, 8, or 32 pixels/frame
min_corr = 0.7;
SNR = 20;

im = 1/SNR * rand(1024, 1024);

x_array = randi([1 1024], num_obs, 1);
y_array = randi([1 1024], num_obs, 1);
r_array = 5 * rand(num_obs, 1);
dir_array = 2 * pi * rand(num_obs, 1);
theta = linspace(0,2*pi,100);


v = VideoWriter(fileName);
v.FrameRate = frameRate;
open(v)

for frameNo = 1 : frameRate * movieLength
    im = 1/SNR * rand(1024, 1024);

    for i = 1 : num_obs
        x_coord = x_array(i);
        y_coord = y_array(i);
        im(x_coord, y_coord) = 1;
        
        rand_angle = 2 * pi * rand(1);
        x_coord = x_coord + round(vel * cos(rand_angle));
        y_coord = y_coord + round(vel * sin(rand_angle));
        
        if x_coord <= 0
            x_coord = x_coord + 1024;
        elseif x_coord > 1024
            x_coord = x_coord - 1024;
        end
        
        if y_coord <= 0
            y_coord = y_coord + 1024;
        elseif y_coord > 1024
            y_coord = y_coord - 1024;
        end
        
        x_array(i) = x_coord;
        y_array(i) = y_coord;
    end
    
    writeVideo(v, im);
    imshow(im);
end

close(v);

implay(fileName);
