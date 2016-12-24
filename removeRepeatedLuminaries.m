% list - the list to be ordered
function [orderedMatrix] = removeRepeatedLuminaries(orderedMatrix)
% Get the count of elements on the matrix
[elemCount aux] = size(orderedMatrix);
endI = elemCount;
i = 1;
while (i < endI)
    j = i+1;
    while (j < endI)
        if (orderedMatrix(i, j) == 0) 
            orderedMatrix = orderedMatrix([1:j-1, j+1:elemCount], [1:j-1, j+1:elemCount]);    
        end
        [elemCount aux] = size(orderedMatrix);
        endI = elemCount;
        j = j + 1; 
    end
    i = i + 1; 
end