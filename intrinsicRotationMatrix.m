% Returns matrix for euler intrinsic rotation (ZX'Z'')
% alpha - angle about Z axis to do first rotation
% beta  - angle about X' axis to do second rotation
% gamma - angle about Z'' axis to do third rotation
% eulerAngleString - string containing the type of the eurler angle e.g Z1_Y2_Z3
function [rotationMatrix] = intrinsicRotationMatrix(alpha, beta, gamma, eulerAngleString)

alpha = deg2rad(alpha);
beta = deg2rad(beta);
gamma = deg2rad(gamma);

c1 = 0;
c2 = 0;
c3 = 0;
s1 = 0;
s2 = 0;
s3 = 0;

switch (eulerAngleString)
    case 'Z1_X2_Z3'
        zxz();
    case 'Z1_-Y2_Z3'
        beta = -beta;
        zyz();
    case 'Z1_Y2_Z3'
        zyz();
    otherwise
        zxz();
end

rotM = [m11 m12 m13; m21 m22 m23; m31 m32 m33];
rotationMatrix = inv(rotM);

    function calcCosSin
        c1 = cos(alpha);
        c2 = cos(beta);
        c3 = cos(gamma);

        s1 = sin(alpha);
        s2 = sin(beta);
        s3 = sin(gamma);
    end

    function zxz
        calcCosSin();
        
        m11 = c1*c3 - c2*s1*s3;
        m12 = -c1*s3 - c2*c3*s1;
        m13 = s1*s2;

        m21 = c3*s1 + c1*c2*s3;
        m22 = c1*c2*c3 - s1*s3;
        m23 = -c1*s2;

        m31 = s2*s3;
        m32 = c3*s2;
        m33 = c2;
    end

    function zyz
        calcCosSin();
        
        m11 = c1*c2*c3 - s1*s3;
        m12 = -c3*s1 - c1*c2*s3;
        m13 = c1*s2;

        m21 = c1*s3 + c2*c3*s1;
        m22 = c1*c3 - c2*s1*s3;
        m23 = s1*s2;

        m31 = -c3*s2;
        m32 = s2*s3;
        m33 = c2;
    end
end