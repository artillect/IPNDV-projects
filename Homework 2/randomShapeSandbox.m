


nShapes = 16;

for j = 1:nShapes
    
    %random vertex numbers
    N = fix(20*rand(1,1)+5);

    %polarShape defining matrix
    %(N=length) theta,radius,
    polarShape = zeros(N,6);

    %populate polarShape matrix
    for i = 1:N-1

        %random theta
        theta = 720/N*rand(1,1);
        polarShape(i+1,1) = theta + polarShape(i,1);
        if polarShape(i+1,1) > 360
            polarShape(i+1,1) = 360;
        end

        %random radius
        radius = 10*rand(1,1)+2;
        polarShape(i,2) = radius;

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
    cartesianShape = fix(normalized*100*rand(1,1));
    
    % choose center location
    centerx = randi([40,984], 1);
    centery = randi([40,984], 1);
    
    % add center to coordinates
    cartesianShape(:,1) = cartesianShape(:,1) + centerx;
    cartesianShape(:,2) = cartesianShape(:,2) + centery;
    
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
    
    hold on
    plot(xcoords,ycoords)
    hold off
    
end




