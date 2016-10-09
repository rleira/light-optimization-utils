% Generates an array with the IDs of the triangles viewed from the hemicube
% file                  - file containing the image of the hemicube view
% of the scene
% extension             - file extension
% hemicubeSize          - index to be examined, coordinate y of the matrix
% sceneTriangleCount    - count of triangles existent in the scene
% takeOneEach           - number of element to skip on each iteration on
%                         the image
function viewHemicubeVector = loadViewTrianglesHemicube(file, extension, hemicubeSize, sceneTriangleCount, takeOneEach)

top = sceneTriangleCount + 1;

% This is a constant! images are 512x512 pixels long
imageSize = 512;

% Load rgb image from the file containing the hemicube view of the scene
hemicubeViewImage = double(imread(file, extension));

if ~exist('takeOneEach', 'var')
    takeOneEach = 1;
end

if ~exist('hemicubeSize', 'var')
    [hemicubeSize aux aux] = size(hemicubeViewImage);
end

halfHemicube = hemicubeSize / 2;
quarterHemicube = hemicubeSize / 4;
threeQuarterHemicube = halfHemicube + quarterHemicube;

% Image on hemicubeViewImage is always a 512x512 image!!
imageToHemicubeRelation = imageSize / hemicubeSize;
% We need to force the takeOneEach variable to consider hemicube size and
% image size
takeOneEach = takeOneEach * imageToHemicubeRelation;

% Generate Vector to contain the flattened matrix corresponding to the
% hemicube
validHemicubePositions = ((hemicubeSize/takeOneEach) * (hemicubeSize/takeOneEach)) - (4 * quarterHemicube * quarterHemicube);
viewHemicubeVector = zeros(validHemicubePositions, 1);
pos = 1;
for i=1:takeOneEach:imageSize
    for j=1:takeOneEach:imageSize
        zone = getHemicubeZone(hemicubeSize, ceil(i/imageToHemicubeRelation), ceil(j/imageToHemicubeRelation));
        if (~strcmp(zone, 'VOID'))
            viewHemicubeVector(pos) = ((255 - hemicubeViewImage(j, i, 3)) * 256 + (255 - hemicubeViewImage(j, i, 2))) * 256 + (255 - hemicubeViewImage(j, i, 1)) + 1;
            if (viewHemicubeVector(pos) > sceneTriangleCount) 
                viewHemicubeVector(pos) = top;
            end
            pos = pos + 1;
        end
    end
end