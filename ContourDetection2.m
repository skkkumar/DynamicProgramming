function ContourDetection2( imageName, contourFile1, contourFile2, mValue, lambda )
%ContourDetection2 A program to find contours in an image
%   Detailed explanation goes here


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

%% Make search space

searchObject = SearchSpace();
searchObject.makeSearchSpace(contourFile1,contourFile2, imageObject.imageMatrix, mValue);

%% Construct position matrix and energy function

energyObject = EnergyCalculation();
energyObject.findMinimalContour(searchObject, lambda);

%% Display the image

figure(1)
imagesc(imageObject.imageMatrix)
colormap(gray)
axis square

%% Load the contour and display it

%contourMatrix = load('init1.ctr');
% plot  contour
hold on;
%this ensures Matlab plots the contour on the same figure
plot(energyObject.realContourMatrix(:,1),energyObject.realContourMatrix(:,2),'r+-','LineWidth',1);


end

