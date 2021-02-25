% Read images and make them grayscale
IC1 = imread('cezanne 1.jpg');
IC1 = im2double(rgb2gray(IC1));
IGT1 = imread('ground truth 1.jpg');
IGT1 = im2double(rgb2gray(IGT1));

IC2 = imread('cezanne 2.jpg');
IC2 = im2double(rgb2gray(IC2));
IGT2 = imread('ground truth 2.jpg');
IGT2 = im2double(rgb2gray(IGT2));

IC3 = imread('cezanne 3.jpg');
IC3 = im2double(rgb2gray(IC3));
IGT3 = imread('ground truth 3.jpg');
IGT3 = im2double(rgb2gray(IGT3));

IC4 = imread('cezanne 4.jpg');
IC4 = im2double(rgb2gray(IC4));
IGT4 = imread('ground truth 4.jpg');
IGT4 = im2double(rgb2gray(IGT4));

% Take 2d fourier transforms of images
FTC1 = fft2(fftshift(IC1));
FTGT1 = fft2(fftshift(IGT1));

FTC2 = fft2(fftshift(IC2));
FTGT2 = fft2(fftshift(IGT2));

FTC3 = fft2(fftshift(IC3));
FTGT3 = fft2(fftshift(IGT3));

FTC4 = fft2(fftshift(IC4));
FTGT4 = fft2(fftshift(IGT4));

% Determine filter for each image
flt1 = FTC1 ./ FTGT1;
flt2 = FTC2 ./ FTGT2;
flt3 = FTC3 ./ FTGT3;
flt4 = FTC4 ./ FTGT4;

% Take average of filters for a better result
flt = (flt1 + flt2 + flt3 + flt4)/4;

% Try to recreate original image
IC1 = imread('cezanne 3.jpg');
IC1 = im2double(rgb2gray(IC1));
FTC1 = fft2(fftshift(IC1));
FTGT1 = FTC1 ./ flt;

IGT1 = ifftshift(ifft2(FTGT1));

imshow(IGT1);