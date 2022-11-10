load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20221110_142214_D0=1300,r=0.3,alpha=1,beta=1,gamma=1,n=0,k=2600.0,dt=0.0333.mat');
% noise_strength=-2; % use -1 for segmented data
% if noise_strength==0.05
%     threshold=-1;
%     noisy_data=cc_noisy_005;
% elseif noise_strength==0.01
%     threshold=-1;
%     noisy_data=cc_noisy_001;
% elseif noise_strength==0
%     threshold=-1;
%     noisy_data=cc;
% elseif noise_strength==-1
%     threshold=0.5;
%     noisy_data=cc_seg;
% elseif noise_strength==-2
%     threshold=[0.1,0.9];
%     noisy_data=(double(cc>threshold(1))+double(cc>threshold(2)))/2;
% else
%     error('no such data\n');
% end
noise_strength=sigma_low;
threshold=-1;
noisy_data=cc_noisy_low;
%use only early data
% noisy_data=noisy_data(1:21,:);
% T=80;

t_skip=1;
x_skip=1;
N=prod(ceil(size(noisy_data)./[t_skip,x_skip])); % number of data pts

true_params=params;
fixed_param_val=[1300, 0.3, 1, 1, 1, 0.00, 2600];
%fixed_param_val=[500,0.05,1,1,1,0];
%lb=fixed_param_val.*[0.8,0.8,0.9,0.9,0.9,0.9];
%ub=fixed_param_val.*[1.2,1.2,1.1,1.1,1.1,1.1];
lb=[1295, 0.298, 0.85, 0.75, 0.7, 0.00, 2599];
ub=[1305, 0.302, 1.15, 1.10, 1.6, 0.03, 2601];
param_names={'D_0','r','alpha','beta','gamma','n','K'};
%leave sigma out
num_params=size(fixed_param_val,2);
%if fixed(i)==1, then the ith param is set to the true value and not optimized over
fixed=[0,0,1,1,1,1,0];
num_free_params=sum(1-fixed);
%numeric_params=[T, dt/100, 100, NaN, NaN, 1];

% feasible range for the optimization algorithm
lb_opt=[ 100, 0.01,  0.01,  0.01,  0.01, 0,   500]; %[0,0,0,0,0,0,0]
ub_opt=[5000, 5.00,  99.0,  99.0,  99.0, 4, 20000]; %[20000,5,10,10,10,10,10000]

figtitle=sprintf(['noise=%g,fixed=[',repmat('%d,',size(fixed)),'],fixedparamval=[',repmat('%g,',size(fixed)),'],threshold=%g,tskip=%d,xskip=%d',',2'],noise_strength,fixed,fixed_param_val,threshold,t_skip,x_skip);
logfile = [prefix,'_',figtitle,'_log.txt'];
diary(logfile);
fprintf('start run on: %s\n',datestr(datetime('now'), 'yyyymmdd_HHMMSS'));

%% overall max likelihood
[overall_minimizer,sigma,max_l,param_str,grad,hessian] = optimize_likelihood(fixed,fixed_param_val,lb_opt,ub_opt,noisy_data,numeric_params,t_skip,x_skip,threshold,ic,1,nan,nan);
fprintf(['Overall max likelihood param is: ',repmat('%.3f,',size(overall_minimizer)),'sigma=%.3f,maxLikelihood=%.3f\n'],overall_minimizer,sigma,max_l);
optimal_param_vals=fixed_param_val';
optimal_param_vals(fixed==0)=overall_minimizer;

aic = -2*max_l + 2*num_free_params;
bic = -2*max_l + log(N)*num_free_params;
fprintf('AIC=%.3f,BIC=%.3f\n',aic,bic);

%% profile likelihood for each param
numpts=21;
param_vals=zeros(num_params,numpts);
max_ls=zeros(num_params,numpts);
minimizers=cell(num_params,numpts);
% add the global optimum to the list of param vals
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
%         if i>1
%             initial(fixed_params==0)=minimizers{param,i-1};
%         end
        initial(fixed_params==0)=optimal_param_vals(fixed_params==0);
        initial(param)=param_vals(param,i);
        [minimizer,~,max_ls(param,i),~,~,~] = optimize_likelihood(fixed_params,initial,lb_opt,ub_opt,noisy_data,numeric_params,t_skip,x_skip,threshold,ic,1,nan,nan);
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
%     if any(max_ls(param,[1:10,13:21])==Inf)
%         max_ls_normalize=max_ls(param,[1:10,13:21]);
%         max_ls_normalize(max_ls_normalize~=Inf)=-Inf;
%         max_ls_normalize(max_ls_normalize==Inf)=0;
%     else
%         max_ls_normalize=max_ls(param,[1:10,13:21])-max(max_ls(param,[1:10,13:21]));
%     end
    %plot(param_vals(param,[1:10,13:21]),max_ls_normalize);
    %plot([min(param_vals(param,:)),max(param_vals(param,:))],[-2,-2]);
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy);
    plot([min(param_vals(param,:)),max(param_vals(param,:))],[-1.92,-1.92]);
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true max
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    xlabel(['$',param_names{param},'$'],'Interpreter','latex');
    ylabel('$\log(L)$','Interpreter','latex');
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
ff_str=strcat('ff=@(x) get_reduced_model_data(',param_str,',numeric_params,t_skip,x_skip,1,ic,nan);');
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
fprintf('finish run on: %s\n',datestr(datetime('now'), 'yyyymmdd_HHMMSS'));
diary off;
