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

% Autothreshold images


% Set measurements for particle analysis
IJ.run("Set Measurements...", "area center centroid redirect=None decimal=3");

% Track positions of particles from movie
for i = 1:100
    IJ.setSlice(i);
    
    % Convert frame to grayscale
    IJ.run("8-bit");
    
    IJ.setThreshold(140, 255);
    % Find positions of particles
    IJ.run("Analyze Particles...", "size=0-" + estimated_size + " show=Nothing display clear slice");
    
    % 
    res = ResultsTable.getResultsTable();
    
    for particleID = 1:(res.size() - 1)
       x_m = res.getValue("XM", particleID);
       y_m = res.getValue("YM", particleID);
    end
end
