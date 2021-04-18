clear
IJ = ij.IJ();

import ij.measure.ResultsTable
% Load movie to be tracked, change to user-input filename later
%mov = VideoReader("team SARA.avi");
IJ.open("team SARA.avi");

% Parameters for tracking
estimated_snr = 2;
estimated_vel = 32;
estimated_radius = 2;
estimated_size = round(pi*estimated_radius^2);
n_particles = 256;

timestep = 0.2;
% Autothreshold images


% Set measurements for particle analysis
IJ.run("Set Measurements...", "area center centroid redirect=None decimal=3");

particleCoords = zeros(0, n_particles*2);

% Track positions of particles from movie
for frame = 1:100
    IJ.setSlice(frame);
    
    % Convert frame to grayscale
    IJ.run("8-bit");
    
    IJ.setThreshold(140, 255);
    % Find positions of particles 
    % (wrapped in evalc to suppress command window output)
    evalc('IJ.run("Analyze Particles...", "size=0-" + estimated_size + " show=Nothing display clear slice")');
    
    % Get results from ImageJ
    res = ResultsTable.getResultsTable();
    
    numFound = res.size();

    
    % Get coordinates of particles in frame
    for particleID = 1:n_particles
        if particleID < res.size()
            x_m = res.getValue("XM", particleID);
            y_m = res.getValue("YM", particleID);
            particleCoords = [particleCoords; particleID frame * timestep x_m y_m];
        end
    end
    
    save('particlecoords.mat', 'particleCoords');
end
