%% general exact soln
gen_exact_soln = @(x0,t,M,b)expm(t*M)*(x0+M\b) - M\b;
%% a bit testing
% a0, a1, b0, b1, b2, c0, c1, c2, c3
% these 2 parameter sets should be indistinguishable given solutions
params1 = [1, 0.1, ...
          1, 0.4, 0.5, ...
          1, 0.5, 0.0, 1];
params2 = [1, 0.1, ...
          1, 0.4, 0.5, ...
          1, 0.0, 0.5, 1];
params3 = [1, 0.1, ...
          1, 0.4, 0.5, ...
          1, 0.25, 0.25, 1];
% params1 = [ 1, 0.1, ...
%           0.1, 0.1, 0.11, ...
%             0, 0.5, 0.0, 1];
% params2 = [ 1, 0.1, ...
%           0.1, 0.1, 0.11, ...
%             0, 0.0, 0.5, 1];
% params3 = [ 1, 0.1, ...
%           0.1, 0.1, 0.11, ...
%             0, 0.25, 0.25, 1];
params=params3;
M = [-params(2), 0, 0;
     params(4), -params(5), 0;
     params(7), params(8), -params(9)];
b=[params(1);
   params(3);
   params(6)];
%x0=[1;0.0;0];
x0=[1;1;0];
T=50;
ode=@(t,x)M*x+b;

[t,X] = ode45(ode,[0,T],x0);

% figure;
% hold on;
% plot(t,X(:,1));
% plot(t,X(:,2));
% plot(t,X(:,3));
% ylim([0,15]);
% legend('A','B','C');

tt=linspace(0,T,100);
exact_solnf=@(t)gen_exact_soln(x0,t,M,b);
exact_soln=arrayfun(exact_solnf,tt,'UniformOutput',false);
exact_soln=cell2mat(exact_soln);
figure;
hold on;
plot(tt,exact_soln(1,:),'-*');
plot(tt,exact_soln(2,:));
plot(tt,exact_soln(3,:));
ylim([0,15]);
legend('A','B','C');
%% generate data
% params = [1.0, 0.10, ...
%           0.1, 0.20, 0.21, ...
%           0.0, 0.25, 0.25, 1.00];
params = [1.0, 0.10, ...
          1.0, 0.40, 0.50, ...
          0.0, 0.25, 0.25, 1.00];
M = [-params(2), 0, 0;
     params(4), -params(5), 0;
     params(7), params(8), -params(9)];
b=[params(1);
   params(3);
   params(6)];
param_names = {'a_0','a_1','b_0','b_1','b_2','c_0','c_1','c_2','c_3'};
x0=[3;3.0;0];
T=50;
nt=100;
tt=linspace(0,T,nt);
numeric_params=[T,nt];
% exact_solnf=@(t)gen_exact_soln(x0,t,M,b);
% exact_soln=arrayfun(exact_solnf,tt,'UniformOutput',false);
% exact_soln=cell2mat(exact_soln);
exact_soln=threethings_solnf(params,numeric_params,x0);
clean_data=exact_soln;

sigma=0.1;
noisy_data=clean_data+randn(size(clean_data))*sigma;

figure;
hold on;
plot(tt,noisy_data(1,:));
plot(tt,noisy_data(2,:));
plot(tt,noisy_data(3,:));
ylim([0,15]);
legend('A','B','C');

%% MLE

sq_err=@(x) sum((threethings_solnf(x,numeric_params,x0)-noisy_data).^2,'all');
initial=params;
options=optimoptions('fmincon','Algorithm','interior-point');
options.Display='iter';
options.Diagnostics='on';
options.MaxFunctionEvaluations=6000;
options.ScaleProblem=true;
problem.objective=sq_err;
problem.x0=initial;
problem.solver='fmincon';
problem.lb=zeros(size(params));
problem.ub=10*ones(size(params));
problem.options=options;
[mle,min_sq_err,~,~,~,~,~] = fmincon(problem);

disp(mle);
mle_soln=threethings_solnf(mle,numeric_params,x0);
figure;
hold on;
plot(tt,mle_soln(1,:));
plot(tt,mle_soln(2,:));
plot(tt,mle_soln(3,:));
ylim([0,15]);
legend('A','B','C');

%% MLE using the new general function

fixed=[1,1,1,1,1,0,0,0,0];
%lb_opt=zeros(size(params));
lb_opt=-10*ones(size(params));
ub_opt=10*ones(size(params));
opt.lb=lb_opt;
opt.ub=ub_opt;
opt.logging=true;
fixed_param_val=params;
[mle,mle_sigma,max_l]=optimize_likelihood_general(@threethings_sq_err,params,fixed,noisy_data,numeric_params,x0,opt);

optimal_param_vals=fixed_param_val';
optimal_param_vals(fixed==0)=mle;

disp(optimal_param_vals);
mle_soln=threethings_solnf(optimal_param_vals,numeric_params,x0);
figure;
hold on;
plot(tt,mle_soln(1,:));
plot(tt,mle_soln(2,:));
plot(tt,mle_soln(3,:));
ylim([0,15]);
legend('A','B','C');

%% profile likelihood for the c parameters

%fixed=[1,1,1,1,1,0,0,0,0];
num_free_params=sum(1-fixed);
true_params=params;
fixed_param_val= [1.00, 0.10, 0.10, 0.40, 0.50,  0.00,  0.25,  0.25, 1.00];
lb=              [0.00, 0.00, 0.10, 0.00, 0.00, -0.80, -1.50, -1.50, 0.50];
ub=              [2.00, 2.00, 2.00, 2.00, 2.00,  0.80,  1.50,  1.50, 1.50];
% diagonal params (2, 5, 9) must be nonzero
scaling = ones(size(fixed_param_val));
%opt.logging=false;
opt.scaling=scaling;
num_params=size(params,2);
starttime=string(datetime,'yyyyMMddHHmm');
figtitle=sprintf('threethings,%s,allow-neg,fix-others',starttime);

numpts=11;
param_vals=zeros(num_params,numpts);
max_ls=zeros(num_params,numpts);
minimizers=cell(num_params,numpts);
% add the global optimum to the list of param vals
param_vals=[param_vals,optimal_param_vals];

for param=[6,7,8,9] %[6,7,8,9]
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
        [minimizer,~,max_ls(param,i)] = optimize_likelihood_general(@threethings_sq_err,initial,fixed_params,noisy_data,numeric_params,x0,opt);
        minimizers{param,i}=minimizer;
        %save([prefix,'_',figtitle,'.mat'],'-mat');
    end
    for i=mle_idx-1:-1:1
        fprintf('Optimizing for %s=%.3f\n',param_names{param},param_vals(param,i));
        initial(fixed_params==0)=minimizers{param,i+1};
        initial(param)=param_vals(param,i);
        [minimizer,~,max_ls(param,i)] = optimize_likelihood_general(@threethings_sq_err,initial,fixed_params,noisy_data,numeric_params,x0,opt);
        minimizers{param,i}=minimizer;
        %save([prefix,'_',figtitle,'.mat'],'-mat');
    end
end

%% plot profile likelihood
fig=figure('Position',[100 100 1400 400],'color','w');
sgtitle(figtitle);
free_param_count=0;
zs = cell(num_params,1);
conf_interval=nan(num_params,1);
for param=[6,7,8,9] %1:num_params
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

%%
save(['simulations/',figtitle,'.mat'],'-mat');
saveas(fig,['simulations/',figtitle,'.png']);