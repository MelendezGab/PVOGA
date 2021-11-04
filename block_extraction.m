% Gabriel Melendez Melendez
% October 2021

function [ original_block, message, message_counter ] = block_extraction(block, n, m, message, message_counter)
    array_length = n*m;
    array_block = reshape(block,[1,array_length]);
    [sorted_block, srt_idx] = sort(array_block);
    u = min(srt_idx(array_length),srt_idx(array_length-1));
    v = max(srt_idx(array_length),srt_idx(array_length-1));
    dmax = array_block(u) - array_block(v);
    
    s = min(srt_idx(1),srt_idx(2));
    t = max(srt_idx(1),srt_idx(2));
    dmin = array_block(s) - array_block(t);

    if dmax > 0
        if (dmax == 1 || dmax == 2)            
            message_counter = message_counter + 1;
            b = dmax-1;
            %disp(strcat('extracted from dmax=',num2str(dmax)));
            message(message_counter) = num2str(b);
            sorted_block(array_length) = array_block(u)-b;
        else
            sorted_block(array_length) = array_block(u)-1;
            %disp(strcat('contract dmax=',num2str(dmax)));
        end
    else
        if (dmax == 0 || dmax == -1)             
            message_counter = message_counter + 1;
            b = dmax*-1;      
            %disp(strcat('extracted from dmax=',num2str(dmax)));      
            message(message_counter) = num2str(b);
            sorted_block(array_length) = array_block(v)-b;
        else
            sorted_block(array_length) = array_block(v)-1;                
            %disp(strcat('contract dmax=',num2str(dmax)));
        end
    end
    
    if dmin > 0 
        if (dmin == 1 || dmin == 2)                
            message_counter = message_counter + 1;
            b = dmin-1;          
            %disp(strcat('extracted from dmin=',num2str(dmin)));
            message(message_counter) = num2str(b);
            sorted_block(1) = array_block(t)+b;
        else
            sorted_block(1) = array_block(t)+1;
            %disp(strcat('contract dmin=',num2str(dmin)));
        end
    else
        if (dmin == 0 || dmin == -1)                
            message_counter = message_counter + 1;
            b = (-1)*dmin;           
            %disp(strcat('extracted from dmin=',num2str(dmin)));     
            message(message_counter) = num2str(b);
            sorted_block(1) = array_block(s)+b;
        else
            sorted_block(1) = array_block(s)+1; 
            %disp(strcat('contract dmin=',num2str(dmin)));   
        end
    end
    
    [~, idx_rev] = sort(srt_idx); 
    unsorted_vec = sorted_block(idx_rev);
    original_block = reshape(unsorted_vec,[n,m]);
end

