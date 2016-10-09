% hemicubeSize  - the size in pixels of the hemicube
% i             - index to be examined, coordinate x of the matrix
% j             - index to be examined, coordinate y of the matrix
function cx = getCX(hemicubeSize, i, j)

halfHemicube = hemicubeSize / 2;
quarterHemicube = hemicubeSize / 4;

% Use the correct semiplane to calculate the cx angle, set the appropiate
% calculation parameters for the cx formula
if (i < halfHemicube) 
    % Use C0 semi-plane
    c = 0;
    m = 1;
else
    % Use C180 semi-plane
    c = 180;
    m = -1;
end

cx = mod(c + m*atand((halfHemicube - j)/(min(abs(halfHemicube - i), quarterHemicube))), 360);

if isnan(cx)
    cx = 0;
end
