% Gabriel Melendez Melendez
% October 2021

function [ Iw, message_counter, message_length ] = data_embedding(Ipr, blocks_array, NL, Rsc, message, T1, T2, n, m)             
    message_counter=0;                             
    message_length = length(message);             
    Iw = Ipr;                 
    long_arr = n*m;               
    
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
    
    ctrl_inf_flag=0;
    
    for i = 1:length(blocks_array)
        if message_counter < message_length
            block = cell2mat(blocks_array(i));                
            if NL(i) <= T2
                % Embed into the sub-blocks
                [sb1, sb2, sb3, sb4] = get_subblocks(block, dim_sb1, dim_sb2, dim_sb3, dim_sb4);

                [sb1, message_counter, final_pee] = mark_block(sb1, dim_sb1(1), dim_sb1(2), dim_sb1(3), message, message_counter);
                final_sb_control = strcat(final_pee, '00');
                
                if message_counter < message_length
                    [sb2, message_counter, final_pee]= mark_block(sb2, dim_sb2(1), dim_sb2(2), dim_sb2(3), message, message_counter);
                    final_sb_control = strcat(final_pee, '01');
                end
                if message_counter < message_length
                    [sb3, message_counter, final_pee]= mark_block(sb3, dim_sb3(1), dim_sb3(2), dim_sb3(3), message, message_counter);
                    final_sb_control = strcat(final_pee, '10'); 
                end
                if message_counter < message_length
                    [sb4, message_counter, final_pee]= mark_block(sb4, dim_sb4(1), dim_sb4(2), dim_sb4(3), message, message_counter);
                    final_sb_control = strcat(final_pee, '11');
                end                    
                marked_block = [sb1 sb2; sb3 sb4];
                blocks_array(i) = {marked_block};
            elseif T2 < NL(i) && NL(i) <= T1
                % Embed using the entire block 
                [marked_block, message_counter, final_pee] = mark_block(block, n, m, long_arr, message, message_counter);
                blocks_array(i) = {marked_block};
                final_sb_control = strcat(final_pee, '00');                
            elseif T1 <= NL(i)
                % Discard block
            end
%--------------------------------------------------------------------------                
            % Control information embedding
            if message_counter == message_length && ctrl_inf_flag == 0          
                [blocks_array, message, message_length ] = control_inf_embedding(Ipr, blocks_array, message, T1, T2, i, Rsc, final_sb_control);
                ctrl_inf_flag = 1;
            end
%--------------------------------------------------------------------------
        else
            break;
        end
    end 
    %disp(strcat('Embedded bits: ',num2str(message_counter)));
    
    cont = 0;   
    for i=1:floor(size(Ipr,1)/n)
        for j=1:floor(size(Ipr,2)/m)
            cont = cont + 1;
            row_s = n*(i-1)+1;
            row_f = n*(i-1)+n;
            
            col_s = m*(j-1)+1;
            col_f = m*(j-1)+m;
            
            Iw(row_s:row_f,col_s:col_f)= cell2mat(blocks_array(cont));
        end
    end
    Iw = uint8(Iw);     
end