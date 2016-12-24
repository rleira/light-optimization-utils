% Generates an array with the IDs of the triangles on the image
% file                  - file containing the image of the hemicube view
% of the scene
% extension             - file extension
% takeOneEach           - number of element to skip on each iteration on
%                         the image
% sceneTriangleCount    - count of triangles existent in the scene
% searchBlack           - if should look for black pixel
function [viewSurfaceMesh selectedTriangles selectedIndexesOrdered] = loadViewSurface(file, extension, takeOneEach, sceneTriangleCount, searchBlack)

if ~exist('searchBlack', 'var')
   searchBlack = 0;
end

top = sceneTriangleCount + 1;

% Load rgb image from the file containing the hemicube view of the scene
viewImage = double(imread(file, extension));

if ~exist('takeOneEach', 'var')
    takeOneEach = 1;
end

selectedTriangles = zeros(top, 1);

[viewImageSizeJ viewImageSizeI aux] = size(viewImage);

meshSizeI = floor(viewImageSizeI/takeOneEach);
meshSizeJ = floor(viewImageSizeJ/takeOneEach);
viewSurfaceMesh = zeros(meshSizeI, meshSizeJ)+top;

if (mod(takeOneEach, 2))
    half = (takeOneEach - 1) / 2;
else
    half = takeOneEach / 2;
end

for i=1:takeOneEach:viewImageSizeI
    for j=1:takeOneEach:viewImageSizeJ
        realI = (i-1)/takeOneEach+1;
        realJ = (j-1)/takeOneEach+1;
        jPoint = j + half;
        iPoint = i + half;
        if (jPoint > viewImageSizeJ)
            break;
        end
        if (iPoint > viewImageSizeI)
            break;
        end
        if searchBlack
            if viewImage(jPoint, iPoint, 3) == 0 && viewImage(jPoint, iPoint, 2) == 0 && viewImage(jPoint, iPoint, 1) == 0 
                viewSurfaceMesh(realI, realJ) = ((255 - viewImage(jPoint, iPoint+1, 3)) * 256 + (255 - viewImage(jPoint, iPoint+1, 2))) * 256 + (255 - viewImage(jPoint, iPoint+1, 1)) + 1;
            end
        else
            viewSurfaceMesh(realI, realJ) = ((255 - viewImage(jPoint, iPoint, 3)) * 256 + (255 - viewImage(jPoint, iPoint, 2))) * 256 + (255 - viewImage(jPoint, iPoint, 1)) + 1;
        end
    end
end

% Used to generate the view Hemicubes with radiosity.exe
selectedIndexesOrdered = sort(unique(viewSurfaceMesh));
selectedTriangles = accumarray(unique(viewSurfaceMesh), 1);
selectedTriangles(top) = 1;
selectedTriangles = selectedTriangles(1:end-1);
end


