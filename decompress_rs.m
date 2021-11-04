% Gabriel Melendez Melendez
% October / 2021

function [ decompressed_rs ] = decompress_rs(compressed)
    global comp_out comp_des arithmetic_coder_path;
    javaaddpath(arithmetic_coder_path)
    ob = Compresion();
    
    dims = size(compressed);
    bytes_number = dims(2)/8;
    %bytes_number
    bytes = zeros(bytes_number,1);
    
    for i=1:bytes_number
        b_start = 8*(i-1)+1;
        b_end = b_start+7;
        bytes(i,1) = bin2dec(compressed(b_start:b_end));
    end
    fileC = fopen(comp_out,'w');
    fwrite(fileC,bytes,'uint8');
    fclose(fileC);
    decompressed_rs = ob.descomprimir_lm(comp_out,comp_des);
end

