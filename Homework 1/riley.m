% Read image and make it grayscale
I1 = imread('cezanne 1.jpg');
I1 = im2double(rgb2gray(I1));
I0 = imread('ground truth 1.jpg');
I0 = im2double(rgb2gray(I0));

FT1 = fft2(fftshift(I1));
FT0 = fft2(fftshift(I0));

flt = FT1 ./ FT0;

figure(1);
imshow(flt);

I1 = imread('cezanne 2.jpg');
I1 = im2double(rgb2gray(I1));
FT1 = fft2(fftshift(I1));
FT0 = FT1 ./ flt;

I0 = ifftshift(ifft2(FT0));
figure(2);

imshow(I0);