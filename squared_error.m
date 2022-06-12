function [err] = squared_error(noisy_data,params,numeric_params,t_skip,x_skip,threshold,ic,xs,noiseweight)
%Squared error between data and model
% noisy_data: the experimental data with observation noise (1D or 2D)
% T: end time of the noisy data
% params: model parameters
% t_skip: use only data at some of the time steps (set to 1 to use all)
% t_skip: use only data at some of the spatial gridpts (set to 1 to use all)
% threshold: -1 for full density data, otherwise threshold the data
% ic: initial condition, set to NaN for using default
% noiseweight: weight for the contribution to the residual from each
%  spaitial point (leave as NaN for uniform weight), should be a row vector
%  for 1D 
if isnan(noiseweight)
    noiseweight=1;
end
if ~iscell(noisy_data)
    % simulation with only full density
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
    data_diff=noisy_data-model_data;
    if ndims(noisy_data)==2
        data_diff=data_diff.*noiseweight;
    else
        % todo
    end
    % there could be rounding here, matlab keep 16 digits precision
    % err can be 1e14 to 1e16
    % but it should be fine
    err=sum(data_diff.^2,'all');
else
    % simulation with cell cycle model
    if ndims(noisy_data{1})==2
        % 1 spatial dimension
        [~,model_cc1,model_cc2,~,~] = woundhealing_cellcycle_1d(params,numeric_params,0,ic,xs);
        model_cc1=model_cc1(1:t_skip:end,1:x_skip:end);
        model_cc2=model_cc2(1:t_skip:end,1:x_skip:end);
        noisy_cc1=noisy_data{1};
        noisy_cc1=noisy_cc1(1:t_skip:end,1:x_skip:end);
        noisy_cc2=noisy_data{2};
        noisy_cc2=noisy_cc2(1:t_skip:end,1:x_skip:end);
        % todo: implement noiseweight
    else
        % 2 spatial dimension
        % to do
    end
    % todo: thresholding for cell cycle model not implemented
    
    data_diff1 = noisy_cc1-model_cc1;
    data_diff2 = noisy_cc2-model_cc2;
    err=sum(data_diff1.^2 + data_diff2.^2,'all');
end

%l=sum(log(normpdf(data_diff,0,sigma2)),'all');
fprintf(['params=',repmat('%.3f,',size(params)),'sum_sq_error=%.6f\n'],params,err);
end