function [Im_YF_Shearlet,time_YF_shearlet,Im_Shearlet,time_shearlet] = YF_shearlet_denoise(Im_noisy,h,search_width,sigma)
% This function computes the shearlet transform and YF_shearlet transform
% of input noisy image.
% Inputs:  Im_noisy          - noisy image
%          h                 - search width of YF_shearlet
%          search_width      - search width of Yaroslavsky filter
%          sigma             - std of noisy image
% Outputs: Im_Shearlet       - output image of shearlet transform method
%          time_shearlet     - elapsed time of shearlet transform
%          Im_YF_Shearlet    - output image of YF_shearlet transform method
%          time_YF_shearlet  - elapsed time of YF_shearlet transform
%
% Written by Reza Abazari on June 5, 2017. 
% Copyright 2010 by Reza Abazari. All Right Reserved.

half_search_widtdh=ceil(search_width/2);

[s_x,s_y]=size(Im_noisy);

%% Shearlet part

% shear =shearing_filters_Myer([30 30 30 30],[2 2 3 3],512);
tic
shear =shearing_filters_Myer([30 30 36 36],[3 3 4 4],s_x);

E = com_norm('maxflat',size(Im_noisy),shear);

Im_Shearlet = shear_denoise(Im_noisy,sigma,shear,E,[2.6 2.6 2.6 2.6 3.8]);
time_shearlet=toc;

%% YF_Shearlet part
tic
Im_YF_Shearlet = YF_yann(Im_noisy,Im_Shearlet,half_search_widtdh,h);
time_YF_shearlet=toc;
%  YF_fast_precompute(Im_noisy,Im_ori,half_search_widtdh,h,1);
