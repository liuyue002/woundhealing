function [err] = squared_error(noisy_data,T,params,t_skip,x_skip,threshold,ic,ispolar,xs)
%Squared error between data and model
% noisy_data: the experimental data with observation noise (1D or 2D)
% T: end time of the noisy data
% params: model parameters
% t_skip: use only data at some of the time steps (set to 1 to use all)
% t_skip: use only data at some of the spatial gridpts (set to 1 to use all)
% threshold: -1 for full density data, otherwise threshold the data
% ic: initial condition, set to NaN for using default
if ndims(noisy_data)==2
    % this is 1D data
    [~,model_data,~] = woundhealing_1d(params,T,0,ispolar,ic,xs);
else
    % this is 2D data
    if ~isnan(ic)
        [~,model_data,~] = woundhealing_2d(params,T,0,ic);
    else
        [~,model_data,~] = woundhealing_2d(params,T,0);
    end
end
model_data=model_data(1:t_skip:end,1:x_skip:end);
if threshold ~= -1
    if numel(threshold)==1
        % one step threshold
        model_data=double(model_data>threshold);
    elseif numel(threshold)==2
        model_data=(double(model_data>threshold(1))+double(model_data>threshold(2)))/2;
    else
        error('not supporting >2 threshold values\n');
    end
end
noisy_data=noisy_data(1:t_skip:end,1:x_skip:end);

data_diff=noisy_data-model_data;
err=sum(data_diff.^2,'all');
%l=sum(log(normpdf(data_diff,0,sigma2)),'all');
fprintf(['params=',repmat('%.3f,',size(params)),'sum_sq_error=%.6f\n'],params,err);
end