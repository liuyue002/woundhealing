function [err] = squared_error(noisy_data,params,numeric_params,t_skip,x_skip,threshold,ic,xs,noiseweight)
%Squared error between data and model
% noisy_data: the experimental data with observation noise (1D or 2D)
% T: end time of the noisy data
% params: model parameters
% t_skip: use only data at some of the time steps (set to 1 to use all)
% t_skip: use only data at some of the spatial gridpts (set to 1 to use all)
% threshold: (removed feature, not used)
% ic: initial condition, set to NaN for using default
% noiseweight: for 1D only, weight for the contribution to the residual 
% from each spaitial point (leave as NaN for uniform weight), should be a row vector
if isnan(noiseweight)
    noiseweight=1;
end
if ndims(noisy_data)==2
    % 1 spatial dimension
    [~,model_data,~,~] = woundhealing_1d(params,numeric_params,0,ic,xs);
    model_data=model_data(1:t_skip:end,1:x_skip:end);
    noisy_data=noisy_data(1:t_skip:end,1:x_skip:end);
else
    % 2 spatial dimension
    [~,model_data,~] = woundhealing_2d(params,numeric_params,0,ic);
    model_data=model_data(1:t_skip:end,1:x_skip:end,1:x_skip:end);
    noisy_data=noisy_data(1:t_skip:end,1:x_skip:end,1:x_skip:end);
end
data_diff=noisy_data-model_data;
data_diff2=data_diff.^2;
if ndims(noisy_data)==2
    data_diff2=data_diff2.*noiseweight;
end
err=sum(data_diff2,'all');

fprintf(['params=',repmat('%.3f,',size(params)),'sum_sq_error=%.6f\n'],params,err);
end