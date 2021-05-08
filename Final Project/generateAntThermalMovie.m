%GENERATEMOVINGPARTICLESMOVIE Generates a movie with random particle motion
% and size based on parameters
%   movieFileName is the file name of the movie output file given these parameters
%   tableFileName is the file name of the table of the objects locations over
%       time
%   num_particles is the number of particles that will be in the movie
%   vel is the velocity of

num_particles = 12;
vel = 10;
SNR = 5;

% Filenames for output files
movieFileName = sprintf('ants_thermal_movie_%d_ants.avi', num_particles);
tableFileName = sprintf('ants_thermal_movie_%d_ants.txt', num_particles);

% Movie Settings
frameRate = 30;
movieLength = 4;
width = 1024;
height = 1280;

% Ant dimensions
ant_w = 6;
ant_l = ant_w * 4;

% Generate random x and y coordinates for each object, and give each object
% a random radius
x_array = randi([1 width], num_particles, 1);
y_array = randi([1 height], num_particles, 1);
vel_array = vel * rand(num_particles, 1);
th_array = 2 * pi * rand(num_particles, 1);
th_dot_array = 0.16 * (rand(num_particles, 1) - 0.5);

% Set up movie for writing
movie = VideoWriter(movieFileName);
movie.FrameRate = frameRate;
open(movie)

% Create table of x and y coordinates for each object in each frame
tablex = zeros(frameRate * movieLength , num_particles);
tabley = zeros(frameRate * movieLength , num_particles);

% Generate frames of movie
for frameNo = 1 : frameRate * movieLength
    im = zeros(width, height); % Zero out frame data to draw new frame
    
    % Draw irregular objects and update their positions
    for i = 1 : num_particles
        x_coord = x_array(i);
        y_coord = y_array(i);
        theta = th_array(i);
        
        % Create irregular objects centered on (x_coord, y_coord) with
        % maximum radius 'radius'
        for x = round(x_coord - ant_l) : round(x_coord + ant_l)
            for y = round(y_coord - ant_l) : round(y_coord + ant_l)
                
                delta_x = x - x_coord;
                delta_y = y - y_coord;
                
                if (delta_x * cos(theta + pi /2) + delta_y * sin(theta + pi /2))^2/ant_w^2 + (delta_y * cos(theta + pi /2) - delta_x * sin(theta + pi /2))^2/ant_l^2 < 1
                    if 0 < x && x < width && 0 < y && y < height
                        im(x, y) = 1;
                    end
                end
                % If randomShapes is true, randomly scale the radius,
                % otherwise, use the current radius as the maximum distance
%                 if randomShapes && dist < radius * (0.3 * rand() + 0.7) && x < 1024 && x  > 1 && y < 1024 && y > 0
%                     im(x,y) = 1;
%                 elseif ~randomShapes && dist < radius && x < 1024 && x  > 1 && y < 1024 && y > 0
%                     im(x,y) = 1;
%                 end
            end
        end
        
        % Change direction slightly and move in that direction at speed 'vel'
        new_angle_dot = th_dot_array(i) + 0.25 * (rand(1) - 0.5);
        max_angle_dot = 0.1;
        
        if new_angle_dot > max_angle_dot || new_angle_dot < -max_angle_dot
            new_angle_dot = sign(new_angle_dot) * max_angle_dot;
        end
        delta_angle = new_angle_dot;
        new_angle = theta + delta_angle;
        
        v = vel_array(i);
        new_vel = v + 2 * (rand(1) - 0.5);
        x_coord = x_coord + new_vel * cos(new_angle);
        y_coord = y_coord + new_vel * sin(new_angle);
        
        % Prevent ants from leaving the frame
        if x_coord < 0
            x_coord = 0;
        end
        if x_coord > width
            x_coord = width;
        end
        if y_coord < 0
            y_coord = 0;
        end
        if y_coord > height
            y_coord = height;
        end

        % Store new values for x and y in their respective arrays
        x_array(i) = x_coord;
        y_array(i) = y_coord;
        th_array(i) = new_angle;
        th_dot_array(i) = new_angle_dot;

        tablex(frameNo,i) = x_array(i); %stores all x coords of objects
        tabley(frameNo,i) = y_array(i) ; %stores all y coords of objects
    end

    % Blur image and add noise to it
    im = imgaussfilt(im, 4);
    im = imnoise(im, 'gaussian', 1/SNR, 0.001);

    % Downscale the image and clamp intensity values to the range [0, 1]
    downscaledIm = imresize(im, [width/2 height/2]);
    downscaledIm(downscaledIm > 1) = 1;
    downscaledIm(downscaledIm < 0) = 0;

    % Write the frame to the filesystem
    writeVideo(movie, downscaledIm);

    % Display the current frame
    imshow(im);
end

% creates cell array of position coordinates
table = horzcat(tablex, tabley); %full table stored in form [x, y]
num_frames = frameRate * movieLength; % get number of frames
labelrows = compose('frame %d', 1:num_frames)'; %row labels
labelcolsx = compose('ant %d x', 1:num_particles)'; %column labels for x-coordinates
labelcolsy = compose('ant %d y', 1:num_particles)'; %column labels for y-coordinates
labelcols = vertcat(labelcolsx, labelcolsy);
cellArray = [[{' '}; labelcols]'; labelrows num2cell(table)]; %create table with labels

% Write table of x and y coordinates to filesystem
writecell(cellArray, tableFileName);

% Clean up
close(movie);
