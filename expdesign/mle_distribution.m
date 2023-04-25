%%
addpath('/home/liuy1/Documents/woundhealing');

%%
C0=100;
N=100;
params=[0.18,2,2600];
t=linspace(0,25,N);
clean_data=sol_richards(t,params,C0);
num_trial=100;
sigma=400;
mles_richards = zeros(num_trial,3);
for i=1:num_trial
    noisy_data=clean_data+randn(size(clean_data))*sigma;
    sq_err=@(x) sum((sol_richards(t,x,C0)-noisy_data).^2);

    initial=params;
    options=optimoptions('fmincon','Algorithm','interior-point');
    options.Display='final';
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
    mles_richards(i,:)=minimizer;
end

%%
figg=figure;
sgtitle(['sigma=',num2str(sigma)]);

sfig1=subplot(1,3,1);
hold on
histfit(mles_richards(:,1));
xline(params(1),':g');
title('r');

sfig2=subplot(1,3,2);
hold on
histfit(mles_richards(:,2));
xline(params(2),':g');
title('gamma');

sfig3=subplot(1,3,3);
hold on
histfit(mles_richards(:,3));
xline(params(3),':g');
title('K');