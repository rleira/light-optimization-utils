% radMap        - matriz containing the radiance of each of the angles 
%contained inside an .ies file
% cx            - coordinate x of the matrix, plane CX of the photometric
% cgamma        - coordinate y of the matrix, determinates vertical angle
% rotM          - rotation matrix
function radiance = getRadianceWrapper(radMapFile, cx, cgamma, rotM)

% Calculate the cartesian coordinates, make the polar curve axis be the
% same as the ones used for spherical coordinates
[x, y, z] = sph2cart(deg2rad(cx), deg2rad(cgamma - 90), 1);

v = [x;y;z]; % Vector in cartesian coordinates
rotatedV = rotM*v;

[ncx, ncgamma] = cart2sph(rotatedV(1), rotatedV(2), rotatedV(3));

ncx = rad2deg(ncx);

ncgamma = rad2deg(ncgamma);

% ncx needs to be between 0 and 360 e.g rad2deg returns -90 for 270 we need
% 270 instead!
if ncx < 0
    ncx = 360 + ncx;
end

% ncgamma needs to be between 0 and 90
ncgamma = ncgamma + 90;

% Make call to original getRadiance
radiance = getRadiance(radMapFile, ncx, ncgamma);