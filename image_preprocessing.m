% Gabriel Melendez Melendez
% October 2021

function [ Ipr, Rs ] = image_preprocessing(Ic)
    Ipr = Ic;
    Rs = '';
    Ipr(Ipr==0) = 1;
    Ipr(Ipr==255) = 254;

    for i=1:size(Ic,1)
        for j=1:size(Ic,2)
            if (Ipr(i,j)==254 || Ipr(i,j)==1)
                if(Ipr(i,j) == Ic(i,j))
                    Rs = append(Rs,'0');
                else
                    Rs = append(Rs,'1');
                end
            end
        end
    end
end

