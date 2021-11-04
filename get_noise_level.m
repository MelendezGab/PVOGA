% Gabriel Melendez Melendez
% October 2021

function [ NL ] = get_noise_level(block, dim_sb1, dim_sb2, dim_sb3, dim_sb4)
    [sb1, sb2, sb3, sb4] = get_subblocks(block, dim_sb1, dim_sb2, dim_sb3, dim_sb4);
        
    sb1_o = sort(reshape(sb1,[1,dim_sb1(3)]));
    sb2_o = sort(reshape(sb2,[1,dim_sb2(3)]));
    sb3_o = sort(reshape(sb3,[1,dim_sb3(3)]));
    sb4_o = sort(reshape(sb4,[1,dim_sb4(3)]));
    
    min_b(1)=sb1_o(2);
    min_b(2)=sb2_o(2);
    min_b(3)=sb3_o(2);
    min_b(4)=sb4_o(2);
    max_b(1)=sb1_o(dim_sb1(3)-1);
    max_b(2)=sb2_o(dim_sb2(3)-1);
    max_b(3)=sb3_o(dim_sb3(3)-1);
    max_b(4)=sb4_o(dim_sb4(3)-1);
    
    NL = max(max_b) - min(min_b);
end

