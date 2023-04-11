%
% This is the main demo for images Blob, Swoosh and Cameraman for the 
% following paper:
% 
%  "A hybrid denoising algorithm based on shearlet transform method and Yaroslavskys filter"
% 
%   Author(s): Reza Abazari, Mehrdad Lakestani
%   e-mail(s): abazari.r@tabrizu.ac.ir, abazari.r@gmail.com
%   Url: https://sites.google.com/site/rizaabazari/home
%
% Written by Reza Abazari on June 5, 2017. 
% Copyright 2010 by Reza Abazari. All Right Reserved.

mex YF_yann.c

%% Initialization
clc;
close all
clear all
format shortG
Table=zeros(12,9);

for i=1:3
    % load ture image
    if i==1
        ima = mean(double(imread('blob.png')),3);
    elseif i==2
        ima = mean(double(imread('swoosh.png')),3);
    else
        ima = mean(double(imread('cameraman.png')),3);
    end
    
% sigma(s) to build noisy image
Sigma=[5, 20, 50, 100]; 
figure
for j=1: size(Sigma,2)
    sigma=Sigma(j);
% noisy image
noisy = ima + sigma * randn(size(ima));
%noisy=ima_nse(j);
Table(j*3-2+i-1,1)   = mean( ( noisy(:)- ima(:) ).^2);
Table(j*3-2+i-1,2) = psnr(noisy, ima);
[mssim_noisy, ssim_map_noisy] = ssim(noisy, ima);
Table(j*3-2+i-1,3) = mssim_noisy;
%% Parameters initialization
param.search_width=15;% half width of the moving average
param.patch_width=5; %patch width
param.h_Yaro=sqrt(10*(sigma)^2);%
param.h_YF_shearlet=sqrt(0.2*sigma^2);

%% Compute the output images of shearlet transform and shearlet_YF filter
[ima_fil_YF_shearlet,time_YF_shearlet,ima_fil_shearlet,time_shearlet]=YF_shearlet_denoise(...
    noisy,param.h_YF_shearlet,param.search_width, sigma); 

%shearlet(j)=ima_fil_shearlet;

Table(j*3-2+i-1,4)   = mean( ( ima_fil_shearlet(:)- ima(:) ).^2);
Table(j*3-2+i-1,5) = psnr(ima_fil_shearlet, ima);
[mssim_noisy, ssim_map_noisy] = ssim(ima_fil_shearlet, ima);
Table(j*3-2+i-1,6) = mssim_noisy;

%YF_shearlet(j)=ima_fil_YF_shearlet;

Table(j*3-2+i-1,7)   = mean( ( ima_fil_YF_shearlet(:)- ima(:) ).^2);
Table(j*3-2+i-1,8) = psnr(ima_fil_YF_shearlet, ima);
[mssim_noisy, ssim_map_noisy] = ssim(ima_fil_YF_shearlet, ima);
Table(j*3-2+i-1,9) = mssim_noisy;
%% Display result

if j>1
    subplot(3,3,(j-1)*3-2); imagesc(noisy);               colormap(gray);
    axis off; 
    title(['\fontsize{6}','Noisy, \sigma=',num2str(sigma),',MSE=',num2str(Table(j*3-2+i-1,1)),',PSNR=',num2str(Table(j*3-2+i-1,2)),',SSIM=',num2str(Table(j*3-2+i-1,3))]);
    subplot(3,3,(j-1)*3-1); imagesc(ima_fil_shearlet);    colormap(gray);
    axis off;
    title(['\fontsize{6}','Shearlet, MSE=',num2str(Table(j*3-2+i-1,4)),',PSNR=',num2str(Table(j*3-2+i-1,5)),',SSIM=',num2str(Table(j*3-2+i-1,6))]);
    subplot(3,3,(j-1)*3);   imagesc(ima_fil_YF_shearlet); colormap(gray);
    axis off;
    title(['\fontsize{6}','YF_Shearlet, MSE=',num2str(Table(j*3-2+i-1,7)),',PSNR=',num2str(Table(j*3-2+i-1,8)),',SSIM=',num2str(Table(j*3-2+i-1,9))]);
end


% ploting true and noisy image with PSNR, MSE and SSIM indexes

end
end
disp('-------------------------------------------------------------------------------------------------------------------------------')
disp('                       Noisy                             Shearlet                             Shearlet_YF                      ')
disp('        -----------------------------           ---------------------------          ------------------------------------------')
disp('        MSE         PSNR         SSIM           MSE        PSNR        SSIM          MSE         PSNR         SSIM             ')
disp('-------------------------------------------------------------------------------------------------------------------------------')
Table

figure
plot(Sigma, Table(1:3:end,2),Sigma,Table(1:3:end,5),'--',Sigma,Table(1:3:end,8),':','LineWidth',2)
legend({'Noisy','Shearlet','Shearlet+YF'},'FontSize',16);
title('Blob', 'FontSize',16);xlabel('\sigma', 'FontSize',16); ylabel('PSNR', 'FontSize',16);
axis([5 100 5 50]);
set(gca, 'FontSize',16);
figure
plot(Sigma, Table(2:3:end,2),Sigma,Table(2:3:end,5),'--',Sigma,Table(2:3:end,8),':','LineWidth',2)
legend({'Noisy','Shearlet','Shearlet+YF'},'FontSize',16);
title('Swoosh', 'FontSize',16);xlabel('\sigma', 'FontSize',16); ylabel('PSNR', 'FontSize',16);
axis([5 100 5 50]);
set(gca, 'FontSize',16);
figure
plot(Sigma, Table(3:3:end,2),Sigma,Table(3:3:end,5),'--',Sigma,Table(3:3:end,8),':','LineWidth',2)
legend({'Noisy','Shearlet','Shearlet+YF'},'FontSize',16);
title('Cameraman', 'FontSize',16);xlabel('\sigma', 'FontSize',16); ylabel('PSNR', 'FontSize',16);
axis([5 100 5 50]);
set(gca, 'FontSize',16);