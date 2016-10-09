% Generates an array with the IDs of the triangles viewed from the hemicube
% i         - current position in i
% j         - current position in i
% lastJ     - last j visited when cycled back to the first i (initially = 1)
% maxI      - max value allowed for i
% maxJ      - max value allowed for j
function [i j lastJ] = nextMatrixPoint(i, j, lastJ, maxI, maxJ)

%En diagonal, siempre intenta ir abajo a la izquierda si no puede vuelve a 
%iniciar en el primer elemento disponible de la primer columna que no fue 
%consultada (o la ultima columna de la matriz en caso que no hayan mas)

if ((i == maxI) && (j == maxJ)) 
    i = 1;
    j = 1;
    lastJ = 1;
else
    down = i + 1;
    left = j - 1;
    if (down <= maxI && left >0)
        i = down;
        j = left;
    else
        lastJ = lastJ + 1;
        nextiii = 1;
        restjjj = lastJ - maxJ;
        if (restjjj <= 0)
            i = nextiii;
            j = lastJ;
        else
            i = restjjj + 1;
            j = maxJ;
        end
    end
end

end

