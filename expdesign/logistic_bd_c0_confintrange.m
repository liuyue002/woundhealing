function [r_conf_range] = logistic_bd_c0_confintrange(C0,params,interest_param,fixed,numeric_params,search_bd)
%Find width of confidence interval of a certain parameter
% logistic/richards model with birth/death and u_K control

%% params (see logistic_rrange_vs_initial.m)
% r=0.3;
% d=0;
% g=1;
% k=2600;
% true_params=[r,d,g,k];
true_params = params;
T=numeric_params(1);
nt=numeric_params(2);

tt=linspace(0,T,nt);
clean_data = sol_richards(tt,true_params,C0);
rng(1); % reproducibility
sigma=400;
noisy_data = clean_data + normrnd(0,sigma,size(clean_data));

%fixed=[0,1,1,0];
fixed_param_val=params;
opt.lb=[0.01, 0.01, 0.1,  500];
opt.ub=[5.00, 1.00, 9.0,10000];
opt.alg=1;
opt.logging=false;

%% MLE
[mle,mle_sigma,max_l] = optimize_likelihood_general(@richards_sq_err,fixed_param_val,fixed,noisy_data,numeric_params,C0,opt);
optimal_param_vals=fixed_param_val';
optimal_param_vals(fixed==0)=mle;
mle_interest=optimal_param_vals(interest_param);
%% search for confidence interval edge

opt.alg=1; % using 1 for local search, 2 global
plr=@(r) plr_helper(r,params,interest_param,fixed,noisy_data,numeric_params,C0,opt,max_l) + 1.92;
search_lb=search_bd(1);
search_ub=search_bd(2);
if mle_interest>search_lb && mle_interest < search_ub
    if plr(search_lb)>0
        % somehow 0.01 is within the confidence interval
        r_lower=0;
        fprintf('lower bound r=%g reached\n',search_lb);
    else
        [r_lower,~,~,~] = fzero(plr,[search_lb, mle_interest]);
    end
    if plr(search_ub)>0
        r_upper=Inf;
        fprintf('upper bound r=%g reached\n',search_ub);
    else
        [r_upper,~,~,~] = fzero(plr,[mle_interest,search_ub]);
    end
else
    fprintf('The MLE for r is not between %g and %g\n',search_lb,search_ub);
    r_lower=0;
    r_upper=Inf;
end
r_conf_range=r_upper-r_lower;
fprintf('C0=%g, Conf Int: [%.4f,%.4f], width=%.4f\n',C0,r_lower,r_upper,r_conf_range);


end

function pl = plr_helper(r,params,interest_param,fixed,noisy_data,numeric_params,C0,opt,max_l)
fixed(interest_param)=1;
params(interest_param)=r;
[~,~,max_l2]=optimize_likelihood_general(@richards_sq_err,params,fixed,noisy_data,numeric_params,C0,opt);
pl=max_l2-max_l;
end