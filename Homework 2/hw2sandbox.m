%hw2 sandbox stuff!

im = zeros(1024,1024, 'uint8'); %clean slate image!
temp = zeros(1024, 1024, 'uint8'); %for manipulating



angles = linspace(0, 2*pi, 500); %don't need this in the loop, won't change
succDrawn = 0;

%until we have drawn [16] circles
while succDrawn < 32
    
    
    badCenters = true;
    while badCenters == true
        %random x centers
        centerx = randi([40,984], 1, 32); 
        %random y centers
        centery = randi([40,984], 1, 32);
        
        %check spacing of centers to ensure no concentric circles
        badCenters = false;
        d = 100000;
        for i=1:1:32
           for j=1:1:32
               if i ~= j
                   d = sqrt((centerx(j)-centerx(i))^2 + (centery(j)-centery(i))^2);
               end
               if (d < 40)
                   badCenters = true;
                   break
               end
           end
           if badCenters == true
               break
           end
        end
        
    end
    


    
    for i = 1:1:32 %for each center
       %attempt to draw circle
       x = centerx(i);
       y = centery(i);
       radius = randi([10,40]); %to be randomized
       
       xcoords = round(radius * cos(angles) + x);
       ycoords = round(radius * sin(angles) + y);
       
       
       %check all the coords (360) to see if intersect another circle
       
       flag = true;
       for j = 1:1:500
          if (temp(xcoords(j), ycoords(j)) ~= 0)
              flag = false;
              break
          end
       end
       
       
       if (flag == true)
           succDrawn = succDrawn + 1;
           %add the circle to temp
           %arbitrary intensity, to be randomized later
           intensity = randi([100, 180]);
           for j = 1:1:500
              temp(xcoords(j), ycoords(j)) = intensity; 
           end
       end
       
       
       if (succDrawn == 32)
           break
       end
    end
    

    
    
end

im = temp;
imwrite(im, 'hw2test.png');


