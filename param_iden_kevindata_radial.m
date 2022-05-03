%load('simulations/kevindata_circle_xy1_20220405_raw.mat');
load('simulations/kevindata_circle_xy2_20220405_raw.mat');
noisy_data=C_radial_avg;
nFrame=size(noisy_data,1);
N=numel(noisy_data);
ic=noisy_data(1,:)';
dt=1/3;
T=(nFrame-1)*dt+0.001;% helps with off-by-1 rounding
t_skip=1;
x_skip=1;
threshold=-1;

fixed_param_val=[1100,0.29,1,1,1,0,2460]; % a 'good guess' for param values
% range of param values to scan over for profile likelihood
lb=[1080,0.285,0.92,1.35,0.5,0,2454]; 
ub=[1180,0.3,0.98,1.55,1.5,0.06,2466];
param_names={'D0','r','alpha','beta','gamma','n','k'};
%leave sigma out
num_params=size(fixed_param_val,2);
%if fixed(i)==1, then the ith param is set to the true value and not optimized over
fixed=[0,0,1,1,1,1,0];
num_free_params=sum(1-fixed);
numeric_params=[T, dt/100, 100, NaN, nx, 1];

% feasible range for the optimization algorithm
lb_opt=[100,0.01,0.1,0.1,0.1,0,500]; %[0,0,0,0,0,0,0]
ub_opt=[5000,1,3,3,3,2,5000]; %[20000,5,10,10,10,10,10000]

%% overall minimizer

[overall_minimizer,sigma,max_l,param_str,~,~] = optimize_likelihood(fixed,fixed_param_val,lb_opt,ub_opt,noisy_data,numeric_params,t_skip,x_skip,threshold,ic,1,rs);
fprintf(['Overall max likelihood param is: ',repmat('%.3f,',size(overall_minimizer)),'sigma=%.3f,\n'],overall_minimizer,sigma);

%% profile likelihood

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
        [minimizer,~,max_ls(param,i),~,~,~] = optimize_likelihood(fixed_params,initial,lb,ub,noisy_data,T,t_skip,x_skip,threshold,ic,1,1,rs);
        minimizers{param,i}=minimizer;
    end
end

%% plot
fig=figure('Position',[100 100 1400 400],'color','w');
figtitle=sprintf(['fixed=[',repmat('%d,',size(fixed)),'],fixedparamval=[',repmat('%g,',size(fixed)),'],kevindata,threshold=%g,tskip=%d,xskip=%d',',radial,9'],fixed,fixed_param_val,threshold,t_skip,x_skip);
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
    plot([min(param_vals(param,:)),max(param_vals(param,:))],[-2,-2]);
    xlabel(param_names{param});
    ylabel('log(L)');
    axis('square');
    xlim([min(param_vals(param,:)),max(param_vals(param,:))]);
    ylim([-2.5,0]);
    hold off;
end
saveas(fig,[prefix,'_',figtitle,'.png']);
save([prefix,'_',figtitle,'.mat'],'-mat');