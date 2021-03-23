function [movieFile, downscaledMovieFile] = generateMovingParticlesMovie(num_objs, vel, SNR)
%GENERATEMOVINGPARTICLESMOVIE Summary of this function goes here
%   Detailed explanation goes here
movieFile = sprintf('%d_particles_%dpx_per_frame_SNR_%d_to_1_1024x.avi', num_objs, vel, SNR);
downscaledMovieFile = sprintf('%d_particles_%dpx_per_frame_SNR_%d_to_1_512x.avi', num_objs, vel, SNR);

frameRate = 5;
movieLength = 20;

x_array = randi([1 1024], num_objs, 1);
y_array = randi([1 1024], num_objs, 1);
r_array = 2 * rand(num_objs, 1) + 2;
theta = linspace(0,2*pi,100);


movie = VideoWriter(movieFile);
movie.FrameRate = frameRate;
open(movie)

downscaledMovie = VideoWriter(downscaledMovieFile);
downscaledMovie.FrameRate = frameRate;
open(downscaledMovie);

tablex = zeros(frameRate * movieLength , num_objs); %creates matrix
tabley = zeros(frameRate * movieLength , num_objs); %creates matrix


for frameNo = 1 : frameRate * movieLength
    im = zeros(1024, 1024);
    
    for i = 1 : num_objs
        x_coord = x_array(i);
        y_coord = y_array(i);
        radius = r_array(i);
        
        for x = round(x_coord - radius) : round(x_coord + radius)
            for y = round(y_coord - radius) : round(y_coord + radius)
                dist = sqrt((x - x_coord)^2 + (y - y_coord)^2);
                if dist < radius * (0.3 * rand() + 0.7) && x < 1024 && x  > 1 && y < 1024 && y > 0
                % if dist < radius && x < 1024 && x  > 1 && y < 1024 && y > 0
                    im(x,y) = 1;
                end
            end
        end
        rand_angle = 2 * pi * rand(1);
        x_coord = x_coord + vel * cos(rand_angle);
        y_coord = y_coord + vel * sin(rand_angle);
        
        x_array(i) = x_coord;
        y_array(i) = y_coord;
        tablex(frameNo,i) = x_array(i); %stores all x coords of objects
        tabley(frameNo,i) = y_array(i) ; %stores all y coords of objects
    end
    % creates cell array of position coordinates
    table = horzcat(tablex, tabley); %full table stored in form [x, y]
    j = frameRate*movieLength; % get number of frames
    labelrows = compose('frame%d', [(1:j)])'; %row labels
    labelcols = compose('obj%d', [(1:2*i)])'; %column labels
    cellArray = [[{' '}; labelcols]'; labelrows num2cell(table)] %create table with labels
    
    % clarification on labels
    x = i/2; 
    y = i/2 +1;
    z = i;
    G = ['objxy 1-',num2str(x),' are x coordinates, and ',num2str(y),'-',num2str(z),' are y coordinates'];
    disp(G)
    %
    
    im = imgaussfilt(im, 0.875);
    
    noise = 1/SNR * rand(1024, 1024); % generate noise with given SNR
    
    im = im + noise;
    
    im(im > 1) = 1; % Set all intensities greater than 1 to 1
    
    writeVideo(movie, im);
    
    downscaledIm = imresize(im, [512 512]);
    
    writeVideo(downscaledMovie, downscaledIm);
    
    imshow(im);
end

close(movie);
close(downscaledMovie);

end