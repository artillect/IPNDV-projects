track = table2array(readtable('particlecoords.xlsx'));

trajectoryID = input("Enter the trajectory ID: ");

coordsForID = track(track(:,1) == trajectoryID, :);

figure(trajectoryID)
plot(coordsForID(:, 3), coordsForID(:, 4));

% for i = 1:size(coordsForID, 1)
%     scatter(coordsForID(i,3), coordsForID(i, 4));
%     axis([0 512 0 512]);
%     pause(0.1);
% end