% Gabriel Melendez Melendez
% October 2021

function [ compressed ] = compress_rs(Rs)
    global comp_in comp_out arithmetic_coder_path;
    javaaddpath(arithmetic_coder_path);
    ob = Compresion();
    ob.comprimir_lm(Rs, comp_in, comp_out);
    
    fileC = fopen(comp_out);
    original_bytes = fread(fileC);

    num_bytes = size(original_bytes);
    compressed = '';
    for i=1:num_bytes(1)
        b_start = 8*(i-1)+1;
        b_end = b_start+7;
        compressed(b_start:b_end) = dec2bin(original_bytes(i,1),8);
    end
    fclose(fileC);
end

