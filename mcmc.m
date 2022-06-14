load('simulations/kevindata_circle_xy1_20220405_raw.mat');
noisy_data=C_radial_avg;
nFrame=size(noisy_data,1);
ic=noisy_data(1,:)';
dt=1/3;
T=(nFrame-1)*dt+0.001;% helps with off-by-1 rounding
t_skip=1;
x_skip=1;
N=prod(ceil(size(noisy_data)./[t_skip,x_skip]));
threshold=-1;

fixed_param_val=[1300,0.27,1,1,1,0,2650]; % a 'good initial guess' for param values
scale=[1,0.0001,0.0001,0.0001,0.0001,0.0001,1];
param_names={'D0','r','alpha','beta','gamma','n','k'};
%leave sigma out
num_params=size(fixed_param_val,2);
%if fixed(i)==1, then the ith param is set to the true value and not optimized over
fixed=[0,0,1,1,1,1,0];
num_free_params=sum(1-fixed);
numeric_params=[T, dt/100, 100, NaN, NaN, 1];

noiseweight = max(num_pts_in_bins,1)';

figtitle=sprintf(['radial1D,mcmc,fixed=[',repmat('%d,',size(fixed)),'],fixedparamval=[',repmat('%g,',size(fixed)),'],1'],fixed,fixed_param_val);
logfile = [prefix,'_',figtitle,'_log.txt'];
diary(logfile);
fprintf('start run on: %s\n',datestr(datetime('now'), 'yyyymmdd_HHMMSS'));

%% chain
maxiter=1000;
samples=zeros(maxiter,num_free_params);
ls=zeros(maxiter,1);
samples(1,:)=fixed_param_val(fixed==0);
ls(1)=log_likelihood(squared_error(noisy_data,fixed_param_val,numeric_params,t_skip,x_skip,threshold,ic,rs,noiseweight),N);
iter=2;
total_sample=1;
while iter<maxiter
    proposal=samples(iter-1,:)+randn(1,num_free_params).*scale(fixed==0);
    proposal_params=fixed_param_val;
    proposal_params(fixed==0)=proposal;
    l=log_likelihood(squared_error(noisy_data,proposal_params,numeric_params,t_skip,x_skip,threshold,ic,rs,noiseweight),N);
    r=exp(l-ls(iter-1));
    if rand(1)<r
        samples(iter,:)=proposal;
        ls(iter)=l;
        fprintf(['iter=%d, accepted [',repmat('%.3f,',1,num_free_params),'], probability %.3f\n'],iter,proposal,r);
        iter=iter+1;
    else
        fprintf(['iter=%d, rejected [',repmat('%.3f,',1,num_free_params),'], probability %.3f\n'],iter,proposal,r);
    end
    total_sample=total_sample+1;
end

%% plot
fig=figure;
param1=1;
param2=2;
plot(samples(:,param1),samples(:,param2));
xlabel(param_names{1});
ylabel(param_names{2});