% Gabriel Melendez Melendez
% October 2021

function [] = set_paths()

    global comp_in comp_out comp_des image_path results_path arithmetic_coder_path;  
    
    image_path          = 'img\';
    results_path        = 'result\';

    arithmetic_coder_path    = 'resources\codificador_aritmetico.jar';
    comp_in             = 'resources\in.txt';
    comp_out            = 'resources\out.txt';
    comp_des            = 'resources\salidades.txt';
end
