function [l] = log_likelihood_1d(noisy_data,T,params,sigma2,t_skip,x_skip)
%Likelihood function for 1D solution
% noisy_data: the experimental data with observation noise
% T: end time of the noisy data
% params: model parameters
% sigma2: variance for the noise
% t_skip: use only data at some of the time steps (set to 1 to use all)
% t_skip: use only data at some of the spatial gridpts (set to 1 to use all)
[~,model_data,~] = woundhealing_1d(params,T,0);
model_data=model_data(1:t_skip:end,1:x_skip:end);
noisy_data=noisy_data(1:t_skip:end,1:x_skip:end);
data_diff=noisy_data-model_data;
l=sum(log(normpdf(data_diff,0,sigma2)),'all');
end

