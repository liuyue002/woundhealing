%load('/home/liuy1/Documents/woundhealing/simulations/kevindata_highdensity_phase20220221_135604.mat')
%load('simulations/kevindata_highdensity_phase20220221_135604.mat')
%load('simulations/kevindata_circle_xy6_20220405_raw.mat');
load('simulations/kevindata_triangle_xy4_20220405_raw.mat');
%addpath('/home/liuy1/my_programs/nlopt/lib/matlab');
k=strfind(prefix,'/');
prefix=strcat('./simulations/',prefix(k(end)+1:end));
nFrame=size(noisy_data,1);
N=numel(noisy_data);
ic=squeeze(noisy_data(1,:,:));
dt=1/3;
T=(nFrame-1)*dt;
t_skip=1;
x_skip=1;
threshold=-1;

fixed_param_val=[2734,0.01,1.4043,0.2992,1,0,2265];
lb=[1150, 0.322, 0.8, 0.8, 0.60, 0.00, 2304];
ub=[1170, 0.326, 1.3, 1.3, 1.60, 1.00, 2309];
param_names={'D0','r','alpha','beta','gamma','n','k'};
%leave sigma out
num_params=size(fixed_param_val,2);
%if fixed(i)==1, then the ith param is set to the true value and not optimized over
fixed=[0,0,0,0,1,1,0];
num_free_params=sum(1-fixed);
numeric_params=[T, dt/10, 10, 4380, 4380, 150, 150];
% feasible range for the optimization algorithm
lb_opt=[ 100, 0.00001, 0.1, 0.1, 0.1, 0,  500]; %[0,0,0,0,0,0,0]
ub_opt=[5000,    1.00, 9.0, 9.0, 9.0, 4, 5000]; %[20000,5,10,10,10,10,10000]

figtitle=sprintf(['fixed=[',repmat('%d,',size(fixed)),'],fixedparamval=[',repmat('%g,',size(fixed)),'],kevindata,threshold=%g,tskip=%d,xskip=%d',',1'],fixed,fixed_param_val,threshold,t_skip,x_skip);
logfile = [prefix,'_',figtitle,'_log.txt'];
diary(logfile);
fprintf('start run on: %s\n',datestr(datetime('now'), 'yyyymmdd_HHMMSS'));
pc = parcluster('local');
pc.JobStorageLocation = strcat('/home/wolf5640/woundhealing/tmp/',getenv('SLURM_JOB_ID'));
parpool(pc);
ppool=gcp('nocreate');
fprintf('%s\n',matlab.unittest.diagnostics.ConstraintDiagnostic.getDisplayableString(ppool));

%% r vs D
% numpts=40;
% D0s=linspace(100,1000,numpts);
% rs=linspace(0.1,4,numpts);
% ls=zeros(numpts,numpts);
% for i=1:numpts
%     for j=1:numpts
%         ls(i,j)=log_likelihood(squared_error(noisy_data,T,[D0s(i),rs(j),1,1,1,0],t_skip,x_skip,threshold,ic),N);
%     end
% end
% %% plot r vs D
% fig=figure;
% imagesc(ls'); % need transpose + reverse axis to make it right
% set(gca,'YDir','normal');
% xlabel('D_0');
% ylabel('r');
% set(gca,'XTick',[1,round(numpts/2),numpts]);
% set(gca,'XTickLabel',num2str([D0s(1),D0s(round(numpts/2)),D0s(numpts)]','%.0f'));
% set(gca,'YTick',[1,round(numpts/2),numpts]);
% set(gca,'YTickLabel',num2str([rs(1),rs(round(numpts/2)),rs(numpts)]','%.1f'));
% 
% [~,I] = max(ls',[],'all','linear');
% [ix, iy] = ind2sub(size(ls'),I);
% hold on
% plot(iy,ix,'r*','MarkerSize',20);
% save([prefix,'_Dvsr.mat'],'-mat','-append');
% saveas(fig,[prefix,'_Dvsr.png']);
% % exit;%%%%%%%%%%%%%%

%% overall minimizer
[overall_minimizer,sigma,max_l,param_str,~,~] = optimize_likelihood(fixed,fixed_param_val,lb_opt,ub_opt,noisy_data,numeric_params,t_skip,x_skip,threshold,ic,2,NaN,NaN);
fprintf(['Overall max likelihood param is: ',repmat('%.3f,',size(overall_minimizer)),'sigma=%.3f,\n'],overall_minimizer,sigma);
%figure(fig);
%hold on
%plot(round((overall_minimizer(1)-D0s(1))/(D0s(end)-D0s(1))*numpts),round((overall_minimizer(2)-rs(1))/(rs(end)-rs(1))*numpts),'r*','MarkerSize',20);
%saveas(fig,[prefix,'_Dvsr.png']);

num_free_param=sum(fixed==0);
aic = -2*max_l + 2*num_free_param;
bic = -2*max_l + log(N)*num_free_param;
fprintf('AIC=%.3f,BIC=%.3f\n',aic,bic);

save([prefix,'_',figtitle,'.mat'],'-mat');

exit; %%%%%%%%%%%%%%%

%% profile likelihood

numpts=11;
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
%         if i>1
%             initial(fixed_params==0)=minimizers{param,i-1};
%         end
        initial(fixed_params==0)=optimal_param_vals(fixed_params==0);
        initial(param)=param_vals(param,i);
        [minimizer,~,max_ls(param,i),~,~,~] = optimize_likelihood(fixed_params,initial,lb_opt,ub_opt,noisy_data,numeric_params,t_skip,x_skip,threshold,ic,1,NaN,NaN);
        minimizers{param,i}=minimizer;
    end
end

%% plot
fig=figure('Position',[100 100 1400 400],'color','w');
sgtitle(figtitle);
free_param_count=0;
zs = cell(num_params,1);
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
    plot([min(param_vals(param,:)),max(param_vals(param,:))],[-1.96,-1.96]);
    xlabel(param_names{param});
    ylabel('log(L)');
    axis('square');
    xlim([min(param_vals(param,:)),max(param_vals(param,:))]);
    ylim([-2.5,0]);
    hold off;
    
    zs{param}=interp_zero(xx,yy+1.96);
    fprintf('Intercept at -2 for param %s are:\n',param_names{param});
    disp(zs{param});
end
saveas(fig,[prefix,'_',figtitle,'.png']);
save([prefix,'_',figtitle,'.mat'],'-mat');
fprintf('finish run on: %s\n',datestr(datetime('now'), 'yyyymmdd_HHMMSS'));
delete(ppool);
diary off;
