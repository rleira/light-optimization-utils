% path                  - path containing the position hemicubes
% hemicubeMatrixSize    - size of the hemicube
function [xM, yM, zM, luminary] = plot3DPolarCurve(path)

if ~exist('path', 'var')
   path = './luminaries/';
end

if ~exist('hemicubeMatrixSize', 'var')
   hemicubeMatrixSize = 512;
end

regexp = strcat(path, '*.matlab');

% ----- START LOAD FILE

loadedLuminaryFile = load(path);
luminary = loadedLuminaryFile(1:end-1, :);
[maxI maxJ] = size(luminary);

% ----- END LOAD FILE


for i=2:maxI-1
    for j=2:maxJ-1
        raizE = sqrt(luminary(i+1, j+1));
        
        cx = (2*pi*luminary(1, j+1))/360;
        cgamma = (2*pi*luminary(i+1, 1))/360;
        
        x = sin(cgamma)*cos(cx);
        y = sin(cgamma)*sin(cx);
        z = -cos(cgamma);
        
        xM(i, j) = raizE*x;
        yM(i, j) = raizE*y;
        zM(i, j) = raizE*z;
    end
end

xM(:, maxJ) = xM(:, 2);
yM(:, maxJ) = yM(:, 2);
zM(:, maxJ) = zM(:, 2);

% % Case luminary is symetric on x plane (cx)
% if (luminary(1, end)) <= 90
%     % Flit on x plane
%     xM = [xM -flipud(xM)];
% 	yM = [yM yM];
% 	zM = [zM zM];
% end
% 
% Case luminary is symetric on y plane (cx)
% if (luminary(1, end)) <= 180
% 	% Flit on y plane
%     xM = [xM xM];
% 	yM = [yM -fliplr(yM)];
% 	zM = [zM zM];
% end

% % Case luminary is symetric on z plane (c-gamma)
% if (luminary(end, 1)) <= 90
%     xM = [xM; xM];
%     yM = [yM; yM];
%     zM = [zM; -zM];
% end

%figure
surf(xM, yM, zM);
zlabel(path)
colormap(gray)
axis equal

beep
end