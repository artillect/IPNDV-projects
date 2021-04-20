clear

estimatedSnr = 20;
%estimatedVel = 4;
%estimatedRadius = 3;
%estimatedSize = round(pi*estimated_radius^2);
%nParticles = 64;

%timestep = 0.2;

totalSnr = 0;

%open video
movie = VideoReader("selectedmovie.avi");

%gets number of frames of the movie
numberOfFrames = movie.NumFrames;

%Create array for holding every frame
frameArray = cell(1, numberOfFrames);

%motion vector works on Gray Image formate
%A = double(rgb2gray(img)); 
%gets frame size
%[height, width] = size(A); 


for frame = 1 : numberOfFrames
		% Extract the frame from the movie structure.
		thisFrame = read(movie, frame);
        %make image grayscale
        grayImage = rgb2gray(thisFrame);
        
        %increases precision of image
        findNoise = im2double(thisFrame);
        %calculates average of noise
        meanNoise = mean(findNoise(:));
        %calculates std of noise
        noiseStd = std(findNoise(:));
        %calculates snr
        snr = log10(meanNoise/noiseStd)*estimatedSnr
        %add to total snr
        totalSnr = totalSnr + snr;
end

%find threshold and mean snr
threshold = totalSnr/numberOfFrames; 
%set counter
counter = 1;
for frame = 1 : numberOfFrames
    % Extract the frame from the movie structure.
    thisFrame = read(movie, frame);
    %reduce noise in frame
    %thisFrame = medfilt2(thisFrame);
    %^ not sure how to fix this error when uncommented
    
    
    %find values under the threshold
    underThresh = (thisFrame < threshold);
    %find values above the threshold
    aboveThresh = (thisFrame>= threshold);
    
    %assign values under threshold to 0
    frameArray{counter}(underThresh) = 0;
    %assign values above threshold to 255
    frameArray{counter}(aboveThresh) = 0;
    
    %
    imwrite(frameArray{counter},'text.png');
    %Read a binary image into workspace
    BW = imread('text.png');
    %returns the centroids in a structure array
    s = regionprops(BW,'centroid');
    %Store the x- and y-coordinates of the centroids into a two-column matrix
    centroids = cat(1,s.Centroid);
    
    %increases counter
    counter = counter+1;
end

%find size of centriod matrix
matrixSize = size(centroids(1)); %creates an error i dont know how to fix
%find the number of particles from the matrix size
nParticles = matrixSize(1);

disp(threshold);
disp(matrixSize);
disp(nParticles);









        