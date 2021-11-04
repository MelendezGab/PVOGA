% Gabriel Melendez Melendez
% October 2021

function [ marked_block, cont_message, final_pee ] = mark_block(block, n, m, array_length, message, cont_message)
    message_length = length(message);   
    array_block = reshape(block,[1,array_length]);
    [sorted_array, srt_idx] = sort(array_block);

    u = min(srt_idx(array_length),srt_idx(array_length-1));
    v = max(srt_idx(array_length),srt_idx(array_length-1));
    dmax = array_block(u) - array_block(v);

    s = min(srt_idx(1),srt_idx(2));
    t = max(srt_idx(1),srt_idx(2));
    dmin = array_block(s) - array_block(t); 
    final_pee = '0';
    if(dmax==1 || dmax==0)
        cont_message = cont_message + 1;        
        %disp(char(strcat('dmax(', num2str(cont_message),{') '},message(cont_message))));
        sorted_array(array_length) = sorted_array(array_length)+ str2double(message(cont_message));
        final_pee = '0';
    else
        sorted_array(array_length) = sorted_array(array_length) + 1;
    end
    
    if cont_message < message_length
        if(dmin==1 || dmin==0) 
            cont_message = cont_message + 1;            
            %disp(char(strcat('dmin(',num2str(cont_message),') ',message(cont_message))));            
            sorted_array(1) = sorted_array(1)- str2double(message(cont_message));
            final_pee = '1';            
        else
            sorted_array(1) = sorted_array(1) - 1;  
        end
    end
    [~, idx_rev] = sort(srt_idx); 
    unsorted_vec = sorted_array(idx_rev);
    marked_block = reshape(unsorted_vec,[n,m]);
end

