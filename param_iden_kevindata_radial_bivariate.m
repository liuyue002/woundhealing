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

fixed_param_val=[1390,0.134,1.1,1.2,1,0,2664]; % a 'good guess' for param values
% range of param values to scan over for profile likelihood
lb=[1150, 0.050, 0.95, 0.95, 1.00, 0.000, 2590]; 
ub=[1650, 0.250, 1.25, 1.45, 1.60, 0.080, 2740];
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
param_names2={'$D_0$','$r$','alpha','beta','gamma','eta','K'};
%leave sigma out
num_params=size(fixed_param_val,2);
%if fixed(i)==1, then the ith param is set to the true value and not optimized over
fixed=[0,0,0,0,1,1,0];
param1=2; % which 2 params to loop over
param2=3;
numeric_params=[T, dt/100, 100, NaN, NaN, 1];

% feasible range for the optimization algorithm
lb_opt=[ 100, 0.01,  0.01,  0.01,  0.01, 0,   500]; %[0,0,0,0,0,0,0]
ub_opt=[5000, 5.00,  99.0,  99.0,  99.0, 4, 20000]; %[20000,5,10,10,10,10,10000]
noiseweight = max(num_pts_in_bins,1)';

figtitle=sprintf(['radial1D,bivariate,fixed=[',repmat('%d,',size(fixed)),'],%s,%s_20240703_5'],fixed,param_names2{param1},param_names2{param2});
logfile = [prefix,'_',figtitle,'_log.txt'];
diary(logfile);
fprintf('start run on: %s\n',datestr(datetime('now'), 'yyyymmdd_HHMMSS'));

fixed(param1)=1;
fixed(param2)=1;
num_free_params=sum(1-fixed);

%% r vs D
numpts=41;
p1s=linspace(lb(param1),ub(param1),numpts);
p2s=linspace(lb(param2),ub(param2),numpts);
ls=zeros(numpts,numpts);
minimizers=cell(numpts,numpts);
for i=1:numpts
    for j=1:numpts
        initial=fixed_param_val;
        initial(param1)=p1s(i);
        initial(param2)=p2s(j);
        fprintf('Optimizing for %s=%.3f,%s=%.3f\n',param_names{param1},initial(param1),param_names{param2},initial(param2));
        %shortcut
        if param1==2 && param2 ==5
            if (initial(param2)< -9.28*(initial(param1)-0.19)+1.55) || (initial(param2)> -9.28*(initial(param1)-0.19)+1.85)
                fprintf('Involking shortcut\n');
                ls(i,j)=-Inf;
                continue;
            end
        end
        if param1==2 && param2==3
            if (initial(param2)< -1.045*(initial(param1)-0.065)+1.145) || (initial(param2)> -1.045*(initial(param1)-0.065)+1.27)
                fprintf('Involking shortcut\n');
                ls(i,j)=-Inf;
                continue;
            end
        end

        if num_free_params==0
            ls(i,j)=log_likelihood(squared_error(noisy_data,initial,numeric_params,t_skip,x_skip,threshold,ic,rs,noiseweight),N);
            minimizers{i,j}=initial;
        else
            % optimize over parameters other than r and D
            [minimizer,~,max_l,~,~,~]=optimize_likelihood(fixed,initial,lb_opt,ub_opt,noisy_data,numeric_params,t_skip,x_skip,threshold,ic,1,rs,noiseweight,nan);
            ls(i,j)=max_l;
            initial(fixed==0)=minimizer;
            minimizers{i,j}=initial;
        end
    end
    save([prefix,'_',figtitle,'.mat'],'-mat');
end

%% plot r vs D
fig=figure;
imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
colorbar;
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");
set(gca,'XTick',[1,round(numpts/2),numpts]);
set(gca,'XTickLabel',num2str([p1s(1),p1s(ceil(numpts/2)),p1s(numpts)]','%.3f'));
set(gca,'YTick',[1,round(numpts/2),numpts]);
set(gca,'YTickLabel',num2str([p2s(1),p2s(ceil(numpts/2)),p2s(numpts)]','%.3f'));

[~,I] = max(ls',[],'all','linear');
[ix, iy] = ind2sub(size(ls'),I);
hold on
plot(iy,ix,'r*','MarkerSize',20);

%% contour
figcontour=figure;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls(1:36,:),[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
plot(p1s(iy),p2s(ix),'r*','MarkerSize',20);
xticks([p1s(1),p1s(round(numpts/2)),p1s(end)]);
yticks([p2s(1),p2s(round(numpts/2)),p2s(end)]);
ytickformat('%.3f');
colorbar;
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");
biggerFont(figcontour,18);

%% save
save([prefix,'_',figtitle,'.mat'],'-mat');
saveas(fig,[prefix,'_',figtitle,'.png']);
saveas(figcontour,[prefix,'_',figtitle,'_contour.png']);
saveas(figcontour,[prefix,'_',figtitle,'_contour.eps'],'epsc');
fprintf('finish run on: %s\n',datestr(datetime('now'), 'yyyymmdd_HHMMSS'));
diary off;