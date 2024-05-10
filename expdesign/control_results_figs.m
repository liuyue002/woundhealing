%%
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_20230704_184943_alpha=0.03,omega=0.10.mat');
%%
figure(figJ);
figJ.Position=[100,100,530,450];
xlabel('$i$ (Iteration)','Interpreter','latex');
ylabel('$J[u^i]$','Interpreter','latex');
yticks(-8e5:5e4:-7e5);
ytickformat('%.1f');
betterFig(figJ);
saveas(figJ,'figure/twomodel_control_20230704_184943_uk_alpha=0.03_figJ.eps','epsc');

fig1=figure('Position',[100,100,530,450]);
hold on;
plot(tfine,C(:,1));
plot(tfine,C(:,2));
plot(tfine,abs(C(:,1)-C(:,2)));
plot(tfine,uknum);
hold off
xlabel('$t$','interpreter','latex');
legend('$C_1$','$C_2$','$|C_1-C_2|$','$u_K^*$','location','northwest','interpreter','latex');
xlim([0,T]);
ylim([0,2600]);
betterFig(fig1);
saveas(fig1,'figure/twomodel_control_20230704_184943_uk_alpha=0.03_forward.eps','epsc');

fig2=figure('Position',[100,100,530,450]);
hold on;
plot(tfine,Lambda(:,1));
plot(tfine,Lambda(:,2));
hold off
xlabel('$t$','interpreter','latex');
legend('$\lambda_1$','$\lambda_2$','location','northeast','interpreter','latex');
xlim([0,T]);
ylim([-1.5e4,1.5e4]);
yticks(-1.5e4:1.5e4:1.5e4);
ytickformat('%.1f');
betterFig(fig2);
saveas(fig2,'figure/twomodel_control_20230704_184943_uk_alpha=0.03_backward.eps','epsc');

fig3=figure('Position',[100,100,530,450]);
plot(tfine,uknumnew);
xlabel('$t$','interpreter','latex');
legend('$u_K^{\textrm{new}}$','location','northeast','interpreter','latex');
xlim([0,T]);
ylim([0,1500]);
box off;
betterFig(fig3);
saveas(fig3,'figure/twomodel_control_20230704_184943_uk_alpha=0.03_unew.eps','epsc');

%%
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_20230615_104256_alpha=0.05,omega=0.10.mat');
fig1=figure('Position',[100,100,530,450]);
hold on;
plot(tfine,C(:,1));
plot(tfine,C(:,2));
plot(tfine,abs(C(:,1)-C(:,2)));
plot(tfine,uknum);
hold off
xlabel('$t$','interpreter','latex');
legend('$C_1$','$C_2$','$|C_1-C_2|$','$u_K^*$','location','northwest','interpreter','latex');
xlim([0,T]);
ylim([0,2600]);
betterFig(fig1);
saveas(fig1,'figure/twomodel_control_20230615_104256_uk_alpha=0.05_forward.eps','epsc');

%%
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_20230704_184943_alpha=0.03,omega=0.10.mat','tfine','T','uknum');
uknum_fbs=uknum;
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_fmincon_20230707_170211_alpha=0.03,omega=0.10.mat','uknum_best');
uknum_fmincon_coarse=uknum_best;
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_20230627_174137_alpha=0.03,omega=0.10_fmincon.mat','uknum_best');
uknum_hybrid=uknum_best;

fig1=figure('Position',[100,100,1130,450]);
tl=tiledlayout(1,2);
nexttile;
hold on;
plot(tfine,uknum_fbs);
plot(tfine,uknum_fmincon_coarse);
plot(tfine,uknum_hybrid);
hold off
xlabel('t','interpreter','latex');
%legend('FBS','Direct optimisation','Hybrid method','location','northeastoutside','interpreter','latex');
xlim([0,T]);
ylim([0,1300]);
rectangle('Position',[0,0,10,400],'LineStyle','--','LineWidth',2);

nexttile;
hold on;
plot(tfine,uknum_fbs);
plot(tfine,uknum_fmincon_coarse);
plot(tfine,uknum_hybrid);
hold off
xlabel('$t$','interpreter','latex');
legend('FBS','Direct optimisation','Hybrid method','location','northeastoutside','interpreter','latex');
xlim([0,10]);
ylim([0,400]);

betterFig(fig1);
saveas(fig1,'figure/twomodel_control_method_comparison.eps','epsc');

%%
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_20230704_184943_alpha=0.03,omega=0.10.mat','tfine','T','uknum');
uknum_continuous003=uknum;
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_20230615_104256_alpha=0.05,omega=0.10.mat','uknum');
uknum_continuous005=uknum;
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_bangbang_gen_20230911_173746_fixed=[111111100],alpha=[0,0,0.03].mat','control_params_best','ukfun');
uknum_bangbang=ukfun(tfine);

fig1=figure('Position',[100,100,800,450]);
hold on;
plot(tfine,uknum_continuous003);
plot(tfine,uknum_continuous005);
plot(tfine,uknum_bangbang);
hold off
xlabel('$t$','interpreter','latex');
legend('Continuous, $\alpha=0.03$','Continuous, $\alpha=0.05$','Bang-bang, $\alpha=0.03$','location','northeastoutside','interpreter','latex');
xlim([0,T]);
ylim([0,1300]);
betterFig(fig1);
saveas(fig1,'figure/twomodel_control_misc.eps','epsc');

%%
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_r_20230629_180209_alpha=500000.00,omega=0.10.mat')
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_bangbang_gen_20230911_175725_fixed=[100111111],alpha=[500000,500000,0.03].mat','urfun')
C=interp1(t,X,tfine);
fig1=figure('Position',[100,100,850,450]);
hold on;
plot(tfine,C(:,1));
plot(tfine,C(:,2));
plot(tfine,abs(C(:,1)-C(:,2)));
ylim([0,3600]);
ylabel('$C_1, C_2, |C_1-C_2|$','Interpreter','latex');
yyaxis right;
ytickformat('%.1f');
ylabel('$u_r$','Interpreter','latex');
plot(tfine,urnum);
plot(tfine,urfun(tfine));
ylim([0,1.1]);
hold off
xlabel('$t$','interpreter','latex');
legend('$C_1$','$C_2$','$|C_1-C_2|$','$u_r^*$ (continuous)','$u_r^*$ (bang-bang)','location','northeastoutside','interpreter','latex');
xlim([0,T]);
betterFig(fig1);
saveas(fig1,'figure/twomodel_control_r_20230629_180209_alpha=500000.00_forward.eps','epsc');

%%
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_kr_fmincon_20230825_205900_alphak=0.10,alphar=700000.00.mat')
load('simulations/twomodel_control_kr_fmincon_20231106_184438_alphak=0.10,alphar=700000.00.mat');

fig1=figure('Position',[100,100,560,450]);
hold on;
plot(tfine,uknum_best);
ylim([0,1300]);
ylabel('$u_K$','Interpreter','latex');
yyaxis right;
ytickformat('%.1f');
ylabel('$u_r$','Interpreter','latex');
plot(tfine,urnum_best);
ylim([0,1.0]);
hold off
xlabel('$t$','interpreter','latex');
xlim([0,T]);
betterFig(fig1);
saveas(fig1,'figure/twomodel_control_kr_fmincon_20231106_184438_alphak=0.10,alphar=700000_direct_opt.eps','epsc');

%%
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_k_r_d_20230823_173454_alpha=0.10,700000.000000,500000.000000,omega=0.10.mat')

uknumnew=fig.Children.Children(2).Children(3).YData;
urnumnew=fig.Children.Children(2).Children(2).YData/1000;

fig1=figure('Position',[100,100,690,450]);
hold on;
yyaxis left;
plot(tfine,uknum,'-','Color',[0 0.4470 0.7410]);
plot(tfine,uknumnew,'--','Color',[0 0.4470 0.7410]);
ylim([0,1300]);
xlabel('$t$',Interpreter='latex');
ylabel('$u_K$',Interpreter='latex');
yyaxis right;
plot(tfine,urnum,'-','Color',[0.8500 0.3250 0.0980]);
plot(tfine,urnumnew,'--','Color',[0.8500 0.3250 0.0980]);
ylabel('$u_r$',Interpreter='latex');
ylim([0,1]);
xlim([0,25]);
legend('$u_K$','$u_K^{\textrm{new}}$','$u_r$','$u_r^{\textrm{new}}$','Location','northeastoutside','interpreter','latex');
betterFig(fig1);
saveas(fig1,'figure/twomodel_control_k_r_d_20230823_173454_alpha=0.10,700000.000000,500000.000000_fbs.eps','epsc');

%%
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_kr_fmincon_20231106_175504_alphak=0.10,alphar=700000.00.mat')

fig1=figure('Position',[100,100,560,450]);
hold on;
plot(tfine,uknum_best);
ylim([0,1300]);
xlabel('$t$',Interpreter='latex');
ylabel('$u_K$',Interpreter='latex');
yyaxis right;
ytickformat('%.1f');
ylabel('$u_r$','Interpreter','latex');
plot(tfine,urnum_best);
ylim([0,1.0]);
hold off
xlim([0,T]);
betterFig(fig1);

saveas(fig1,'figure/twomodel_control_kr_fmincon_20231106_175504_alphak=0.10,alphar=700000_hybrid.eps','epsc');

%%
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_ud_relative_20230825_175703_alpha=1300000.00,omega=0.05.mat')
C=interp1(t,X,tfine);
fig1=figure('Position',[100,100,800,450]);
hold on;
plot(tfine,C(:,1));
plot(tfine,C(:,2));
plot(tfine,abs(C(:,1)-C(:,2)));
ylim([0,2600]);
ylabel('$C_1, C_2, |C_1-C_2|$','Interpreter','latex');
yyaxis right;
ytickformat('%.1f');
ylabel('$u_\delta$','Interpreter','latex');
plot(tfine,udnum);
ylim([0,0.6]);
hold off
xlabel('$t$','interpreter','latex');
legend('$C_1$','$C_2$','$|C_1-C_2|$','$u_\delta^*$','location','northeastoutside','interpreter','latex');
xlim([0,T]);
betterFig(fig1);

saveas(fig1,'figure/twomodel_control_ud_relative_20230825_175703_alpha=1300000_forward.eps','epsc');

%%
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_r_relative_20230820_171048_alpha=700000.00,omega=0.10.mat')

C=interp1(t,X,tfine);
fig1=figure('Position',[100,100,800,450]);
hold on;
plot(tfine,C(:,1));
plot(tfine,C(:,2));
plot(tfine,abs(C(:,1)-C(:,2)));
ylim([0,3200]);
ylabel('$C_1, C_2, |C_1-C_2|$','Interpreter','latex');
yyaxis right;
ytickformat('%.1f');
ylabel('$u_r$','Interpreter','latex');
plot(tfine,urnum);
ylim([0,0.6]);
hold off
xlabel('$t$','interpreter','latex');
legend('$C_1$','$C_2$','$|C_1-C_2|$','$u_r^*$','location','northeastoutside','interpreter','latex');
xlim([0,T]);
betterFig(fig1);

saveas(fig1,'figure/twomodel_control_r_relative_20230820_171048_alpha=700000_forward.eps','epsc');

%%
r1=0.225;
d1=0;
gamma1=8;
K1=2381;

r2=0.235;
d2=0;
gamma2=3;
K2=2433;

C0=100;

tfine=linspace(0,25,100);
sol1=sol_richards(tfine,[r1,d1,gamma1,K1],C0);
sol2=sol_richards(tfine,[r2,d2,gamma2,K2],C0);

fig1=figure('Position',[100,100,530,450]);
hold on;
plot(tfine, sol1);
plot(tfine, sol2);
hold off;
xlim([0,25]);
xlabel('t','interpreter','latex');
legend('$C_1$','$C_2$','interpreter','latex','location','southeast');
betterFig(fig1);

saveas(fig1,'figure/control_discrim_richards_sol.eps','epsc');

%%
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_gen_richard_20230914_005907_active=[0,0,1],absolute=0,alpha=[130000.00,130000.00,30000.00],omega=0.10.mat')
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_gen_richard_20230913_224440_active=[0,0,1],alpha=[500000.00,500000.00,0.03],omega=0.10.mat')

fig1=figure('Position',[100,100,660,450]);
hold on;
plot(ts,C(:,1));
plot(ts,C(:,2));
plot(ts,abs(C(:,1)-C(:,2)));
plot(ts,unum(3,:));
ylim([0,2600]);
hold off
xlabel('$t$','interpreter','latex');
ylabel('$C_1, C_2, |C_1-C_2|, u_K$','Interpreter','latex');
legend('$C_1$','$C_2$','$|C_1-C_2|$','$u_K^*$','location','northeastoutside','interpreter','latex');
xlim([0,T]);
betterFig(fig1);

saveas(fig1,'figure/twomodel_control_gen_richard_20230913_224440_active=[0,0,1],alpha=[500000.00,500000.00,0.03]_forward.eps','epsc');

%%
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_gen_richard_20230914_004743_active=[1,0,0],absolute=0,alpha=[130000.00,1300000.00,30000.00],omega=0.10.mat')
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_gen_richard_20230914_001355_active=[1,0,0],alpha=[30000.00,500000.00,0.03],omega=0.10.mat')

fig1=figure('Position',[100,100,800,450]);
hold on;
plot(ts,C(:,1));
plot(ts,C(:,2));
plot(ts,abs(C(:,1)-C(:,2)));
ylim([0,2600]);
ylabel('$C_1, C_2, |C_1-C_2|$','Interpreter','latex');
yyaxis right;
ytickformat('%.2f');
ylabel('$u_r$','Interpreter','latex');
plot(ts,unum(1,:));
ylim([0,0.3]);
hold off
xlabel('$t$','interpreter','latex');
legend('$C_1$','$C_2$','$|C_1-C_2|$','$u_r^*$','location','northeastoutside','interpreter','latex');
xlim([0,T]);
betterFig(fig1);

saveas(fig1,'figure/twomodel_control_gen_richard_20230914_001355_active=[1,0,0],alpha=[30000.00,500000.00,0.03]_forward.eps','epsc');

%%
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_gen_richard_20230914_002937_active=[0,1,0],alpha=[30000.00,500000.00,0.03],omega=0.10.mat')

fig1=figure('Position',[100,100,800,450]);
hold on;
plot(ts,C(:,1));
plot(ts,C(:,2));
plot(ts,abs(C(:,1)-C(:,2)));
ylim([0,2500]);
ylabel('$C_1, C_2, |C_1-C_2|$','Interpreter','latex');
yyaxis right;
ytickformat('%.2f');
ylabel('$u_\delta$','Interpreter','latex');
plot(ts,unum(2,:));
ylim([0,0.3]);
hold off
xlabel('$t$','interpreter','latex');
legend('$C_1$','$C_2$','$|C_1-C_2|$','$u_\delta^*$','location','northeastoutside','interpreter','latex');
xlim([0,T]);
betterFig(fig1);

saveas(fig1,'figure/twomodel_control_gen_richard_20230914_002937_active=[0,1,0],alpha=[30000.00,500000.00,0.03]_forward.eps','epsc');