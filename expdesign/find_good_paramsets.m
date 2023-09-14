%% synthetic data with logistic model
C0=100;
nt=100;
T=25;
t=linspace(0,T,nt);
params=[0.3,0,1,2600];
u_d=@(t) 0;
u_k=@(t) 0;

sol_logistic = sol_richards(t,params,C0);

%% try to fit a rochards model with gamma=3
fixed=[0,1,1,0];
fixed_param_val=[0.3,0,3,2600];
numeric_params={T,nt,u_d,u_k};
lb_opt=[0,0,0,0];
ub_opt=[5,5,5,50000];
opt.lb=lb_opt;
opt.ub=ub_opt;
opt.logging=true;
opt.alg=2;
[mle3,mle_sigma3,max_l3] = optimize_likelihood_general(@richards_ctrl_sq_err,fixed_param_val,fixed,sol_logistic,numeric_params,C0,opt);

params3=fixed_param_val;
params3(fixed==0)=mle3;
%% try to fit a rochards model with gamma=3

fixed=[0,1,1,0];
fixed_param_val=[0.3,0,9,2600];
numeric_params={T,nt,u_d,u_k};
lb_opt=[0,0,0,0];
ub_opt=[5,5,5,50000];
opt.lb=lb_opt;
opt.ub=ub_opt;
opt.logging=true;
opt.alg=2;
[mle9,mle_sigma9,max_l9] = optimize_likelihood_general(@richards_ctrl_sq_err,fixed_param_val,fixed,sol_logistic,numeric_params,C0,opt);

params9=fixed_param_val;
params9(fixed==0)=mle9;

%% plot
sol3 = sol_richards(t,params3,C0);
sol9 = sol_richards(t,params9,C0);
figure;
hold on;
plot(t,sol_logistic,'DisplayName','Logistic');
plot(t,sol3,'DisplayName','\gamma=3');
plot(t,sol9,'DisplayName','\gamma=9');
xlabel('t');
hold off;
legend();