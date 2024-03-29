% Read images and make them grayscale
IC1 = imread('cezanne 1.jpg');
IC1 = im2double(rgb2gray(IC1));
IGT1 = imread('ground truth 1.jpg');
IGT1 = im2double(rgb2gray(IGT1));

%figure(1);
%imshow(IC1);

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
FTC1 = fft2(IC1);
FTGT1 = fft2(IGT1);

%figure(2);
%imshow(FTC1);

FTC2 = fft2(IC2);
FTGT2 = fft2(IGT2);

FTC3 = fft2(IC3);
FTGT3 = fft2(IGT3);

FTC4 = fft2(IC4);
FTGT4 = fft2(IGT4);

% Determine filter for each image
flt1 = FTC1 ./ FTGT1;
flt2 = FTC2 ./ FTGT2;
flt3 = FTC3 ./ FTGT3;
flt4 = FTC4 ./ FTGT4;

% Take average of filters for a better result
flt = (flt1 + flt2 + flt3 + flt4)/4;
%figure(3);
%imshow(flt);

% Try to recreate original image
IC = imread('painting to reverse 2.jpg');
IC = im2double(rgb2gray(IC));
FTC = fft2(IC);
% Calculate the prediction of what the real image looked like
FTR = FTC ./ flt;


IR = ifft2(FTR);

figure(4);
imagesc(abs(fft2(IR)));

figure(5);
imshow(IR);

imwrite(IR, 'reversed painting.jpg');