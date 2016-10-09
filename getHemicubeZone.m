% hemicubeSize  - the size in pixels of the hemicube
% i             - index to be examined, coordinate x of the matrix
% j             - index to be examined, coordinate y of the matrix
function zone = getHemicubeZone(hemicubeSize, i, j)

halfHemicube = hemicubeSize / 2;
quarterHemicube = hemicubeSize / 4;
threeQuartersHemicube = halfHemicube + quarterHemicube;

% Calculate position on the hemicube and calculate the height of the triangle
% i.e 'b'
if (quarterHemicube < j && j <= threeQuartersHemicube)
    % Case Front side    
    if (i <= quarterHemicube)
        zone = 'FRONT';
    % Case Back side
    elseif (threeQuartersHemicube < i)
        zone = 'BACK';
    % Else must be case of Bottom side
    else
        zone = 'BOTTOM';
    end
% If not on the center of the matrix
else
    % Check if it is the left or right side
    if (j <= quarterHemicube)
        % Case Left side
        if (quarterHemicube < i && i <= threeQuartersHemicube)
            zone = 'LEFT';
        else
            zone = 'VOID';
        end
    % Case Right side
    elseif (quarterHemicube < i && i <= threeQuartersHemicube) 
        zone = 'RIGHT';
    else
        zone = 'VOID';
    end
end