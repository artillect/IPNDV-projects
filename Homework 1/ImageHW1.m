IO = imread('cezanne 1.jpg');
I = rgb2gray(IO);
I1 = IO;
FI1 = fft2(I1);
I1 = I;
FI1 = fft2(I1);
[x_sz, y_sz] = size(I1);
f1t = zeros(x_sz, y_sz);
f1t = random('Uniform', 0, 128, x_sz, y_sz);
f1t = floor(f1t);
Ff1t = fft2(f1t);
FI2 = FI1 .* Ff1t;
FI3 = FI2 ./ Ff1t;
I3 = ifft2(FI3);
imshow(I3)


f1t = random('Uniform', -8, 8, x_sz, y_sz);
Ff1t = fft2(f1t);
FI2 = FI1 .* Ff1t;
FI3 = FI2 ./ Ff1t;
I3 = ifft2(FI3);
imshow(I3)
FI3 = FI2./Ff1t;
I3 = ifft2(FI3);
imshow(uint8(I3));
IO = imread('cezanne 1.jpg');
I = rgb2gray(IO);
imshow(I);
f1t = random('Uniform', 0, 128, x_sz, y_sz);
f1t = floor(f1t);
Ff1t = fft2(f1t);
FI2 = FI1 .* Ff1t;
FI3 = FI2 ./ Ff1t;
imshow(FI3)