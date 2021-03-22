function im = randomIrregularShapes(nShapes)

im = zeros(1024,1024, 'uint8');
succDrawn = 0;

%until we have drawn n circles
while succDrawn < nShapes
    
    badCenters = true;
    while badCenters == true
        %random x centers
        centerx = randi([100,924], 1, nShapes);
        %random y centers
        centery = randi([100,924], 1, nShapes);
        
        %check spacing of centers to ensure no concentric circles
        badCenters = false;
        for i=1:1:nShapes
           for j=1:1:nShapes
               dist2 = 101;
               if i ~= j
                   dist2 = sqrt((centerx(j)-centerx(i))^2 + (centery(j)-centery(i))^2);
               end
               if dist2 < 101
                   badCenters = true;
               end
           end
        end
        
    end

    for i = 1:1:nShapes %for each center
    
        %random vertex numbers
        N = fix(15*rand(1,1)+5);

        %polarShape defining matrix
        %(N=length) theta,radius,
        polarShape = zeros(N,2);

        %populate polarShape matrix
        for j = 1:N-1

            %random theta
            theta = 720/N*rand(1,1);
            polarShape(j+1,1) = theta + polarShape(j,1);
            if polarShape(j+1,1) > 360
                polarShape(j+1,1) = 360;
            end

            %random radius
            radius = 10*rand(1,1)+5;
            polarShape(j,2) = radius;

        end

        % end polar conditions
        polarShape(N,1) = 360; %last theta=360
        polarShape(N,2) = polarShape(1,2); %last radius = first radius

        % convert to cartestian
        cartesianShape = zeros(N,2);
        cartesianShape(:,1) = polarShape(:,2) .* cos(polarShape(:,1)*(pi/180));
        cartesianShape(:,2) = polarShape(:,2) .* sin(polarShape(:,1)*(pi/180));

        % convert to pixel dimensions
        longAxis = max(max(cartesianShape));
        normalized = cartesianShape/longAxis;
        cartesianShape = fix(normalized*randi([20,50],1));

        % add center to coordinates
        cartesianShape(:,1) = cartesianShape(:,1) + centerx(i);
        cartesianShape(:,2) = cartesianShape(:,2) + centery(i);

        xcoords = zeros(1);
        ycoords = zeros(1);

        for k = 1:N-1
            xNcoords = round(linspace(cartesianShape(k,1),cartesianShape(k+1,1),500));
            xcoords = [xcoords,xNcoords];

            yNcoords = round(linspace(cartesianShape(k,2),cartesianShape(k+1,2),500));
            ycoords = [ycoords,yNcoords];

        end
    
        xcoords = xcoords(2:end);
        ycoords = ycoords(2:end);     

%        %check all the coords (360) to see if intersect another circle
%        
%        flag = true;
%        for j = 1:1:500
%           if (temp(xcoords(j), ycoords(j)) ~= 0)
%               flag = false;
%               break
%           end
%        end
       
       %if (flag == true)
           succDrawn = succDrawn + 1;
           %add the circle to temp
           %arbitrary intensity, to be randomized later
           intensity = randi([100, 180]);
           for j = 1:1:size(xcoords,2)
              im(xcoords(j), ycoords(j)) = intensity; 
           end
       %end  
       
       if (succDrawn == nShapes)
           break
       end
    end
     
end

end