
for exp=1:8
    if any(exp==[1,2,5,6])
        load(sprintf('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy%d_20220405_raw.mat',exp),'noisy_data');
    else
        load(sprintf('/home/liuy1/Documents/woundhealing/simulations/kevindata_triangle_xy%d_20220405_raw.mat',exp),'noisy_data');
    end

    fig=figure('Position',[10 100 600 600],'color','w');
    data_vec=reshape(noisy_data(77,:,:),1,[]);
    fprintf('avg=%.2f, non-0 avg=%.2f\n',mean(data_vec),mean(data_vec(data_vec~=0)));
    cfig=imagesc(squeeze(noisy_data(77,:,:)),[0,6000]);
    if any(exp==[7,8])
        cfig=imagesc(fliplr(squeeze(noisy_data(77,:,:))),[0,6000]);
    end
    colormap('hot');
    axis off
    pbaspect([1 1 1]);
    ax=gca;
    ax.Position=[0,0,1,1];

    %saveas(fig,sprintf('figure/xy%d_finalcond.eps',exp),'epsc');
end

%% just for the colorbar 
fig2=figure('Position',[10 100 1000 600],'color','w');
cfig=imagesc(squeeze(noisy_data(77,:,:)),[0,6000]);
colormap('hot');
cb=colorbar;
cb.FontSize=28;
cb.Ticks=[0,2000,4000,6000];
% then take screenshot

%% looking at residual

load('simulations/kevindata_circle_xy1_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1200,0.3,1,1,1,0,2600,],kevindata,threshold=-1,tskip=1,xskip=1,7.mat');
[~,model_cc,~] = woundhealing_2d(optimal_param_vals,numeric_params,0,ic);
cc_diff=abs(model_cc-noisy_data);
model_cc1=reshape(model_cc,[],1);
cc_diff1=reshape(cc_diff,[],1);

figure;
plot(model_cc1,cc_diff1,'.');
