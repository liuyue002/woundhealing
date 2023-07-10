load('simulations/kevindata_triangle_xy3_20220405_raw.mat');

nFrame=size(noisy_data,1);
ic=squeeze(noisy_data(1,:,:));
dt=1/3;
T=(nFrame-1)*dt;
t_skip=1;
x_skip=1;
N=prod(ceil(size(noisy_data)./[t_skip,x_skip,x_skip]));
threshold=-1;

fixed_param_val=[1300,0.3,1,1,1,0,2600];
lb=[3000, 0.01, 1.0, 0.01, 7.70, 0.555, 2210];
ub=[3500, 0.06, 3.5, 0.90, 8.00, 0.580, 2230];
param_names={'D0','r','alpha','beta','gamma','n','k'};
%leave sigma out
num_params=size(fixed_param_val,2);
%if fixed(i)==1, then the ith param is set to the true value and not optimized over
fixed=[0,0,0,0,1,1,0];
num_free_params=sum(1-fixed);
numeric_params=[T, dt/10, 10, 4380, 4380, 150, 150];

figtitle=sprintf(['sweep_fixed=[',repmat('%d,',size(fixed)),'],fixedparamval=[',repmat('%g,',size(fixed)),'],kevindata,threshold=%g,tskip=%d,xskip=%d',',1'],fixed,fixed_param_val,threshold,t_skip,x_skip);
logfile = [prefix,'_',figtitle,'_log.txt'];
diary(logfile);
fprintf('start run on: %s\n',string(datetime,'yyyyMMdd_HHmmss'));
pc = parcluster('local');
pc.JobStorageLocation = strcat('/home/wolf5640/woundhealing/tmp/',getenv('SLURM_JOB_ID'));
parpool(pc);
ppool=gcp('nocreate');
fprintf('%s\n',matlab.unittest.diagnostics.ConstraintDiagnostic.getDisplayableString(ppool));

%% prepare

% an optimizer from previous runs, added to the mix of param values to try
prev_overall_minimizer = [3070,0.047,1.120,0.022,2214];
prev_optimal_param_vals=fixed_param_val;
prev_optimal_param_vals(fixed==0)=prev_overall_minimizer;
%max_l=squared_error(noisy_data,optimal_param_vals,numeric_params,t_skip,x_skip,threshold,ic,nan,nan);

numpts=20;
param_vals=zeros(num_params,numpts);
param_vals=[param_vals,prev_optimal_param_vals'];
for param=1:num_params
    if fixed(param)
        continue;
    end
    param_vals(param,1:numpts)=linspace(lb(param),ub(param),numpts);
    param_vals(param,:)=sort(param_vals(param,:));
end
numpts=numpts+1;

% assume 5 free params
param_vals2=cell(numpts,numpts,numpts,numpts,numpts);
errs=zeros(numpts,numpts,numpts,numpts,numpts);
likelihoods=zeros(numpts,numpts,numpts,numpts,numpts);
profile_l=zeros(num_params,numpts);
%% sweep

parfor i1=1:numpts
    for i2=1:numpts
        for i3=1:numpts
            for i4=1:numpts
                for i5=1:numpts
                    params=[param_vals(1,i1),param_vals(2,i2),param_vals(3,i3),param_vals(4,i4),1,0,param_vals(7,i5),];
                    param_vals2{i1,i2,i3,i4,i5}=params;
                    errs(i1,i2,i3,i4,i5)=squared_error(noisy_data,params,numeric_params,t_skip,x_skip,threshold,ic,nan,nan);
                    likelihoods(i1,i2,i3,i4,i5) = log_likelihood(errs(i1,i2,i3,i4,i5),N);
                end
            end
        end
    end
end

% intermediate save in case of error/crash...
save([prefix,'_',figtitle,'.mat'],'-mat');

%% analyze
[M,I] = max(likelihoods,[],"all");
[I1,I2,I3,I4,I5]=ind2sub([numpts,numpts,numpts,numpts,numpts],I);
best_found=param_vals2{I1,I2,I3,I4,I5};
fprintf(['best param found by sweep: ',repmat('%.3f,',size(best_found)),'\n'],best_found);

profile_l(1,:) = reshape(max(likelihoods,[],[2,3,4,5]), [1,numpts]);
profile_l(2,:) = reshape(max(likelihoods,[],[1,3,4,5]), [1,numpts]);
profile_l(3,:) = reshape(max(likelihoods,[],[1,2,4,5]), [1,numpts]);
profile_l(4,:) = reshape(max(likelihoods,[],[1,2,3,5]), [1,numpts]);
profile_l(7,:) = reshape(max(likelihoods,[],[1,2,3,4]), [1,numpts]);

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
    yy=profile_l(param,:)-max(profile_l(param,:));
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

%% save
saveas(fig,[prefix,'_',figtitle,'.png']);
save([prefix,'_',figtitle,'.mat'],'-mat');
fprintf('finish run on: %s\n',string(datetime,'yyyyMMdd_HHmmss'));
diary off;