%%
addpath('/home/liuy1/Documents/woundhealing');
%%
fig=figure;
tt=linspace(0,25,50);
hold on
%plot(tt,sol_richards(tt,[0.3,1,2600],100));
%plot(tt,sol_richards(tt,[0.3,2,2600],100));
plot(tt,sol_richards(tt,[1,0.2,2600],100));

%%
noisy_data=sol_richards(tt,[0.25,3,2600],100);

%% 
% sps the true data is generated with Richards, 
% r=0.18, gamma=2, K=2600
C0=100;
N=100;
t=linspace(0,25,N);
params=[0.18,2,2600];
clean_data=sol_richards(t,params,C0);
sigma=20;
noisy_data=clean_data+randn(size(clean_data))*sigma;

figure;
hold on
plot(t,clean_data);
plot(t,noisy_data);

%% try to do MLE for logistic growth, i.e. fix gamma=1
%MLE:
sq_err=@(x) sum((sol_richards(t,[x(1),1,x(2)],C0)-noisy_data).^2);
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
mle_logistic=[minimizer(1),1,minimizer(2)];
min_sq_err_logistic=min_sq_err;
disp(mle_logistic);
[max_l_logistic,sigma_logistic]= log_likelihood(min_sq_err_logistic,N);
aic_logistic = -2*max_l_logistic + 2*2;
bic_logistic = -2*max_l_logistic + log(N)*2;
fprintf('Logistic model: AIC=%.3f,BIC=%.3f\n',aic_logistic,bic_logistic);

%% Just to make sure: do a MLE for Richards, should get the true params back
sq_err=@(x) sum((sol_richards(t,x,C0)-noisy_data).^2);
initial=params;
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
mle_richards=minimizer;
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
problem.ub=[1000];
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
sq_err=@(x) sum((sol_richards(t,[x(1),1,params(3)],C0)-noisy_data).^2);
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
mle_logistic=[minimizer(1),1,params(3)];
min_sq_err_logistic=min_sq_err;
disp(mle_logistic);
[max_l_logistic,sigma_logistic]= log_likelihood(min_sq_err_logistic,N);
aic_logistic = -2*max_l_logistic + 2*2;
bic_logistic = -2*max_l_logistic + log(N)*2;
fprintf('Logistic model: AIC=%.3f,BIC=%.3f\n',aic_logistic,bic_logistic);

%% MLE for Richards, K exact
sq_err=@(x) sum((sol_richards(t,[x(1),x(2),params(3)],C0)-noisy_data).^2);
initial=params;
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
mle_richards=minimizer;
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