% hemicube              - hemicube containing data
% hemicubeMatrixSize    - size of the hemicube
function vector = reduceHemicubeReturnVector(hemicube, finalHemicubeSize)

hemicubeMatrixSize = length(hemicube);

if ~exist('finalHemicubeSize', 'var')
   finalHemicubeSize = hemicubeMatrixSize / 2;
end

sizesFactor = hemicubeMatrixSize / finalHemicubeSize;
halfSizesFactor = sizesFactor / 2;

hemicubePixelsWidth = hemicubeMatrixSize / 2;
hemicubePixelsHeight = hemicubeMatrixSize / 4;

vector = [];

for i=(hemicubePixelsHeight+halfSizesFactor):sizesFactor:(hemicubePixelsHeight+hemicubePixelsWidth)
   for j=halfSizesFactor:sizesFactor:hemicubePixelsHeight
       vector = [vector hemicube(i,j)];
   end
end

for i=halfSizesFactor:sizesFactor:hemicubeMatrixSize
   for j=(hemicubePixelsHeight+halfSizesFactor):sizesFactor:(hemicubePixelsHeight+hemicubePixelsWidth)
       vector = [vector hemicube(i,j)];
   end
end

for i=(hemicubePixelsHeight+halfSizesFactor):sizesFactor:(hemicubePixelsHeight+hemicubePixelsWidth)
   for j=(hemicubePixelsHeight+hemicubePixelsWidth+halfSizesFactor):sizesFactor:hemicubeMatrixSize
       vector = [vector hemicube(i,j)];
   end
end