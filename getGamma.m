% zone          - the zone to which the pixel belongs on the hemicube
% hemicubeSize  - the size in pixels of the hemicube
% i             - index to be examined, coordinate x of the matrix
% j             - index to be examined, coordinate y of the matrix
function gamma = getGamma(zone, hemicubeSize, i, j)

halfHemicube = hemicubeSize / 2;
quarterHemicube = hemicubeSize / 4;

a = sqrt((min(abs(halfHemicube - i), quarterHemicube))^2 + (min(abs(halfHemicube - j), quarterHemicube))^2);
% Check position on the hemicube and calculate the height of the triangle
% i.e 'b'

switch (zone)
    case 'FRONT'
        b = i;
    case 'BACK'
        b = hemicubeSize - i;
    case 'BOTTOM'
        b = quarterHemicube;
    case 'LEFT'
        b = j;
    case 'RIGHT'
        b = hemicubeSize - j;
    otherwise
        gamma = 0;
        return;
end

gamma = atand(a/b);