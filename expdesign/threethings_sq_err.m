function [err] = threethings_sq_err(data,params,numeric_params,x0,logging)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
model_data=threethings_solnf(params,numeric_params,x0);
err=sum((model_data-data).^2,'all');

if logging
    fprintf(['params=',repmat('%.3f,',size(params)),'sum_sq_error=%.6f\n'],params,err);
end
end