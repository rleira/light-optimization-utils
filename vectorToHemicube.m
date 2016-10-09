% vector                - vector containing the zipped hemicube
% hemicubeMatrixSize    - size of the hemicube
function hemicube = vectorToHemicube(vector, hemicubeMatrixSize)

if ~exist('hemicubeMatrixSize', 'var')
   hemicubeMatrixSize = 512;
end

hemicubePixelsWidth = hemicubeMatrixSize / 2;
hemicubePixelsHeight = hemicubeMatrixSize / 4;

hemicube = zeros(hemicubeMatrixSize);

count = 0;
for i=1:hemicubePixelsHeight
    hemicube(i, :) = [zeros(1, hemicubePixelsHeight) vector(count*hemicubePixelsWidth+1:(count+1)*hemicubePixelsWidth, 1)' zeros(1, hemicubePixelsHeight)];
    count = count + 1;
end

offset1 = hemicubePixelsWidth*hemicubePixelsHeight;
count = 0;
for i=hemicubePixelsHeight+1:hemicubePixelsHeight+hemicubePixelsWidth
    hemicube(i, :) = vector(offset1+(count*hemicubeMatrixSize+1):offset1+((count+1)*hemicubeMatrixSize), 1)';
    count = count + 1;
end

offset2 = offset1+hemicubePixelsWidth*hemicubeMatrixSize;
count = 0;
for i=hemicubePixelsHeight+hemicubePixelsWidth+1:hemicubeMatrixSize
    hemicube(i, :) = [zeros(1, hemicubePixelsHeight) vector(offset2+(count*hemicubePixelsWidth+1):offset2+((count+1)*hemicubePixelsWidth), 1)' zeros(1, hemicubePixelsHeight)];
    count = count + 1;
end