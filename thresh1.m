function [coeff maxi] = thresh1(Ct,lambda,option,E,sc,opt)

temp = [];
if option == 2    
    % Apply thresholding
    for s = 1:length(Ct)
          for w = 1:size(Ct{s},3)
              Ct{s}(:,:,w) = Ct{s}(:,:,w).* (abs(Ct{s}(:,:,w)) > sc(s)*(lambda)*E(s,w));
              % apply hard thresholding on each shearlet coefficient with threshold 
              % parameter sc(s)*lambda for each scale s. 
              if opt == 1
                  wedge = max(max(abs(Ct{s}(:,:,w)/E(s,w))));
                  temp = [temp; wedge(:)];
              end
          end
    end
else
    
for j = 1:size(Ct,3)-1
    Ct(:,:,j) = Ct(:,:,j).*(abs(Ct(:,:,j))>lambda);
    % apply hard thresholding on wavelet coeffcients with threshold parameter lambda. 
end
    if opt == 1
        tmp = Ct(:,:,1:size(Ct,3)-1);
        temp = abs(tmp(:));
    end
end
coeff = Ct;
if opt == 1
    maxi = max(temp);
else
    maxi = 0;
end