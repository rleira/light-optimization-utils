% path                  - path containing the .matlab files
% hemicubeMatrixSize    - size of the hemicube
% saveResult            - if true will save the results to disc
% generateTop           - if true will generate top hemicubes
function [luminaireMatrix luminaireNameMap luminairePower] = generateLuminareMatrix(path, hemicubeMatrixSize, saveResult, generateTop)

if ~exist('path', 'var')
   path = './matlab/';
end

if ~exist('hemicubeMatrixSize', 'var')
   hemicubeMatrixSize = 512;
end

if ~exist('saveResult', 'var')
   saveResult = 0;
end

if ~exist('generateTop', 'var')
   generateTop = false;
end

matlabRegExp = strcat(path, '*.matlab');
nameRegExp = '(.*).matlab';
% ----- START LOAD FILES

workingDir = dir(matlabRegExp);
luminarySize = size(workingDir);
pos = 1;
for file=1:luminarySize(1)
    filePath = strcat(path, workingDir(file).name);
    luminary{pos} = load(filePath);
    [mat, tok] = regexp(workingDir(file).name, nameRegExp, 'match', 'tokens');
    luminaireNameMap{pos} = tok{1};
    luminairePower(pos) = luminary{pos}(end, end);
    pos = pos + 1;
end

% ----- END LOAD FILES

% Calculates the width and height of the hemicubes
hemicubePixelsHeight = hemicubeMatrixSize / 2;
hemicubePixelsWidth = hemicubeMatrixSize / 4;

% Creates matrix to store hemicube
%hemicube = zeros(hemicubeMatrixSize, hemicubeMatrixSize);hemicubeTop = zeros(hemicubeMatrixSize, hemicubeMatrixSize); % USE THIS TO GENERATE AN HEMICUBE
validHemicubePositions = (hemicubeMatrixSize * hemicubeMatrixSize) - (4 * hemicubePixelsWidth * hemicubePixelsWidth);hemicube = zeros(validHemicubePositions, 1);hemicubeTop = zeros(validHemicubePositions, 1); pos = 1; % USE THIS TO GENERATE A VECTOR
% Calculate the offset of the width i.e where the right side starts
hemicubeOffsetedPixelsWidth = hemicubePixelsHeight + hemicubePixelsWidth;
% Fills the hemicubes pixels with the corresponding radiance

% Create matrix to contain result
if generateTop
    luminaireMatrix = zeros (luminarySize(1), validHemicubePositions*2);
else
    luminaireMatrix = zeros (luminarySize(1), validHemicubePositions);
end

rotateTopMatrix = intrinsicRotationMatrix(0, 180, 0, 'Z1_-Y2_Z3');
[Hcx, Hcgamma, TopHcx, TopHcgamma, pixelDeltaAngle] = generateCXAndCGammaHemicubes;

for lum=1:luminarySize(1)
    pos = 1;
    for i=1:hemicubeMatrixSize
        for j=1:hemicubeMatrixSize
            zone = getHemicubeZone(hemicubeMatrixSize, i, j);
            if (~strcmp(zone, 'VOID'))
                %hemicube(i, j) = getRadiance(luminary{lum}, Hcx(i,j), Hcgamma(i, j))*getPixelFormFactor(zone, hemicubeMatrixSize, i, j);hemicubeTop(i, j) = getRadiance(luminary{lum}, TopHcx(i,j), TopHcgamma(i, j))*getPixelFormFactor(zone, hemicubeMatrixSize, i, j); % USE THIS TO GENERATE AN HEMICUBE
                hemicube(pos) = getRadiance(luminary{lum}, Hcx(i,j), Hcgamma(i, j))*pixelDeltaAngle(i, j);hemicubeTop(pos) = getRadiance(luminary{lum}, TopHcx(i,j), TopHcgamma(i, j))*pixelDeltaAngle(i, j);pos = pos + 1; % USE THIS TO GENERATE A VECTOR
            %else % USE THIS TO GENERATE AN HEMICUBE
                %hemicube(i, j) = 0; % USE THIS TO GENERATE AN HEMICUBE
            end
        end
    end
    [lum]
    if generateTop
        luminaireMatrix(lum, :) = [hemicube;hemicubeTop]*luminary{lum}(1,1); %Multiplied by candela factor
    else
        luminaireMatrix(lum, :) = hemicube*luminary{lum}(1,1); %Multiplied by candela factor
    end
end

lastLumPos = luminarySize(1) + 1;
% Add empty luminaire
luminaireMatrix(lastLumPos, :) = zeros(1, size(luminaireMatrix, 2));
luminaireNameMap{lastLumPos} = 'EMPTY';
luminairePower(lastLumPos) = 0;

if (saveResult)
    save luminaireMatrix luminaireMatrix -v7.3;
    save luminaireNameMap luminaireNameMap;
    save luminairePower luminairePower;
end

beep