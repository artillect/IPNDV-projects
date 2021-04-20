import ij.measure.ResultsTable;

clear;

IJ = ij.IJ();

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


% Set measurements for particle analysis
IJ.run("Set Measurements...", "area center centroid redirect=None decimal=3");

% Convert movie to grayscale
IJ.run("8-bit");

% Set threshold
IJ.setThreshold(140, 255);


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
    
    if frame == 1
        largestTrajectoryID = numFound;
    else
        largestTrajectoryID = max(lastCoords(:,1));
    end

    % Get coordinates of particles in frame
    for particleID = 1:n_particles
        if particleID < res.size()
            xm = res.getValue("XM", particleID);
            ym = res.getValue("YM", particleID);

            if frame ~= 1 % MATLAB recommends using 1i instead of i for "robustness"
                % Match particles to particles in previous frame
                closest_dist = 512;
                trajectoryID = 0;
                
                for j = 1:size(lastCoords)
                    % Keep track of largest trajectory ID so we can create
                    % new trajectories for particles that we lose track of
                    % and then find again
                    dist = sqrt((xm - lastCoords(j, 2))^2 + (ym - lastCoords(j, 3))^2);
                    
                    if dist > 2 * estimated_vel
                        continue
                    elseif abs(estimated_vel - dist) < abs(estimated_vel - closest_dist)
                        closest_dist = dist;
                        trajectoryID = lastCoords(j, 1);
                    end
                end
                
                if trajectoryID == 0
                    trajectoryID = largestTrajectoryID + 1;
                    largestTrajectoryID = trajectoryID;
                end
                
                % Remove this particle's match from the list of particles
                % in the last frame
                lastCoords(lastCoords(:,1) == trajectoryID, :) = [];
                
                coords(particleID, :) = [particleID xm ym];
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
