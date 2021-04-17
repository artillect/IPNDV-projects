function checkTrack(file)

% input tracked data
track = table2array(readtable(file));

%input ground truth data
ground = dataConversion('selected_movie_table.xlsx')/2; %team sara
%ground = dataConversion('selected_movie_table.xlsx')/2; %fiji water
%ground = dataConversion('selected_movie_table.xlsx')/2; %pixel pushers
%ground = dataConversion('selected_movie_table.xlsx')/2; %rugrats

%reset success
success = 0;

for i = 1:181
    
    % define point, frame, and comparison values
    trackedPoint = [track(i,4),track(i,5)];
    currentFrame = track(i,3);
    realPoints = [ground(1:256,3),ground(1:256,4)];
    
    % determine closest point
    dist = bsxfun(@hypot,realPoints(:,1)-trackedPoint(1),realPoints(:,2)-trackedPoint(2));
    closest = realPoints(dist==min(dist),:)
    
    % determine if tracked
    distance = ( (trackedPoint(1)-closest(1))^2 + (trackedPoint(2)-closest(2))^2 )^(0.25);
    if distance < 5
        success = success + 1;
    end
    
end

success

end
