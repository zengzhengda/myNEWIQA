clear all; clc;
img1_path='img1.bmp';
img_src=imread(img1_path);
img_src_gray=rgb2gray(img_src);
img_dst_list_path={};
img_dst_list_path{1}='img1.bmp';
img_dst_list_path{2}='img13.bmp';
img_dst_list_path{3}='img29.bmp';
img_dst_list_path{4}='img33.bmp';
img_dst_list_path{5}='img156.bmp';
img_dst_list_path{6}='img222.bmp';
dmos=[0,46.684, 63.645, 52.786, 71.451, 31.278];
iqa_ssim=[];
iqa_sparse=[];
% parameter setting
param.lambda=[0.0002, 0];
param.semiN=2;
param.padval='symmetric';

for i =1:length(img_dst_list_path)
    img_dst=imread(img_dst_list_path{i});
    img_dst_gray=rgb2gray(img_dst);
    iqa_ssim(i)=ssim_index(img_src_gray,img_dst_gray);
    iqa_sparse(i)=Sparse_ssim(img_src_gray,img_dst_gray,param);
end
mos=100-dmos
iqa_ssim
iqa_sparse
[CC_ssim,SROCC_ssim,RMSE_ssim]=performance_eval(dmos,iqa_ssim,0)
[CC_sparse,SROCC_sparse,RMSE_sparse]=performance_eval(dmos,iqa_sparse,0)
