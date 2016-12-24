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

%test = load('./data/Arc 94 RetroLED MRN 30 DS-NW 42 4700 NW LED.matlab');
%test = load('./data/LXC15 04E-PL02859-001 - 15.matlab');
test = load('./data/Alabama BOLLARD 1 MT 70 7300 3000 G12.matlab');

rotM = intrinsicRotationMatrix(0, 0, 0, 'Z1_-Y2_Z3');

[Hcx, Hcgamma, TopHcx, TopHcgamma, pixelDeltaAngle] = generateCXAndCGammaHemicubes;

hemicubeMatrixSize = 512;
% Calculates the width and height of the hemicubes
hemicubePixelsHeight = hemicubeMatrixSize / 2;
hemicubePixelsWidth = hemicubeMatrixSize / 4;

% Creates matrix to store hemicube
hemicube = zeros(hemicubeMatrixSize, hemicubeMatrixSize); % USE THIS TO GENERATE AN HEMICUBE
%validHemicubePositions = (hemicubeMatrixSize * hemicubeMatrixSize) - (4 * hemicubePixelsWidth * hemicubePixelsWidth);hemicube = zeros(validHemicubePositions, 1); pos = 1; % USE THIS TO GENERATE A VECTOR
% Calculate the offset of the width i.e where the right side starts
hemicubeOffsetedPixelsWidth = hemicubePixelsHeight + hemicubePixelsWidth;
% Fills the hemicubes pixels with the corresponding radiance
for i=1:hemicubeMatrixSize
    for j=1:hemicubeMatrixSize
        zone = getHemicubeZone(hemicubeMatrixSize, i, j);
        if (~strcmp(zone, 'VOID'))
%DEPRECATED CODE -------------------------------------------------------------------------------------
%             cx = getCX(hemicubeMatrixSize, i, j);
%             cgamma = getGamma(zone, hemicubeMatrixSize, i, j);
%             hemicube(i, j) = getRadiance(test, cx, cgamma)*getPixelFormFactor(zone, hemicubeMatrixSize, i, j); % USE THIS TO GENERATE AN HEMICUBE
%             hemicube(pos) = getRadiance(test, cx, cgamma)*getPixelFormFactor(zone, hemicubeMatrixSize, i, j);pos = pos + 1; % USE THIS TO GENERATE A VECTOR
%DEPRECATED CODE -------------------------------------------------------------------------------------

%             hemicube(pos) = getRadianceWrapper(test, cx, cgamma, rotM)*getPixelFormFactor(zone, hemicubeMatrixSize, i, j);pos = pos + 1; % USE THIS TO GENERATE A VECTOR
            hemicube(i, j) = getRadianceWrapper(test, Hcx(i,j), Hcgamma(i, j), rotM)*pixelDeltaAngle(i, j); % USE THIS TO GENERATE AN HEMICUBE
            
        %else % USE THIS TO GENERATE AN HEMICUBE
            %hemicube(i, j) = 0; % USE THIS TO GENERATE AN HEMICUBE
        end
    end
end

%Multiply by candela factor
hemicube = hemicube*test(1, 1);

% viewHemicubeVector = loadViewTrianglesHemicube('./data/H_14268.bmp', 'BMP', 512, 21824, 512/hemicubeMatrixSize);
% 
% res = accumarray(viewHemicubeVector, hemicube);
% 
% res = res(1:end-1);
% 
% %------
% 
% epsilon = 0.0;
% alpha = 2;
% res = (res / (max(res) + epsilon)).^(1/alpha);
% result=[res res res];
% save result result -ascii
