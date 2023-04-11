function E = com_norm(pfilt,n,w_s)
%Compute the norm of shearlets for each scale and direction. 

%Input 
%pfilt : name of laplacian pyramid filter.
%n : size of input image (e.g : 256 X 256, 512 X 512...)
%w_s : cell array of directional shearing filters

%Output 
%E : l^2 norm of shearlets across scales and directions


    F = ones(n(1),n(2));
    X = fftshift(ifft2(F)) * sqrt(prod(size(F)));
    C=shear_trans(X,pfilt,w_s);
    
    % Compute norm of shearlets (exact)
    for s=1:length(C)
        for w=1:size(C{s},3)
            A = C{s}(:,:,w);
            E(s,w) = sqrt(sum(sum(A.*conj(A))) / prod(size(A)));
        end
    end