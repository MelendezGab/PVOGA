% Gabriel Melendez Melendez
% October 2021

function [ recovered_image, message ] = data_extraction(Iw)
    [n, m, T1,T2, last_marked_block, Rs, Iw_no_ci, final_sb, Rsc] = control_inf_extraction(Iw);

    Iw = Iw_no_ci;
    [blocks_array, NL] = get_blocks(Iw, n, m); 
    message_counter = 0;                      
    recovered_image = Iw;            
    message = '';
    
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
    
    for i = 1:length(blocks_array)
        block = cell2mat(blocks_array(i)); 
        if i < last_marked_block
            if NL(i) <= T2
                % Extract from sub-blocks
                [sb1, sb2, sb3, sb4] = get_subblocks(block, dim_sb1, dim_sb2, dim_sb3, dim_sb4);

                [rb1, message, message_counter] = block_extraction(sb1, dim_sb1(1), dim_sb1(2), message, message_counter);
                [rb2, message, message_counter] = block_extraction(sb2, dim_sb2(1), dim_sb2(2), message, message_counter);
                [rb3, message, message_counter] = block_extraction(sb3, dim_sb3(1), dim_sb3(2), message, message_counter);
                [rb4, message, message_counter] = block_extraction(sb4, dim_sb4(1), dim_sb4(2), message, message_counter);
                recovered_block = [rb1 rb2; rb3 rb4];
                blocks_array(i) = {recovered_block};
            elseif  T2 < NL(i) && NL(i) <= T1
                % Extract from the entire block
                [recovered_block, message, message_counter] = block_extraction(block, n, m, message, message_counter);
                blocks_array(i) = {recovered_block};
            elseif T1 <= NL(i)
                % Ommited block
            end
        elseif i == last_marked_block
            if NL(i) <= T2
                [sb1, sb2, sb3, sb4] = get_subblocks(block, dim_sb1, dim_sb2, dim_sb3, dim_sb4);
                if (strcmp(final_sb(2:3),'00'))                       
                    [rb1, message, message_counter] = last_block_extraction(sb1, message, message_counter, final_sb(1));
                    recovered_block = [rb1 sb2; sb3 sb4];
                elseif (strcmp(final_sb(2:3),'01'))                        
                    [rb1, message, message_counter] = last_block_extraction(sb1, message, message_counter, '1');
                    [rb2, message, message_counter] = last_block_extraction(sb2, message, message_counter, final_sb(1));
                    recovered_block = [rb1 rb2; sb3 sb4];
                elseif (strcmp(final_sb(2:3),'10'))
                    [rb1, message, message_counter] = last_block_extraction(sb1, message, message_counter, '1');
                    [rb2, message, message_counter] = last_block_extraction(sb2, message, message_counter, '1');
                    [rb3, message, message_counter] = last_block_extraction(sb3, message, message_counter, final_sb(1));
                    recovered_block = [rb1 rb2; rb3 sb4];
                else
                    [rb1, message, message_counter] = last_block_extraction(sb1, message, message_counter, '1');
                    [rb2, message, message_counter] = last_block_extraction(sb2, message, message_counter, '1');
                    [rb3, message, message_counter] = last_block_extraction(sb3, message, message_counter, '1');
                    [rb4, message, message_counter] = last_block_extraction(sb4, message, message_counter, final_sb(1)); 
                    recovered_block = [rb1 rb2; rb3 rb4];
                end
                blocks_array(i) = {recovered_block};
            elseif T2 < NL(i)&& NL(i) <= T1 
                [recovered_block, message, message_counter] = last_block_extraction(block, message, message_counter, final_sb(1));
                blocks_array(i) = {recovered_block};
            elseif T1 <= NL(i)
                % Ommited block
            end
        else
            break;
        end
    end    
    %disp(char(strcat(num2str(message_counter+64+length(Rsc)),{' '},'extracted bits.')));
    cont=0;
    for i=1:floor(size(Iw,1)/n)
        for j=1:floor(size(Iw,2)/m)
            cont = cont + 1;
            row_s = n*(i-1)+1;
            row_f = n*(i-1)+n;
            
            col_s = m*(j-1)+1;
            col_f = m*(j-1)+m;
            
            recovered_image(row_s:row_f,col_s:col_f)= cell2mat(blocks_array(cont));
        end
    end
   
    recovered_image = uint8(recovered_image); 
    recovered_image = image_postprocessing(recovered_image,Rs);
    
end

