function [l,sigma] = log_likelihood(err,N)
%Likelihood function assuming Gaussian noise, with sigma2 free
% err: sum of squared error
% N: number of data points
sigma2=err/N;
sigma=sqrt(sigma2);
l = -N*log(sqrt(2*pi*sigma2)) - (1/(2*sigma2))*err;
end

