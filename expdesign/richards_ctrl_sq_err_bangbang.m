function err = richards_ctrl_sq_err_bangbang(data,params,numeric_params,x0,logging)
% numeric params: [T, nt, urmax, tau0r, taur, udmax, tau0d, taud, ukmax, tau0k, tauk]
T=numeric_params(1);
nt=numeric_params(2);
t=linspace(0,T,nt);
control_params=numeric_params(3:end);
urmax=control_params(1);
tau0r=control_params(2);
taur=control_params(3);
tau1r=tau0r+taur;
udmax=control_params(4);
tau0d=control_params(5);
taud=control_params(6);
tau1d=tau0d+taud;
ukmax=control_params(7);
tau0k=control_params(8);
tauk=control_params(9);
tau1k=tau0k+tauk;
model_data=sol_richards_bangbang2(t,params,x0,urmax, tau0r, tau1r, udmax, tau0d, tau1d, ukmax, tau0k, tau1k);
err=sum((model_data-data).^2,'all');

if logging
    fprintf(['params=',repmat('%.3f,',size(params)),'sum_sq_error=%.6f\n'],params,err);
end
end