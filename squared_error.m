function [err] = squared_error(noisy_data,T,params,t_skip,x_skip,ic)
%Squared error between data and model
% noisy_data: the experimental data with observation noise (1D or 2D)
% T: end time of the noisy data
% params: model parameters
% t_skip: use only data at some of the time steps (set to 1 to use all)
% t_skip: use only data at some of the spatial gridpts (set to 1 to use all)
% ic: initial condition (optional)
if ndims(noisy_data)==2
    % this is 1D data
    if exist('ic','var')
        [~,model_data,~] = woundhealing_1d(params,T,0,ic);
    else
        [~,model_data,~] = woundhealing_1d(params,T,0);
    end
    model_data=model_data(1:t_skip:end,1:x_skip:end);
    noisy_data=noisy_data(1:t_skip:end,1:x_skip:end);
else
    % this is 2D data
    if exist('ic','var')
        [~,model_data,~] = woundhealing_2d(params,T,0,ic);
    else
        [~,model_data,~] = woundhealing_2d(params,T,0);
    end
    model_data=model_data(1:t_skip:end,1:x_skip:end,1:x_skip:end);
    noisy_data=noisy_data(1:t_skip:end,1:x_skip:end,1:x_skip:end);
end
data_diff=noisy_data-model_data;
err=sum(data_diff.^2,'all');
%l=sum(log(normpdf(data_diff,0,sigma2)),'all');
fprintf(['params=',repmat('%.3f,',size(params)),'sum_sq_error=%.6f\n'],params,err);
end