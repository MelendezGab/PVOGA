% Gabriel Melendez Melendez
% October 2021

function [ new_individual, fitness, evaluated ] = genetic_operators(current, north, south, east, west, Ipr, Ic, message, evaluated, Rsc)
    winner = selection(north, south, east, west);
    recombinated = crossover(current, winner);
    [new_individual, evaluated] = mutation(recombinated, evaluated);
    [blocks_array, NL] = get_blocks(Ipr, new_individual(1,1), new_individual(1,2));
    %new_individual(1,:)
    [marked_image, message_counter, message_length] = data_embedding(Ipr, blocks_array, NL, Rsc, message, new_individual(1,3), new_individual(1,4), new_individual(1,1), new_individual(1,2));
    if message_counter < message_length || length(Rsc) >= message_length
        new_individual(2,1)=0;
    else
        new_individual(2,1)= psnr(Ic,marked_image);
    end
    
    if new_individual(2,1) < current(2,1)
        new_individual =current;
    end
    fitness = new_individual(2,1);
end

