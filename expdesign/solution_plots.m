%% plot some logistic solutions with varying ic
params=[0.3,0,1,2600];
fig=figure('Position',[50,50,1200,350],'color','w');
t=tiledlayout(1,3);
nexttile;
tt=linspace(0,25,100);
sol1=sol_richards(tt,params,1);
hold on;
plot(tt,sol1,'DisplayName','$C_0=1$');
plot([21.6,21.6],[-10,10000],':k','HandleVisibility','off');
hold off;
xlim([0,25]);
ylim([0,2600]);
legend('Interpreter','latex');
text(10,1700,'I','Interpreter','latex','FontSize',20);
text(23,1700,'II','Interpreter','latex','FontSize',20);
nexttile;
sol2=sol_richards(tt,params,100);
hold on;
plot(tt,sol2,'DisplayName','$C_0=100$');
plot([6.1,6.1],[-10,10000],':k','HandleVisibility','off');
plot([15.3,15.3],[-10,10000],':k','HandleVisibility','off');
hold off;
xlim([0,25]);
ylim([0,2600]);
legend('Interpreter','latex','location','southeast');
text(3,2000,'I','Interpreter','latex','FontSize',20);
text(10,2000,'II','Interpreter','latex','FontSize',20);
text(19,1200,'III','Interpreter','latex','FontSize',20);
nexttile;
sol2=sol_richards(tt,params,2300);
plot(tt,sol2,'DisplayName','$C_0=2300$');
xlim([0,25]);
ylim([0,2600]);
legend('Interpreter','latex');
text(7,1500,'III','Interpreter','latex','FontSize',20);
betterFig(fig);

saveas(fig,'figure/logistic_sigmoid_phases.eps','epsc');

%% some richards solution with different gamma
fig=figure;
hold on;
tt=linspace(0,25,100);
sol5=sol_richards(tt,[0.482,0,0.5,2380],100);
sol1=sol_richards(tt,[0.324,0,1,2380],100);
sol2=sol_richards(tt,[0.259,0,2,2380],100);
%sol3=sol_richards(tt,[0.242,0,3,2380],100);
sol4=sol_richards(tt,[0.225,0,8,2380],100);
plot(tt,sol5,'DisplayName','$\gamma=0.5$');
plot(tt,sol1,'DisplayName','$\gamma=1$');
plot(tt,sol2,'DisplayName','$\gamma=2$');
%plot(tt,sol3,'DisplayName','$\gamma=3$');
plot(tt,sol4,'DisplayName','$\gamma=8$');
legend('Location','southeast','Interpreter','latex');
xlim([0,25]);
betterFig(fig);

saveas(fig,'figure/richards_soln.eps','epsc');