I=imread('receipt.jpeg');
%imshow(I)
% Thresholding Image 

I_gray=im2gray(I);
I_thresh=I_gray>126;
%imshow(I_thresh);

% Automatic Thresholding
%To automate the threshold selection 
%process, you can use the imbinarize 
%function, which calculates the "best" 
%threshold for the image
gsAdj = imadjust(I_gray); % This operation increases the contrast of the output image
I_AT=imbinarize(gsAdj);
%imshow(I_AT);

I_ATA = imbinarize(gsAdj,"adaptive");% look at smaller portions of the image and pick the best threshold
%imshow(I_ATA);


% select foreground 'bright' or 'dark'
I_ATAB = imbinarize(gsAdj,"adaptive","ForegroundPolarity","dark");% look at smaller portions of the image and pick the best threshold
%figure(1);

%imshowpair(I_AT,I_ATAB,"montage")
%Identifying Text Patterns
S=sum(I_AT);
figure(2);

%plot(S);

%Remove Noise from  image
F = fspecial("average",3);%Create a 3-by-3 averaging median filter 
Ifltr = imfilter(gsAdj,F);
figure(4);
%imshowpair(Ifltr,gsAdj,"montage")

Ifltr2 = imfilter(gsAdj,F,"replicate");
figure(5);
%imshowpair(Ifltr,Ifltr2,"montage")%using pixel intensity values on the image border for pixels outside the image
%Binarization after filtring
I_ATAB1 = imbinarize(Ifltr2,"adaptive","ForegroundPolarity","dark");
%imshow(I_ATAB1);

%Background subtraction
SE = strel("disk",8);
Iclosed = imclose(Ifltr,SE);
%imshowpair(Ifltr,Iclosed,"montage");

Isub =  Iclosed-Ifltr;

Isub=~imbinarize(Isub);
%imshow(Isub);
% Or we can use directly  "bottom hat transform" function  in Matlab
BW = imbothat(Ifltr,SE);
imshow(BW);

%Final work 
figure(10)
montage({I,I_gray});
figure(11)

montage({gsAdj,I_thresh});
figure(12)

montage({Iclosed,Ifltr,Isub,'Size',[1 3]});