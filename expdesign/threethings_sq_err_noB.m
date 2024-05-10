function [err] = threethings_sq_err_noB(data,params,numeric_params,x0,logging)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
x0(2)=params(10);
model_data=threethings_solnf_new(params,numeric_params,x0);
%err=sum((model_data-data).^2,'all');
err=sum((model_data(1,:)-data(1,:)).^2,"all")+sum((model_data(3,:)-data(3,:)).^2,"all");

if logging
    fprintf(['params=',repmat('%.3f,',size(params)),'sum_sq_error=%.6f\n'],params,err);
end
end