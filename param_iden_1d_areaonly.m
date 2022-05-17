load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20220321_172023_D0=500,r=0.05,alpha=1,beta=1,gamma=1,n=0,dt=0.01.mat');

true_params=params;
%fixed_param_val=true_params;
fixed_param_val=[500,0.05,1,1,1,1];
%lb=fixed_param_val.*[0.8,0.8,0.9,0.9,0.9,0.9];
%ub=fixed_param_val.*[1.2,1.2,1.1,1.1,1.1,1.1];
lb=[300,0.03,1.0,1.0,1,1];
ub=[700,0.07,1.0,1.0,1,1];
param_names={'D0','r','alpha','beta','gamma','n'};
%leave sigma out
num_params=size(true_params,2);
%if fixed(i)==1, then the ith param is set to the true value and not optimized over
fixed=[0,0,1,1,1,1];
num_free_params=sum(1-fixed);


%% r vs D
numpts=41;
D0s=linspace(300,700,numpts);
rs=linspace(0.03,0.07,numpts);
area_diff=zeros(numpts,numpts);
nFrame=size(cc,1);
for i=1:numpts
    for j=1:numpts
        [~,model_output,~,~] = woundhealing_1d([D0s(i),rs(j),1,1,1,0],T,0);
        areas_model=zeros(nFrame,1);
        for frame=1:nFrame
            areas_model(frame)=sum(model_output(frame,:)<0.5,'all');
        end
        area_diff(i,j)=sum((areas-areas_model).^2);
    end
end
%% plot r vs D
fig=figure;
imagesc(area_diff'); % need transpose + reverse axis to make it right
set(gca,'YDir','normal');
xlabel('D_0');
ylabel('r');
set(gca,'XTick',[1,round(numpts/2),numpts]);
set(gca,'XTickLabel',num2str([D0s(1),D0s(round(numpts/2)),D0s(numpts)]','%.0f'));
set(gca,'YTick',[1,round(numpts/2),numpts]);
set(gca,'YTickLabel',num2str([rs(1),rs(round(numpts/2)),rs(numpts)]','%.2f'));
colorbar;

[~,I] = min(area_diff',[],'all','linear');
[ix, iy] = ind2sub(size(area_diff'),I);
hold on
plot(iy,ix,'r*','MarkerSize',20);
save([prefix,'_Dvsr_areaonly.mat'],'-mat');
saveas(fig,[prefix,'_Dvsr_areaonly.png']);
