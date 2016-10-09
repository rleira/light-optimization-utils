% list          - the list to be ordered
% delta         - the min distance to consider two elements to be a part of
% saveResult    - 1 to save results to disc
%the same cluster
function [orderedList orderedLuminarieListIndexes] = closeClusterOrder(list, delta, saveResult)

if ~exist('delta', 'var')
   delta = 0.001;
end

orderedList = list;
% Get the count of elements on the matrix
[elemCount aux] = size(list);

orderedLuminarieListIndexes = [1:elemCount]';
for i=1:elemCount-1
    % START - find min indexes of sub matrix
    subMatrix = orderedList(1:i, i+1:elemCount);
    theSize = size(subMatrix);
    [minVal, minIndex] = min(subMatrix(:));
    [minRow minCol] = ind2sub(theSize, minIndex);
    minCol = minCol + i;
    if (minRow > 1) % use 'minRow < i' for inserting next!!!
        isCloseToNext = orderedList(minRow - 1, minCol) < delta;
    else
        isCloseToNext = true;
    end
    % END - find min indexes of sub matrix
    % Reorder matrix
    if ((minVal < delta) && isCloseToNext)
        %orderedList = orderedList([1:minRow, minCol, minRow+1:minCol-1, minCol+1:elemCount], [1:minRow, minCol, minRow+1:minCol-1, minCol+1:elemCount]);
        %indexes = indexes([1:minRow, minCol, minRow+1:minCol-1, minCol+1:elemCount]);
        orderedList = orderedList([1:minRow-1, minCol, minRow:minCol-1, minCol+1:elemCount], [1:minRow-1, minCol, minRow:minCol-1, minCol+1:elemCount]);
        orderedLuminarieListIndexes = orderedLuminarieListIndexes([1:minRow-1, minCol, minRow:minCol-1, minCol+1:elemCount]);
    else
        orderedList = orderedList([1:i, minCol, i+1:minCol-1, minCol+1:elemCount], [1:i, minCol, i+1:minCol-1, minCol+1:elemCount]);
        orderedLuminarieListIndexes = orderedLuminarieListIndexes([1:i, minCol, i+1:minCol-1, minCol+1:elemCount]);
    end
    i
end

if exist('saveResult', 'var') && saveResult
   save orderedList orderedList;
   save orderedLuminarieListIndexes orderedLuminarieListIndexes;
end