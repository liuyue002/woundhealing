load('simulations/kevindata_circle_xy1_20220405_raw.mat');
noisy_data=C_radial_avg;
nFrame=size(noisy_data,1);
N=numel(noisy_data);
ic=noisy_data(1,:)';
dt=1/3;
T=(nFrame-1)*dt+0.001;% helps with off-by-1 rounding
t_skip=1;
x_skip=1;
threshold=-1;

fixed_param_val=[1300,0.26,1,1,1,0,2645]; % a 'good guess' for param values
% range of param values to scan over for profile likelihood
lb=[1250, 0.255, 0.80, 0.60, 0.78, 0.115, 2630]; 
ub=[1350, 0.280, 1.10, 0.80, 0.88, 0.160, 2660];
param_names={'D0','r','alpha','beta','gamma','n','k'};
%leave sigma out
num_params=size(fixed_param_val,2);
%if fixed(i)==1, then the ith param is set to the true value and not optimized over
fixed=[0,0,1,1,1,1,0];
param1=1; % which 2 params to loop over
param2=2;
fixed(param1)=1;
fixed(param2)=1;
num_free_params=sum(1-fixed);
numeric_params=[T, dt/100, 100, NaN, NaN, 1];

% feasible range for the optimization algorithm
lb_opt=[ 100, 0.01,  0.01,  0.01,  0.01, 0,   500]; %[0,0,0,0,0,0,0]
ub_opt=[5000, 5.00,  99.0,  99.0,  99.0, 4, 20000]; %[20000,5,10,10,10,10,10000]
noiseweight = max(num_pts_in_bins,1)';

figtitle=sprintf(['radial1D,bivariate,fixed=[',repmat('%d,',size(fixed)),'],%s,%s_1'],fixed,param_names{param1},param_names{param2});
logfile = [prefix,'_',figtitle,'_log.txt'];
diary(logfile);
fprintf('start run on: %s\n',datestr(datetime('now'), 'yyyymmdd_HHMMSS'));
pc = parcluster('local');
pc.JobStorageLocation = strcat('/home/wolf5640/woundhealing/tmp/',getenv('SLURM_JOB_ID'));
parpool(pc);
ppool=gcp('nocreate');
fprintf('%s\n',matlab.unittest.diagnostics.ConstraintDiagnostic.getDisplayableString(ppool));

%% r vs D
numpts=21;
p1s=linspace(lb(param1),ub(param1),numpts);
p2s=linspace(lb(param2),ub(param2),numpts);
ls=zeros(numpts,numpts);
minimizers=cell(numpts,numpts);
parfor i=1:numpts
    for j=1:numpts
        initial=fixed_param_val;
        initial(param1)=p1s(i);
        initial(param2)=p2s(j);
        fprintf('Optimizing for %s=%.3f,%s=%.3f\n',param_names{param1},initial(param1),param_names{param2},initial(param2));
        if num_free_params==0
            ls(i,j)=log_likelihood(squared_error(noisy_data,initial,numeric_params,t_skip,x_skip,threshold,ic,rs,noiseweight),N);
            minimizers{i,j}=initial;
        else
            % optimize over parameters other than r and D
            [minimizer,~,max_l,~,~,~]=optimize_likelihood(fixed,initial,lb_opt,ub_opt,noisy_data,numeric_params,t_skip,x_skip,threshold,ic,1,rs,noiseweight);
            ls(i,j)=max_l;
            initial(fixed==0)=minimizer;
            minimizers{i,j}=initial;
        end
    end
end

%% plot r vs D
fig=figure;
imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
colorbar;
set(gca,'YDir','normal');
xlabel(param_names{param1});
ylabel(param_names{param2});
set(gca,'XTick',[1,round(numpts/2),numpts]);
set(gca,'XTickLabel',num2str([p1s(1),p1s(ceil(numpts/2)),p1s(numpts)]','%.3f'));
set(gca,'YTick',[1,round(numpts/2),numpts]);
set(gca,'YTickLabel',num2str([p2s(1),p2s(ceil(numpts/2)),p2s(numpts)]','%.3f'));

[~,I] = max(ls',[],'all','linear');
[ix, iy] = ind2sub(size(ls'),I);
hold on
plot(iy,ix,'r*','MarkerSize',20);

%% save
save([prefix,figtitle,'.mat'],'-mat');
saveas(fig,[prefix,'_',figtitle,'.png']);
fprintf('finish run on: %s\n',datestr(datetime('now'), 'yyyymmdd_HHMMSS'));
delete(ppool);
diary off;