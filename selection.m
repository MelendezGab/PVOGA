% Gabriel Melendez Melendez
% October 2021

function [ winner ] = selection(north, south, east, west)
    if north(2,1) > south(2,1)
        winner = north;
    else 
        winner = south;
    end    
    if east(2,1) > winner(2,1)
        winner = east;
    end    
    if west(2,1) > winner(2,1)
        winner = west;
    end
end

