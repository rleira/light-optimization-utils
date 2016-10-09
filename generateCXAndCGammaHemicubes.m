% Following 'half an hemicube' is named as just 'hemicube', but be aware 
% that here we always work with a half of an hemicube
% Hemicube distribution is as follows for BOTTOM hemicube
%          o------------------o          
%          +                  +          
%          +      FRONT       +          
%          +                  +          
%o---------o------------------o---------o
%+         +                  +         +
%+         +                  +         +
%+         +                  +         +
%+  LEFT   +     BOTTOM       +  RIGHT  +
%+         +                  +         +
%+         +                  +         +
%+         +                  +         +
%o---------o------------------o---------o
%          +                  +          
%          +      BACK        +          
%          +                  +          
%          o------------------o    

% Planes distribution is as follows (seen from above)
%             C0
%             +
%             +      
%             +          
% C90---------o---------C270
%             +          
%             +          
%             +          
%            C180

% radMapFile - Is a matrix containing the .ies/.ldt in .matlab format
function [Hcx, Hcgamma] = generateCXAndCGammaHemicubes(returnTopHemicube)

hemicubeMatrixSize = 512;
% Calculates the width and height of the hemicubes
hemicubePixelsHeight = hemicubeMatrixSize / 2;
hemicubePixelsWidth = hemicubeMatrixSize / 4;

% Creates matrix to store hemicube
% START - USE THIS TO GENERATE AN HEMICUBE
Hcx = zeros(hemicubeMatrixSize, hemicubeMatrixSize);
Hcgamma = zeros(hemicubeMatrixSize, hemicubeMatrixSize);
% END - USE THIS TO GENERATE AN HEMICUBE

% START - USE THIS TO GENERATE A VECTOR
% validHemicubePositions = (hemicubeMatrixSize * hemicubeMatrixSize) - (4 * hemicubePixelsWidth * hemicubePixelsWidth);
% pos = 1;
% 
% Hcx = zeros(validHemicubePositions, 1);
% Hcgamma = zeros(validHemicubePositions, 1);
% END - USE THIS TO GENERATE A VECTOR

% Calculate the offset of the width i.e where the right side starts
hemicubeOffsetedPixelsWidth = hemicubePixelsHeight + hemicubePixelsWidth;
% Fills the hemicubes pixels with the corresponding radiance
for i=1:hemicubeMatrixSize
    for j=1:hemicubeMatrixSize
        zone = getHemicubeZone(hemicubeMatrixSize, i, j);
        if (~strcmp(zone, 'VOID'))          
            % START - USE THIS TO GENERATE A VECTOR
            Hcx(pos) = getCX(hemicubeMatrixSize, i, j); 
            Hcgamma(pos) = getGamma(zone, hemicubeMatrixSize, i, j);
            pos = pos + 1;
            % END - USE THIS TO GENERATE A VECTOR
            
            % START - USE THIS TO GENERATE AN HEMICUBE
%             Hcx(i, j) = getCX(hemicubeMatrixSize, i, j);
%             Hcgamma(i, j) = getGamma(zone, hemicubeMatrixSize, i, j);
            % END - USE THIS TO GENERATE AN HEMICUBE
        end
    end
end