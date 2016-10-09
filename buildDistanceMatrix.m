% matrix - matrix for wich the distances between its rows this function
% will return - Joda
function distanceMatrix = buildDistanceMatrix(matrix)
    matrixSize = size(matrix);
    distanceMatrix = zeros(matrixSize(1));
    
    for i=1:matrixSize(1)
        for j=i+1:matrixSize(1)
            diffVect = matrix(i, :) - matrix(j, :);
            distanceMatrix(i, j) = sqrt(sum((diffVect).*(diffVect)));
            distanceMatrix(j, i) = distanceMatrix(i, j);
        end
    end
end
