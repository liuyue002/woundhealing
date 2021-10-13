function [l] = log_likelihood_1d(noisy_data,Dc,r,sigma2)
%Likelihood function for 1D solution
[~,model_data,~] = woundhealing_1d(Dc,r,1,1,50,0,0,0);
data_diff=noisy_data-model_data;
l=sum(log(normpdf(data_diff,0,sigma2)),'all');
end

