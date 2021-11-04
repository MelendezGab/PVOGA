% Gabriel Melendez Melendez
% October 2021

function [ modified, evaluated ] = mutation(recombinated, evaluated)
    new_individual_exists = 0;
    modified = recombinated;
    
    while new_individual_exists == 0
        parameter = randi(3);
        operation = randi(2);
        B_block = randi(2);
        B_threshold = randi(10);
        if parameter==1
            if operation == 1
                if modified(1,3)+B_threshold <= 254
                    modified(1,3)=modified(1,3)+B_threshold;
                    modified(1,4)=randi(modified(1,3)-1);
                end
            else
                if modified(1,3)-B_threshold > 1 
                    modified(1,3)=modified(1,3)-B_threshold;
                    modified(1,4)=randi(modified(1,3)-1);
                end
            end

        elseif parameter==2
            if operation == 1
                if modified(1,1)+B_block < 16
                    modified(1,1)=modified(1,1)+B_block;
                end
            else
                if modified(1,1)-B_block >=4 % Minimo tamaño bloque  
                    modified(1,1)=modified(1,1)-B_block;
                end
            end
        else
            if operation == 1
                if modified(1,2)+B_block < 16
                    modified(1,2)=modified(1,2)+B_block;
                end
            else
                if modified(1,2)-B_block >=4 
                    modified(1,2)=modified(1,2)-B_block;
                end
            end
        end
        %disp(any(cellfun(@(rec) isequal(rec, modified(1,:)), evaluated)));
        %Definir un numero max de T's
        disp(modified(1,:));
        if any(cellfun(@(rec) isequal(rec, modified(1,:)), evaluated)) == 0
            evaluated{end+1} = modified(1,:);
            new_individual_exists = 1;
        end
    end
end

