%load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20211015_163234_Dc=500_r=0.05_n=0_alpha=1_beta=1.mat');
load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20211116_135259_D0=500,r=0.05,alpha=1,beta=1,gamma=1,n=0,dt=0.02.mat');
%load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20211108_113846_D0=500,r=0.12,alpha=1.5,beta=1.4,gamma=1,n=0.mat');
noise_strength=0.05;
if noise_strength==0.05
    noisy_data=cc_noisy_005;
elseif noise_strength==0.01
    noisy_data=cc_noisy_001;
elseif noise_strength==0
    noisy_data=cc;
else
    error('no such data\n');
end
t_skip=10;
x_skip=30;
%use only early data
% noisy_data=noisy_data(1:21,:);
% nFrame=20;
% T=80;
%f=@(x) -log_likelihood_1d(noisy_data,T,x(1),x(2),x(3),x(4),x(5),t_skip,x_skip);
true_params=params;
fixed_param_val=true_params;
lb=true_params.*[0.8,0.8,0.9,0.9,0.9,0.9];
ub=true_params.*[1.2,1.2,1.1,1.1,1.1,1.1];
param_names={'D0','r','alpha','beta','gamma','n'};
%leave sigma out
num_params=size(true_params,2);
%if fixed(i)==1, then the ith param is set to the true value and not optimized over
fixed=[0,0,0,0,1,1];
num_free_params=sum(1-fixed);

%% overall max likelihood
[overall_minimizer,sigma,max_l,param_str,grad,hessian] = optimize_likelihood(fixed,fixed_param_val,lb,ub,noisy_data,T,t_skip,x_skip);

fprintf(['Overall max likelihood param is: ',repmat('%.3f,',size(overall_minimizer)),'sigma=%.3f,\n'],overall_minimizer,sigma);

% % fisher information
%addpath('/home/liuy1/Documents/woundhealing/DERIVESTsuite');
%eval(f_str);
%[grad,~,~] = gradest(f,overall_minimizer);
%[hess,err] = hessian(f,overall_minimizer);
%% profile likelihood for each param
numpts=21;
param_vals=zeros(num_params,numpts);
max_ls=zeros(num_params,numpts);
minimizers=cell(num_params,numpts);
% add the global optimum to the list of param vals
optimal_param_vals=fixed_param_val';
optimal_param_vals(fixed==0)=overall_minimizer;
param_vals=[param_vals,optimal_param_vals];
for param=1:num_params
    if fixed(param)
        continue;
    end
    param_vals(param,1:numpts)=linspace(lb(param),ub(param),numpts);
    param_vals(param,:)=sort(param_vals(param,:));
    fixed_params=fixed;
    fixed_params(param)=1;
    initial=fixed_param_val;
    for i=1:numpts+1
        fprintf('Optimizing for %s=%.3f\n',param_names{param},param_vals(param,i));
        if i>1
            initial(fixed_params==0)=minimizers{param,i-1};
        end
        initial(param)=param_vals(param,i);
        [minimizer,~,max_ls(param,i),~,~,~] = optimize_likelihood(fixed_params,initial,lb,ub,noisy_data,T,t_skip,x_skip);
        minimizers{param,i}=minimizer;
    end
end

%% plot
fig=figure('Position',[100 100 1400 400],'color','w');
figtitle=sprintf(['fixed=[',repmat('%d,',size(fixed)),'],fixedparamval=[',repmat('%g,',size(fixed)),'],noise=%g,tskip=%d,xskip=%d',''],fixed,fixed_param_val,noise_strength,t_skip,x_skip);
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
    plot(param_vals(param,:),-2*ones(size(param_vals(param,:))));
    xlabel(param_names{param});
    ylabel('log(L)');
    axis('square');
    ylim([-2.5,0]);
    hold off;
end

%% fisher info
ff_str=strcat('ff=@(x) get_reduced_model_data(T,',param_str,',t_skip,x_skip);');
N=prod(ceil(size(noisy_data)./[t_skip,x_skip])); % number of data pts
eval(ff_str);
dXdtheta=zeros(N,num_free_params);
model_data0=ff(optimal_param_vals);
for i=1:num_free_params
    dtheta=0.00001;
    param_vals=optimal_param_vals;
    param_vals(i)=param_vals(i)+dtheta;
    model_data_plus=ff(param_vals);
    param_vals(i)=param_vals(i)-2*dtheta;
    model_data_minus=ff(param_vals);
    dXdtheta(:,i)=(model_data_plus-model_data_minus)/(2*dtheta);
end
fim = sigma^2 * (dXdtheta'*dXdtheta);

%% save

saveas(fig,[prefix,'_',figtitle,'.png']);
save([prefix,'_',figtitle,'.mat'],'-mat');
