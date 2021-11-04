% Gabriel Melendez Melendez
% October 2021
% PVO-GA

clearvars
set_paths();
global image_path results_path;

% Create a random binary sequence as payload
payload_length=10000;  
message = num2str(round(rand(1,payload_length)));   
message = message(~isspace(message));

image_name = 'Lena';
Ic = imread(strcat(image_path,image_name,'.tiff'));
Ic = Ic(:,:,1);
[Ipr,Rs] = image_preprocessing(Ic);
[Rsc] = compress_rs(Rs);

population = cell(4,4);
fitness = zeros(4);
evaluated = {};

for i = 1:4
    for j=1:4

        n =randi(12)+4;         % Random values between 4 and 16
        m =randi(12)+4;         % Random values between 4 and 16
        T1 = randi(254)+1;      % Random values between 1 and 255
        T2 = randi(T1-1);       % Random values between 1 and T1-1

        individual(1,1) = n;
        individual(1,2) = m;
        individual(1,3) = T1;    % T1 > T2
        individual(1,4) = T2;

        evaluated{end+1} = [individual(1,:)];

        [blocks_array, NL] = get_blocks(Ipr,individual(1,1), individual(1,2));
        [Iw, message_counter, message_length] = data_embedding(Ipr, blocks_array, NL, Rsc, message, individual(1,3), individual(1,4), individual(1,1), individual(1,2));
        if message_counter < message_length || length(Rsc) >= payload_length
            individual(2,1)=0;
        else
            individual(2,1) = psnr(Ic,Iw);
            fitness(i,j) = individual(2,1);
        end
        population{i,j} = individual;
    end
end

disp('**************************** Begin generations ****************************');
num_gen=20;
fit{1} = fitness;
pob{1} = population;
for i = 1:num_gen
    disp(char(strcat(' ---> Generation ', {' '}, num2str(i))));
    [population{1,1}, fitness(1,1), evaluated] = genetic_operators(cell2mat(population(1,1)),cell2mat(population(4,1)),cell2mat(population(2,1)),cell2mat(population(1,2)),cell2mat(population(1,4)), Ipr, Ic, message, evaluated, Rsc);
    [population{1,2}, fitness(1,2), evaluated] = genetic_operators(cell2mat(population(1,2)),cell2mat(population(4,2)),cell2mat(population(2,2)),cell2mat(population(1,3)),cell2mat(population(1,1)), Ipr, Ic, message, evaluated, Rsc);
    [population{1,3}, fitness(1,3), evaluated] = genetic_operators(cell2mat(population(1,3)),cell2mat(population(4,3)),cell2mat(population(2,3)),cell2mat(population(1,4)),cell2mat(population(1,2)), Ipr, Ic, message, evaluated, Rsc);
    [population{1,4}, fitness(1,4), evaluated] = genetic_operators(cell2mat(population(1,4)),cell2mat(population(4,4)),cell2mat(population(2,4)),cell2mat(population(1,1)),cell2mat(population(1,3)), Ipr, Ic, message, evaluated, Rsc);
    [population{2,1}, fitness(2,1), evaluated] = genetic_operators(cell2mat(population(2,1)),cell2mat(population(1,1)),cell2mat(population(3,1)),cell2mat(population(2,2)),cell2mat(population(2,4)), Ipr, Ic, message, evaluated, Rsc);
    [population{2,2}, fitness(2,2), evaluated] = genetic_operators(cell2mat(population(2,2)),cell2mat(population(1,2)),cell2mat(population(3,2)),cell2mat(population(2,3)),cell2mat(population(2,1)), Ipr, Ic, message, evaluated, Rsc);
    [population{2,3}, fitness(2,3), evaluated] = genetic_operators(cell2mat(population(2,3)),cell2mat(population(1,3)),cell2mat(population(3,3)),cell2mat(population(2,4)),cell2mat(population(2,2)), Ipr, Ic, message, evaluated, Rsc);
    [population{2,4}, fitness(2,4), evaluated] = genetic_operators(cell2mat(population(2,4)),cell2mat(population(1,4)),cell2mat(population(3,4)),cell2mat(population(2,1)),cell2mat(population(2,3)), Ipr, Ic, message, evaluated, Rsc);
    [population{3,1}, fitness(3,1), evaluated] = genetic_operators(cell2mat(population(3,1)),cell2mat(population(2,1)),cell2mat(population(4,1)),cell2mat(population(3,2)),cell2mat(population(3,4)), Ipr, Ic, message, evaluated, Rsc);
    [population{3,2}, fitness(3,2), evaluated] = genetic_operators(cell2mat(population(3,2)),cell2mat(population(2,2)),cell2mat(population(4,2)),cell2mat(population(3,3)),cell2mat(population(3,1)), Ipr, Ic, message, evaluated, Rsc);
    [population{3,3}, fitness(3,3), evaluated] = genetic_operators(cell2mat(population(3,3)),cell2mat(population(2,3)),cell2mat(population(4,3)),cell2mat(population(3,4)),cell2mat(population(3,2)), Ipr, Ic, message, evaluated, Rsc);
    [population{3,4}, fitness(3,4), evaluated] = genetic_operators(cell2mat(population(3,4)),cell2mat(population(2,4)),cell2mat(population(4,4)),cell2mat(population(3,1)),cell2mat(population(3,3)), Ipr, Ic, message, evaluated, Rsc);
    [population{4,1}, fitness(4,1), evaluated] = genetic_operators(cell2mat(population(4,1)),cell2mat(population(3,1)),cell2mat(population(1,1)),cell2mat(population(4,2)),cell2mat(population(4,4)), Ipr, Ic, message, evaluated, Rsc);
    [population{4,2}, fitness(4,2), evaluated] = genetic_operators(cell2mat(population(4,2)),cell2mat(population(3,2)),cell2mat(population(1,2)),cell2mat(population(4,3)),cell2mat(population(4,1)), Ipr, Ic, message, evaluated, Rsc);
    [population{4,3}, fitness(4,3), evaluated] = genetic_operators(cell2mat(population(4,3)),cell2mat(population(3,3)),cell2mat(population(1,3)),cell2mat(population(4,4)),cell2mat(population(4,2)), Ipr, Ic, message, evaluated, Rsc);
    [population{4,4}, fitness(4,4), evaluated] = genetic_operators(cell2mat(population(4,4)),cell2mat(population(3,4)),cell2mat(population(1,4)),cell2mat(population(4,1)),cell2mat(population(4,3)), Ipr, Ic, message, evaluated, Rsc);
    fit{i+1} = fitness;
    pob{i+1} = population;
end

cell2mat(population)
fitness

% Filetext creation to write results.
filePh = fopen(char(strcat(results_path,image_name,{' '}, regexprep(datestr(datetime('now')),':',','),'.txt')),'wt');
fprintf(filePh,'\n%s\n\n',image_path);

for i=1:num_gen+1
    a = cell2mat(fit(i));
    disp(a);
    disp(max(a(:)));
end

for current_gen = 1:num_gen+1
%disp(strcat(' Generation --> ',num2str(i-1),' -----------------------------------------------------------------------'))
fprintf(filePh,'%s\n',strcat(' Generation --> ',num2str(current_gen-1),' -----------------------------------------------------------------------'));
current_population = pob{i};
    for i = 1:4
        for j=1:4
            individual = cell2mat(current_population(i,j));
            %disp(strcat('Individual(', num2str(i),',',num2str(i),')--> N:',num2str(individual(1,1)),' M:',num2str(individual(1,2)),', T1:',num2str(individual(1,3)),' T2:',num2str(individual(1,4)),' PSNR:',num2str(individual(2,1))));
            fprintf(filePh,'%s\n',strcat('Individual(', num2str(i),',',num2str(j),')--> N:',num2str(individual(1,1)),' M:',num2str(individual(1,2)),', T1:',num2str(individual(1,3)),' T2:',num2str(individual(1,4)),' PSNR:',num2str(individual(2,1))));
        end
    end
end
fprintf(filePh,'\n\n%s\n\n',' Best fitness value per generation');
for i=1:num_gen+1
    a = cell2mat(fit(i));
    %disp(num2str(max(a(:))));
    fprintf(filePh,'%s\n',num2str(max(a(:))));
end
fclose(filePh);

%end;
