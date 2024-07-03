function r_conf_range = logistic_bd_uk_rrange(u_K0,tau0,tau)
%Find width of confidence interval of r
% logistic model with birth/death and u_K control

%% generate data
seed=0;
rng(seed);
C0=100;
nt=101;
T=25;
t=linspace(0,T,nt);
%params=[0.45,0.15,1,3900];
%params=[0.225,0,8,2381];
params=[0.3,0.0,1,2600];
%u_K0=200;
%tau0=5;
%tau=15;
u_d=@(t)0;
u_r=@(t)0;
u_K=@(t) ((t>tau0)&(t<(tau0+tau)))*u_K0;
clean_data=sol_richards_control(t,params,C0,u_d,u_K,u_r);
fixed=[0,0,1,0]; %% change for logistic/richards
try
%clean_data=sol_richards_bangbang2(t,params,C0,0,0,0,0,0,0,u_K0,tau0,tau0+tau);
sigma=20;
noisy_data=clean_data+randn(size(clean_data))*sigma;

%% MLE
fixed_param_val=params;
opt_initial=fixed_param_val;
opt_initial(2)=0.001; % so that fmincon will not shift initial to be strictly within the bounds
%numeric_params=[T,nt,0,0,0,0,0,0,u_K0,tau0,tau0+tau];
numeric_params={T,nt,u_d,u_K,u_r};
lb_opt=[0,0,0,0];
ub_opt=[5,5,9,50000];
opt.lb=lb_opt;
opt.ub=ub_opt;
opt.logging=false;
opt.alg=1;
%[mle,mle_sigma,max_l] = optimize_likelihood_general(@richards_ctrl_sq_err_bangbang,opt_initial,fixed,noisy_data,numeric_params,C0,opt);
[mle,mle_sigma,max_l] = optimize_likelihood_general(@richards_ctrl_sq_err,opt_initial,fixed,noisy_data,numeric_params,C0,opt);
optimal_param_vals=fixed_param_val';
optimal_param_vals(fixed==0)=mle;

%% search for confidence interval edge

%r_eff=params(1)-params(2);
opt.alg=1; % using 1 for local search, 2 global
plr=@(r) plr_helper(r,params,fixed,noisy_data,numeric_params,C0,opt,max_l) + 1.92;
% use 0.001 and 5 as search range for the bound of conf interval of r
if plr(0.001)>0
    % somehow r_eff is within the confidence interval
    r_lower=0;
else
    bd_rlow=[0.001,optimal_param_vals(1)];
    [r_lower,~,~,~] = fzero(plr,bd_rlow);
end
if plr(5)>0
    % we didn't find an upper bound for the confidence interval of r
    r_upper=Inf;
else
    bd_rhigh=[optimal_param_vals(1),5];
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

function pl = plr_helper(r,params,fixed,noisy_data,numeric_params,C0,opt,max_l)
    %[~,~,max_l2]=optimize_likelihood_general(@richards_ctrl_sq_err_bangbang,[r,max(params(2),0.001),params(3),params(4)],[1,fixed(2:end)],noisy_data,numeric_params,C0,opt);
    [~,~,max_l2]=optimize_likelihood_general(@richards_ctrl_sq_err,[r,max(params(2),0.001),params(3),params(4)],[1,fixed(2:end)],noisy_data,numeric_params,C0,opt);
    pl=max_l2-max_l;
end

