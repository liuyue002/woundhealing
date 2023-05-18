%%
addpath('/home/liuy1/Documents/woundhealing');
%%
fig=figure;
tt=linspace(0,25,50);
hold on
%plot(tt,sol_richards(tt,[0.3,1,2600],100));
%plot(tt,sol_richards(tt,[0.3,2,2600],100));
plot(tt,sol_richards(tt,[1,0.2,1,2600],100));

%%
noisy_data=sol_richards(tt,[0.25,0,3,2600],100);

%% 
% sps the true data is generated with Richards, 
% r=0.18, gamma=2, K=2600
C0=100;
N=100;
t=linspace(0,25,N);
params=[0.18,0,2,2600];
clean_data=sol_richards(t,params,C0);
sigma=20;
noisy_data=clean_data+randn(size(clean_data))*sigma;

figure;
hold on
plot(t,clean_data);
plot(t,noisy_data);

%% try to do MLE for logistic growth, i.e. fix gamma=1
%MLE:
sq_err=@(x) sum((sol_richards(t,[x(1),0,1,x(2)],C0)-noisy_data).^2);
initial=[0.18,2600];
options=optimoptions('fmincon','Algorithm','interior-point');
options.Display='iter';
options.Diagnostics='on';
options.MaxFunctionEvaluations=6000;
options.ScaleProblem=true;
problem.objective=sq_err;
problem.x0=initial;
problem.solver='fmincon';
problem.lb=[0,0];
problem.ub=[2,10000];
problem.options=options;
[minimizer,min_sq_err,~,~,~,~,~] = fmincon(problem);
mle_logistic=[minimizer(1),0,1,minimizer(2)];
min_sq_err_logistic=min_sq_err;
disp(mle_logistic);
[max_l_logistic,sigma_logistic]= log_likelihood(min_sq_err_logistic,N);
aic_logistic = -2*max_l_logistic + 2*2;
bic_logistic = -2*max_l_logistic + log(N)*2;
fprintf('Logistic model: AIC=%.3f,BIC=%.3f\n',aic_logistic,bic_logistic);

%% Just to make sure: do a MLE for Richards, should get the true params back
sq_err=@(x) sum((sol_richards(t,[x(1),0,x(2),x(3)],C0)-noisy_data).^2);
initial=[0.18,2,2600];
options=optimoptions('fmincon','Algorithm','interior-point');
options.Display='iter';
options.Diagnostics='on';
options.MaxFunctionEvaluations=6000;
options.ScaleProblem=true;
problem.objective=sq_err;
problem.x0=initial;
problem.solver='fmincon';
problem.lb=[0,0,0];
problem.ub=[2,10,10000];
problem.options=options;
[minimizer,min_sq_err,~,~,~,~,~] = fmincon(problem);
mle_richards=[minimizer(1),0,minimizer(2),minimizer(3)];
min_sq_err_richards=min_sq_err;
disp(mle_richards);
[max_l_richards,sigma_richards]= log_likelihood(min_sq_err_richards,N);
aic_richards = -2*max_l_richards + 2*2;
bic_richards = -2*max_l_richards + log(N)*2;
fprintf('Richards model: AIC=%.3f,BIC=%.3f\n',aic_richards,bic_richards);

%% could do a profile likelihood, but it's expected to be very identifiable

%% plot the true solution vs mle solutions
figure;
hold on;
plot(t,noisy_data);
plot(t,sol_richards(t,mle_richards,C0));
plot(t,sol_richards(t,mle_logistic,C0));

%% now we want to distinguish between the two models by picking a C0

neg_model_diff=@(C0) -sum((sol_richards(t,mle_richards,C0)-sol_richards(t,mle_logistic,C0)).^2);
initial=100;
options=optimoptions('fmincon','Algorithm','interior-point');
options.Display='iter';
options.Diagnostics='on';
options.MaxFunctionEvaluations=6000;
options.ScaleProblem=true;
problem.objective=neg_model_diff;
problem.x0=initial;
problem.solver='fmincon';
problem.lb=[0];
% if ub is above K, then will pick very large C0 (probably at ub)
% if set below K, will pick small C0
problem.ub=[10000]; 
problem.options=options;
[best_C0,best_model_diff,~,~,~,~,~] = fmincon(problem);
best_model_diff= -best_model_diff;

figure;
hold on;
plot(sol_richards(t,mle_richards,best_C0));
plot(sol_richards(t,mle_logistic,best_C0));

% it tends to pick a very large C0, since the carrying capacity MLE is
% different, so the model difference is maximized if we reach carrying
% capacity early

%% MLE for logistic growth, with K fixed to be exact
sq_err=@(x) sum((sol_richards(t,[x(1),0,1,params(4)],C0)-noisy_data).^2);
initial=[0.18];
options=optimoptions('fmincon','Algorithm','interior-point');
options.Display='iter';
options.Diagnostics='on';
options.MaxFunctionEvaluations=6000;
options.ScaleProblem=true;
problem.objective=sq_err;
problem.x0=initial;
problem.solver='fmincon';
problem.lb=[0];
problem.ub=[2];
problem.options=options;
[minimizer,min_sq_err,~,~,~,~,~] = fmincon(problem);
mle_logistic=[minimizer(1),0,1,params(4)];
min_sq_err_logistic=min_sq_err;
disp(mle_logistic);
[max_l_logistic,sigma_logistic]= log_likelihood(min_sq_err_logistic,N);
aic_logistic = -2*max_l_logistic + 2*2;
bic_logistic = -2*max_l_logistic + log(N)*2;
fprintf('Logistic model: AIC=%.3f,BIC=%.3f\n',aic_logistic,bic_logistic);

%% MLE for Richards, K exact
sq_err=@(x) sum((sol_richards(t,[x(1),0,x(2),params(4)],C0)-noisy_data).^2);
initial=[params(1),params(3)];
options=optimoptions('fmincon','Algorithm','interior-point');
options.Display='iter';
options.Diagnostics='on';
options.MaxFunctionEvaluations=6000;
options.ScaleProblem=true;
problem.objective=sq_err;
problem.x0=initial;
problem.solver='fmincon';
problem.lb=[0,0];
problem.ub=[2,10];
problem.options=options;
[minimizer,min_sq_err,~,~,~,~,~] = fmincon(problem);
mle_richards=[minimizer(1),0,minimizer(2),params(4)];
min_sq_err_richards=min_sq_err;
disp(mle_richards);
[max_l_richards,sigma_richards]= log_likelihood(min_sq_err_richards,N);
aic_richards = -2*max_l_richards + 2*2;
bic_richards = -2*max_l_richards + log(N)*2;
fprintf('Richards model: AIC=%.3f,BIC=%.3f\n',aic_richards,bic_richards);

%% best C0, for K exact

neg_model_diff=@(C0) -sum((sol_richards(t,mle_richards,C0)-sol_richards(t,mle_logistic,C0)).^2);
initial=2500;
options=optimoptions('fmincon','Algorithm','interior-point');
options.Display='iter';
options.Diagnostics='on';
options.MaxFunctionEvaluations=6000;
options.ScaleProblem=true;
problem.objective=neg_model_diff;
problem.x0=initial;
problem.solver='fmincon';
problem.lb=[0];
problem.ub=[2600];
problem.options=options;
[best_C0,best_model_diff,~,~,~,~,~] = fmincon(problem);
best_model_diff= -best_model_diff;

figure;
hold on;
plot(sol_richards(t,mle_richards,best_C0));
plot(sol_richards(t,mle_logistic,best_C0));

% with ub set to K, will now pick a small C0 (13.85) near 0 for T=25
% if T=10, pick C0=1022.2
% if T=5, pick 1412.1
% T short: want to pick a higher C0 to observe sigmoid growth, since a
% small C0 just give linear growth which looks the same to both models
% T long enough for both model to reach K: want to pick low C0 to observe
% more transient behaviour

%% split into birth/death, make it structurally non-identifiable
% params=[r,d,gamma,K]
C0=100;
nt=100;
T=50;
t=linspace(0,T,nt);
params=[0.3,0.15,1,2600];
clean_data=sol_richards(t,params,C0);
sigma=20;
noisy_data=clean_data+randn(size(clean_data))*sigma;

figure;
hold on
plot(t,clean_data);
plot(t,noisy_data);

%% MLE for birth/death logistic

sq_err=@(x) sum((sol_richards(t,x,C0)-noisy_data).^2);
initial=[0.3,0.15,1,2600];
options=optimoptions('fmincon','Algorithm','interior-point');
options.Display='iter';
options.Diagnostics='on';
options.MaxFunctionEvaluations=6000;
options.ScaleProblem=true;
problem.objective=sq_err;
problem.x0=initial;
problem.solver='fmincon';
problem.lb=[0,0,0,0];
problem.ub=[2,2,2,5000];
problem.options=options;
[minimizer,min_sq_err,~,~,~,~,~] = fmincon(problem);

disp(minimizer); % should pretty much recover it exactly

%% MLE with the general function
fixed=[0,0,1,0];
fixed_param_val=[0.3,0.15,1,2600];
numeric_params=[T,nt];
lb_opt=[0,0,0,0];
ub_opt=[2,2,2,5000];
opt.lb=lb_opt;
opt.ub=ub_opt;
opt.logging=true;
[mle,mle_sigma,max_l] = optimize_likelihood_general(@richards_sq_err,fixed_param_val,fixed,noisy_data,numeric_params,C0,opt);
optimal_param_vals=fixed_param_val';
optimal_param_vals(fixed==0)=mle;
%% profile likelihood for birth/death logistic
fixed_param_val=[0.3,0.15,1,2600];
fixed=[0,0,1,0];
num_params=size(fixed_param_val,2);
num_free_params=sum(1-fixed);
lb=[ 0.1,0,0, 1000];
ub=[ 0.6,1,2, 3000];
opt.ub=[2,2,2,99000];
param_names={'r','\delta','\gamma','K'};

numpts=21;
param_vals=zeros(num_params,numpts);
max_ls=zeros(num_params,numpts);
minimizers=cell(num_params,numpts);
% add the global optimum to the list of param vals
param_vals=[param_vals,optimal_param_vals];

for param=1:num_params
    if fixed(param)
        continue;
    end
    param_vals(param,1:numpts)=linspace(lb(param),ub(param),numpts);
    param_vals(param,:)=sort(param_vals(param,:));
    [~,mle_idx]=min(abs(param_vals(param,:)-optimal_param_vals(param)));
    fixed_params=fixed;
    fixed_params(param)=1;
    initial=fixed_param_val;
    minimizers{param,mle_idx}=optimal_param_vals(fixed_params==0);
    max_ls(param,mle_idx)=max_l;
    for i=mle_idx+1:numpts+1
        fprintf('Optimizing for %s=%.3f\n',param_names{param},param_vals(param,i));
        initial(fixed_params==0)=minimizers{param,i-1};
        initial(param)=param_vals(param,i);
        [minimizer,~,max_ls(param,i)] = optimize_likelihood_general(@richards_sq_err,initial,fixed_params,noisy_data,numeric_params,C0,opt);
        minimizers{param,i}=minimizer;
        %save([prefix,'_',figtitle,'.mat'],'-mat');
    end
    for i=mle_idx-1:-1:1
        fprintf('Optimizing for %s=%.3f\n',param_names{param},param_vals(param,i));
        initial(fixed_params==0)=minimizers{param,i+1};
        initial(param)=param_vals(param,i);
        [minimizer,~,max_ls(param,i)] = optimize_likelihood_general(@richards_sq_err,initial,fixed_params,noisy_data,numeric_params,C0,opt);
        minimizers{param,i}=minimizer;
        %save([prefix,'_',figtitle,'.mat'],'-mat');
    end
end

%% plot profile likelihood
true_params=[0.3,0.15,1,2600];
fig=figure('Position',[100 100 1400 400],'color','w');
sgtitle('title');
free_param_count=0;
zs = cell(num_params,1);
conf_interval=nan(num_params,1);
for param=1:num_params
    if fixed(param)
        continue;
    end
    free_param_count = free_param_count+1;
    subplot(1,4,free_param_count);
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy);
    plot([min(param_vals(param,:)),max(param_vals(param,:))],[-1.92,-1.92]);
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true max
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    xlabel(param_names{param});
    ylabel('log(L)');
    axis('square');
    xlim([min(param_vals(param,:)),max(param_vals(param,:))]);
    ylim([-2.5,0]);
    hold off;
    
    zs{param}=interp_zero(xx,yy+1.92);
    if size(zs{param},2) == 2
        conf_interval(param)=zs{param}(2)-zs{param}(1);
        fprintf('95%% Confidence interval for param %s is: (intercept at -1.92)\n',param_names{param});
        fprintf('width=%.4f: [%.4f,%.4f]\n',conf_interval(param),zs{param}(1),zs{param}(2));
    elseif size(zs{param},2) == 1 && strcmp(param_names{param},'n')
        conf_interval(param)=zs{param}(1);
        fprintf('95%% Confidence interval for param %s is: (intercept at -1.92)\n',param_names{param});
        fprintf('width=%.4f: [0,%.4f]\n',conf_interval(param),zs{param}(1));
    elseif size(zs{param},2) == 1 && strcmp(param_names{param},'gamma')
        conf_interval(param)=Inf;
        fprintf('95%% Confidence interval for param %s is: (intercept at -1.92)\n',param_names{param});
        fprintf('width=Inf: [%.4f,Inf]\n',zs{param}(1));
    else
        fprintf('Do not have 2 intercepts for param %s, they are:\n',param_names{param});
        disp(zs{param});
    end
end

% it's completely non-identifiable with r,delta,K all free
% should be worse if gamma is also free

%% add in control for K
rng(0);
C0=100;
nt=100;
T=50;
t=linspace(0,T,nt);
params=[0.3,0.15,1,2600];
u_K0=50;
u_d=@(t)0;
u_K=@(t) ((t>10)&(t<30))*u_K0;
clean_data=sol_richards_control(t,params,C0,u_d,u_K);
sigma=20;
noisy_data=clean_data+randn(size(clean_data))*sigma;

%data2=sol_richards_control(t,[0.2302,0.0803,1,2000],C0,u_d,u_K);

figure;
hold on
plot(t,clean_data);
plot(t,noisy_data);
plot(t,u_K(t));
%plot(t,data2);


%% MLE for logistic
fixed=[0,0,1,0];
fixed_param_val=[0.3,0.15,1,2600];
numeric_params={T,nt,u_d,u_K};
lb_opt=[0,0,0,0];
ub_opt=[2,2,2,10000];
opt.lb=lb_opt;
opt.ub=ub_opt;
opt.logging=true;
opt.alg=2;
[mle,mle_sigma,max_l] = optimize_likelihood_general(@richards_ctrl_sq_err,fixed_param_val,fixed,noisy_data,numeric_params,C0,opt);
optimal_param_vals=fixed_param_val';
optimal_param_vals(fixed==0)=mle;

mle_soln=sol_richards_control(t,optimal_param_vals,C0,u_d,u_K);

% get something close to true value

%% profile likelihood for logistic, with birth/death, and u_K

fixed_param_val=[0.3,0.15,1,2600];
fixed=[0,0,1,0];
num_params=size(fixed_param_val,2);
num_free_params=sum(1-fixed);
lb=[ 0.10, 0.00, 0,   600];
ub=[ 1.00, 1.00, 2,  8000];
opt.ub=[10,10,10,99000];
opt.alg=1;
param_names={'r','\delta','\gamma','K'};

numpts=21;
param_vals=zeros(num_params,numpts);
max_ls=zeros(num_params,numpts);
minimizers=cell(num_params,numpts);
% add the global optimum to the list of param vals
param_vals=[param_vals,optimal_param_vals];

for param=1:num_params
    if fixed(param)
        continue;
    end
    param_vals(param,1:numpts)=linspace(lb(param),ub(param),numpts);
    param_vals(param,:)=sort(param_vals(param,:));
    [~,mle_idx]=min(abs(param_vals(param,:)-optimal_param_vals(param)));
    fixed_params=fixed;
    fixed_params(param)=1;
    initial=fixed_param_val;
    minimizers{param,mle_idx}=optimal_param_vals(fixed_params==0);
    max_ls(param,mle_idx)=max_l;
    for i=mle_idx+1:numpts+1
        fprintf('Optimizing for %s=%.3f\n',param_names{param},param_vals(param,i));
        initial(fixed_params==0)=minimizers{param,i-1};
        initial(param)=param_vals(param,i);
        [minimizer,~,max_ls(param,i)] = optimize_likelihood_general(@richards_ctrl_sq_err,initial,fixed_params,noisy_data,numeric_params,C0,opt);
        minimizers{param,i}=minimizer;
        %save([prefix,'_',figtitle,'.mat'],'-mat');
    end
    for i=mle_idx-1:-1:1
        fprintf('Optimizing for %s=%.3f\n',param_names{param},param_vals(param,i));
        initial(fixed_params==0)=minimizers{param,i+1};
        initial(param)=param_vals(param,i);
        [minimizer,~,max_ls(param,i)] = optimize_likelihood_general(@richards_ctrl_sq_err,initial,fixed_params,noisy_data,numeric_params,C0,opt);
        minimizers{param,i}=minimizer;
        %save([prefix,'_',figtitle,'.mat'],'-mat');
    end
end

%% plot profile likelihood
true_params=[0.3,0.15,1,2600];
fig=figure('Position',[100 100 1400 400],'color','w');
sgtitle(sprintf('u_K=%.0f',u_K0));
free_param_count=0;
zs = cell(num_params,1);
conf_interval=nan(num_params,1);
for param=1:num_params
    if fixed(param)
        continue;
    end
    free_param_count = free_param_count+1;
    subplot(1,num_free_params,free_param_count);
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy);
    plot([min(param_vals(param,:)),max(param_vals(param,:))],[-1.92,-1.92]);
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true max
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    xlabel(param_names{param});
    ylabel('log(L)');
    axis('square');
    xlim([min(param_vals(param,:)),max(param_vals(param,:))]);
    ylim([-2.5,0]);
    hold off;
    
    zs{param}=interp_zero(xx,yy+1.92);
    if size(zs{param},2) == 2
        conf_interval(param)=zs{param}(2)-zs{param}(1);
        fprintf('95%% Confidence interval for param %s is: (intercept at -1.92)\n',param_names{param});
        fprintf('width=%.4f: [%.4f,%.4f]\n',conf_interval(param),zs{param}(1),zs{param}(2));
    elseif size(zs{param},2) == 1 && strcmp(param_names{param},'n')
        conf_interval(param)=zs{param}(1);
        fprintf('95%% Confidence interval for param %s is: (intercept at -1.92)\n',param_names{param});
        fprintf('width=%.4f: [0,%.4f]\n',conf_interval(param),zs{param}(1));
    elseif size(zs{param},2) == 1 && strcmp(param_names{param},'gamma')
        conf_interval(param)=Inf;
        fprintf('95%% Confidence interval for param %s is: (intercept at -1.92)\n',param_names{param});
        fprintf('width=Inf: [%.4f,Inf]\n',zs{param}(1));
    else
        fprintf('Do not have 2 intercepts for param %s, they are:\n',param_names{param});
        disp(zs{param});
    end
end
