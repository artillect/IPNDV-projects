% Make sure to type:
% ImageJ;
% into your command window before running this script

% Follow the instructions here:
% https://imagej.net/MATLAB_Scripting.html#Prerequisites
% and here (2nd paragraph of intro):
% https://imagej.net/Miji
% to add ImageJ to your MATLAB path

clear

% Start ImageJ
ImageJ;
import ij.measure.ResultsTable;
IJ = ij.IJ();


% Open movie for tracking
fileName = input("Filename of movie to be tracked: ", 's');
if exist(fileName, 'file') ~= 2
    disp("Invalid filename");
    % Quit ImageJ
    ij.IJ.run("Quit","");
    return;
end
IJ.open(fileName);

% Get parameters for tracking
n_particles = input("Number of particles: ");
estimated_vel = input("Estimated particle velocity: ")/2;
estimated_radius = input("Estimated average particle radius: ");
estimated_area = round(pi*estimated_radius^2);

timestep = 0.2;

% Set measurements for particle analysis
IJ.run("Set Measurements...", "area center centroid redirect=None decimal=3");

% Convert movie to grayscale
IJ.run("8-bit");

largestTrajectoryID = n_particles;
particleCoords = zeros(0, 4);

% Track positions of particles from movie
for frame = 1:100
    IJ.setSlice(frame);
    % Auto threshold
    IJ.run("Auto Threshold", "method=Minimum white");
    
    % Find positions of particles 
    % (wrapped in evalc to suppress command window output)
    evalc('IJ.run("Analyze Particles...", "size=0-" + estimated_area + " show=Nothing display clear slice")');
    
    % Get results from ImageJ
    res = ResultsTable.getResultsTable();
    
    numFound = res.size();
    coords = zeros(res.size() - 1, 4);


    % Get coordinates of particles in frame
    for particleID = 1:n_particles
        if particleID < numFound
            xm = res.getValue("XM", particleID);
            ym = res.getValue("YM", particleID);

            if frame == 1 % Give particles trajectory IDs in first frame
                coords(particleID, :) = [particleID 1 xm ym];
                particleCoords = [particleCoords; particleID frame * timestep xm ym];
            else
                trajectoryID = 0;
                
                % Find the particle with the distance from this particle
                % that is closest to estimated_vel
                distArray = sqrt((xm * ones(size(lastCoords, 1), 1) - lastCoords(:, 3)).^2 + (ym * ones(size(lastCoords, 1), 1) - lastCoords(:, 4)).^2);
                errorArray = abs(distArray - estimated_vel);
                
                minError = min(errorArray);
                
                lastParticleID = find(errorArray == minError, 1);

                frameLastSeen = lastCoords(lastParticleID, 2);
                
                % If the error is low enough, the two particles match
                if minError < estimated_vel * (1 + frame - frameLastSeen)    
                    trajectoryID = lastCoords(lastParticleID, 1);
                    % Remove this particle's match from the list of particles
                    % in the last frame
                    lastCoords(lastCoords(:,1) == trajectoryID, :) = []; 
                end
                
                % If particle doesn't have a match, assign it a new
                % trajectoryID
                if trajectoryID == 0
                    trajectoryID = largestTrajectoryID + 1;
                    largestTrajectoryID = trajectoryID;
                end
                
                % Add coordinates of this particle to array for next loop
                % and output array
                coords(particleID, :) = [trajectoryID frame xm ym];
                particleCoords = [particleCoords; trajectoryID frame * timestep xm ym];
            end
        end
    end
    
    if frame == 1
        lastCoords = coords;
    else
        % Carry unmatched particles over to next iteration of loop
        lastCoords = [lastCoords; coords];
    end
end

for i = 1:size(lastCoords)
    ID = lastCoords(i, 1);
    frameLastSeen = lastCoords(i, 2);
    if frameLastSeen ~= frame
        disp("Lost track of particle " + lastCoords(i, 1) + " in frame " + lastCoords(i, 2));
    end
end

% Delete output file if it already exists
if exist('particlecoords.xlsx', 'file')==2
  delete('particlecoords.xlsx');
end

% Save tracking data to output file
writematrix(particleCoords, 'particlecoords.xlsx');

% Quit ImageJ
ij.IJ.run("Quit","");
