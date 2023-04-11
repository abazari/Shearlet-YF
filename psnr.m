function p = PSNR(X,X_noisy)
%
% This function computes the PSNR of an noisy image with respect to its 
% original image.
%    INPUT 
%        X        - original image
%        X_noisy  - noisy image
%    OUPUT 
%        P - psnr
%
% Written by Reza Abazari on June 5, 2017. 
% Copyright 2010 by Reza Abazari. All Right Reserved.

D    = abs(X-X_noisy).^2;
mse  = sum(D(:))/numel(X);

peakValue = max(abs(X(:)));
if peakValue > 1
    peakValue = 255;
else
    peakValue = 1;
end

p = 10*log10(peakValue^2/mse);
end