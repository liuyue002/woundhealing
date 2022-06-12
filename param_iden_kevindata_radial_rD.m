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

fixed_param_val=[1853,0.17,1,1,1,0,2615]; % a 'good guess' for param values
% range of param values to scan over for profile likelihood
lb=[1700, 0.15, 0.80, 0.60, 0.78, 0.115, 2600]; 
ub=[2000, 0.19, 1.10, 0.80, 0.88, 0.160, 2700];
param_names={'D0','r','alpha','beta','gamma','n','k'};
%leave sigma out
num_params=size(fixed_param_val,2);
%if fixed(i)==1, then the ith param is set to the true value and not optimized over
fixed=[1,1,1,1,0,1,0];
num_free_params=sum(1-fixed);
numeric_params=[T, dt/100, 100, NaN, NaN, 1];

% feasible range for the optimization algorithm
lb_opt=[ 100, 0.01,  0.01,  0.01,  0.01, 0,   500]; %[0,0,0,0,0,0,0]
ub_opt=[5000, 5.00,  99.0,  99.0,  99.0, 4, 20000]; %[20000,5,10,10,10,10,10000]
noiseweight = max(num_pts_in_bins,1)';

figtitle=sprintf(['radial1D,rvsD,fixed=[',repmat('%d,',size(fixed)),'],fixedparamval=[',repmat('%g,',size(fixed)),'],kevindata,threshold=%g,tskip=%d,xskip=%d',',1'],fixed,fixed_param_val,threshold,t_skip,x_skip);
logfile = [prefix,'_',figtitle,'_log.txt'];
diary(logfile);
fprintf('start run on: %s\n',datestr(datetime('now'), 'yyyymmdd_HHMMSS'));

%% r vs D
numpts=21;
D0s=linspace(lb(1),ub(1),numpts);
rss=linspace(lb(2),ub(2),numpts);
ls=zeros(numpts,numpts);
minimizers=cell(numpts,numpts);
for i=1:numpts
    for j=1:numpts
        initial=fixed_param_val;
        initial(1)=D0s(i);
        initial(2)=rss(j);
        fprintf('Optimizing for D=%.3f,r=%.3f\n',initial(1),initial(2));
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
imagesc(ls'); % need transpose + reverse axis to make it right
set(gca,'YDir','normal');
xlabel('D_0');
ylabel('r');
set(gca,'XTick',[1,round(numpts/2),numpts]);
set(gca,'XTickLabel',num2str([D0s(1),D0s(ceil(numpts/2)),D0s(numpts)]','%.0f'));
set(gca,'YTick',[1,round(numpts/2),numpts]);
set(gca,'YTickLabel',num2str([rs(1),rs(ceil(numpts/2)),rs(numpts)]','%.1f'));

[~,I] = max(ls',[],'all','linear');
[ix, iy] = ind2sub(size(ls'),I);
hold on
plot(iy,ix,'r*','MarkerSize',20);
save([prefix,'_Dvsr.mat'],'-mat');
saveas(fig,[prefix,'_Dvsr.png']);
diary off;