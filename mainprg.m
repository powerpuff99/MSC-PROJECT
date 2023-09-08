clc;
close all;
% Turn off this warning "Warning: Image is too big to fit on screen displaying at 33% "
% To set the warning state, you must first know the message identifier for the one warning you want to enable. 
% Query the last warning to acquire the identifier.  For example: 
% warnStruct = warning('query', 'last');
% msgid_integerCat = warnStruct.identifier
% msgid_integerCat =
%    MATLAB:concatenation:integerInteraction
warning('off', 'Images:initSize:adjustingMag');


% select folder
[inp1, pathname] = uigetfile('*.png');
if isequal(inp1,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(pathname, inp1)]);
end


    %input image

m=imread(inp1);
[~, ~, ~] = size(m);
im=imresize(m,[250,250]);

 %display originalimage
 figure, imshow(im),title('original image');
 %Converting the original image to gray scale
I = rgb2gray(im);
figure,imshow(I),title('Gray Image')
%histogram for original
imhist(I),title('histogram of gray image');

% %RGB VALUE

r=im(:,:,1);
g=im(:,:,2);
b=im(:,:,3);
             
% % % disckel
 th=graythresh(g);
ne=g>140;
binaryImage=ne;
%figure,imshow(binaryImage),title('binaryimage');
% Get rid of stuff touching the border
binaryImage = imclearborder(binaryImage);
fill=imfill(binaryImage,'holes');
%figure,imshow(fill);
se=strel('disk',6);
dil=imdilate(fill,se);
 
figure,imshow(dil);
title('disk image ');
 
% % % disckel
% th=graythresh(g);
ne=g>140;
binaryImage=ne;
% Get rid of stuff touching the border
binaryImage = imclearborder(binaryImage);
cup=imfill(binaryImage,'holes');
 
se1=strel('disk',2);
di=imdilate(cup,se1);
 
cup=di;
 
 figure,imshow(cup);
 title('cup image ');
 
 
% Extract only the two largest blobs.
% binaryImage = bwareafilt(binaryImage, 2);
% CC = bwconncomp(binaryImage,8);
% numPixels = cellfun(@numel,CC.PixelIdxList);
% [biggest,idx] = max(numPixels);
% BW(CC.PixelIdxList{idx}) = 0;
BW=binaryImage ;
CC = bwconncomp(BW);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
BW(CC.PixelIdxList{idx}) = 0;
filteredForeground=BW;

% % Fill holes 
 binaryImage = imfill(binaryImage, 'holes');

a = dil;
stats = regionprops(double(a),'Centroid',...
    'MajorAxisLength','MinorAxisLength');
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = diameters/2;
% Plot the circles.
 figure,imshow(im);
hold on
viscircles(centers,radii);
hold off
%display input image
figure;
subplot(3,3,1);
imshow(im);
title('input image ');
%disk segment image
subplot(3,3,2);
imshow(dil,[]);
title('disk segment image ');
%disc boundary
subplot(3,3,3);
imshow(im);
hold on
viscircles(centers,radii);
hold off
title('Disc boundary');
%display cup image
subplot(3,3,4);
imshow(di,[]);
title('cup image ');
%display cup boundary
subplot(3,3,5);
imshow(im);
hold on
viscircles(centers,radii/2);
hold off
title('cup boundary');
%cdr and rdr
c1=bwarea(dil);
c2=bwarea(di);
cdr=c2/(c1);
rim=(1-di)-(1-dil);
RDR=bwarea(rim)./(c2);
nn=sprintf('The CDR is  %2f ',cdr);
msgbox(nn);
pause(2)
nn1=sprintf('The RDR is  %2f ',RDR/2);
msgbox(nn1);
pause(2)
%Feature Extraction
glcm = graycomatrix(I);
R1 = graycoprops(glcm);
R2(1) = R1.Contrast;
R2(2) = R1.Correlation;
R2(3) = R1.Energy;
R2(4) = R1.Homogeneity;

textureval = R1.Contrast;R1.Correlation;R1.Energy;R1.Homogeneity;
disp TextureValue
disp(textureval);

    
%condition testing
if cdr<0.6
    
   msgbox('NO GLUCOMA DETECTED & NORMAL EYE ');

    
elseif cdr <0.8 && cdr>0.6 && (0.030<textureval)&&(textureval<=0.13)
    
    msgbox('GLAUCOMA DETECTED ');
    msgbox('pls provide  input');
x = inputdlg({'EYE PAIN','HEAD ACHE','VISION'}, 'Customer', [1 15;1 15;1 15]);

inp1=x{1};
    inp2=x{2};
    inp3=x{3};
    
     if inp1==1&&inp3==1

        msgbox('very low risk');
     else
       msgbox('LOW RISK')
        
    end
    
         
    
    
elseif cdr>0.8 &&(0.04<textureval)&&(textureval<=0.13)
    
    msgbox('GLUCOMA DETECTED ');
     msgbox('pls provide  input');
    x = inputdlg({'EYE PAIN','HEAD ACHE','VISION'}, 'Customer', [1 15; 1 15; 1 15]);
    inp1=x{1};
    inp2=x{2};
    inp3=x{3};
    if inp1==1 && inp3==1
        msgbox('consult doctor');
    else
     msgbox(' HIGH RISK');
         msgbox('CHECK UP FOR EVERY 2 MONTHS ');
    end
    
end
     
   

