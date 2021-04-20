track = table2array(readtable('particlecoords.xlsx'));

trajectoryID = input("Enter the trajectory ID: ");

coordsForID = track(track(:,1) == trajectoryID, :);

plot(coordsForID(:,3), coordsForID(:, 4));