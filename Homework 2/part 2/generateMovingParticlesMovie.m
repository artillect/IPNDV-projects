function [movieFileName, tableFileName] = generateMovingParticlesMovie(num_objs, vel, SNR, randomShapes)
%GENERATEMOVINGPARTICLESMOVIE Summary of this function goes here
%   Detailed explanation goes here

% Filenames for output files
movieFileName = sprintf('%d_particles_%dpx_per_frame_SNR_%d_to_1_randomshapes_%s_512x.avi', num_objs, vel, SNR, mat2str(randomShapes));
tableFileName = sprintf('%d_particles_%dpx_per_frame_SNR_%d_to_1_randomshapes_%s.txt', num_objs, vel, SNR, mat2str(randomShapes));

% Movie Settings
frameRate = 5;
movieLength = 20;

x_array = randi([1 1024], num_objs, 1);
y_array = randi([1 1024], num_objs, 1);
r_array = 2 * rand(num_objs, 1) + 2;

movie = VideoWriter(movieFileName);
movie.FrameRate = frameRate;
open(movie)

tablex = zeros(frameRate * movieLength , num_objs); %creates matrix
tabley = zeros(frameRate * movieLength , num_objs); %creates matrix

% Generate frames of movie
for frameNo = 1 : frameRate * movieLength
    im = zeros(1024, 1024); % Zero out frame data to draw new frame
    
    % Draw irregular objects and update their positions
    for i = 1 : num_objs
        x_coord = x_array(i);
        y_coord = y_array(i);
        radius = r_array(i);
        
        % Create irregular objects centered on (x_coord, y_coord) with
        % maximum radius 'radius'
        for x = round(x_coord - radius) : round(x_coord + radius)
            for y = round(y_coord - radius) : round(y_coord + radius)
                dist = sqrt((x - x_coord)^2 + (y - y_coord)^2);
                % Only fill pixels that are within the boundaries and max
                % distance to (x_coord, y_coord)
                
                % If randomShapes is true, randomly scale the radius,
                % otherwise, use the current radius as the maximum distance
                if randomShapes && dist < radius * (0.3 * rand() + 0.7) && x < 1024 && x  > 1 && y < 1024 && y > 0
                    im(x,y) = 1;
                elseif ~randomShapes && dist < radius && x < 1024 && x  > 1 && y < 1024 && y > 0
                    im(x,y) = 1;
                end
            end
        end
        
        % Pick a random angle and move in that direction at speed 'vel'
        rand_angle = 2 * pi * rand(1);
        x_coord = x_coord + vel * cos(rand_angle);
        y_coord = y_coord + vel * sin(rand_angle);
        
        % Store new values for x and y in their respective arrays
        x_array(i) = x_coord;
        y_array(i) = y_coord;
        
        tablex(frameNo,i) = x_array(i); %stores all x coords of objects
        tabley(frameNo,i) = y_array(i) ; %stores all y coords of objects
    end
   
    
    im = imgaussfilt(im, 0.875); % Blur image
    
    % Generate noise with given SNR and add it to the image
    noise = 1/SNR * rand(1024, 1024);
    im = im + noise;    
    downscaledIm = imresize(im, [512 512]);
    
    downscaledIm(downscaledIm > 1) = 1;
    downscaledIm(downscaledIm < 0) = 0;
    
    writeVideo(movie, downscaledIm);
    
    imshow(im);
end

% creates cell array of position coordinates
table = horzcat(tablex, tabley); %full table stored in form [x, y]
num_frames = frameRate * movieLength; % get number of frames
labelrows = compose('frame %d', 1:num_frames)'; %row labels
labelcolsx = compose('obj %d x', 1:num_objs)'; %column labels for x-coordinates
labelcolsy = compose('obj %d y', 1:num_objs)'; %column labels for y-coordinates
labelcols = vertcat(labelcolsx, labelcolsy);
cellArray = [[{' '}; labelcols]'; labelrows num2cell(table)]; %create table with labels

writecell(cellArray, tableFileName);

close(movie);

end

