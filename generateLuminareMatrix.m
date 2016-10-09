% path                  - path containing the position hemicubes
% hemicubeMatrixSize    - size of the hemicube
function [luminaireMatrix luminaireNameMap luminairePower] = generateLuminareMatrix(path, hemicubeMatrixSize, saveResult)

if ~exist('path', 'var')
   path = './matlab/';%'';
end

if ~exist('hemicubeMatrixSize', 'var')
   hemicubeMatrixSize = 512;
end

if ~exist('saveResult', 'var')
   saveResult = 0;
end

regexp = strcat(path, '*.matlab');

% ----- START LOAD FILES

workingDir = dir(regexp);
luminarySize = size(workingDir);
pos = 1;
for file=1:luminarySize(1)
    filePath = strcat(path, workingDir(file).name);
    luminary{pos} = load(filePath);
    luminaireNameMap{pos} = workingDir(file).name;
    luminairePower(pos) = luminary{pos}(end, end);
    pos = pos + 1;
end

% ----- END LOAD FILES

% Calculates the width and height of the hemicubes
hemicubePixelsHeight = hemicubeMatrixSize / 2;
hemicubePixelsWidth = hemicubeMatrixSize / 4;

% Creates matrix to store hemicube
%hemicube = zeros(hemicubeMatrixSize, hemicubeMatrixSize); % USE THIS TO GENERATE AN HEMICUBE
validHemicubePositions = (hemicubeMatrixSize * hemicubeMatrixSize) - (4 * hemicubePixelsWidth * hemicubePixelsWidth);hemicube = zeros(validHemicubePositions, 1); pos = 1; % USE THIS TO GENERATE A VECTOR
% Calculate the offset of the width i.e where the right side starts
hemicubeOffsetedPixelsWidth = hemicubePixelsHeight + hemicubePixelsWidth;
% Fills the hemicubes pixels with the corresponding radiance

% Create matrix to contain result
luminaireMatrix = zeros (luminarySize(1), validHemicubePositions);

for lum=1:luminarySize(1)
    pos = 1;
    for i=1:hemicubeMatrixSize
        for j=1:hemicubeMatrixSize
            %Important note!!! cx and cgamma can be seen as fixed hemicubes!
            %this calculation  could be reused if multiple radiance hemicubes
            %should be calcualted by this function!!
            %Important! cx can be reused for calculation of TOP hemicube as is
            %Important! cgamma hemicube can be calculated using BOTTOM cgamma
            %hemicube 
            zone = getHemicubeZone(hemicubeMatrixSize, i, j);
            if (~strcmp(zone, 'VOID'))
                cx = getCX(hemicubeMatrixSize, i, j);
                cgamma = getGamma(zone, hemicubeMatrixSize, i, j);
                % Multiply by cosine of the angle between the parallel plane C0
                % and the pixel in order to get the weighted candelas (as seen 
                % from the light point, ref hemicubes reference on EF hemicubes
                % paper)
                %hemicube(i, j) = getRadiance(luminary, cx, cgamma)*getPixelFormFactor(zone, hemicubeMatrixSize, i, j); % USE THIS TO GENERATE AN HEMICUBE
                hemicube(pos) = getRadiance(luminary{lum}, cx, cgamma)*getPixelFormFactor(zone, hemicubeMatrixSize, i, j);pos = pos + 1; % USE THIS TO GENERATE A VECTOR
            %else % USE THIS TO GENERATE AN HEMICUBE
                %hemicube(i, j) = 0; % USE THIS TO GENERATE AN HEMICUBE
            end
        end
    end
    [lum]
    luminaireMatrix(lum, :) = hemicube*luminary{lum}(1,1); %Multiplied by candela factor
end

lastLumPos = luminarySize(1) + 1;
% Add empty luminaire
luminaireMatrix(lastLumPos, :) = zeros(1, size(luminaireMatrix,2));
luminaireNameMap{lastLumPos} = 'EMPTY';
luminairePower(lastLumPos) = 0;

if (saveResult)
    save luminaireMatrix luminaireMatrix -v7.3;
    save luminaireNameMap luminaireNameMap;
    save luminairePower luminairePower;
end

beep