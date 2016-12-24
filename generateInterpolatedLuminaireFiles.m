% path          - path containing the .matlab files
% savePath      - path where files will be saved
function [file] = generateInterpolatedLuminaireFiles(path, savePath)

    if ~exist('path', 'var')
       path = './matlab/';
    end
    
    if ~exist('savePath', 'var')
       savePath = path;
    end

    matlabRegExp = strcat(path, '*.matlab');
    nameRegExp = '(.*).matlab';
   
    % ----- START LOAD FILES & GENERATING POLAR CURVES
    workingDir = dir(matlabRegExp);
    luminarySize = size(workingDir);    
    for file=1:luminarySize(1)
        filePath = strcat(path, workingDir(file).name);
        luminary = load(filePath);
        
        matlabVersion2 = zeros(361, 181);
        for cx=0:360
            for cgamma=0:180
                matlabVersion2(cx+1, cgamma+1) = getRadiance(luminary, cx, cgamma)*luminary(1, 1); % Multiply by candela factor
            end
        end
        
        [mat, tok] = regexp(workingDir(file).name, nameRegExp, 'match', 'tokens');
        newName = strcat(savePath, tok{1}, '_matlab2.mat');
        save(newName{1}, 'matlabVersion2');
        [file]
    end
    
    matlabVersion2 = zeros(361, 181);
    newName = strcat(savePath, 'EMPTY', '_matlab2.mat');
    save(newName{1}, 'matlabVersion2');
    % ----- END LOAD FILES & GENERATING POLAR CURVES
end

