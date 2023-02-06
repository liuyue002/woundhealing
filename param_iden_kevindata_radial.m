load('simulations/kevindata_circle_xy1_20220405_raw.mat');
noisy_data=C_radial_avg;
nFrame=size(noisy_data,1);
ic=noisy_data(1,:)';
dt=1/3;
T=(nFrame-1)*dt+0.001;% helps with off-by-1 rounding
t_skip=1;
x_skip=1;
N=prod(ceil(size(noisy_data)./[t_skip,x_skip])); % number of data pts
threshold=-1;

fixed_param_val=[1692,0.1844,1.0196,0.6993,1,0,2587]; % a 'good guess' for param values
% range of param values to scan over for profile likelihood
lb=[1550, 0.12, 0.80, 0.50, 0.80, 0.00, 2570]; 
ub=[1850, 0.25, 1.10, 0.90, 1.70, 0.06, 2600];
%scaling = [1000, 1, 1, 1, 1, 1, 1000];
scaling = nan;
param_names={'D0','r','alpha','beta','gamma','n','k'};
%leave sigma out
num_params=size(fixed_param_val,2);
%if fixed(i)==1, then the ith param is set to the true value and not optimized over
fixed=[0,0,0,0,1,1,0];
num_free_params=sum(1-fixed);
numeric_params=[T, dt/100, 100, NaN, NaN, 1];

% feasible range for the optimization algorithm
lb_opt=[ 100, 0.01,  0.01,  0.01,  0.01, 0,   500]; %[0,0,0,0,0,0,0]
ub_opt=[5000, 5.00,   9.0,   9.0,   9.0, 4, 20000]; %[20000,5,10,10,10,10,10000]
noiseweight = max(num_pts_in_bins,1)';
starttime=string(datetime,'yyyyMMddHHmm');
figtitle=sprintf(['radial1D,weighted,fixed=[',repmat('%d,',size(fixed)),'],fixedparamval=[',repmat('%g,',size(fixed)),'],kevindata,threshold=%g,tskip=%d,xskip=%d',',%s'],fixed,fixed_param_val,threshold,t_skip,x_skip,starttime);
logfile = [prefix,'_',figtitle,'_log.txt'];
diary(logfile);
fprintf('start run on: %s\n',string(datetime('now'), 'yyyy/MM/dd HH:mm:ss'));
%% overall minimizer

[overall_minimizer,sigma,max_l,param_str,~,~] = optimize_likelihood(fixed,fixed_param_val,lb_opt,ub_opt,noisy_data,numeric_params,t_skip,x_skip,threshold,ic,1,rs,noiseweight,scaling);
fprintf(['Overall max likelihood param is: ',repmat('%.3f,',size(overall_minimizer)),'sigma=%.3f,maxLikelihood=%.3f\n'],overall_minimizer,sigma,max_l);

aic = -2*max_l + 2*num_free_params;
bic = -2*max_l + log(N)*num_free_params;
fprintf('AIC=%.3f,BIC=%.3f\n',aic,bic);
save([prefix,'_',figtitle,'.mat'],'-mat');

%% profile likelihood

numpts=41;
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
    for i=mle_idx+1:numpts+1
        fprintf('Optimizing for %s=%.3f\n',param_names{param},param_vals(param,i));
%         if i>1
%             initial(fixed_params==0)=minimizers{param,i-1};
%         end
        %initial(fixed_params==0)=optimal_param_vals(fixed_params==0);
        initial(fixed_params==0)=minimizers{param,i-1};
        initial(param)=param_vals(param,i);
        [minimizer,~,max_ls(param,i),~,~,~] = optimize_likelihood(fixed_params,initial,lb_opt,ub_opt,noisy_data,numeric_params,t_skip,x_skip,threshold,ic,1,rs,noiseweight,scaling);
        minimizers{param,i}=minimizer;
    end
    for i=mle_idx-1:-1:1
        fprintf('Optimizing for %s=%.3f\n',param_names{param},param_vals(param,i));
        initial(fixed_params==0)=minimizers{param,i+1};
        initial(param)=param_vals(param,i);
        [minimizer,~,max_ls(param,i),~,~,~] = optimize_likelihood(fixed_params,initial,lb_opt,ub_opt,noisy_data,numeric_params,t_skip,x_skip,threshold,ic,1,rs,noiseweight,scaling);
        minimizers{param,i}=minimizer;
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

%% fisher info
ff_str=strcat('ff=@(x) get_reduced_model_data(',param_str,',numeric_params,t_skip,x_skip,1,ic,rs);');
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
fprintf('finish run on: %s\n',string(datetime('now'), 'yyyy/MM/dd HH:mm:ss'));
diary off;
