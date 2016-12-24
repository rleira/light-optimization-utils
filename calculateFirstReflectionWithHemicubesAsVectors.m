% Given a vector 'positionHemicubeAsVector' containing the patches seen by 
% the hemicube and the luminaire polar curve 'polarCurveMatrix' it 
% accumulates the direct luminoux flux on the provided 'firstReflection' array
% positionHemicubeAsVector  - vector of the hemicube view (top and bottom)
% that contains the patches seen
% polarCurveMatrix          - matrix containing the polar curve of the
% luminaire that is being used to calculate the ligthing
% hemicubeMatrixSize        - size of the side of the hemicube that is
% being used to perform the calculations
% Hcx                       - hemicube containing the value of the cx angle
% for each pixel (bottom hemicube)
% bottomHemicubeCXAndCGammaAsCartesian  - vector containing the hemicube
% (bottom) cx and cgamma coordinates transformed to cartesian coordinates
% topHemicubeCXAndCGammaAsCartesian     - vector containing the hemicube
% (top) cx and cgamma coordinates transformed to cartesian coordinates
% rotZ1                     - angle used to perform the first rotation from
% z axis (intrisic rotation)
% rotY2                     - angle used to perform the second rotation from
% y axis (intrisic rotation)
% rotZ3                     - angle used to perform the third rotation from
% z axis (intrisic rotation)
% patchCount                - amount of pixels the scene has
% firstReflection           - vector of size patchCount containing the
% accumulated direct luminoux flux for each patch in the scene
function firstReflection = calculateFirstReflectionWithHemicubesAsVectors(positionHemicubeAsVector, polarCurveMatrix, hemicubeMatrixSize, bottomHemicubeCXAndCGammaAsCartesian, topHemicubeCXAndCGammaAsCartesian, pixelDeltaAngle, rotZ1, rotY2, rotZ3, patchCount, firstReflection)

    if ~exist('hemicubeMatrixSize', 'var')
       hemicubeMatrixSize = 512;
    end

    if ~exist('firstReflection', 'var')
       firstReflection = zeros(patchCount+1, 1);
    end

    % Hemicube size variables
    hemicubePixelsWidth = hemicubeMatrixSize / 2;
    hemicubePixelsHeight = hemicubeMatrixSize / 4;
    hemicubeThreeQuarters = hemicubePixelsWidth + hemicubePixelsHeight;
    
    % Vector size variables
    halfVectorPos = size(positionHemicubeAsVector, 2)/2;

    rotM = intrinsicRotationMatrix(rotZ1, rotY2, rotZ3, 'Z1_-Y2_Z3');
    
    rotatedBottomHemicubeCXAndCGammaAsCartesian = rotM*bottomHemicubeCXAndCGammaAsCartesian;
    [cx, cgamma, r] = cart2sph(rotatedBottomHemicubeCXAndCGammaAsCartesian(1,:), rotatedBottomHemicubeCXAndCGammaAsCartesian(2,:), rotatedBottomHemicubeCXAndCGammaAsCartesian(3,:));
    rotatedBottomHemicubeCX = floor(mod(rad2deg(cx), 360)) + 1;
    rotatedBottomHemicubeCGamma = floor(rad2deg(cgamma) + 90) + 1;
    
    rotatedTopHemicubeCXAndCGammaAsCartesian = rotM*topHemicubeCXAndCGammaAsCartesian;
    [cx, cgamma, r] = cart2sph(rotatedTopHemicubeCXAndCGammaAsCartesian(1,:), rotatedTopHemicubeCXAndCGammaAsCartesian(2,:), rotatedTopHemicubeCXAndCGammaAsCartesian(3,:));
    rotatedTopHemicubeCX = floor(mod(rad2deg(cx), 360)) + 1;
    rotatedTopHemicubeCGamma = floor(rad2deg(cgamma) + 90) + 1;

    firstReflection = accumarray( ...
        positionHemicubeAsVector', ...
        [polarCurveMatrix(sub2ind(size(polarCurveMatrix), rotatedBottomHemicubeCX, rotatedBottomHemicubeCGamma)) polarCurveMatrix(sub2ind(size(polarCurveMatrix), rotatedTopHemicubeCX, rotatedTopHemicubeCGamma))].*pixelDeltaAngle ...
    );
    firstReflection(patchCount+1) = 0;
    firstReflection = firstReflection(1:end-1);
end