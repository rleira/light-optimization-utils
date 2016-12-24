function vector = hemicubeToVector(hemicube)
    hemicubeMatrixSize = size(hemicube, 1);
    if (hemicubeMatrixSize ~= size(hemicube, 2)) 
        throw(MException('hemicubeToVector:BadInput', 'Hemicube must be a two dimentions square matrix'));
    end
    if (floor(log2(hemicubeMatrixSize)) ~= log2(hemicubeMatrixSize)) 
        throw(MException('hemicubeToVector:BadInput', 'Hemicube size must be a power of 2'));
    end
    
    squareHemicubeSize = hemicubeMatrixSize * hemicubeMatrixSize;
    vector = zeros(squareHemicubeSize - squareHemicubeSize/4, 1);
    vectorPos = 1;
    
    for i=1:hemicubeMatrixSize
        for j=1:hemicubeMatrixSize
            zone = getHemicubeZone(hemicubeMatrixSize, i, j);
            if (~strcmp(zone, 'VOID'))
                vector(vectorPos, 1) = hemicube(i,j);
                vectorPos = vectorPos + 1;
            end
        end
    end
end

