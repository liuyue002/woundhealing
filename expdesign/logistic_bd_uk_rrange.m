function r_conf_range = logistic_bd_uk_rrange(u_K0,tau0,tau)
%Find width of confidence interval of r
% logistic model with birth/death and u_K control

%% generate data
seed=0;
rng(seed);
C0=100;
nt=100;
T=25;
t=linspace(0,T,nt);
%params=[0.45,0.15,1,3900];
params=[0.225,0,8,2381];
%u_K0=200;
%tau0=5;
%tau=15;
u_d=@(t)0;
u_K=@(t) ((t>tau0)&(t<(tau0+tau)))*u_K0;
%clean_data=sol_richards_control(t,params,C0,u_d,u_K);

try
clean_data=sol_richards_bangbang2(t,params,C0,0,0,0,0,0,0,u_K0,tau0,tau0+tau);
sigma=20;
noisy_data=clean_data+randn(size(clean_data))*sigma;

%% MLE
fixed=[0,0,0,0];
fixed_param_val=params;
opt_initial=fixed_param_val;
opt_initial(2)=0.001; % so that fmincon will not shift initial to be strictly within the bounds
numeric_params=[T,nt,0,0,0,0,0,0,u_K0,tau0,tau0+tau];
lb_opt=[0,0,0,0];
ub_opt=[5,5,2,50000];
opt.lb=lb_opt;
opt.ub=ub_opt;
opt.logging=false;
opt.alg=2;
[mle,mle_sigma,max_l] = optimize_likelihood_general(@richards_ctrl_sq_err_bangbang,opt_initial,fixed,noisy_data,numeric_params,C0,opt);
optimal_param_vals=fixed_param_val';
optimal_param_vals(fixed==0)=mle;

%% search for confidence interval edge

r_eff=params(1)-params(2);
opt.alg=1; % using 1 for local search, 2 global
plr=@(r) plr_helper(r,params,noisy_data,numeric_params,C0,opt,max_l) + 1.92;
if plr(r_eff-0.05)>0
    % somehow r_eff is within the confidence interval
    r_lower=0;
else
    bd_rlow=[r_eff-0.05,optimal_param_vals(1)];
    [r_lower,~,~,~] = fzero(plr,bd_rlow);
end
if plr(ub_opt(1))>0
    % we didn't find an upper bound for the confidence interval of r
    r_upper=Inf;
else
    bd_rhigh=[optimal_param_vals(1),ub_opt(1)];
    [r_upper,~,~,~] = fzero(plr,bd_rhigh);
end
r_conf_range=r_upper-r_lower;
fprintf('u_K0=%g,tau0=%g,tau=%g, r Conf Int: [%.4f,%.4f], width=%.4f\n',u_K0,tau0,tau,r_lower,r_upper,r_conf_range);
catch exception
    disp(getReport(exception));
    r_conf_range=nan;
    fprintf('u_K0=%g,tau0=%g,tau=%g, had error\n',u_K0,tau0,tau);
end

end

function pl = plr_helper(r,params,noisy_data,numeric_params,C0,opt,max_l)
    [~,~,max_l2]=optimize_likelihood_general(@richards_ctrl_sq_err_bangbang,[r,max(params(2),0.001),params(3),params(4)],[1,0,0,0],noisy_data,numeric_params,C0,opt);
    pl=max_l2-max_l;
end

function sol = sol_richards_bangbang2(t,params,C0,urmax, tau0r, tau1r, udmax, tau0d, tau1d, ukmax, tau0k, tau1k)
T=t(end);
[tt,sol] = sol_richards_bangbang(T,params,true,[urmax, tau0r, tau1r, udmax, tau0d, tau1d, ukmax, tau0k, tau1k],C0);
sol=interp1(tt,sol,t);
end

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