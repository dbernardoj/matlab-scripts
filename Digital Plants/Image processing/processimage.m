% Read image
dir = '/Users/pma007/Dropbox/Vale/Digital Plants/Leaves/Leaves/7 - Phoebe nanmu [OK]/';
I = imread(strcat(dir,'1348.jpg'));
J = rgb2gray(I);
%figure, imshow(I)
%figure, imshow(J);

% Global image threshold using Otsu's method
level = graythresh(I);
BW = im2bw(I,level);
BWN = ~BW;
figure, imshow(BWN)

ds = bwareaopen(BW,5000);
figure, imshow(ds)
%BW_filled = imfill(BW,'holes');
%figure, imshow(BW_filled)

dim = size(BW);
col = round(dim(2)/2)-90;
row = min(find(BW(:,col)));
boundary = bwtraceboundary(BW,[row,col],'N');
%imshow(I)
%hold on;
%plot(boundary(:,2),boundary(:,1),'g','LineWidth',3);

% Apply Sobel and Canny edge deterctors
BW1 = edge(J,'sobel');
BW2 = edge(J,'canny');
%figure, imshow(BW1)
%figure, imshow(BW2)

s = size(BWN);
%{
for row = 2:55:s(1)
    for col=1:s(2)
        if BWN(row,col),
            break;
        end
    end
    
    contour = bwtraceboundary(BWN, [row, col], 'W', 8, Inf, 'counterclockwise');
    if(~isempty(contour))
        hold on;
        plot(contour(:,2),contour(:,1),'g','LineWidth',2);
        hold on;
        plot(col, row, 'bx','LineWidth',2);
    else
        hold on; plot(col, row, 'rx','LineWidth',2);
    end
end
%}

contour = bwtraceboundary(BWN, [126, 95], 'W', 8, Inf, 'counterclockwise');


%% 2. Find each of the four corners
[y,x] = find(BWN);
[~,loc] = min(y+x);
C = [x(loc),y(loc)];
[~,loc] = min(y-x);
C(2,:) = [x(loc),y(loc)];
[~,loc] = max(y+x);
C(3,:) = [x(loc),y(loc)];
[~,loc] = max(y-x);
C(4,:) = [x(loc),y(loc)];
%% 2.5 Find Euclidean Distance
d = pdist(C,'euclidean');
z = squareform(d);
%% 3. Plot the corners
imshow(BWN); hold all
plot(C([1:4 1],1),C([1:4 1],2),'r','linewidth',3);

%% Crop Image
wd = abs(1108-445);
hh = abs(522-624);
IC = imcrop(I,[445 624 wd hh]);
imshow(IC)