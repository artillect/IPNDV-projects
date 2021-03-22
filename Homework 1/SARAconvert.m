
function SARAconvert(cezanneNumber)
% SARAconvert takes a number ranging from 1-6 as an input, and displays a
% prediction of the original image that the painting was based on

% cezanne 1.jpg through cezanne 4.jpg are reference paintings that were
% generated using a style transfer algorithm on ground truth 1.jpg through
% ground truth 4.jpg.

% cezanne 5.jpg and cezanne 6.jpg are two paintings by Cezanne that
% demonstrate the image-unpainting algorithm that we have written.

%% Create filter based on ai-generated paintings and ground truth images

% Read images and make them grayscale
% Original images from assignment
IC1 = imread('cezanne 1.jpg');
IC1 = im2double(IC1);
IGT1 = imread('ground truth 1.jpg');
IGT1 = im2double(IGT1);

IC2 = imread('cezanne 2.jpg');
IC2 = im2double(IC2);
IGT2 = imread('ground truth 2.jpg');
IGT2 = im2double(IGT2);

IC3 = imread('cezanne 3.jpg');
IC3 = im2double(IC3);
IGT3 = imread('ground truth 3.jpg');
IGT3 = im2double(IGT3);

IC4 = imread('cezanne 4.jpg');
IC4 = im2double(IC4);
IGT4 = imread('ground truth 4.jpg');
IGT4 = im2double(IGT4);

% Additional paintings with no ground truth image.
IC5 = imread('cezanne 5.jpg');
IC5 = im2double(IC5);

IC6 = imread('cezanne 6.jpg');
IC6 = im2double(IC6);

% Take 2d fourier transforms of images
FTC1 = fftn(fftshift(IC1));
FTGT1 = fftn(fftshift(IGT1));

FTC2 = fftn(fftshift(IC2));
FTGT2 = fftn(fftshift(IGT2));

FTC3 = fftn(fftshift(IC3));
FTGT3 = fftn(fftshift(IGT3));

FTC4 = fftn(fftshift(IC4));
FTGT4 = fftn(fftshift(IGT4));

% Determine filter for each image
flt1 = FTC1 ./ FTGT1;
flt2 = FTC2 ./ FTGT2;
flt3 = FTC3 ./ FTGT3;
flt4 = FTC4 ./ FTGT4;

% Take average of filters for a better result
flt = (flt1 + flt2 + flt3 + flt4)/4;


%% Determine what the real image that the painting is based on looks like

% Select painting to try to find the original image of
switch cezanneNumber
    case 1
        IC = IC1;
        IGT = IGT1;
    case 2
        IC = IC2;
        IGT = IGT2;
    case 3
        IC = IC3;
        IGT = IGT3;
    case 4
        IC = IC4;
        IGT = IGT4;
    case 5
        IC = IC5;
    case 6
        IC = IC6;
    otherwise
        disp("Please input a number from 1-6");
end

% Compute Fourier transform of image
IC = im2double(IC);
FTC = fftn(fftshift(IC));

% Calculate the prediction of what the real image looked like
FTR = FTC ./ flt;

IR = ifftshift(ifftn(FTR));

% Try to remove noise from image
IR = imgaussfilt3(IR,'FilterSize',9);
IR = medfilt3(IR);

% Sharpen image
IR = imsharpen(IR,'Radius',0.1,'Amount',6);
IR = imsharpen(IR,'Radius',0.5,'Amount',3);
IR = imsharpen(IR,'Amount',10,'Threshold',0.7);

%% Display filtered version of the painting

if cezanneNumber <= 4
    % If one of the reference images is chosen, show both the ground truth
    % and the painting images
    imshowpair(IGT,IR,'montage');
    title('Photo / Filtered Painting','FontSize',14)
elseif cezanneNumber >= 5
    % Only show the reversed painting if one of the reference images was
    % not chosen
    imshow(IR);
    title('Filtered Painting', 'FontSize',14)
end

imwrite(IR, 'reversed painting.jpg');