

Elapsed time is 15240.663409 seconds.


% Generate view of luminaire order
image(luminaireHemicubeMatrix(orderedLuminarieListIndexes, :)*1000)

[maxI aux] = size(luminaireHemicubeMatrix);
for i=1:maxI
	a = luminaireHemicubeMatrix(i, :);
	fileName = ['./lumOneByOne/' int2str(i)];
	save(fileName, 'a')
end

load luminaireHemicubeMatrix.mat luminaireHemicubeMatrix
tic;
for i=1:15000
	index = floor(rand() * 1200)+1;
	luminDisc = luminaireHemicubeMatrix(index, :);
end
toc;


tic;
for i=1:15000
	index = floor(rand() * 1200)+1;
	fileName = ['./lumOneByOne/' int2str(index)];
	luminDisc = load(fileName);
end
toc;

load luminaireHemicubeMatrix.mat luminaireHemicubeMatrix
tic;
for i=1:15000
	index = floor(rand() * 1200)+1;
	luminDisc = luminaireHemicubeMatrix(index, :);
end
toc;

load luminaireHemicubeMatrix.mat luminaireHemicubeMatrix
tic;
for i=1:15000
	luminDisc = luminaireHemicubeMatrix(487, :);
end
toc;


%----------------------------------------------------
% GENERATE LUMINAIRES AND POSITIONS

tic;
initialLuminaryHemicubeSize = 512;
deltaClusterDistance = 0.1;%10;

if ~exist('positionsPath', 'var')
   positionsPath = './positions/';
end

if ~exist('luminarePath', 'var')
   luminarePath = './matlab/';
end

%[positionsMatrix positionsNameMap] = generatePositionsMatrix(positionsPath, initialLuminaryHemicubeSize, 1, 1);

[luminaireMatrix luminaireNameMap luminairePower] = generateLuminareMatrix(luminarePath, initialLuminaryHemicubeSize, 1);

[orderedLuminarieList orderedLuminarieListIndexes] = closeClusterOrder(buildDistanceMatrix(luminaireMatrix), deltaClusterDistance, 1);
luminaireHemicubeMatrix = luminaireMatrix(orderedLuminarieListIndexes, :);
save luminaireHemicubeMatrix luminaireHemicubeMatrix -v7.3;
figure;
image(luminaireMatrix*1000);
figure;
image(luminaireHemicubeMatrix*1000);
toc;
%----------------------------------------------------

%----------------------------------------------------
% GENERATE POSITIONS ONLY
tic;
initialLuminaryHemicubeSize = 512;
deltaClusterDistance = 0.1;
if ~exist('positionsPath', 'var')
   positionsPath = './positions/';
end
[positionsMatrix positionsNameMap] = generatePositionsMatrix(positionsPath, initialLuminaryHemicubeSize, 1, 1);
toc;
%----------------------------------------------------

%----------------------------------------------------
% GENERATE FILES FOR EACH LUMINAIRE
[maxI aux] = size(luminaireHemicubeMatrix);
for i=1:maxI
	a = luminaireHemicubeMatrix(i, :);
	fileName = ['./lumOneByOne/' int2str(i)];
	save(fileName, 'a')
end
%----------------------------------------------------

%----------------------------------------------------
% SEARCH FOR LUMINARIES WITH NAN VALUES
load luminaireHemicubeMatrix.mat luminaireHemicubeMatrix;
load luminaireNameMap.mat luminaireNameMap;
load orderedLuminarieListIndexes.mat orderedLuminarieListIndexes
orderedLuminaireNameMap = luminaireNameMap(orderedLuminarieListIndexes);
[sizeI sizeJ] = size(luminaireHemicubeMatrix);
for k=1:sizeI
	[i j] = find(isnan(luminaireHemicubeMatrix(k, :)));
	if length(i)
		disp(['mal ' int2str(k)])
		luminaireNameMap(k)
	end
end
%----------------------------------------------------


%----------------------------------------------------
% Generate file with names of .matlab files to .ldt
regexp = strcat('./matlab/', '*.matlab');
workingDir = dir(regexp);
[sizeI sizeJ] = size(workingDir);
for file=1:sizeI
    ldtFile{file} = workingDir(file).name;
end
modifiedStr = strrep(ldtFile, '.matlab', '.ldt')
fid = fopen('ldt_database.csv','w');
[sizeI sizeJ] = size(modifiedStr);
for i=1:sizeJ
	fprintf(fid,'%s\n',modifiedStr{i});
end
fclose(fid);
%----------------------------------------------------

%----------------------------------------------------
% Generate luminaire matrix of reduced size
load luminaireHemicubeMatrix.mat luminaireHemicubeMatrix
[maxLum aux] = size(luminaireHemicubeMatrix);
for lum=1:maxLum
    reducedLuminaireHemicubeMatrix(lum, :) = reduceHemicubeReturnVector(vectorToHemicube(luminaireHemicubeMatrix(lum, :)', 512), 32);
    reducedLuminaireHemicubeMatrixAVG(lum, :) = reduceHemicubeReturnVectorAVG(vectorToHemicube(luminaireHemicubeMatrix(lum, :)', 512), 32);
end
%----------------------------------------------------

%----------------------------------------------------
% Generate unordered vector of indexes from ordered vector
load orderedLuminarieListIndexes.mat orderedLuminarieListIndexes
maxLum = length(orderedLuminarieListIndexes);
for lum=1:maxLum
    unOrderedLuminarieListIndexes(orderedLuminarieListIndexes(lum, 1), 1) = lum;
end
%----------------------------------------------------

%----------------------------------------------------
% GENERATE VECTOR OF POSITION INDEXES FOR EMISION
emision = zeros(21824, 1);
load positionsNameMap.mat positionsNameMap

positionsMap = regexp(positionsNameMap, 'H_(\d+).bmp', 'tokens', 'once');
positionsMap = vertcat(positionsMap{:});
positionsMap = sprintf('%s ', positionsMap{:});
selectedIndexesOrdered = sscanf(positionsMap, '%u') + 1;

maxTraingle = length(res);
for triangle=1:maxTraingle
    patchId = selectedIndexesOrdered(res(triangle, 4));
    emision(patchId) = 1;
end
emision = [emision emision emision];
%----------------------------------------------------

%----------------------------------------------------
% CALCULATE POWER FOR ALL LUMINARIES
prefijo='patio_fino2Pisos21824';
objectiveImage = 'piso_patio_fino2Pisos21824.bmp';
areaPatch = (0.3*0.3)/2;

load luminaireHemicubeMatrix.mat luminaireHemicubeMatrix
load luminaireNameMap.mat luminaireNameMap
load orderedLuminarieListIndexes.mat orderedLuminarieListIndexes

load luminairePower.mat luminairePower
luminairePower = luminairePower(orderedLuminarieListIndexes);
maxPower = max(luminairePower);

orderedLuminaireNameMap = luminaireNameMap(orderedLuminarieListIndexes);

load positionsMatrix.mat positionsMatrix
load positionsNameMap.mat positionsNameMap

[objectivePositionsMapMatrix objectiveSelectedTriangles objectiveSelectedIndexesOrdered] = loadViewSurface(objectiveImage, 'BMP', 1, 21824);

if ~exist('V', 'var')
    V=single(load([prefijo '_V.dat'],'-ascii'));
    [k,n]=size(V);
    VI=zeros(1,n);
    for i=1:n,VI(i)=find(V(:,i)==1);end
    U=single(load([prefijo '_U.dat'],'-ascii'));
    R=(load([prefijo '_ros.dat'],'-ascii'));
    RU=zeros(n,k,'single'); %for i=1:n, if R(i,1)<1,R(i,:)=0.1;end,RU(i,:)=.7*U(i,:)*sum(R(i,:))/3;end 
    for i=1:n, RU(i,:)=U(i,:)*sum(R(i,:))/3;end 

    VRU=zeros(k,'single');
    for i=1:n, VRU(VI(i),:)=VRU(VI(i),:)+RU(i,:); end
    Y=-RU*inv(eye(k)-(VRU));
    clear U;
    area=single(load([prefijo '_area.dat'],'-ascii'));
    Yp = Y(objectiveSelectedIndexesOrdered, :);
    Rmean = mean(R')';

    triangleCount = n;
end

positions = [2898 7036 7037 6990 14286 14178 2900 14287 2908];
positionsLength = length(positions);

path = './lumOneByOne/';
regexp = strcat(path, '*.mat');
workingDir = dir(regexp);
luminairesSize = length(workingDir);

results = zeros(positionsLength, luminairesSize);

for position=1:positionsLength
    for selectedLuminary=1:luminairesSize
        fileName = ['./lumOneByOne/' int2str(selectedLuminary)];
        luminDisc = load(fileName);
        E = accumarray([positionsMatrix(position, :) triangleCount]', [luminDisc.a 0]);

        E = E(1:triangleCount);
        E = E.*Rmean;

        B = -Yp*(V*E) + E(objectiveSelectedIndexesOrdered);
        BB = zeros(triangleCount, 1);
        BB(objectiveSelectedIndexesOrdered) = B;
        objetivo = sum(luminairePower(selectedLuminary));
        % Penalty
        c1 = ((max(100 - (min(B)/areaPatch), 0)^2)*100);
        if (c1 > 0)
            c1 = c1 + maxPower; % c1 >= maxPower
        end
        c2 = ((max((max(B)/areaPatch) - 750, 0)^2)*100);
        if (c2 > 0)
            c2 = c2 + maxPower; % c2 >= maxPower
        end

        if (c1 > 0) || (c2 > 0)
            objetivo = 0;
        end
        %objetivo = objetivo + c1 + c2;


        results(position, selectedLuminary) = objetivo;
    end    
end
%----------------------------------------------------