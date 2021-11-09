%load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20211015_163234_Dc=500_r=0.05_n=0_alpha=1_beta=1.mat');
load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20211104_112707_D0=500,r=0.05,alpha=1,beta=1,gamma=1,n=0.mat');
%load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20211108_113846_D0=500,r=0.12,alpha=1.5,beta=1.4,gamma=1,n=0.mat');
noise_strength=0.01;
if noise_strength==0.05
    noisy_data=cc_noisy_005;
else
    noisy_data=cc_noisy_001;
end
t_skip=5;
x_skip=12;
%use only early data
% noisy_data=noisy_data(1:21,:);
% nFrame=20;
% T=80;
%f=@(x) -log_likelihood_1d(noisy_data,T,x(1),x(2),x(3),x(4),x(5),t_skip,x_skip);
true_params=[params,noise_strength];
fixed_param_val=true_params;
lb=true_params.*[0.8,0.8,0.9,0.9,0.9,0.9,0.8];
ub=true_params.*[1.2,1.2,1.1,1.1,1.1,1.1,1.2];
param_names={'D0','r','alpha','beta','gamma','n','sigma2'};
num_params=size(true_params,2);
%if fixed(i)==1, then the ith param is set to the true value and not optimized over
fixed=[0,0,0,0,1,1,0];
num_free_params=sum(1-fixed);

%% overall max likelihood
[overall_minimizer,max_l,f_str,grad,hessian] = optimize_likelihood(fixed,fixed_param_val,lb,ub,noisy_data,T,t_skip,x_skip);

fprintf(['Overall max likelihood param is: ',repmat('%.3f,',size(overall_minimizer)),'\n'],overall_minimizer);

% % fisher information
%addpath('/home/liuy1/Documents/woundhealing/DERIVESTsuite');
%eval(f_str);
%[grad,~,~] = gradest(f,overall_minimizer);
%[hess,err] = hessian(f,overall_minimizer);
%% profile likelihood for each param
numpts=20;
param_vals=zeros(num_params,numpts);
max_ls=zeros(num_params,numpts);
for param=1:num_params
    if fixed(param)
        continue;
    end
    param_vals(param,:)=linspace(lb(param),ub(param),numpts);
    fixed_params=fixed;
    fixed_params(param)=1;
    initial=fixed_param_val;
    for i=1:numpts
        if i>1
            initial(fixed_params==0)=minimizer;
        end
        initial(param)=param_vals(param,i);
        [minimizer,max_ls(param,i),~,~,~] = optimize_likelihood(fixed_params,initial,lb,ub,noisy_data,T,t_skip,x_skip);
    end
end

%% plot
fig=figure('Position',[100 100 1400 400],'color','w');
figtitle=sprintf(['fixed=[',repmat('%d,',size(fixed)),'],fixedparamval=[',repmat('%g,',size(fixed)),'],noise=%g,tskip=%d,xskip=%d'],fixed,fixed_param_val,noise_strength,t_skip,x_skip);
sgtitle(figtitle);
free_param_count=0;
for param=1:num_params
    if fixed(param)
        continue;
    end
    free_param_count = free_param_count+1;
    subplot(1,num_free_params,free_param_count);
    hold on;
    plot(param_vals(param,:),max_ls(param,:)-max(max_ls(param,:)));
    plot(param_vals(param,:),-2*ones(1,numpts));
    xlabel(param_names{param});
    ylabel('log(L)');
    axis('square');
    ylim([-2.5,0]);
    hold off;
end
saveas(fig,[prefix,'_',figtitle,'.png']);
save([prefix,'_',figtitle,'.mat'],'-mat');
