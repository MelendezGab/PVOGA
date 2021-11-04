% Gabriel Melendez Melendez
% October 2021

function [ recombinated ] = crossover(current, father)
    operator = randi(2);
    crossover_point = randi(3);
    if operator == 1
        recombinated(1,1:crossover_point) = current(1,1:crossover_point);
        recombinated(1,crossover_point+1:4) = father(1,crossover_point+1:4);
    elseif operator == 2
        recombinated(1,1:crossover_point) = father(1,1:crossover_point);
        recombinated(1,crossover_point+1:4) = current(1,crossover_point+1:4); 
    end
end

