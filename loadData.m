totalTimerId = tic;
here = pwd; cd '..\OptimizationEngine\hemicubesGenerator\';
disp('LOADING DATA...');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -------PARAMETERS -------------
format long g

if ~exist('lumCount', 'var')
   lumCount = 2;
end

if ~exist('CargarMatrices', 'var')
   CargarMatrices=1;
end

objectiveImage = 'piso_patio_fino2Pisos21824.bmp';
if ~exist('positionsImage', 'var')
    positionsImage = 'techo_patio_fino2Pisos21824.bmp';
end
% -------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -------LOAD DATA---------------
if CargarMatrices
    disp('LOADING LUMINARIES MATRICES...');
    
    load('luminaireHemicubeMatrix.mat', 'luminaireHemicubeMatrix');
    load('luminaireNameMap.mat', 'luminaireNameMap');
    load('luminairePower.mat', 'luminairePower');
    load('orderedLuminarieListIndexes.mat', 'orderedLuminarieListIndexes');
    load('positionsMatrix.mat', 'positionsMatrix');
    load('positionsNameMap.mat', 'positionsNameMap');
    
    % ORDER AUXILIAR MATRICES
    % Order luminaireNameMap to make it consistent with the luminaireHemicubeMatrix
    orderedLuminaireNameMap = luminaireNameMap(orderedLuminarieListIndexes);
    % Order luminairePower to make it consistent with the luminaireHemicubeMatrix
    luminairePower = luminairePower(orderedLuminarieListIndexes);
    maxPower = max(luminairePower);
    %Order luminaireNameMap with matrix order
    luminaireNameMap = luminaireNameMap(orderedLuminarieListIndexes);
    
    disp('LUMINARIES MATRICES LOADED SUCCESSFULLY...');
else
    disp('LUMINARIES MATRICES SEEM TO BE ALREADY LOADED, skipping step...');
end

% -------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -------CALCULATE---------------
% [positionsMapMatrix selectedTriangles selectedIndexesOrdered] = loadViewSurface(positionsImage, 'BMP', 92, 9216);
[positionsMapMatrix selectedTriangles selectedIndexesOrdered] = loadViewSurface(positionsImage, 'BMP', 50, 21824);

% Get the triangles on the objective
[objectivePositionsMapMatrix objectiveSelectedTriangles objectiveSelectedIndexesOrdered] = loadViewSurface(objectiveImage, 'BMP', 1, 21824);

% Transform positions file names to indexes
positionsMap = regexp(positionsNameMap, 'H_(\d+).bmp', 'tokens', 'once');
positionsMap = vertcat(positionsMap{:});
positionsMap = sprintf('%s ', positionsMap{:});
selectedIndexesOrdered = sscanf(positionsMap, '%u') + 1;

prefijo = 'patio_fino2Pisos21824';   %es el prefijo de los archivos que contienen U, V, R, área.

%<<<<<<<<< PARÁMETROS DE EJECUCIÓN <<<<<<<<<<<<<<<<<<
%<<<<<<<<< PARÁMETROS DE EJECUCIÓN <<<<<<<<<<<<<<<<<<
%<<<<<<<<< PARÁMETROS DE EJECUCIÓN <<<<<<<<<<<<<<<<<<

nvars=3;            % count of variables
allVars = nvars*lumCount; % count of all vars on each solution

%---------------------------------------
% Optimize Power Find min and max luxes:
%---------------------------------------
areaPatch = (0.3*0.3)/2; % triangles of half a meter
%---------------------------------------

[y x] = size(positionsMapMatrix);
[l aux] = size(orderedLuminarieListIndexes);

% Calculate the max value a neighbor can have
variableMaxNeighbor = [y;x;l];

variableMaxNeighborLumCount = [];
for i=1:lumCount
    variableMaxNeighborLumCount = [variableMaxNeighborLumCount variableMaxNeighbor'];
end
variableMaxNeighborLumCountT = variableMaxNeighborLumCount';

if ~exist('weightArray', 'var')
   weightArray = [1 1 3];
end
weightArray = [ones(1, weightArray(1)) ones(1, weightArray(2))*2 ones(1, weightArray(3))*3];
[aux weightArraySize] = size(weightArray);

weightArrayAll = [];
for i=1:nvars:allVars
    weightArrayAll = [weightArrayAll (weightArray+(i-1))];
end

[aux weightArrayAllSize] = size(weightArrayAll);

target = load('target.mat');
target = target.B;

if CargarMatrices
    disp('LOADING LOW-RANK RADIOSITY MATRICES...');
    CargarMatrices=0;
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
    disp('LOW-RANK RADIOSITY MATRICES LOADED SUCCESSFULLY...');
else
    disp('LOW-RANK RADIOSITY MATRICES SEEM TO BE ALREADY LOADED, skipping step...');
end
triangleCount = n;
% -------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%REORGANIZE VARIABLES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Problem specific
problemObj.objectiveSelectedIndexesOrdered = objectiveSelectedIndexesOrdered;
problemObj.selectedIndexesOrdered = selectedIndexesOrdered;
problemObj.target = target;
problemObj.triangleCount = triangleCount;
problemObj.areaPatch = areaPatch;
problemObj.lumCount = lumCount;
problemObj.nvars = nvars;
problemObj.luminarieLocation = '../OptimizationEngine/hemicubesGenerator/lumOneByOne/';
problemObj.weightArray = weightArray;
problemObj.MutationProbability = 0.02;
problemObj.CrossoverProbability = 0.6;
problemObj.PopulationSize = 50;
problemObj.Generations = 300;

% Low-Rank specific
lowRankObj.Rmean = Rmean;
lowRankObj.RmeanMatrix = diag(Rmean);
lowRankObj.Yp = Yp;
lowRankObj.Y = Y;
lowRankObj.V = V;

% Positions specific
positionObj.positionsMapMatrix = positionsMapMatrix;
positionObj.positionsMatrix = positionsMatrix;

% Luminarie specific
luminarieObj.orderedLuminaireNameMap = orderedLuminaireNameMap;
luminarieObj.maxPower = maxPower;
luminarieObj.luminairePower = luminairePower;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(here);
disp('ALL DATA LOADED SUCCESSFULLY...');
totalTime = toc(totalTimerId);
X = ['TIME CONSUMED LOADING DATA: ', num2str(totalTime), ' seconds'];
disp(X);
