% Gabriel Melendez Melendez
% October 2021

function [ Ipr ] = image_postprocessing(Ic, Rs)
    Ipr = Ic;
    cont = 0;
    for i=1:size(Ipr,1)
        for j=1:size(Ipr,2)
            if Ipr(i,j) == 254 || Ipr(i,j) == 1
                cont = cont + 1;
                if Rs(cont) == '1'
                    if Ipr(i,j) == 254
                        Ipr(i,j) = 255;
                    else
                        Ipr(i,j) = 0;
                    end
                end
            end
        end
    end
end

