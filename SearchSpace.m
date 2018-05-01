classdef SearchSpace < handle
    %UNTITLED8 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        contourLine1
        contourLine2
        searchSpace
        lineMatrix
        realContourMatrix
        noOfPoints
    end
    
    methods
        
        function loadContours(searchObject, fileName1, fileName2)
            try
                searchObject.contourLine1 = load(fileName1); % simple2.ctr, init1.ctr
            catch a
                err = MException('FILEExc:FileNotFound', ...
                    'The contour file %s can not be found' , fileName1 );
                throw(err)
            end
            try
                searchObject.contourLine2 = load(fileName2);
            catch a
                err = MException('FILEExc:FileNotFound', ...
                    'The contour file %s can not be found' , fileName2 );
                throw(err)
            end
            % get dimensions that will be used later
            [searchObject.noOfPoints,~] = size(searchObject.contourLine1);
        end
        
        function makeSearchSpace(searchObject, fileName1, fileName2, imageMatrix, noOfPoints)
            % take sample values from the search space defined by these lines
            loadContours(searchObject, fileName1, fileName2)
            
            % make lines
            searchObject.searchSpace = [];%zeros(mValue, mValue);
            
            searchObject.lineMatrix = [];
            
            %disp(['no of points ' , num2str(searchObject.noOfPoints)]);
            
            for lineIndex = 1 : searchObject.noOfPoints
                
                startX = searchObject.contourLine2(lineIndex,1);
                startY = searchObject.contourLine2(lineIndex,2);
                endX = searchObject.contourLine1(lineIndex,1);
                endY = searchObject.contourLine1(lineIndex,2);
                
                line = BresenhamLine.makeLineMatrix(startX, startY, endX, endY, noOfPoints );
                %disp(line);
                [pointCount, ~] = size(line);
                % disp(['size of line ', num2str(pointCount)]);
                for rowCounter = 1 :  pointCount
                    pointX = line(rowCounter, 1);
                    pointY = line(rowCounter, 2);
                    
                    if pointX == 0
                         err = MException('ArgCheck:NullValueInArgument', ...
                            'Input parameter m is to large');
                         throw(err)
                    end
                    
                    % disp(['point --> ',num2str(pointX),' ',num2str(pointY)]);
                    
                    searchObject.searchSpace(   rowCounter, lineIndex) = imageMatrix( pointY, pointX);
                    %disp(['point --> ' , num2str(columnCounter), ' ' , num2str(rowIndex) ,' : ' ,  num2str(pointX), ', ', num2str( pointY) , 's intensity = ' , num2str(imageMatrix( pointY , pointX))]);
                    %searchObject.lineMatrix(lineIndex, pointY - searchObject.contourLine2(lineIndex,2) + 1, 1) = pointX;
                    %searchObject.lineMatrix(lineIndex, pointY - searchObject.contourLine2(lineIndex,2) + 1, 2) = pointY;
                    
                    searchObject.lineMatrix(lineIndex, rowCounter, 1) = pointX;
                    searchObject.lineMatrix(lineIndex, rowCounter, 2) = pointY;
                    
                end
                
            end
        end
        
        function shiftMatrices(searchObject, midpoint)
            %copyLineMatrix = searchObject.lineMatrix;
            %copySearchMatrix = searchObject.searchSpace;
            
            [rows,columns, ~] = size(searchObject.lineMatrix);
            %disp(['start ' , num2str(midpoint - 1),  ' to ' , num2str(rows)]);
            
            part1 = searchObject.lineMatrix(1 : midpoint - 1, :, :);
            part2 = searchObject.lineMatrix(midpoint : rows, :, :);
            searchObject.lineMatrix = [part2; part1];
             %disp(['start ' , num2str(midpoint - 1),  ' to ' , num2str(rows)]);
           
             
            %disp(size(searchObject.lineMatrix));
            %disp(size(searchObject.searchSpace));
            [~ , columns ] = size(searchObject.searchSpace);
            part1 = searchObject.searchSpace(:, 1 : midpoint -1);
             %disp(size(part1));
            part2 = searchObject.searchSpace(:, midpoint : columns);
            % disp(size(part2));
            searchObject.searchSpace = [part2 part1];
            
           % disp(size(searchObject.searchSpace));
            %{
            for j = 1 : columns
                
                for i = 1 : midpoint - 1
                    searchObject.lineMatrix(i + midpoint + 1, j, 1) = copyLineMatrix(i, j, 1);
                    searchObject.lineMatrix(i + midpoint + 1, j, 2) = copyLineMatrix(i, j, 2);
                end
                
                for i = midpoint  : rows
                    searchObject.lineMatrix(i - midpoint + 1, j, 1) = copyLineMatrix(i, j, 1);
                    searchObject.lineMatrix(i - midpoint + 1, j, 2) = copyLineMatrix(i, j, 2);
                end
                
            end
            %}
            %{
            [rows , ~ ] = size(searchObject.searchSpace);
            for j = 1 : rows
                for i = 1 : midpoint - 1
                    searchObject.searchSpace(j ,i + midpoint + 1) = copySearchMatrix(j, i);
                end
                for i = midpoint  : rows
                    searchObject.searchSpace(j ,i - midpoint + 1) = copySearchMatrix(j, i);
                end
            end
            %}
        end
        
        function fixFirstTwoPoints(searchObject, row1, row2)
            [rows , ~ ] = size(searchObject.searchSpace);
            for j = 1 : rows
                if j ~= row1
                    searchObject.searchSpace(j, 1) = 1;
                end
                if j ~= row2
                    searchObject.searchSpace(j, 2) = 1;
                end
            end
        end
        
        function calculateImageFunctional(searchObject)
            [rows , columns ] = size(searchObject.searchSpace);
            disp(size(searchObject.searchSpace))
            %shift all rows up
            part2 = [searchObject.searchSpace(2 : rows, :); zeros(1, columns)];
            %perform subtraction
            searchObject.searchSpace = abs(searchObject.searchSpace - part2);
            
            %make last row zero
            searchObject.searchSpace(rows, :) = 0;
            
            disp(size(searchObject.searchSpace))
            
            %find min and max
            
            searchObject.searchSpace = double(searchObject.searchSpace);
            imax = max(max(searchObject.searchSpace));
            imin = min(min(searchObject.searchSpace));
            searchObject.searchSpace = -(searchObject.searchSpace - imin)/(imax - imin);
        end
    end
    
end
