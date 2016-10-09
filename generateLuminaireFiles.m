load luminaireHemicubeMatrix.mat luminaireHemicubeMatrix
[maxI aux] = size(luminaireHemicubeMatrix);
for i=1:maxI
	a = luminaireHemicubeMatrix(i, :);
	fileName = ['./lumOneByOne/' int2str(i)];
	save(fileName, 'a')
end