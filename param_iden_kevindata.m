load('/home/liuy1/Documents/woundhealing/simulations/kevindata_highdensity_phase20220221_135604.mat')
nFrame=size(noisy_data,1);
N=numel(noisy_data);
ic=squeeze(noisy_data(1,:,:));
T=23;
t_skip=1;
x_skip=1;

fixed_param_val=[350,1,1,1,1,3.79];
lb=[11000,0.9,1,1,1,3.5];
ub=[12000,1.1,1,1,1,4];
param_names={'D0','r','alpha','beta','gamma','n'};
%leave sigma out
num_params=size(fixed_param_val,2);
%if fixed(i)==1, then the ith param is set to the true value and not optimized over
fixed=[0,0,1,1,1,0];
num_free_params=sum(1-fixed);
%% r vs D
% numpts=40;
% D0s=linspace(100,1000,numpts);
% rs=linspace(0.3,2,numpts);
% ls=zeros(numpts,numpts);
% for i=1:numpts
%     for j=1:numpts
%         ls(i,j)=log_likelihood(squared_error(noisy_data,T,[D0s(i),rs(j),1,1,1,0],t_skip,x_skip,ic),N);
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
% save([prefix,'.mat'],'-mat','-append');

%% overall iminimizer

[overall_minimizer,sigma,max_l,param_str,grad,hessian] = optimize_likelihood(fixed,fixed_param_val,lb,ub,noisy_data,T,t_skip,x_skip,ic);
fprintf(['Overall max likelihood param is: ',repmat('%.3f,',size(overall_minimizer)),'sigma=%.3f,\n'],overall_minimizer,sigma);
%figure(fig);
%hold on
%plot(round((overall_minimizer(1)-D0s(1))/(D0s(end)-D0s(1))*numpts),round((overall_minimizer(2)-rs(1))/(rs(end)-rs(1))*numpts),'r*','MarkerSize',20);
%saveas(fig,[prefix,'_Dvsr.png']);
%save([prefix,'.mat'],'-mat','-append');

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
        [minimizer,~,max_ls(param,i),~,~,~] = optimize_likelihood(fixed_params,initial,lb,ub,noisy_data,T,t_skip,x_skip,ic);
        minimizers{param,i}=minimizer;
    end
end

%% plot
fig=figure('Position',[100 100 1400 400],'color','w');
figtitle=sprintf(['fixed=[',repmat('%d,',size(fixed)),'],fixedparamval=[',repmat('%g,',size(fixed)),'],kevindata,tskip=%d,xskip=%d','_2'],fixed,fixed_param_val,t_skip,x_skip);
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