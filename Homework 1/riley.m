% Read image and make it grayscale
I0 = imread('ground truth 1.jpg');
I0 = rgb2gray(I0);
I1 = imread('cezanne 1.jpg');
I1 = rgb2gray(I1);

FT0 = fft(I0);
FT1 = fft(I1);

flt = FT0 ./ FT1;

figure(1);
imshow(flt);

I0 = imread('ground truth 2.jpg');
I0 = rgb2gray(I0);
FT0 = fft(I0);
FT1 = FT0 .* flt;

I1 = ifft(FT1);
figure(2);
imshow(I1);