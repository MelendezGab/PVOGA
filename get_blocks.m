%Gabriel Melendez Melendez
% November 2021

function [ array_blocks, NL ] = get_blocks(image, n, m)
    [rows, cols] = size(image);
    rows_number = floor(rows/n); 
    cols_number = floor(cols/m);

    dim_sb1(1) = floor(n/2);
    dim_sb1(2) = floor(m/2);
    dim_sb1(3) = dim_sb1(1)*dim_sb1(2);
    
    dim_sb2(1) = floor(n/2);
    dim_sb2(2) = ceil(m/2);
    dim_sb2(3) = dim_sb2(1)*dim_sb2(2);
    
    dim_sb3(1) = ceil(n/2);
    dim_sb3(2) = floor(m/2);
    dim_sb3(3) = dim_sb3(1)*dim_sb3(2);
    
    dim_sb4(1) = ceil(n/2);
    dim_sb4(2) = ceil(m/2);
    dim_sb4(3) = dim_sb4(1)*dim_sb4(2);
    %----------------------------------------------------------------------
    NL = {};
    array_blocks = {}; 
    for i = 1:(rows_number)
        for j = 1:(cols_number)
            block_s = ((i-1)*n)+1;
            block_f = ((j-1)*m)+1;
            block = image(block_s:block_s+(n-1),block_f:block_f+(m-1));
            NL{end+1} = get_noise_level(block, dim_sb1,dim_sb2,dim_sb3,dim_sb4);
            array_blocks{end+1} = double(block);   
        end
    end
    NL = cell2mat(NL);
end