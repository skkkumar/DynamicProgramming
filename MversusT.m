
%% A program to find contours in an image
clear

%% Reading the image

imageObject = Image();
imageObject.getImage('resources/images/tongue.png', true);


%% make search space by imaginary countour lines

searchObject = SearchSpace();
searchObject.makeSearchSpace('resources/init1.ctr','resources/init2.ctr', imageObject.imageMatrix, -1);


%% find the size of the search space which will be used as the limit of the value for m
% this value will also be used to apply the average filter
[spaceSearchRowsLimit, ~] = size(searchObject.searchSpace);

 %% make time graph

timeGraph = zeros(spaceSearchRowsLimit, 2);
    
%% start process

lastIndex = 0;
% mValueInverse is just the distance i.e length / mvalue
for mValue =  1 : spaceSearchRowsLimit
   disp(['m' , num2str(mValue)]);

   %mValueInverse = 1;%spaceSearchRowsLimit ;

   % first filter the image
    imageObject.applyAverageFilter(mValue);
    searchObject.makeSearchSpace('resources/init1.ctr','resources/init2.ctr', imageObject.copyImageMatrix, mValue);

   %searchObject.makeSearchSpace('resources/init1.ctr','resources/init2.ctr', imageObject.imageMatrix, mValue);
    
    %% can start tic toc

    tic;

    %% Construct position matrix and energy function and backtrack
    energyObject = EnergyCalculation();
    energyObject.findMinimalContour3(searchObject);

    %% can end tic toc

    %timeGraph( floor(spaceSearchRowsLimit / mValueInverse) , 1) =  floor(spaceSearchRowsLimit / mValueInverse);
    %replace old value
    %if lastIndex == 0 || timeGraph( lastIndex , 1) ~= mValue
    lastIndex=lastIndex+1;
    %end
    timeGraph( lastIndex , 2) = toc;
    timeGraph( lastIndex , 1) = mValue ;
    
end

%% Display the image

figure(1)
imagesc(imageObject.imageMatrix)
colormap(gray)
%axis square
scaleGraph1 = axis;

%% Load the contour and display it

% plot  contour
hold on;
%this ensures Matlab plots the contour on the same figure

plot(searchObject.contourLine1(:,1),searchObject.contourLine1(:,2),'r+-','LineWidth',2);
plot(searchObject.contourLine2(:,1),searchObject.contourLine2(:,2),'r+-','LineWidth',2);

% plot first two lines generated by bresenham's algo
[linesCount] = size(searchObject.lineMatrix);
%for lineIndex = 1 : 1
   % plot(searchObject.lineMatrix(lineIndex, :,1),searchObject.lineMatrix(lineIndex, :,2),'b','LineWidth',1);
%plot(lineMatrix(2, :,1),lineMatrix(2, :,2),'y+-','LineWidth',1);
%end
% plot real contour matrix
plot(energyObject.realContourMatrix(:,1),energyObject.realContourMatrix(:,2),'g+-','LineWidth',2);
%% Display the contour

figure(2)
imagesc(searchObject.searchSpace)
colormap(gray)
axis square
%axis(scaleGraph1);

hold on;
plot(energyObject.contourMatrix(:,1),energyObject.contourMatrix(:,2),'r+-','LineWidth',1);

figure(3)
plot(timeGraph(:,1), timeGraph(:,2), 'g');