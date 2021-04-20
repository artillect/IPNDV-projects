ImageJ;

import ij.measure.ResultsTable;

clear;

IJ = ij.IJ();

% Load movie to be tracked, change to user-input filename later
%mov = VideoReader("team SARA.avi");
IJ.open("testing movie.avi");

% Parameters for tracking
estimated_snr = 20;
estimated_vel = 4;
estimated_radius = 3;
estimated_size = round(pi*estimated_radius^2);
n_particles = 64;

timestep = 0.2;


% Set measurements for particle analysis
IJ.run("Set Measurements...", "area center centroid redirect=None decimal=3");

% Convert movie to grayscale
IJ.run("8-bit");

% Set threshold
IJ.setThreshold(255/estimated_snr + estimated_snr, 255);

largestTrajectoryID = n_particles;
particleCoords = zeros(0, 4);

% Track positions of particles from movie
for frame = 1:100
    IJ.setSlice(frame);
    
    % Find positions of particles 
    % (wrapped in evalc to suppress command window output)
    evalc('IJ.run("Analyze Particles...", "size=0-" + estimated_size + " show=Nothing display clear slice")');
    
    % Get results from ImageJ
    res = ResultsTable.getResultsTable();
    
    numFound = res.size();
    coords = zeros(res.size() - 1, 3);


    % Get coordinates of particles in frame
    for particleID = 1:n_particles
        if particleID < res.size()
            xm = res.getValue("XM", particleID);
            ym = res.getValue("YM", particleID);

            if frame ~= 1 % MATLAB recommends using 1i instead of i for "robustness"
                % Match particles to particles in previous frame
%                 closest_dist = 512;
                trajectoryID = 0;
                
                distArray = sqrt((xm * ones(size(lastCoords, 1), 1) - lastCoords(:, 2)).^2 + (ym * ones(size(lastCoords, 1), 1) - lastCoords(:, 3)).^2);
                errorArray = abs(distArray - estimated_vel);
                
                minError = min(errorArray);
                
                if minError > estimated_vel
                    disp("Regained track of particle in frame " + frame);
                end
                
                if minError < estimated_vel
                    lastParticleID = find(errorArray == minError);
                    if (abs(xm - lastCoords(lastParticleID, 2)) > 2 * estimated_vel) || (abs(ym - lastCoords(lastParticleID, 3)) > 2 * estimated_vel)
                        disp("no workey");
                    end
                    
                    
                    trajectoryID = lastCoords(lastParticleID, 1);
                end
                
                if trajectoryID == 0
                    trajectoryID = largestTrajectoryID + 1;
                    largestTrajectoryID = trajectoryID;
                else
                    % Remove this particle's match from the list of particles
                    % in the last frame
                    lastCoords(lastCoords(:,1) == trajectoryID, :) = []; 
                end
                

                
                coords(particleID, :) = [trajectoryID xm ym];
                particleCoords = [particleCoords; trajectoryID frame * timestep xm ym];

            % Give particles trajectory IDs for matching later
            elseif frame == 1
                coords(particleID, :) = [particleID xm ym];
                particleCoords = [particleCoords; particleID frame * timestep xm ym];
            end
        end
    end
    
    lastCoords = coords;
end

save('particlecoords.mat', 'particleCoords');
writematrix(particleCoords, 'particlecoords.xlsx');

ij.IJ.run("Quit","");
