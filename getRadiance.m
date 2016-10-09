% radMap  - matriz containing the radiance of each of the angles contained
% inside an .ies file
% cx      - coordinate x of the matrix, plane CX of the photometric
% cgamma  - coordinate y of the matrix, determinates vertical angle
function radiance = getRadiance(radMapFile, cx, cgamma)
% get the radMap, remove the params on the last row
radMap = radMapFile(1:end, :);

[vertAnglesSize horAnglesSize] = size(radMap);
horAngleMap = radMap(1, :);
vertAngleMap = radMap(:, 1)';
vertAngleMap = vertAngleMap(1:end-1);
vertAnglesSize = vertAnglesSize -1;


lastHorAngle = horAngleMap(end);
x = horAnglesSize;
if (lastHorAngle == 0 || lastHorAngle == horAngleMap(1))
    x = 1;
% Case symmetry on all four quardants 90-180-270-360
else
    if (lastHorAngle <= 90)
        quadrant = floor(cx/90);
        cx0_90 = mod(cx, 90);
        if mod(quadrant,2) == 0
          cx = cx0_90;
        else
          cx = 90 - cx0_90;
        end
    elseif (lastHorAngle <= 180)
        semiplane = floor(cx/180);
        cx0_180 = mod(cx, 180);
        if mod(semiplane,2) == 0
          cx = cx0_180;
        else
          cx = 180 - cx0_180;
        end
    end
    
    % Find closest match for the angle given (for horizontal angles)
    for i=2:horAnglesSize-1
        if(horAngleMap(i) <= cx && horAngleMap(i + 1) > cx)
            x = i;
        end
    end
end

% Find closest match for the angle given (for vertical angles)
y = vertAnglesSize;
for j=2:vertAnglesSize-1
    if(vertAngleMap(j) <= cgamma && vertAngleMap(j + 1) > cgamma)
        y = j;
        break;
    end
end

% In case we have and exact match just return the value!
if(cx == horAngleMap(x) && cgamma == vertAngleMap(y))
    radiance = radMap(y, x);
    return
end
% Else we need to interpolate!!

% Calculate interpolation indexes on matrix
x1 = x;
% Horizontal angles are represented as a ring so on overflow go back to the
% beginning 
x2 = max(mod(x+1, horAnglesSize), 2);
y1 = y;
% Vertical angles are not a ring so on overflow use the same point twice
y2 = min(y+1, vertAnglesSize);

dX = (cx - horAngleMap(x1)) / (horAngleMap(x2) - horAngleMap(x1));
if (isnan(dX) || isinf(dX))
    dX = 0;
end
dY = (cgamma - vertAngleMap(y1)) / (vertAngleMap(y2) - vertAngleMap(y1));
if (isnan(dY) || isinf(dY))
    dY = 0;
end

rx1 = ((1.0 - dX) * radMap(y1, x1)) + (dX * radMap(y1, x2));
rx2 = ((1.0 - dX) * radMap(y2, x1)) + (dX * radMap(y2, x2));

if (isnan(((1.0 - dY) * rx1) + (dY * rx2)))
    disp('isnan')
end

radiance = ((1.0 - dY) * rx1) + (dY * rx2);