function y = windowing(x,L,c)

N = length(x);
y = zeros(N,(L+2));
T = ceil(N/(L+2));
g = zeros(1,2*T);
for j = 1:2*T
    n = -1*T/2+j-1;
    g(j) = meyer_wind(c*n/T);
end

for j = 2:L+2
    index = 1;
    for k = -1*T/2:1.5*T-1
        in_sig=floor( mod(k+(j-1)*T,N))+1;
        y(in_sig,j) = g(index)*x(in_sig);
        index = index + 1;
    end
end

y(:,1) = abs(1 - sum(y,2));
        
    

