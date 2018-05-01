classdef Image < handle
    %Image Utility class to handle all image related operations
    %   Detailed explanation goes here
    
    properties
        imageMatrix
        copyImageMatrix
    end
    
    methods
        function image = Image()
        end
        
        function getImage(image, fileName, isInvert)
            image.readImage(fileName);
            image.normalizeImage();
            if isInvert
                image.invertImage();
            end
            %image.applyAverageFilter();
            
        end
        function image = readImage(image, fileName)
            imageMatrix1 = imread(fileName);
            
            % do rgb to grey
            try
               image.imageMatrix = rgb2gray(image.imageName);
            catch
            end
            
            % extra processing for images that have 3 dimensions instead of
            % 2 and checking if image exists
            [rows, ~, planes] = size(imageMatrix1);
            %disp(['rows ' , num2str(rows)]);
            
            if rows == 0
                err = MException('FILEExc:FileNotFound', ...
                  'The image file %s can not be found or appears to be empty' , fileName );
               throw(err)
            end
            
            if planes == 3
               image.imageMatrix = imageMatrix1(:,:,3);
            else
               image.imageMatrix = imageMatrix1;
            end
        end
        
        function normalizeImage(image)
            % Convert the image to have values in the range 0 -1
            
            image.imageMatrix = double(image.imageMatrix);
            imax = max(max(image.imageMatrix));
            imin = min(min(image.imageMatrix));
            image.imageMatrix = (image.imageMatrix - imin)/(imax - imin);
            
        end
        
        function invertImage(image)
            % inverse all values so that minimization problem can be done
            [rows, columns] = size(image.imageMatrix);
            image.imageMatrix = ones(rows, columns) - image.imageMatrix;
            %disp(image.imageMatrix);
        end
        
        function [minPosition, minValue] = findMinimumIntensity(image)
            % find minimum value present in column 1
            minValue = 1.1;
            minPosition = -1;
            
            [rows, columns] = size(image.imageMatrix);
            
            for rowIndex = 1 : rows
                if image.imageMatrix(rowIndex,1) < minValue;
                    minValue = image.imageMatrix(rowIndex,1);
                    minPosition = rowIndex;
                end
            end
        end
        
        function applyAverageFilter(imageObject, mValue)
            imageObject.copyImageMatrix = imageObject.imageMatrix;
            averageMaskMatrix = fspecial('average', mValue);
            imageObject.copyImageMatrix = imfilter(imageObject.copyImageMatrix, averageMaskMatrix);
        end 
    end
end

