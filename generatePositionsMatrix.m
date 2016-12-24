% path                  - path containing the position hemicubes
% hemicubeMatrixSize    - size of the hemicube
% saveResult            - 1 to save results to disc
% takeOneEach           - number of element to skip on each iteration on
%                         the image
function [positionsMatrix positionsNameMap] = generatePositionsMatrix(path, hemicubeMatrixSize, saveResult, takeOneEach)

if ~exist('path', 'var')
   path = '';
end

if ~exist('hemicubeMatrixSize', 'var')
   hemicubeMatrixSize = 512;
end

if ~exist('saveResult', 'var')
   saveResult = 0;
end

if ~exist('takeOneEach', 'var')
   takeOneEach = 1;
end

regexp = strcat(path, 'H*.bmp');

% ----- START LOAD FILES

workingDir = dir(regexp);
positionsSize = size(workingDir);
pos = 1;
for file=1:positionsSize(1)
    % Bottom Hemicube
    filePath = strcat(path, workingDir(file).name);
    vector = loadViewTrianglesHemicube(filePath, 'BMP', hemicubeMatrixSize, 21824, takeOneEach);

    % Top hemicube
    try
        filePath = strcat(path, 'Sen', workingDir(file).name);
        topHemiVector = loadViewTrianglesHemicube(filePath, 'BMP', hemicubeMatrixSize, 21824, takeOneEach);
        vector = [vector;topHemiVector];
    catch
        disp(strcat('Top hemicube not found for: ', workingDir(file).name));
    end
    
    positionsMatrix(pos, :) = vector;
    positionsNameMap{pos} = workingDir(file).name;
    pos = pos + 1
end

% ----- END LOAD FILES

if (saveResult)
    save positionsMatrix positionsMatrix
    save positionsNameMap positionsNameMap
end

beep