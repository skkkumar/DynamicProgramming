classdef EnergyCalculation < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        energyMatrix
        positionMatrix
        contourMatrix
        realContourMatrix
    end
    
    methods
        function makeEnergyPositionMatrices2(energyObject, imageMatrix, rows, columns, lambda)
            %lambda = 5/ 5; %300
            
            energyObject.positionMatrix = zeros ( rows, columns);
            energyObject.energyMatrix = zeros ( rows, columns);
            
            % for first column just take the 1- lambda * intensity as value of enery
            
            for rowIndex = 1 : rows
                energyObject.energyMatrix(rowIndex,1)=(1-lambda)* imageMatrix(rowIndex,1);
            end
            
            for columnIndex = 2 : columns
                for rowIndex = 1 : rows
                    % for each cell calculate minimum energy function for all the other
                    % rows cells in the previous columns
                    
                    minimumEnergy = 10000;
                    minPosition = -1;
                    
                    for otherRowIndex = 1 : rows
                        energy = energyObject.energyMatrix (otherRowIndex, columnIndex - 1) ...
                            + lambda * ( sqrt( 1 + (rowIndex - otherRowIndex )^2)) ...
                            + ((1 - lambda) * imageMatrix(rowIndex,columnIndex));
                        %disp( energy)
                        
                        if energy < minimumEnergy
                            minimumEnergy = energy;
                            minPosition = otherRowIndex;
                        end
                    end
                    
                    % store min position and minimum energy in the matrices
                    energyObject.positionMatrix(rowIndex, columnIndex) = minPosition;
                    energyObject.energyMatrix(rowIndex, columnIndex) = minimumEnergy;
                    
                end
            end
            
        end
        
        function makeEnergyPositionMatrices(energyObject, searchSpace, rows, columns, lambda)
            
            % start constructing the energy and position matrices
            
            energyObject.positionMatrix = zeros ( rows, columns);
            energyObject.energyMatrix = zeros ( rows, columns);
            
            
            % for first column just take the 1 - lambda * intensity as value of enery
            
            for rowIndex = 1 : rows
                energyObject.energyMatrix(rowIndex,1)=(1-lambda)* searchSpace(rowIndex,1);
            end
            
            % do it for the remaining columns
            for columnIndex = 2 : columns
                for rowIndex = 1 : rows
                    % for each cell calculate minimum energy function for all the other
                    % rows cells in the previous columns
                    
                    minimumEnergy = 10000;
                    minPosition = -1;
                    
                    for otherRowIndex = 1 : rows
                        energy = energyObject.energyMatrix (otherRowIndex, columnIndex - 1) ...
                            + lambda * ( sqrt( 1 + (rowIndex - otherRowIndex )^2)) ...
                            + ((1 - lambda) * searchSpace(rowIndex,columnIndex));
                        %disp( energy)
                        
                        if energy < minimumEnergy
                            minimumEnergy = energy;
                            minPosition = otherRowIndex;
                        end
                    end
                    
                    % store min position and minimum energy in the matrices
                    energyObject.positionMatrix(rowIndex, columnIndex) = minPosition;
                    energyObject.energyMatrix(rowIndex, columnIndex) = minimumEnergy;
                    
                end
            end
            
            
        end
        
        function backtrackAlongMinimalEnergy2(energyObject, rows, columns)
            minValue = 1000000;
            minPosition = -1;
            
            
            %disp(size(energyObject.energyMatrix));
            
            
            for rowIndex = 1 : rows
                if energyObject.energyMatrix(rowIndex,columns) < minValue;
                    minValue = energyObject.energyMatrix(rowIndex,columns);
                    minPosition = rowIndex;
                end
            end
            
            %disp(['min position ',num2str( minPosition), ' columnIndex' , num2str( columns) ]);
            
            energyObject.contourMatrix = zeros(columns, 2);
            
            for columnIndex = columns  : -1: 1
                %disp('hello');
                energyObject.contourMatrix(columnIndex,2) = minPosition;
                energyObject.contourMatrix(columnIndex,1) = columnIndex;
                
                if columnIndex ~= -1
                    minPosition = energyObject.positionMatrix(minPosition, columnIndex);
                end
            end
        end
        
        function backtrackAlongMinimalEnergy(energyObject, rows, columns, searchObject)
            % find minimum value present in the last column
            minValue = 1000000;
            minPosition = -1;
            
            for rowIndex = 1 : rows
                if energyObject.energyMatrix(rowIndex,columns - 1) < minValue;
                    minValue = energyObject.energyMatrix(rowIndex,columns - 1);
                    minPosition = rowIndex;
                end
            end
            
            disp(['min position ',num2str( minPosition), ' columnIndex' , num2str( columns) ]);
            
            energyObject.contourMatrix = zeros(columns, 2);
            energyObject.realContourMatrix = zeros(columns, 2);
            
            % backtrack from that mimumm value to the first column and fill the real
            % contour matrix
            for columnIndex = columns  : -1: 1
                %disp('hello');
                energyObject.contourMatrix(columnIndex,2) = minPosition;
                energyObject.contourMatrix(columnIndex,1) = columnIndex;
                
                energyObject.realContourMatrix(columnIndex, 1) = searchObject.lineMatrix( columnIndex, minPosition,  1 );
                energyObject.realContourMatrix(columnIndex, 2) = searchObject.lineMatrix( columnIndex, minPosition, 2 );
                
                if columnIndex ~= -1
                    minPosition = energyObject.positionMatrix(minPosition, columnIndex);
                end
            end
        end
        
        
        function makeEnergyPositionMatrices3(energyObject, imageMatrix, rows, columns, lambda)
            % lambda = 0.5;%0.2
            
            % stores last row
            energyObject.positionMatrix = zeros ( rows, rows, columns);
            energyObject.energyMatrix = zeros ( rows, rows, 2);
            
            %find first energy value 1,2
            for rowIndex = 1 : rows
                for anotherRowIndex = 1 : rows
                    
                    energyObject.energyMatrix(rowIndex, anotherRowIndex, 1) = (1-lambda) * imageMatrix(rowIndex, 1) ...
                        + lambda * sqrt((rowIndex - anotherRowIndex)^2 + 1);
                    
                end
            end
            
            for columnIndex = 2 : columns - 1
                
                
                %disp(['column ' + num2str(columnIndex)]);
                %i
                for rowIndex = 1 : rows
                    %i+1
                    for anotherRowIndex = 1: rows
                        % for each cell calculate minimum energy function for all the other
                        % rows cells in the previous columns
                        
                        minimumEnergy = 10000;
                        %minPosition = -1;
                        minPosition2 = -1;
                        
                        %i-1
                        for otherRowIndex = 1 : rows
                            
                            %* 0.5
                            energy = energyObject.energyMatrix (otherRowIndex, rowIndex, 1) ...
                                + (1- lambda)* imageMatrix(rowIndex, columnIndex) ...
                                + lambda * 0.5 *((otherRowIndex + anotherRowIndex - 2 * rowIndex ) ^ 2) / ((otherRowIndex - anotherRowIndex)^2 + 4);
                            
                            %disp( [' energy at ' , num2str(rowIndex), ' , ', num2str(anotherRowIndex)...
                            %    , ' , ', num2str(otherRowIndex), ' --> ', num2str(energy)]);
                            
                            if energy < minimumEnergy
                                minimumEnergy = energy;
                                %minPosition = rowIndex;
                                minPosition2 = otherRowIndex;
                            end
                            %end
                        end
                        
                        % disp(['storing at ' + num2str( rowIndex) + ' ' + num2str(anotherRowIndex) ] );
                        
                        % store min position and minimum energy in the matrices
                        energyObject.positionMatrix(rowIndex, anotherRowIndex, columnIndex) = minPosition2;
                        energyObject.energyMatrix(rowIndex, anotherRowIndex, 2) = minimumEnergy;
                        
                    end
                    
                end
                
                
                % shift column 2 to column 1
                for row1 = 1 : rows
                    for row2 = 1: rows
                        energyObject.energyMatrix(row1, row2, 1) = energyObject.energyMatrix(row1, row2, 2);
                    end
                end
                
            end
            
            % add values in the last column too
            for rowIndex = 1 : rows
                for anotherRowIndex = 1 : rows
                    
                    
                    energyObject.energyMatrix(rowIndex, anotherRowIndex, 2) = energyObject.energyMatrix (rowIndex, anotherRowIndex, 1) ...
                        + (1-lambda) * imageMatrix(anotherRowIndex, columns) ...
                        + lambda * sqrt((rowIndex - anotherRowIndex)^2 + 1);
                    
                end
            end
        end
        
        function backtrackAlongMinimalEnergy3(energyObject, rows, columns, searchObject)
            minValue = 1000000;
            minPosition1 = -1;
            minPosition2 = -1;
            
            energyObject.contourMatrix = zeros(columns, 2);
            
            % find minimum value in the last column
            for rowIndex = 1 : rows
                for anotherRowIndex = 1 : rows
                    if energyObject.energyMatrix(rowIndex, anotherRowIndex, 2) < minValue;
                        minValue = energyObject.energyMatrix(rowIndex, anotherRowIndex, 2);
                        minPosition1 = rowIndex;
                        minPosition2 = anotherRowIndex;
                    end
                end
            end
            
            energyObject.contourMatrix(columns, 2) = minPosition2;
            energyObject.contourMatrix(columns, 1) = columns;
            energyObject.contourMatrix(columns - 1, 1) = columns - 1;
            energyObject.contourMatrix(columns - 1, 2) = minPosition1;
            
            energyObject.realContourMatrix(columns, 1) = searchObject.lineMatrix( columns, minPosition2,  1 );
            energyObject.realContourMatrix(columns, 2) = searchObject.lineMatrix( columns, minPosition2, 2 );
            energyObject.realContourMatrix(columns - 1, 1) = searchObject.lineMatrix( columns - 1, minPosition1,  1 );
            energyObject.realContourMatrix(columns - 1, 2) = searchObject.lineMatrix( columns - 1, minPosition1, 2 );
            
            %disp(['min position ',num2str( minPosition), ' columnIndex' , num2str( columns) ]);
            
            for columnIndex = columns - 2  : -1: 1
                % disp('hello');
                
                if columnIndex ~= 1
                    temp = minPosition1;
                    minPosition = energyObject.positionMatrix(minPosition1, minPosition2, columnIndex + 1);
                    minPosition2 = temp;
                    
                    % minPosition2 = positionMatrix(minPosition, minPosition2, columnIndex, 2);
                    % minPosition = positionMatrix(minPosition, minPosition2, columnIndex, 1);
                end
                
                energyObject.contourMatrix(columnIndex,2) = minPosition;
                energyObject.contourMatrix(columnIndex,1) = columnIndex;
                
                energyObject.realContourMatrix(columnIndex, 1) = searchObject.lineMatrix( columnIndex, minPosition,  1 )  ;
                energyObject.realContourMatrix(columnIndex, 2) = searchObject.lineMatrix( columnIndex, minPosition, 2 ) ;
                
            end
            
        end
        
        function findMinimalContour2(energyObject, imageMatrix, lambda)
            [rows, columns] = size(imageMatrix);
            
            energyObject.makeEnergyPositionMatrices2(imageMatrix, rows, columns, lambda);
            energyObject.backtrackAlongMinimalEnergy2(rows, columns);
        end
        
        function findMinimalContour(energyObject, searchObject, lambda)
            [rows, columns] = size(searchObject.searchSpace);
            
            energyObject.makeEnergyPositionMatrices(searchObject.searchSpace, rows, columns, lambda);
            energyObject.backtrackAlongMinimalEnergy(rows, columns, searchObject);
        end
        
        function findMinimalContour3(energyObject, searchObject, lambda)
            [rows, columns] = size(searchObject.searchSpace);
            
            energyObject.makeEnergyPositionMatrices3(searchObject.searchSpace, rows, columns, lambda);
            energyObject.backtrackAlongMinimalEnergy3(rows, columns, searchObject);
        end
        
        
    end
    
end


