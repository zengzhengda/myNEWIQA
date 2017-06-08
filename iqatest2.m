clear all,clc;
MetricName=cell(1,30);
MetricName(1)={'PSNR'};MetricName(2)={'SSIM'};MetricName(3)={'MSSIM'};
MetricName(4)={'VIF'};MetricName(5)={'VSNR'};MetricName(6)={'MAD'};
MetricName(7)={'IWSSIM'};MetricName(8)={'FSIM'};MetricName(9)={'GMSD'};
MetricName(10)={'Setr'};MetricName(11)={'SIQA'};MetricName(12)={'Sparse_SSIM'};
MetricName(20)={'BIQI'};MetricName(21)={'BRISQUE'};MetricName(22)={'DIVINE'};
MetricName(23)={'BLIINDS'};MetricName(24)={'QAC'};

DataBase=[1];    %1,LIVE;2,CSIQ;3,TID2008;4,MDIQ;5,TID2013;6,CID2013;7,MDID;
Metric=[12];%1,PSNR;2,SSIM;3,MSSIM;4,VIF;5,VSNR;6,MAD;7,IW-SSIM;8,FSIM;9,GMSD;   20,BIQI;21,BRISQUE;22,DIVINE;23,BLIINDS;24,QAC;
[iqa_sub,iqa_obj,CCs,SROCCs,RMSEs,betas]=selectFunctions(DataBase,Metric);
evaluate_str=[num2str(CCs) '|' num2str(SROCCs) ' ' num2str(RMSEs)]
