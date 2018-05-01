classdef BresenhamLine
    %BresenhamLine Makes lines
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Static)
        
        function [prefix2dy, errorGreater0, errorLesser0, error, pointX, pointY, line] = calculateParams(startX, startY, endX, endY, slope)
            % calculate delta x and delta y
            deltaX  = endX - startX;
            deltaY  = endY - startY;
            
            prefix2dy = 1;
            if slope < 0
                prefix2dy = -1;
            end
            
            if abs(slope) >= 1
                errorGreater0 = 2 * prefix2dy * deltaX - 2 * deltaY;
                errorLesser0 =  2 * prefix2dy * deltaX ;
                error = - deltaY + 2 * prefix2dy * deltaX;
                
            else
                errorGreater0 = - 2 * deltaX + 2 * prefix2dy * deltaY;
                errorLesser0 = 2 * prefix2dy * deltaY;
                error = 2 * prefix2dy * deltaY - deltaX;
            end
            
            
            pointX = startX;
            pointY = startY;
            if abs(slope) >= 1
                line = zeros(endY - startY + 1,2);
            else
                line = zeros(endX - startX + 1, 2);
            end
            line(1,1) = startX;
            line(1,2) = startY;
            
            %disp(['start' , startX]);
            
            %disp(['slope == ' , num2str(slope) , ' ' , num2str( prefix2dy) ] );
            %disp(['errors ', num2str(errorGreater0) , ' ' , num2str(errorLesser0)]);
            %disp(['deltas ' , num2str(deltaX) , ' ' , num2str(deltaY)]);
        end
        
        function line = makeLineMatrix(startX, startY, endX, endY, noOfPoints)
            [line1,inverted] = BresenhamLine.makeLine(startX, startY, endX, endY);
            [lineCount,~] = size(line1);
            
            if inverted
                for i = 1 : floor(lineCount/2)
                    temp1 = line1(i, 1);
                    temp2 = line1(i, 2);
                    line1(i, 1) = line1(lineCount - i + 1, 1);
                    line1(i, 2) = line1(lineCount - i + 1, 2);
                    line1(lineCount - i + 1, 1) = temp1;
                    line1(lineCount - i + 1, 2) = temp2;
                end
            end
            
            
            if noOfPoints == -1
                interval = 1;
                noOfPoints = lineCount;
            else
                interval = floor(lineCount / noOfPoints);
            end
            line = zeros(noOfPoints, 2);
            
            %disp(['interval ' ,num2str(interval) , ' lines = ',num2str(lineCount) , ' points= ' ,num2str(noOfPoints)]);
            i = 1; j =1;
            while i <= noOfPoints && j <= lineCount
                if mod(j, interval) == 0
                    line(i,:) = line1(j, :);  
                    i = i+1;
                end
                j = j+1;
            end
            
            %disp(line);    
        end
        
        function [line,inverted] = makeLine(startX, startY, endX, endY)
            
            %calculate slope
            slope = (endY - startY ) / (endX - startX);
            
            rowCounter = 1;
            
            %% slope equal to infinite
            if abs(slope) == Inf
                %just increase or decrease y
                
                %disp('slope equal to infinite');
                %sort start and end values
                [startX, startY, endX, endY,inverted] = BresenhamLine.sortPoints(startX, startY, endX, endY, true, false);
                
                pointX = startX;
                line = zeros( endY - startY + 1,2);
                
                %disp(['start x' , num2str(startX), ' start y ' , num2str(startY), ' endX ' , num2str(endX), ' endY ' , num2str(endY)] );
                rowCounter = 0;
                for pointY = startY :  endY
                    %disp(['error ' , num2str(error)]);
                    %disp(['error ' , num2str(pointX) , ' ' , num2str(pointY)]);
                    rowCounter = rowCounter + 1;
                    line(rowCounter,1) = pointX;
                    line(rowCounter,2) = pointY;
                end
                
                %% slope equal to 0
            elseif abs(slope) == 0
                % just increase or decrease x
                
                %disp('slope equal to 0');
                %sort start and end values
                [startX, startY, endX, endY, inverted] = BresenhamLine.sortPoints(startX, startY, endX, endY, true, true);
                
                pointY = startY;
                line = zeros( endY - startY + 1,2);
                
                %disp(['start x' , num2str(startX), ' start y ' , num2str(startY), ' endX ' , num2str(endX), ' endY ' , num2str(endY)] );
                rowCounter = 0;
                for pointX = startX :  endX
                    %disp(['error ' , num2str(error)]);
                    %disp(['error ' , num2str(pointX) , ' ' , num2str(pointY)]);
                    rowCounter = rowCounter + 1;   
                    line(rowCounter,1) = pointX;
                    line(rowCounter,2) = pointY;
                end
                
                %% slope greater than 1
            elseif abs(slope) >=1
                %disp('slope greater than 1');
                %sort start and end values
                [startX, startY, endX, endY, inverted] = BresenhamLine.sortPoints(startX, startY, endX, endY, true, false);
                
                [prefix2dy, errorGreater0, errorLesser0, errorValue, pointX, ~, line] = BresenhamLine.calculateParams(startX, startY, endX, endY, slope);
                
                %disp(['start x' , num2str(startX), ' start y ' , num2str(startY), ' endX ' , num2str(endX), ' endY ' , num2str(endY)] );
                
                for pointY = startY + 1:  endY
                    %disp(['error ' , num2str(error)]);
                    %disp(['error ' , num2str(pointX) , ' ' , num2str(pointY) , ' ' , num2str(errorValue)]);
                    
                    if errorValue > 0
                        pointX = pointX + prefix2dy;
                        errorValue = errorValue + errorGreater0;
                    else
                        errorValue = errorValue + errorLesser0;
                    end
                    
                    rowCounter = rowCounter + 1;
                    line(rowCounter,1) = pointX;
                    line(rowCounter,2) = pointY;
                end
                %% slope less than 1
            else
               % disp('slope less than 1');
                
                
                
                %sort start and end values - true, false
                [startX, startY, endX, endY, inverted] = BresenhamLine.sortPoints(startX, startY, endX, endY, slope > 0, true);
                
                [prefix2dy, errorGreater0, errorLesser0, errorValue, ~, pointY, line] = BresenhamLine.calculateParams(startX, startY, endX, endY, slope);
                
                %disp(['start x' , num2str(startX), ' start y ' , num2str(startY), ' endX ' , num2str(endX), ' endY ' , num2str(endY)] );
                
                for pointX = startX + prefix2dy: prefix2dy: endX
                    %disp(['error2 ' , num2str(pointX) , ' ' , num2str(pointY)]);
                    
                    if errorValue * prefix2dy > 0
                        pointY = pointY + 1;
                        errorValue = errorValue + errorGreater0;
                    else
                        errorValue = errorValue + errorLesser0;
                    end
                    
                    rowCounter = rowCounter + 1;
                    line(rowCounter,1) = pointX;
                    line(rowCounter,2) = pointY;
                end
            end
            
        end
        
        function [startX, startY, endX, endY, inverted] = sortPoints(startX, startY, endX, endY, direction, isX)
            inverted = false;
            if direction
                if isX
                    if startX > endX
                        [startX, startY, endX, endY, inverted] = BresenhamLine.swapPoints(startX, startY, endX, endY);
                    end
                else
                    if startY > endY
                        [startX, startY, endX, endY, inverted] = BresenhamLine.swapPoints(startX, startY, endX, endY);
                    end
                end
            else
                if isX
                    if endX > startX
                        [startX, startY, endX, endY, inverted] = BresenhamLine.swapPoints(startX, startY, endX, endY);
                    end
                else
                    if endY > startY
                        [startX, startY, endX, endY, inverted] = BresenhamLine.swapPoints(startX, startY, endX, endY);
                    end
                end
                
            end
            %disp(['fn :::: start x' , num2str(startX), ' start y ' , num2str(startY), ' endX ' , num2str(endX), ' endY ' , num2str(endY)] );
        end
        
        function [startX, startY, endX, endY, inverted] = swapPoints(startX, startY, endX, endY)
            [startX, endX] = BresenhamLine.swapCoordinates(startX, endX);
            [startY, endY] = BresenhamLine.swapCoordinates(startY, endY);
            inverted = true;
        end
        
        function [point1, point2] = swapCoordinates(point1, point2)
            temp = point1;
            point1 = point2;
            point2 = temp;
        end
    end
    
end

