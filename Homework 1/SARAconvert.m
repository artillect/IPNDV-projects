
function SARAconvert(cezanneNumber)

% Read images and make them grayscale
IC1 = imread('cezanne 1.jpg');
IC1 = im2double((IC1));
IGT1 = imread('ground truth 1.jpg');
IGT1 = im2double((IGT1));

IC2 = imread('cezanne 2.jpg');
IC2 = im2double((IC2));
IGT2 = imread('ground truth 2.jpg');
IGT2 = im2double((IGT2));

IC3 = imread('cezanne 3.jpg');
IC3 = im2double((IC3));
IGT3 = imread('ground truth 3.jpg');
IGT3 = im2double((IGT3));

IC4 = imread('cezanne 4.jpg');
IC4 = im2double((IC4));
IGT4 = imread('ground truth 4.jpg');
IGT4 = im2double((IGT4));

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

% select painting to use
if cezanneNumber == 1
    IC = IC1;
    IGT = IGT1;
elseif cezanneNumber == 2
    IC = IC2;
    IGT = IGT2;
elseif cezanneNumber == 3
    IC = IC3;
    IGT = IGT3;
elseif cezanneNumber == 4
    IC = IC4;
    IGT = IGT4;
end

% Try to recreate original image
IC = im2double((IC));
FTC = fftn(fftshift(IC));

% Calculate the prediction of what the real image looked like
FTR = FTC ./ flt;

IR = ifftshift(ifftn(FTR));

% noise filtering
IRfilter = imgaussfilt3(IR,'FilterSize',9);
IRfilter = medfilt3(IRfilter);

% % color adjustment
% hsvImage = rgb2hsv(IRfilter); % Convert the image to HSV space
% hsvImage(:,:,2) = hsvImage(:,:,2)*1.5; % saturation adjustment
% hsvImage(hsvImage > 1) = 1; % limit max
% IRfilter = hsv2rgb(hsvImage)*80; % Convert the image back to RGB space
% IRfilter(:,:,2) = IRfilter(:,:,2)*1.05; % overall brightness adjustment

% sharpening
IRfilter = imsharpen(IRfilter,'Radius',0.1,'Amount',6);
IRfilter = imsharpen(IRfilter,'Radius',0.5,'Amount',3);
IRfilter = imsharpen(IRfilter,'Amount',10,'Threshold',0.7);

% % remove white pixels
% for i=1:size(IRfilter,1)-1
%     for j=1:size(IRfilter,2)-1
%         if IRfilter(i,j,:) == zeros(1,1,3)
%             IRfilter(i,j,:) = IRfilter(i-1,j-1,:);
%         end
%     end
% end

% output images
figure(2);
imshowpair(IGT,IRfilter,'montage');
title('Photo / Filtered Painting','FontSize',14)

end
