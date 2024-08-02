%% general exact soln
gen_exact_soln = @(x0,t,M,b)expm(t*M)*(x0+M\b) - M\b;
warning('off','MATLAB:singularMatrix');
%% exploration
% 
% %params = [1, 0, 0, 0.1, 0.6, 0.4, 0.3, 0.4, 1, 0];
% %params=[0.980326519449384,0.454278893275776,0,0.0969429943707930,2.26491342427675e-05,0.0987308624669520,0.0148919262573131,2.4,0.635309851128110,0.0905760825788031];
% M = [-params(4), 0, 0;
%      params(5), -params(6), 0;
%      params(7), params(8), -params(9)];
% b=[params(1);params(2);params(3)];
% x0=[1;params(10);0];
% T=50;
% ode=@(t,x)M*x+b;
% 
% % [t,X] = ode45(ode,[0,T],x0);figure;
% % hold on;
% % plot(t,X(:,1));
% % plot(t,X(:,2));
% % plot(t,X(:,3));
% % ylim([0,15]);
% % legend('A','B','C');
% % title('numeric solution');
% 
% tt=linspace(0,T,100);
% exact_solnf=@(t)gen_exact_soln(x0,t,M,b);
% exact_soln=arrayfun(exact_solnf,tt,'UniformOutput',false);
% exact_soln=cell2mat(exact_soln);
% figure;
% hold on;
% plot(tt,exact_soln(1,:));
% plot(tt,exact_soln(2,:));
% plot(tt,exact_soln(3,:));
% ylim([0,15]);
% legend('A','B','C');
% title('exact soln');

%% generate data
rng(0);
starttime=string(datetime,'yyyyMMddHHmm');

params = [1, 0, 0, 0.1, 0.6, 0.4, 0.3, 0.4, 1, 0];
M = [-params(4), 0, 0;
     params(5), -params(6), 0;
     params(7), params(8), -params(9)];
b=[params(1);params(2);params(3)];
x0=[1;params(10);0];
T=50;
param_names = {'a_0','b_0','c_0','a_1','b_1','b_2','c_1','c_2','c_3','B_0'};
nt=100;
tt=linspace(0,T,nt);
% numeric_params: [T,nt,tau0A,tau1A,uA,tau0B,tau1B,uB,tau0C,tau1C,uC,]
numeric_params=[T,nt,0,0,0, 10,20,18, 0,0,0];
%exact_soln=threethings_solnf_new(params,numeric_params,x0);
exact_soln=threethings_solnf_control(params,numeric_params,x0);
clean_data=exact_soln;

sigma=0.3;
noisy_data=clean_data+randn(size(clean_data))*sigma;

figclean=figure;
hold on;
plot(tt,clean_data(1,:));
plot(tt,clean_data(2,:));
plot(tt,clean_data(3,:));
ylim([0,15]);
legend('A','B','C');
title('clean data');
fignoisy=figure;
hold on;
plot(tt,noisy_data(1,:));
plot(tt,noisy_data(2,:));
plot(tt,noisy_data(3,:));
ylim([0,15]);
legend('A','B','C');
title('noisy data');

%%
figtitle=sprintf('threethings,%s,_4',starttime,num2str(numeric_params(3:11)));
diary(['simulations/',figtitle,'.txt']);
true_err=threethings_sq_err_noB(noisy_data,params,numeric_params,x0,0);
fprintf('Error of true param set: %.5f\n',true_err);
saveas(figclean,['simulations/',figtitle,'_clean_data.png']);
saveas(fignoisy,['simulations/',figtitle,'_noisy_data.png']);


%% MLE with 'a' params fixed

% fixed=[1,1,0,0,0,0,0]; % the 'a' parameters should be exactly identifiable, so can have them fixed
% %lb_opt=zeros(size(params));
% lb_opt=zeros(size(params));
% ub_opt=10*ones(size(params));
% opt.lb=lb_opt;
% opt.ub=ub_opt;
% opt.logging=true;
% opt.N=2*nt; % not 3*nt since B is not observable
% fixed_param_val=params;
% [mle,mle_sigma,max_l]=optimize_likelihood_general(@threethings_sq_err_noB,params,fixed,noisy_data,numeric_params,x0,opt);
% 
% optimal_param_vals=fixed_param_val';
% optimal_param_vals(fixed==0)=mle;
% 
% disp(optimal_param_vals);
% mle_soln=threethings_solnf_new(optimal_param_vals,numeric_params,x0);
% figure;
% hold on;
% plot(tt,mle_soln(1,:));
% plot(tt,mle_soln(2,:));
% plot(tt,mle_soln(3,:));
% ylim([0,15]);
% legend('A','B','C');

%% MLE with all params unfixed

% fixed=[0,0,0,0,0,0,0]; % unfix all params
% %lb_opt=zeros(size(params));
% lb_opt=zeros(size(params));
% ub_opt=10*ones(size(params));
% opt.lb=lb_opt;
% opt.ub=ub_opt;
% opt.logging=true;
% fixed_param_val=params;
% [mle,mle_sigma,max_l]=optimize_likelihood_general(@threethings_sq_err_noB,params,fixed,noisy_data,numeric_params,x0,opt);
% 
% optimal_param_vals=fixed_param_val';
% optimal_param_vals(fixed==0)=mle;
% 
% disp(optimal_param_vals);
% mle_soln=threethings_solnf_new(optimal_param_vals,numeric_params,x0);
% figure;
% hold on;
% plot(tt,mle_soln(1,:));
% plot(tt,mle_soln(2,:));
% plot(tt,mle_soln(3,:));
% ylim([0,15]);
% legend('A','B','C');

%% MLE
%param_names = {'a_0','b_0','c_0','a_1','b_1','b_2','c_1','c_2','c_3','B_0'};
fixed=[1,0,1,1,0,0,0,0,0,0];
%lb_opt=zeros(size(params));
lb_opt=[0.00, 0.00, 0.00, 0.01, 0.00, 0.01, 0.00,  0.00,  0.01, 0.00];
ub_opt=10*ones(size(params));
opt.lb=lb_opt;
opt.ub=ub_opt;
opt.logging=true;
opt.alg=2;
opt.N=2*nt; % not 3*nt since B is not observable
%fixed_param_val=rand(size(params));
%fixed_param_val(3)=0;
%fixed_param_val = [1, 0, 0, 0.1, rand*2, rand*2, rand*2, rand*2, rand*2, rand*2];
fixed_param_val = params;
scaling = ones(size(fixed_param_val));
opt.scaling=scaling;
[mle,mle_sigma,max_l]=optimize_likelihood_general(@threethings_sq_err_noB,fixed_param_val,fixed,noisy_data,numeric_params,x0,opt);

optimal_param_vals=fixed_param_val';
optimal_param_vals(fixed==0)=mle;

disp(optimal_param_vals);
mle_soln=threethings_solnf_control(optimal_param_vals,numeric_params,x0);
figure;
hold on;
plot(tt,mle_soln(1,:));
plot(tt,mle_soln(2,:));
plot(tt,mle_soln(3,:));
ylim([0,15]);
legend('A','B','C');
title('MLE solution');

%% profile likelihood for the c parameters
%param_names = {'a_0','b_0','c_0','a_1','b_1','b_2','c_1','c_2','c_3','B_0'};
fixed=[1,0,1,1,0,0,0,0,0,0];
num_free_params=sum(1-fixed);
true_params=params;
fixed_param_val= [1.00, 0.00, 0.00, 0.10, 0.60, 0.40, 0.30,  0.40,  1.00, 0.00];
lb=              [0.00, 0.00, 0.00, 0.01, 0.00, 0.01, 0.00,  0.30,  0.20, 0.00];
ub=              [2.00, 6.00, 0.00, 2.00, 4.00, 4.00, 0.60,  0.60,  1.50, 5.00];
% diagonal params (4,6,9) must be nonzero
scaling = ones(size(fixed_param_val));
%opt.logging=false;
opt.scaling=scaling;
opt.alg=2;
num_params=size(params,2);

numpts=41;
param_vals=zeros(num_params,numpts);
max_ls=zeros(num_params,numpts+2);
minimizers=cell(num_params,numpts+2);
% add the global optimum to the list of param vals
param_vals=[param_vals,optimal_param_vals];
% add true param to the list of param vals
param_vals=[param_vals,params'];

for param=[7,8,9]
    if fixed(param)
        continue;
    end
    param_vals(param,1:numpts)=linspace(lb(param),ub(param),numpts);
    param_vals(param,:)=sort(param_vals(param,:));
    [~,mle_idx]=min(abs(param_vals(param,:)-optimal_param_vals(param)));
    fixed_params=fixed;
    fixed_params(param)=1;
    initial=fixed_param_val;
    minimizers{param,mle_idx}=optimal_param_vals;
    max_ls(param,mle_idx)=max_l;
    for i=mle_idx+1:numpts+2
        fprintf('Optimizing for %s=%.3f\n',param_names{param},param_vals(param,i));
        initial=minimizers{param,i-1};
        initial(param)=param_vals(param,i);
        [minimizer,~,max_ls(param,i)] = optimize_likelihood_general(@threethings_sq_err_noB,initial,fixed_params,noisy_data,numeric_params,x0,opt);
        minimizers{param,i}=initial;
        minimizers{param,i}(fixed_params==0)=minimizer;
        %save([prefix,'_',figtitle,'.mat'],'-mat');
    end
    for i=mle_idx-1:-1:1
        fprintf('Optimizing for %s=%.3f\n',param_names{param},param_vals(param,i));
        initial=minimizers{param,i+1};
        initial(param)=param_vals(param,i);
        [minimizer,~,max_ls(param,i)] = optimize_likelihood_general(@threethings_sq_err_noB,initial,fixed_params,noisy_data,numeric_params,x0,opt);
        minimizers{param,i}=initial;
        minimizers{param,i}(fixed_params==0)=minimizer;
        %save([prefix,'_',figtitle,'.mat'],'-mat');
    end
end

%% plot profile likelihood
fig=figure('Position',[100 100 1400 400],'color','w');
sgtitle(figtitle);
free_param_count=0;
zs = cell(num_params,1);
conf_interval=nan(num_params,1);
for param=[7,8,9] %1:num_params
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
diary off;
