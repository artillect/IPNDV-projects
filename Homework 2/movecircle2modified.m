fileName = 'movecircle.avi';
frameRate = 5;
movieLength = 20;

num_obs = 32;
vel = 32; % 4, 8, or 32 pixels/frame
min_corr = 0.7;
SNR = 20;

x_array = randi([1 1024], num_obs, 1);
y_array = randi([1 1024], num_obs, 1);
r_array = 2 * rand(num_obs, 1) + 1;
dir_array = 2 * pi * rand(num_obs, 1);
theta = linspace(0,2*pi,100);


v = VideoWriter(fileName);
v.FrameRate = frameRate;
open(v)

for frameNo = 1 : frameRate * movieLength
    im = 1/SNR * rand(1024, 1024); % generate background with noise with given SNR

    for i = 1 : num_obs
        x_coord = x_array(i);
        y_coord = y_array(i);
        radius = r_array(i);
        
        for x = round(x_coord - radius) : round(x_coord + radius)
            for y = round(y_coord - radius) : round(y_coord + radius)
                dist = sqrt((x - x_coord)^2 + (y - y_coord)^2);
                if dist < radius && x < 1024 && x  > 1 && y < 1024 && y > 0
                    im(x,y) = 1-dist/radius;
                end
            end
        end
        rand_angle = 2 * pi * rand(1);
        x_coord = x_coord + vel * cos(rand_angle);
        y_coord = y_coord + vel * sin(rand_angle);
        
        if round(x_coord) <= 1
            x_coord = x_coord + 1023;
        elseif round(x_coord) > 1024
            x_coord = x_coord - 1023;
        end
        
        if round(y_coord) <= 1
            y_coord = y_coord + 1023;
        elseif round(y_coord) > 1024
            y_coord = y_coord - 1023;
        end
        
        x_array(i) = x_coord;
        y_array(i) = y_coord;
    end
    
    writeVideo(v, im);
    imshow(im);
end

close(v);

implay(fileName);
