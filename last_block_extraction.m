% Gabriel Melendez Melendez
% October 2021

function [ rec_block, mark, payload_counter ] = last_block_extraction(block, mark, payload_counter, last_pee)
    block_dims = size(block);
    array_size = block_dims(1)*block_dims(2);
    block_array = reshape(block,[1,array_size]);
    [sorted_block, sorted_index] = sort(block_array);
    
    u = min(sorted_index(array_size),sorted_index(array_size-1));
    v = max(sorted_index(array_size),sorted_index(array_size-1));
    dmax = block_array(u) - block_array(v);
    
    s = min(sorted_index(1),sorted_index(2));
    t = max(sorted_index(1),sorted_index(2));
    dmin = block_array(s) - block_array(t);

    if dmax > 0
        if (dmax == 1 || dmax == 2)
            %disp(strcat('extracted from dmax=',num2str(dmax)));
            payload_counter = payload_counter + 1;
            b = dmax-1;
            mark(payload_counter) = num2str(b);
            sorted_block(array_size) = block_array(u)-b;
        else
            %disp(strcat('contract dmax=',num2str(dmax)));
            sorted_block(array_size) = block_array(u)-1;
        end
    else
        if (dmax == 0 || dmax == -1)
            %disp(strcat('extracted from dmax=',num2str(dmax)));
            payload_counter = payload_counter + 1;
            b = dmax*-1;
            mark(payload_counter) = num2str(b);
            sorted_block(array_size) = block_array(v)-b;
        else
            %disp(strcat('contract dmax=',num2str(dmin)));
            sorted_block(array_size) = block_array(v)-1;
        end
    end
    
    if (strcmp(last_pee,'1'))
        if dmin > 0 
            if (dmin == 1 || dmin == 2)
                %disp(strcat('extracted from dmin=',num2str(dmin)));
                payload_counter = payload_counter + 1;
                b = dmin-1;
                mark(payload_counter) = num2str(b);
                sorted_block(1) = block_array(t)+b;
            else
                %disp(strcat('contract dmin=',num2str(dmin)));
                sorted_block(1) = block_array(t)+1;
            end
        else
            if (dmin == 0 || dmin == -1)
                %disp(strcat('extracted from dmin = ',num2str(dmin)));
                payload_counter = payload_counter + 1;
                b = (-1)*dmin;
                mark(payload_counter) = num2str(b);
                sorted_block(1) = block_array(s)+b;
            else
                %disp(strcat('contract dmin = ',num2str(dmin)));
                sorted_block(1) = block_array(s)+1;    
            end
        end
    end

    [~, inv_index] = sort(sorted_index); 
    unsorted_array = sorted_block(inv_index);
    rec_block = reshape(unsorted_array,[block_dims(1),block_dims(2)]);
end
