% Gabriel Melendez Melendez
% October 2021 

function [ n, m, T1, T2, last_block, Rs, Iw_no_ci, final_sb_control, Rsc ] = control_inf_extraction(Iw)
    im_dims = size(Iw);
    bits_Rsc_length ='';
    for i = 46:61
        bits_Rsc_length = append(bits_Rsc_length, num2str(bitget(Iw(1,i),1)));         
    end
    Rsc_length = bin2dec(bits_Rsc_length);
    aux_inf = '';
    cont = 0;
    backup_length = 61 + Rsc_length; 
    
    for i=1:im_dims(1)
        for j=1:im_dims(2)
            cont = cont + 1;
            if cont <= backup_length
                aux_inf(cont)=num2str(bitget(Iw(i,j),1));
            else 
                break;
            end
        end
        if cont > backup_length
            break;
        end
    end
 
    n = bin2dec(aux_inf(1:4));
    m = bin2dec(aux_inf(5:8));
    T1 = bin2dec(aux_inf(9:16));
    T2 = bin2dec(aux_inf(17:24));
    final_sb_control = aux_inf(25:27);
    last_block = bin2dec(aux_inf(28:45));   
    Rsc = aux_inf(62:length(aux_inf));
    
    rs_java_lang_string = decompress_rs(Rsc);
    Rs = rs_java_lang_string.toCharArray();
    
    [blocks_array, NL] = get_blocks(Iw,n,m); 
         
    backup_bits_counter=0;              % Back up bits counter
    Iw_no_ci = Iw;                      % Marked image without control inf     
    backup_bits = '';
    
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
        
    for i = last_block+1:length(blocks_array)
        if backup_bits_counter < backup_length                                 
            block = cell2mat(blocks_array(i));                     
            if NL(i) <= T2
                % Extract from sub-blocks                    
                [sb1, sb2, sb3, sb4] = get_subblocks(block, dim_sb1, dim_sb2, dim_sb3, dim_sb4);

                [rb1, backup_bits, backup_bits_counter] = ctrl_inf_block_extraction(sb1,backup_bits,backup_bits_counter, backup_length);
                [rb2, backup_bits, backup_bits_counter] = ctrl_inf_block_extraction(sb2,backup_bits,backup_bits_counter, backup_length);
                [rb3, backup_bits, backup_bits_counter] = ctrl_inf_block_extraction(sb3,backup_bits,backup_bits_counter, backup_length);
                [rb4, backup_bits, backup_bits_counter] = ctrl_inf_block_extraction(sb4,backup_bits,backup_bits_counter, backup_length);
                recovered_block = [rb1 rb2; rb3 rb4];
                blocks_array(i) = {recovered_block};
            elseif  T2 < NL(i) && NL(i) <= T1
                % Extract form the entire block
                [recovered_block, backup_bits, backup_bits_counter] = ctrl_inf_block_extraction(block,backup_bits,backup_bits_counter, backup_length);
                blocks_array(i) = {recovered_block};
            elseif T1 <= NL(i)
                % No bits were embedded
            end                
        else
            break;
        end
    end
    
    cont=0;
    for i=1:floor(im_dims(1)/n)
        for j=1:floor(im_dims(2)/m)
            cont = cont + 1;
            row_s = n*(i-1)+1;
            row_f = n*(i-1)+n;
            
            col_s = m*(j-1)+1;
            col_f = m*(j-1)+m;
            
            Iw_no_ci(row_s:row_f,col_s:col_f)= cell2mat(blocks_array(cont));
        end
    end
    
    Iw_no_ci = uint8(Iw_no_ci); 
    
    cont = 0;   
    for i=1:im_dims(1)
        for j=1:im_dims(2)
            cont = cont + 1;
            if cont <= backup_length
            Iw_no_ci(i,j)=bitset(Iw_no_ci(i,j),1,+bin2dec(backup_bits(cont)));
            else 
                break;
            end
        end
        if cont > backup_length
            break;
        end
    end
end

