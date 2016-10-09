% hemicube              - hemicube containing data
% hemicubeMatrixSize    - size of the hemicube
function vector = reduceHemicubeReturnVectorAVG(hemicube, finalHemicubeSize)

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
       vector = [vector mean(mean(hemicube((i-halfSizesFactor+1):(i+halfSizesFactor), (j-halfSizesFactor+1):(j+halfSizesFactor))))];
   end
end

for i=halfSizesFactor:sizesFactor:hemicubeMatrixSize
   for j=(hemicubePixelsHeight+halfSizesFactor):sizesFactor:(hemicubePixelsHeight+hemicubePixelsWidth)
       vector = [vector mean(mean(hemicube((i-halfSizesFactor+1):(i+halfSizesFactor), (j-halfSizesFactor+1):(j+halfSizesFactor))))];
   end
end

for i=(hemicubePixelsHeight+halfSizesFactor):sizesFactor:(hemicubePixelsHeight+hemicubePixelsWidth)
   for j=(hemicubePixelsHeight+hemicubePixelsWidth+halfSizesFactor):sizesFactor:hemicubeMatrixSize
       vector = [vector mean(mean(hemicube((i-halfSizesFactor+1):(i+halfSizesFactor), (j-halfSizesFactor+1):(j+halfSizesFactor))))];%[vector hemicube(i,j)];
   end
end