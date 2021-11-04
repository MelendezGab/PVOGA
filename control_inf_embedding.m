% Gabriel Melendez Melendez
% October 2021

function [ blocks_array, message, new_payload_size ] = control_inf_embedding(image, blocks_array, message, T1,T2, block_counter, Rsc, final_sb)
    cont = 0;
    marked_image = image;
    [n,m] = size(cell2mat(blocks_array(1)));
    row_blocks = floor(size(image,1)/n);
    col_blocks = floor(size(image,2)/m);
    
    for i=1:row_blocks
        for j=1:col_blocks
            cont = cont + 1;
            row_s = n*(i-1)+1;
            row_f = n*(i-1)+n;

            col_s = m*(j-1)+1;
            col_f = m*(j-1)+m;
            marked_image(row_s:row_f,col_s:col_f)= cell2mat(blocks_array(cont));
        end
    end
    marked_image = uint8(marked_image);  
    
    %   Control information metadata
    %   block sizes     =   4  bits
    %   thresholds      =   8  bits (1-255)
    %   last block      =   18 bits
    %   scan sec size   =   16 bits
    %   last block info =   3 bits 
    
    aux_inf = strcat(dec2bin(n,4),dec2bin(m,4),dec2bin(T1,8),dec2bin(T2,8),final_sb,dec2bin(block_counter,18),dec2bin(length(Rsc),16),Rsc);
    backup(1:length(aux_inf)) = '0';
    im_dims = size(marked_image);
    cont = 0;
    for i=1:im_dims(1)
        for j=1:im_dims(2)
            if cont <  length(aux_inf)
                cont = cont + 1;
                backup(cont) = num2str(bitget(marked_image(i,j),1));
                marked_image(i,j) = bitset(marked_image(i,j),1,bin2dec(aux_inf(cont)));
            end
        end
    end
    marked_image = uint8(marked_image); 
    [blocks_array, ~] = get_blocks(marked_image,n, m); 
    message = strcat(message,backup);
    new_payload_size = length(message);
end

