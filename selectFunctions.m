%LIVE
function [dmos_new,iqa_pred]=iqatest_live(MetricNum)
load('..\Datasets\LIVE\refnames_all.mat');
%refnames_all{i} is the name of the reference image for image i whose dmos value is given by dmos(i).
load('..\Datasets\LIVE\dmos.mat');%dmos and orgs. orgs(i)==0 for distorted images.
%dmos=[dmos_jpeg2000(1:227) dmos_jpeg(1:233) white_noise(1:174) gaussian_blur(1:174) fast_fading(1:174)]

pathr='..\Datasets\LIVE\refimgs\';
pathd=cell(1,5);
pathd(1)={'..\Datasets\LIVE\jp2k\'};
pathd(2)={'..\Datasets\LIVE\jpeg\'};
pathd(3)={'..\Datasets\LIVE\wn\'};
pathd(4)={'..\Datasets\LIVE\gblur\'};
pathd(5)={'..\Datasets\LIVE\fastfading\'};
load('..\Datasets\LIVE\dmos_realigned.mat');%dmos and orgs. orgs(i)==0 for distorted images.
                                            %dmos=[dmos_jpeg2000(1:227) dmos_jpeg(1:233) white_noise(1:174) gaussian_blur(1:174) fast_fading(1:174)]
txtpath='..\Datasets\data/LIVE-';
txtpath=strcat(txtpath,MetricName(MetricNum));
txtpath=strcat(txtpath,'.txt');
txtpath=char(txtpath);

iqa_pred=[];
imgn=[227,233,174,174,174];
delta=[0,227,460,634,808];
for j=1:5
    simgn=imgn(j);
    pad=char(pathd(j));
    delt=delta(j);
  for i=1:simgn
    refname=strcat(pathr,refnames_all(i+delt));
    disname=strcat(pad,'img');
    disname=strcat(disname,num2str(i));
    disname=strcat(disname,'.bmp');
    refimg=imread(char(refname));
    disimg=imread(disname);
    iqaij=metric(refimg,disimg,MetricNum);
    iqa_pred=[iqa_pred;iqaij];
  end
end
%writetxt(iqa,'d:/database/qaclive.txt');
%writetxt(iqa,'e:/IQA/database/data/LIVE-FSIM.txt');
% [CC,SROCC,RMSE]=performance_eval(test_quality,test_mos,isShow);
writetxt(iqa,txtpath);
end


%}
function []=iqatest_csiq(MetricNum)
%CSIQ
%���ṩ�����ֽ����CONSTRASTֻ���ĸ����ݣ�
%
pathr='D:\Study Files\Scientific Research\IQA\database\CSIQ\src_imgs\';
pathd=cell(1,5);
pathd(1)={'D:\Study Files\Scientific Research\IQA\database\CSIQ\dst_imgs\awgn\'};
pathd(5)={'D:\Study Files\Scientific Research\IQA\database\CSIQ\dst_imgs\blur\'};
%pathd(3)={'E:\IQA\database\CSIQ\dst_imgs\contrast\'};
pathd(4)={'D:\Study Files\Scientific Research\IQA\database\CSIQ\dst_imgs\fnoise\'};
pathd(2)={'D:\Study Files\Scientific Research\IQA\database\CSIQ\dst_imgs\jpeg\'};
pathd(3)={'D:\Study Files\Scientific Research\IQA\database\CSIQ\dst_imgs\jpeg2000\'};
filetype='*.png';
iqa=[];
rimg_path_list = dir(strcat(pathr,filetype));

txtpath='D:\Study Files\Scientific Research\IQA\database/data/CSIQ-';
txtpath=strcat(txtpath,MetricName(MetricNum));
txtpath=strcat(txtpath,'.txt');
txtpath=char(txtpath);

for j=1:5
    pad=char(pathd(j));
    dimg_path_list = dir(strcat(pad,filetype));
  for i=1:150
    refname=strcat(pathr,rimg_path_list(floor(i/5.0+0.8)).name);
    disname=dimg_path_list(i).name;
    disname=strcat(pad,disname);
    refimg=imread(char(refname));
    disimg=imread(disname);
    %[iqaij, quality_map] = GMSD(refimg,disimg);
    iqaij=metric(refimg,disimg,MetricNum);
    iqa=[iqa;iqaij];
  end
end
%writetxt(iqa,'d:/database/gmsdcsiq.txt');
writetxt(iqa,txtpath);
end
%} 


%TID2008
%
function []=iqatest_tid2008(MetricNum)
pathr='e:\Study Files\Scientific Research/IQA/database/TID2008/reference_images/I';
%pathd='e:/IQA/database/TID2008/distorted_images/I';
file_path='e:\Study Files\Scientific Research/IQA/database/TID2008/distorted_images/';
filetype='*.bmp'; 
txt_path_list = dir(strcat(file_path,filetype));%��ȡ���ļ����������ض���ʽ��ͼ��

txtpath='e:\Study Files\Scientific Research/IQA/database/data/TID2008-';
txtpath=strcat(txtpath,MetricName(MetricNum));
txtpath=strcat(txtpath,'.txt');
txtpath=char(txtpath);

iqa=[];
for i=1:25
    refname=strcat(pathr,num2name(i));
    refname=strcat(refname,'.bmp');
    refimg=imread(refname);
    for j=1:68
        txt_name = txt_path_list(68*i-68+j).name;% ͼ����
        disimg = imread(strcat(file_path,txt_name));
        iqaij=metric(refimg,disimg,MetricNum);
       % [FSIM, iqaij] = FeatureSIM(refimg,disimg);
        iqa=[iqa;iqaij];     
    end
end
%writetxt(iqa,'d:/database/fsimtid2008.txt');
writetxt(iqa,txtpath);
end
%}

%MDIQ
%
function []=iqatest_mdiq(MetricNum)
pathr='D:\database\LIVEmultidistortiondatabase\To_Release\ref\';
pathd1='D:\database\LIVEmultidistortiondatabase\To_Release\Part 1\blurjpeg\';
pathd2='D:\database\LIVEmultidistortiondatabase\To_Release\Part 2\blurnoise\';
filetype='*.bmp'; 
rimg_path_list = dir(strcat(pathr,filetype));
dimg1_path_list = dir(strcat(pathd1,filetype));
dimg2_path_list = dir(strcat(pathd2,filetype));

txtpath='e:/IQA/database/data/MDIQ-';
txtpath=strcat(txtpath,MetricName(MetricNum));
txtpath=strcat(txtpath,'.txt');
txtpath=char(txtpath);

iqa1=[];
iqa2=[];
for i=1:15
    refname=rimg_path_list(i).name;
    refimg = imread(strcat(pathr,refname));
    for j=1:15
        disname1=dimg1_path_list(16*i-15+j).name;
        disname2=dimg2_path_list(16*i-15+j).name;
        disimg=imread(strcat(pathd1,disname1));
        %[iqaij, quality_map] = GMSD(refimg,disimg);
        iqaij=metric(refimg,disimg,MetricNum);
        iqa1=[iqa1;iqaij];
        disimg=imread(strcat(pathd2,disname2));
        iqaij=metric(refimg,disimg,MetricNum);
        %[iqaij, quality_map] = GMSD(refimg,disimg);
        iqa2=[iqa2;iqaij];
    end
end
iqa=[iqa1;iqa2];
%writetxt(iqa,'d:/database/gmsdmdiq.txt');
writetxt(iqa,txtpath);
end
%}

        
%TID2013
%
function []=iqatest_tid2013(MetricNum)
pathr='e:\Study Files\Scientific Research/IQA/database/TID2013/reference_images/I';
%pathd='e:/IQA/database/TID2013/distorted_images/I';
file_path='e:\Study Files\Scientific Research/IQA/database/TID2013/distorted_images/';;
filetype='*.bmp'; 
txt_path_list = dir(strcat(file_path,filetype));%��ȡ���ļ����������ض���ʽ��ͼ��

txtpath='e:/IQA/database/data/TID2013-';
txtpath=strcat(txtpath,MetricName(MetricNum));
txtpath=strcat(txtpath,'.txt');
txtpath=char(txtpath);

iqa=[];
for i=1:25
    refname=strcat(pathr,num2name(i));
    refname=strcat(refname,'.bmp');
    refimg=imread(refname);
    for j=1:120
        txt_name = txt_path_list(120*i-120+j).name;% ͼ����
        disimg = imread(strcat(file_path,txt_name));
        %[iqaij, quality_map] = GMSD(refimg,disimg);
        iqaij=metric(refimg,disimg,MetricNum);
        iqa=[iqa;iqaij];     
    end
end
%writetxt(iqa,'d:/database/gmsdtid2013.txt');
writetxt(iqa,txtpath);
end
%}


%CID2013
%
function []=iqatest_cid2013(MetricNum)
pathd=cell(1,6);
pathd(1)={'E:\IQA\database\CID2013\IS11\'};
pathd(2)={'E:\IQA\database\CID2013\IS22\'};
pathd(3)={'E:\IQA\database\CID2013\IS33\'};
pathd(4)={'E:\IQA\database\CID2013\IS44\'};
pathd(5)={'E:\IQA\database\CID2013\IS55\'};
pathd(6)={'E:\IQA\database\CID2013\IS66\'};
filetype='*.jpg';

txtpath='e:/IQA/database/data/CID2013-';
txtpath=strcat(txtpath,MetricName(MetricNum));
txtpath=strcat(txtpath,'.txt');
txtpath=char(txtpath);

iqa=[];

for i=1:6
    pad=char(pathd(i));
    dimg_path_list = dir(strcat(pad,filetype));
    img_num = length(dimg_path_list),
    for j=1:img_num
        disname=dimg_path_list(j).name;
        disname=strcat(pad,disname);
        disimg=imread(disname);
        refimg=disimg;
        iqaij=metric(refimg,disimg,MetricNum);
        iqa=[iqa;iqaij];
    end
end
%writetxt(iqa,'d:/database/qaccid.txt');
writetxt(iqa,txtpath);
end
%}


%MDID
%
function []=iqatest_mdid(MetricNum)
pathr='d:/database/MDID/reference_images/img';
%pathd='d:/database/MDID/distortion_images/img';
file_path='d:/database/MDID/distortion_images/';
filetype='*.bmp'; 
txt_path_list = dir(strcat(file_path,filetype));%��ȡ���ļ����������ض���ʽ��ͼ��

txtpath='e:/IQA/database/data/MDID-';
txtpath=strcat(txtpath,MetricName(MetricNum));
txtpath=strcat(txtpath,'.txt');
txtpath=char(txtpath);

iqa=[];
for i=1:20
    refname=strcat(pathr,num2name(i));
    refname=strcat(refname,'.bmp');
    refimg=imread(refname);
    for j=1:80
        txt_name = txt_path_list(80*i-80+j).name;% ͼ����     
        strcat(file_path,txt_name),
        disimg = imread(strcat(file_path,txt_name));
        %[FSIM, iqaij] = FeatureSIM(refimg,disimg);
        iqaij=metric(refimg,disimg,MetricNum);
        iqa=[iqa;iqaij];     
    end
end
%writetxt(iqa,'d:/database/gmsdmdid.txt');
writetxt(iqa,txtpath);
end
%}



         
    
%%
function id=num2name(porder);
id='00';
if porder>9
    id=num2str(porder);
else
    id(2)=num2str(porder);
end
end
%%
function iqares=metric(refimage,disimage,metricnumber);
    switch metricnumber
        case 1
            iqares=PSNR(refimage,disimage);
        case 2
            [iqares s_map]=ssim_index(refimage,disimage);
        case 3
            iqares= msssim(refimage,disimage);
        case 4
            iqares= vifvec(refimage,disimage);
        case 5
            iqares= vsnr(refimage,disimage);
        case 6
            [I Map] = MAD_index_april_2010(refimage,disimage);
            iqares=I.MAD;
        case 7
            [iqares,iwmse,iwpsnr]= iwssim(refimage,disimage);
        case 8
            [FSIM, iqares] = FeatureSIM(refimage,disimage);
        case 9
            [iqares, q_map] = GMSD(refimage,disimage);
        case 10
            iqares=Setr(refimage,disimage);    
        case 11
            iqares=SIQA(refimage,disimage);
        case 20
            [iqares probs]= biqi(rgb2gray(disimage));
        case 21
            iqares  = brisquescore(disimage);
        case 22
            iqares = divine(disimage);
        case 23
            features = bliinds2_feature_extraction(disimage);
            iqares = bliinds_prediction(features) ;
        case 24
            im =  rgb2gray(disimage);
            feature_fun = @compute_DOG;
            iqares = QAC(im, cluster_center, feature_fun);
    end
end

        
        
    
