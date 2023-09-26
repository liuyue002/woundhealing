% Perform identifiability analysis using profile likelihoods

% the dataset, can either be expeimental or synthetic
load('experimental_data/processed_data/xy1_data_processed.mat');
fulldataset=1; %whether we are using the full density or radially-averaged density
nFrame=size(noisy_data,1);
dt=1/3;
% down-sample the data spatially or temporally. 1 means use all data,
% 2 means use every 2nd datapoint, etc
t_skip=1; 
x_skip=1;
if fulldataset
    ic=squeeze(noisy_data(1,:,:));
    N=prod(ceil(size(noisy_data)./[t_skip,x_skip,x_skip])); % number of data pts
    rs=nan;
    noiseweight=nan;
    scaling=nan;
else
    noisy_data=C_radial_avg;
    ic=noisy_data(1,:)';
    N=prod(ceil(size(noisy_data)./[t_skip,x_skip])); % number of data pts
    noiseweight = max(num_pts_in_bins,1)';
    scaling=nan;
end
T=(nFrame-1)*dt+0.001*dt;% the 0.001 helps with off-by-1 rounding
threshold=-1; %(removed feature, not used)
% number of points to evaluate, recommend 11 for a relatively quick
% calculation, 41 for a better-looking plot
numpts=11;

% Which parameters are fixed at the default values, i.e. parameters not in
% the model currently considering.
% fixed=[0,0,1,1,1,1,0]; % Standard Fisher Model
% fixed=[0,0,1,1,1,0,0]; % Porous Fisher Model
% fixed=[0,0,1,1,0,1,0]; % Richards Model
% fixed=[0,0,0,0,1,1,0]; % Generalised Fisher Model
fixed=[0,0,1,1,1,1,0];
% The default parameter values. Fixed parameters (i.e. parameters not in 
% the model) will be set to these values. They are also used to initialise
% the optimisations of the likelihoods
fixed_param_val=[1200,0.3,1,1,1,0,2600];
% lower and upper bounds of the ranges for which we want to plot the
% profile likelihoods. Only matters for the non-fixed parameters
lb=[1270, 0.275, 0.5, 0.5, 0.70, 0.001, 2619];
ub=[1300, 0.280, 2.0, 2.0, 8.00, 0.600, 2624];
param_names={'D_0','r','\alpha','\beta','\gamma','\eta','K'};
num_params=size(fixed_param_val,2);
num_free_params=sum(1-fixed);
% parameters for numerical scheme for running model simulations
numeric_params=[T, dt/10, 10, 4380, 4380, 150, 150];
% feasible range for the optimization algorithm. The optimisation algorithm
% will not search outside of these ranges to optimise the likelihood. These
% bounds should be very wide so that the region of parameter space of
% interest is well within it.
lb_opt=[ 100, 0.01, 0.1, 0.1, 0.1, 0,  500];
ub_opt=[5000, 1.00, 9.0, 9.0, 9.0, 4, 5000];

% where the results are saved, should create the folder before running the script
prefix='output_folder/'; 
figtitle=sprintf(['identifiability_fixed=[',repmat('%d,',size(fixed)),'],fixedparamval=[',repmat('%g,',size(fixed)),'],experimental_data,tskip=%d,xskip=%d',',13'],fixed,fixed_param_val,t_skip,x_skip);
logfile = [prefix,'_',figtitle,'_log.txt'];
diary(logfile);
fprintf('start run on: %s\n',string(datetime('now'), 'yyyy/MM/dd HH:mm:ss'));

%% overall minimizer
[overall_minimizer,sigma,max_l,param_str,~,~] = optimize_likelihood(fixed,fixed_param_val,lb_opt,ub_opt,noisy_data,numeric_params,t_skip,x_skip,threshold,ic,2,rs,noiseweight,scaling);
fprintf(['Overall max likelihood param is: ',repmat('%.3f,',size(overall_minimizer)),'sigma=%.3f,\n'],overall_minimizer,sigma);

aic = -2*max_l + 2*num_free_params;
bic = -2*max_l + log(N)*num_free_params;
fprintf('AIC=%.3f,BIC=%.3f\n',aic,bic);
save([prefix,'_',figtitle,'.mat'],'-mat');

%% profile likelihood
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
    [~,mle_idx]=min(abs(param_vals(param,:)-optimal_param_vals(param)));
    fixed_params=fixed;
    fixed_params(param)=1;
    initial=fixed_param_val;
    minimizers{param,mle_idx}=optimal_param_vals(fixed_params==0);
    max_ls(param,mle_idx)=max_l;
    % Start from the MLE and proceed on both sides
    for i=mle_idx+1:numpts+1
        fprintf('Optimizing for %s=%.3f\n',param_names{param},param_vals(param,i));
        initial(fixed_params==0)=minimizers{param,i-1};
        initial(param)=param_vals(param,i);
        [minimizer,~,max_ls(param,i),~,~,~] = optimize_likelihood(fixed_params,initial,lb_opt,ub_opt,noisy_data,numeric_params,t_skip,x_skip,threshold,ic,1,rs,noiseweight,scaling);
        minimizers{param,i}=minimizer;
        save([prefix,'_',figtitle,'.mat'],'-mat');
    end
    for i=mle_idx-1:-1:1
        fprintf('Optimizing for %s=%.3f\n',param_names{param},param_vals(param,i));
        initial(fixed_params==0)=minimizers{param,i+1};
        initial(param)=param_vals(param,i);
        [minimizer,~,max_ls(param,i),~,~,~] = optimize_likelihood(fixed_params,initial,lb_opt,ub_opt,noisy_data,numeric_params,t_skip,x_skip,threshold,ic,1,rs,noiseweight,scaling);
        minimizers{param,i}=minimizer;
        save([prefix,'_',figtitle,'.mat'],'-mat');
    end
end

%% plot
fig=figure('Position',[100 100 1400 400],'color','w');
sgtitle(figtitle);
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
    else
        fprintf('Do not have 2 intercepts for param %s, they are:\n',param_names{param});
        disp(zs{param});
    end
end
%% Fisher information
% ff_str=strcat('ff=@(x) get_reduced_model_data(',param_str,',numeric_params,t_skip,x_skip,2,ic,nan);');
% eval(ff_str);
% dXdtheta=zeros(N,num_free_params);
% model_data0=ff(overall_minimizer);
% for i=1:num_free_params
%     dtheta=0.00001;
%     param_vals2=overall_minimizer;
%     param_vals2(i)=param_vals2(i)+dtheta;
%     model_data_plus=ff(param_vals2);
%     param_vals2(i)=param_vals2(i)-2*dtheta;
%     model_data_minus=ff(param_vals2);
%     dXdtheta(:,i)=(model_data_plus-model_data_minus)/(2*dtheta);
% end
% fim = sigma^2 * (dXdtheta'*dXdtheta);

%% save
saveas(fig,[prefix,'_',figtitle,'.png']);
save([prefix,'_',figtitle,'.mat'],'-mat');
fprintf('finish run on: %s\n',string(datetime('now'), 'yyyy/MM/dd HH:mm:ss'));
diary off;