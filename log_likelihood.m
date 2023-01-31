function [l,sigma] = log_likelihood(err,N)
%Likelihood function assuming Gaussian noise, with sigma2 free
% err: sum of squared error (residual)
% N: number of data points
sigma2=err/N;
sigma=sqrt(sigma2);
if err==0
    l=Inf;
else
    %l = -N*log(sqrt(2*pi*sigma2)) - (1/(2*sigma2))*err;
    l = -(N/2)*(log(2*pi*sigma2)+1);
end
end

