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

%test = load('./Alabama ALA-IND# 1 QE 125 6800 4100 E27.matlab');
%test = load('./scripTestLum/BRP775 FG 12xECO20 830 DS.matlab');
%test = load('./scripTestLum/LXC25 04E-ITL79572 25.matlab');
%test = load('./scripTestLum/LXC15 12E-PL02859-001 - 15.matlab');
%test = load('./scripTestLum/9408745-ARKTIS LED 1x86W PSR PRACHTOPAL MEDIUM BEAM.matlab');
%test = load('./scripTestLum/4050300774626.matlab');
%test = load('./scripTestLum/FLD-OL-15-D2-14-D-UL-700-57K.matlab');
%test = load('./scripTestLum/testRev3.matlab');
%test = load('./scripTestLum/IES File- WS4-47L-40K-FD.matlab');
%test = load('./scripTestLum/Joy CL61-CLEAR-ARC80-JS1A 1 MT 70 6300 2800 E27.matlab');
%test = load('./data/Arc 94 RetroLED MRN 30 DS-NW 42 4700 NW LED.matlab');
test = load('./data/LXC15 04E-PL02859-001 - 15.matlab');

alpha = deg2rad(0);
beta = deg2rad(0);
gamma = deg2rad(0);

c1 = cos(alpha);
c2 = cos(beta);
c3 = cos(gamma);

s1 = sin(alpha);
s2 = sin(beta);
s3 = sin(gamma);

m11 = c1*c3 - c2*s1*s3;
m12 = -c1*s3 - c2*c3*s1;
m13 = s1*s2;

m21 = c3*s1 + c1*c2*s3;
m22 = c1*c2*c3 - s1*s3;
m23 = -c1*s2;

m31 = s2*s3;
m32 = c3*s2;
m33 = c2;

rotM = [m11 m12 m13; m21 m22 m23; m31 m32 m33];
rotM = inv(rotM);

[Hcx, Hcgamma] = generateCXAndCGammaHemicubes(false);

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
        %Important note!!! cx and cgamma can be seen as fixed hemicubes!
        %this calculation  could be reused if multiple radiance hemicubes
        %should be calcualted by this function!!
        %Important! cx can be reused for calculation of TOP hemicube as is
        %Important! cgamma hemicube can be calculated using BOTTOM cgamma
        %hemicube 
        zone = getHemicubeZone(hemicubeMatrixSize, i, j);
        if (~strcmp(zone, 'VOID'))
%             cx = getCX(hemicubeMatrixSize, i, j);
%             cgamma = getGamma(zone, hemicubeMatrixSize, i, j);
            % Multiply by cosine of the angle between the parallel plane C0
            % and the pixel in order to get the weighted candelas (as seen 
            % from the light point, ref hemicubes reference on EF hemicubes
            % paper)
            %hemicube(i, j) = getRadiance(test, cx, cgamma)*getPixelFormFactor(zone, hemicubeMatrixSize, i, j); % USE THIS TO GENERATE AN HEMICUBE
            %hemicube(pos) = getRadiance(test, cx, cgamma)*getPixelFormFactor(zone, hemicubeMatrixSize, i, j);pos = pos + 1; % USE THIS TO GENERATE A VECTOR
            
            %hemicube(pos) = getRadianceWrapper(test, cx, cgamma, rotM)*getPixelFormFactor(zone, hemicubeMatrixSize, i, j);pos = pos + 1; % USE THIS TO GENERATE A VECTOR
            hemicube(i, j) = getRadianceWrapper(test, Hcx(i,j), Hcgamma(i, j), rotM)*getPixelFormFactor(zone, hemicubeMatrixSize, i, j); % USE THIS TO GENERATE AN HEMICUBE
            
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
