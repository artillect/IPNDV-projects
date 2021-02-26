% Read images and make them grayscale
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


figure(1);
imshow(IC3);

IC4 = imread('cezanne 4.jpg');
IC4 = im2double(IC4);
IGT4 = imread('ground truth 4.jpg');
IGT4 = im2double(IGT4);

% Take 2d fourier transforms of images
FTC1 = fftn(fftshift(IC1));
FTGT1 = fftn(fftshift(IGT1));

figure(2);
imshow(FTC1);

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
figure(3);
imshow(flt);

% Try to recreate original image
IC = imread('cezanne 3.jpg');
IC = im2double(IC);
FTC = fftn(fftshift(IC));
% Calculate the prediction of what the real image looked like
FTR = FTC ./ flt;

IR = ifftshift(ifftn(FTR));

figure(4);
imshow(fftn(fftshift(IR)));

figure(5);
imshow(IR);