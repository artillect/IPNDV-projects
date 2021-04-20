track = table2array(readtable('particlecoords.xlsx'));

trajectoryID = input("Enter the trajectory ID: ");

coordsForID = zeros(0, 4);

for i = 1:size(track)
    if track(i, 1) == trajectoryID
        coordsForID = [coordsForID; track(i, :)];
    end
end


figure(trajectoryID)
plot(coordsForID(:, 3), coordsForID(:, 4));
axis([0 512 0 512]);
axis square

% for i = 1:size(coordsForID, 1)
%     scatter(coordsForID(i,3), coordsForID(i, 4));
%     axis([0 512 0 512]);
%     pause(0.1);
% end