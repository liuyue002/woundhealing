%load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20211116_153149_D0=500,r=0.12,alpha=1.5,beta=1.4,gamma=1,n=0,dt=0.02.mat');
%load('simulations/woundhealing_1d_20220308_173604_D0=1000,r=0.1,alpha=1,beta=1,gamma=1,n=1,dt=0.01.mat');
%load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20211116_135259_D0=500,r=0.05,alpha=1,beta=1,gamma=1,n=0,dt=0.02.mat');
load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20220321_172023_D0=500,r=0.05,alpha=1,beta=1,gamma=1,n=0,dt=0.01.mat');
noise_strength=-2; % use -1 for segmented data
if noise_strength==0.05
    threshold=-1;
    noisy_data=cc_noisy_005;
elseif noise_strength==0.01
    threshold=-1;
    noisy_data=cc_noisy_001;
elseif noise_strength==0
    threshold=-1;
    noisy_data=cc;
elseif noise_strength==-1
    threshold=0.5;
    noisy_data=cc_seg;
elseif noise_strength==-2
    threshold=[0.1,0.9];
    noisy_data=(double(cc>threshold(1))+double(cc>threshold(2)))/2;
else
    error('no such data\n');
end
%use only early data
% noisy_data=noisy_data(1:21,:);
% T=80;

t_skip=5;
x_skip=12;

true_params=params;
%fixed_param_val=true_params;
fixed_param_val=[500,0.05,1,1,1,0];
%lb=fixed_param_val.*[0.8,0.8,0.9,0.9,0.9,0.9];
%ub=fixed_param_val.*[1.2,1.2,1.1,1.1,1.1,1.1];
lb=[300,0.03,1.0,1.0,1,0];
ub=[700,0.07,1.0,1.0,1,0];
param_names={'D0','r','alpha','beta','gamma','n'};
%leave sigma out
num_params=size(true_params,2);
%if fixed(i)==1, then the ith param is set to the true value and not optimized over
fixed=[0,0,1,1,1,1];
num_free_params=sum(1-fixed);

%% overall max likelihood
[overall_minimizer,sigma,max_l,param_str,grad,hessian] = optimize_likelihood(fixed,fixed_param_val,lb,ub,noisy_data,T,t_skip,x_skip,threshold,NaN,0);
fprintf(['Overall max likelihood param is: ',repmat('%.3f,',size(overall_minimizer)),'sigma=%.3f,\n'],overall_minimizer,sigma);

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
        [minimizer,~,max_ls(param,i),~,~,~] = optimize_likelihood(fixed_params,initial,lb,ub,noisy_data,T,t_skip,x_skip,threshold,NaN,0);
        minimizers{param,i}=minimizer;
    end
end

%% plot
fig=figure('Position',[100 100 1400 400],'color','w');
figtitle=sprintf(['fixed=[',repmat('%d,',size(fixed)),'],fixedparamval=[',repmat('%g,',size(fixed)),'],noise=%g,tskip=%d,xskip=%d','_twothresholded'],fixed,fixed_param_val,noise_strength,t_skip,x_skip);
sgtitle(figtitle);
free_param_count=0;
for param=1:num_params
    if fixed(param)
        continue;
    end
    free_param_count = free_param_count+1;
    subplot(1,num_free_params,free_param_count);
    hold on;
    if any(max_ls(param,[1:10,13:21])==Inf)
        max_ls_normalize=max_ls(param,[1:10,13:21]);
        max_ls_normalize(max_ls_normalize~=Inf)=-Inf;
        max_ls_normalize(max_ls_normalize==Inf)=0;
    else
        max_ls_normalize=max_ls(param,[1:10,13:21])-max(max_ls(param,[1:10,13:21]));
    end
    plot(param_vals(param,[1:10,13:21]),max_ls_normalize);
    plot([min(param_vals(param,:)),max(param_vals(param,:))],[-2,-2]);
    xlabel(param_names{param});
    ylabel('log(L)');
    axis('square');
    xlim([min(param_vals(param,:)),max(param_vals(param,:))]);
    ylim([-2.5,0]);
    hold off;
end

%% fisher info
ff_str=strcat('ff=@(x) get_reduced_model_data(T,',param_str,',t_skip,x_skip,1);');
N=prod(ceil(size(noisy_data)./[t_skip,x_skip])); % number of data pts
eval(ff_str);
dXdtheta=zeros(N,num_free_params);
model_data0=ff(optimal_param_vals);
for i=1:num_free_params
    dtheta=0.00001;
    param_vals2=optimal_param_vals;
    param_vals2(i)=param_vals2(i)+dtheta;
    model_data_plus=ff(param_vals2);
    param_vals2(i)=param_vals2(i)-2*dtheta;
    model_data_minus=ff(param_vals2);
    dXdtheta(:,i)=(model_data_plus-model_data_minus)/(2*dtheta);
end
fim = sigma^2 * (dXdtheta'*dXdtheta);

%% save

saveas(fig,[prefix,'_',figtitle,'.png']);
save([prefix,'_',figtitle,'.mat'],'-mat');
