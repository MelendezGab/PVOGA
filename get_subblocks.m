% Gabriel Melendez Melendez
% October 2021

function [ sb1, sb2, sb3, sb4 ] = get_subblocks(block, dim_sb1, dim_sb2, dim_sb3, dim_sb4)
    sb1 = block(1:dim_sb1(1),1:dim_sb1(2));
    sb2 = block(1:dim_sb2(1), dim_sb1(2)+1:dim_sb1(2)+dim_sb2(2));
    sb3 = block(dim_sb1(1)+1:dim_sb1(1)+dim_sb3(1),1:dim_sb3(2));
    sb4 = block(dim_sb1(1)+1:dim_sb1(1)+dim_sb4(1), dim_sb1(2)+1:dim_sb1(2)+dim_sb4(2));
end

