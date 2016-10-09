% zone          - the zone to which the pixel belongs on the hemicube
% hemicubeSize  - the size in pixels of the hemicube
% i             - index to be examined, coordinate x of the matrix
% j             - index to be examined, coordinate y of the matrix
% Refer to http://artis.imag.fr/~Cyril.Soler/DEA/IlluminationGlobale/Papers/p31-cohen.pdf
% for more details about the calculations involved in this file
% Sum of form factors for an hemicube must sum up to 2*pi instead of pi
% like in cohen paper
function formFactor = getPixelFormFactor(zone, hemicubeSize, i, j)

halfHemicube = hemicubeSize / 2;
quarterHemicube = hemicubeSize / 4;
halfAPixel = quarterHemicube / halfHemicube;

switch (zone)
    case 'BOTTOM'
        x = (j + halfAPixel) - halfHemicube - 1;
        y = (i + halfAPixel) - halfHemicube - 1;
    case 'FRONT'
        x = i + halfAPixel - 1;
        y = (j + halfAPixel) - halfHemicube - 1;
    case 'BACK'
        x = hemicubeSize - (i - halfAPixel);
        y = (j + halfAPixel) - halfHemicube - 1;
    case 'LEFT'
        x = j + halfAPixel - 1;
        y = (i + halfAPixel) - halfHemicube - 1;
    case 'RIGHT'
        x = hemicubeSize - (j - halfAPixel);
        y = (i + halfAPixel) - halfHemicube - 1;
    case 'VOID'
        formFactor = 0;
        return;
    otherwise
        formFactor = NaN;
        return;
end
formFactor = (quarterHemicube)/(((x*x + y*y + quarterHemicube*quarterHemicube)^(3/2)));
