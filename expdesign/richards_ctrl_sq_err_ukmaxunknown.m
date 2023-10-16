function [err] = richards_ctrl_sq_err_ukmaxunknown(data,params,numeric_params,x0,logging)

% numeric params: [T, nt]
T=numeric_params{1};
nt=numeric_params{2};
u_d=numeric_params{3};
u_K=numeric_params{4};
t=linspace(0,T,nt);
model_data=sol_richards_control_ukmaxunknown(t,params,x0,u_d,u_K);
err=sum((model_data-data).^2,'all');

if logging
    fprintf(['params=',repmat('%.3f,',size(params)),'sum_sq_error=%.6f\n'],params,err);
end
end