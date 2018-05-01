function ContourDetection3( imageName, contourFile1, contourFile2 , mValue, lambda)
%ContourDetection3  A program to find contours in an image
%   Detailed explanation goes here


%  ContourDetection3('resources/images/tongue.png','resources/init1.ctr','resources/init2.ctr')

%% Argument checking

if ~ ischar(imageName)
    % Construct an MException object to represent the error.
    err = MException('ArgCheck:NullValueInArgument', ...
       'Input parameter imageName has to be string');
    throw(err)
end
if ~ ischar(contourFile1)
    % Construct an MException object to represent the error.
    err = MException('ArgCheck:NullValueInArgument', ...
       'Input parameter contourFile1 has to be string');
    throw(err)
end
if ~ ischar(contourFile2)
    % Construct an MException object to represent the error.
    err = MException('ArgCheck:NullValueInArgument', ...
       'Input parameter contourFile2 has to be string');
    throw(err)
end
if lambda > 1
    % Construct an MException object to represent the error.
    err = MException('ArgCheck:IntLimitArgument', ...
        'Input parameter lambda has to be less than equal to 1 and greater than equal to 0');
    throw(err)
elseif lambda < 0
    % Construct an MException object to represent the error.
    err = MException('ArgCheck:IntLimitArgument', ...
        'Input parameter lambda has to be less than equal to 1 and greater than equal to 0');
    throw(err)
end

%% Reading the image
imageObject = Image();
imageObject.getImage(imageName, false);

        

%% Peform some filtering
imageObject.applyAverageFilter(mValue);


%% make search space by imaginary countour lines

searchObject = SearchSpace();
searchObject.makeSearchSpace(contourFile1,contourFile2, imageObject.imageMatrix, mValue);


%% Construct position matrix and energy function and backtrack
energyObject = EnergyCalculation();
energyObject.findMinimalContour3(searchObject, lambda);


%% Display the image

figure(1)
imagesc(imageObject.imageMatrix)
colormap(gray)
%axis square
scaleGraph1 = axis;

%% Load the contour and display it

%contourMatrix = load('init1.ctr');
% plot  contour
hold on;
%this ensures Matlab plots the contour on the same figure

plot(searchObject.contourLine1(:,1),searchObject.contourLine1(:,2),'r+-','LineWidth',2);
plot(searchObject.contourLine2(:,1),searchObject.contourLine2(:,2),'r+-','LineWidth',2);

% plot first two lines generated by bresenham's algo
[linesCount] = size(searchObject.lineMatrix);
%for lineIndex = 1 : 1

%plot(searchObject.lineMatrix(lineIndex, :,1),searchObject.lineMatrix(lineIndex, :,2),'b','LineWidth',1);
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
plot(energyObject.contourMatrix(:,1),energyObject.contourMatrix(:,2),'r+-','LineWidth',2);


end

