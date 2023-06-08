clearvars
set_paths;
global image_path

message_length = 37500;  
message = num2str(round(rand(1,message_length)));   
message = message(~isspace(message));

image_name = 'Lena';
Ic = imread(strcat(image_path,image_name,'.tiff'));
Ic = Ic(:,:,1);
[Ipr,Rs] = image_preprocessing(Ic);
[Rsc] = compress_rs(Rs);

n = 11;
m = 5;
T1 = 68;
T2 = 18;
tic
[blocks_array, NL] = get_blocks(Ipr,n,m);
[Iw,p_counter,~] = data_embedding(Ipr,blocks_array,NL,Rsc,message,T1,T2,n,m);
p_counter
[Ir,extracted_message] = data_extraction(Iw);
toc

%diff_image = Ic-Ir;
%diff_image(diff_image~=0)=255;
%imshow(diff_image);

disp(strcat('PSNR(Ic,Iw):',num2str(psnr(Ic,Ir))));
disp(strcat('PSNR(Ic,Iw):',num2str(psnr(Ic,Iw))));
disp(strcat('Embedded message  : ',message));
disp(strcat('Extracted message : ',extracted_message));

