% this file is a simplied version of pl_logistic_bd_uk.m
%% params that needs changing

u_K0=200;
tau0=5;
tau=13;
prev_bounds=[0.3833,0.6258]; % found previously the bounds of conf int
lb=0.29; ub=1;
warning('off','MATLAB:ode45:IntegrationTolNotMet');
%% generate data
seed=0;
rng(seed);
C0=100;
nt=100;
T=25;
t=linspace(0,T,nt);
params=[0.45,0.15,1,3900];
%u_K0=200;
%tau0=5;
%tau=15;
u_d=@(t)0;
u_K=@(t) ((t>tau0)&(t<(tau0+tau)))*u_K0;
clean_data=sol_richards_control(t,params,C0,u_d,u_K);
sigma=20;
noisy_data=clean_data+randn(size(clean_data))*sigma;

figtitle=sprintf('pl_logistic_bd_uk_%s_sigma=%g,tau0=%g,tau=%g,uK0=%g,rng=%g',string(datetime,'yyyyMMdd_HHmmss'),sigma,tau0,tau,u_K0,seed);
%% MLE
% params: [r,d,gamma,K]
fixed=[0,0,1,0];
fixed_param_val=params;
numeric_params={T,nt,u_d,u_K};
lb_opt=[0,0,0,u_K0+1];
ub_opt=[5,5,2,50000];
opt.lb=lb_opt;
opt.ub=ub_opt;
opt.logging=false;
opt.alg=2;
[mle,mle_sigma,max_l] = optimize_likelihood_general(@richards_ctrl_sq_err,fixed_param_val,fixed,noisy_data,numeric_params,C0,opt);
optimal_param_vals=fixed_param_val';
optimal_param_vals(fixed==0)=mle;

%% plot solutions
sol = sol_richards_control(t,optimal_param_vals,C0,u_d, u_K);
solfig=figure;
hold on;
plot(t,clean_data);
plot(t,noisy_data);
plot(t,sol);
plot(t,u_K(t));
xlabel('t');
hold off;
legend('Clean data','Noisy data','MLE solution','u');

%% profile likelihoods for r

numpts=21;
param_vals=linspace(lb,ub,numpts);
numpts=numpts+3;
max_ls=zeros(1,numpts);
minimizers=cell(1,numpts);
% add the global optimum, and previously found bounds of conf intervals to the list of param vals
param_vals=[param_vals,optimal_param_vals(1),prev_bounds];
param_vals=sort(param_vals);
for i=1:numpts
    [minimizer,~,max_l2]=optimize_likelihood_general(@richards_ctrl_sq_err,[param_vals(i),params(2),params(3),params(4)],[1,0,1,0],noisy_data,numeric_params,C0,opt);
    minimizers{i}=minimizer;
    max_ls(i)=max_l2;
end

%% plot
plfig=figure;
hold on;
plot(param_vals,max_ls-max(max_ls));
plot([0,max(param_vals)],[-1.92,-1.92]);
hold off;
ylim([-2.5,0]);
xlabel('r');
ylabel('l');

%% save

prefix='/home/liuy1/Documents/woundhealing/expdesign/simulations/';
save([prefix,figtitle,'.mat'],'-mat');
saveas(plfig,[prefix,figtitle,'.png']);