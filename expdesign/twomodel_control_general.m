%% general setup
% whether the effects of the control variables are absolute (additive) or
% relative (multiplicative)
absolute = false;

% uall=[ur,ud,uk];
if absolute
    % effects of u's are additivie
    fgen = @(C,r,d,gamma,K,uall) (r+uall(1))*C.*(1-(C./(K-uall(3))).^gamma)-(d+uall(2))*C;
    dfdCgen= @(C,r,d,gamma,K,uall) (r+uall(1))*(1-(1+gamma)*(C./(K-uall(3))).^gamma)-(d+uall(2));
    % lower/upper bound for control variables
    lb = [0,0,0];
    ub = [0.5, 0.5, 1200];
    % weight of control cost
    alpha = [3e4, 3e4, 0.03];
    plotting_scale=[1000,1000,1];
    default_u = [0.1, 0.3, 700]; %starting point of optimisation
else
    % effects of u's are multiplicative
    fgen = @(C,r,d,gamma,K,uall) r*(1+uall(1))*C.*(1-(C./(K*(1-uall(3)))).^gamma)-d*(1+uall(2))*C;
    dfdCgen= @(C,r,d,gamma,K,uall) r*(1+uall(1))*(1-(1+gamma)*(C./(K*(1-uall(3)))).^gamma)-d*(1+uall(2));
    % lower/upper bound for control variables
    lb = [0,0,0];
    ub = [0.5, 0.5, 0.5];
    % weight of control cost
    alpha = [1.3e5, 3e4, 3e4];
    plotting_scale=[1000,1000,1000];
    default_u = [0, 0.3, 0]; %starting point of optimisation
end

r1=0.225;
d1=0;
gamma1=8;
K1=2381;

r2=0.235;
d2=0;
gamma2=3;
K2=2433;

active_u=logical([false, true, false]); % ud, ud, uk
% initial guess
ur=@(t) 0;
ud=@(t) 0.3;
uk=@(t) 0;

C0=100;
T=25;
upts=100;
odeopts = odeset('RelTol',1e-4,'AbsTol',1e-4,'MaxStep',T/upts);
omega=0.1;
Hgen = @(C1,C2,lambda1,lambda2,uall) (C1-C2).^2-alpha(1)*uall(1).^2-alpha(2)*uall(2).^2-alpha(3)*uall(3).^2 + lambda1*fgen(C1,r1,d1,gamma1,K1,uall) + lambda2*fgen(C2,r2,d2,gamma2,K2,uall);
H = @(C1,C2,lambda1,lambda2,u) Hgen(C1,C2,lambda1,lambda2,combine_u(u,active_u));

filename=sprintf('simulations/twomodel_control_gen_richard_%s_active=[%d,%d,%d],absolute=%d,alpha=[%.2f,%.2f,%.2f],omega=%.2f',string(datetime,'yyyyMMdd_HHmmss'),active_u,absolute,alpha,omega);
makeplot=true;
giffile=[filename,'.gif'];
logfile=[filename,'.txt'];
matfile=[filename,'.mat'];
if makeplot
    diary(logfile);
end
fprintf('start run on: %s\n',string(datetime,'yyyyMMdd_HHmmss'));

%% figure and initializations
ts=linspace(0,T,upts);
unum=zeros(3,upts);
if active_u(1)
    unum(1,:)=arrayfun(ur,ts);
end
if active_u(2)
    unum(2,:)=arrayfun(ud,ts);
end
if active_u(3)
    unum(3,:)=arrayfun(uk,ts);
end
Lambinit=[0;0];
Jold=nan;
maxiter=1000;
Js=zeros(maxiter,1);
Jmodels=zeros(maxiter,1);
Jcontrols=zeros(maxiter,1);

if makeplot
    fig=figure('visible','on','Position',[50,200,1700,600]);
    tiles=tiledlayout(1,3);
    ax1=nexttile;
    hold on
    c1plot=plot(ax1,ts,zeros(size(ts)),'DisplayName','C_1');
    c2plot=plot(ax1,ts,zeros(size(ts)),'DisplayName','C_2');
    cdiffplot=plot(ax1,ts,zeros(size(ts)),'DisplayName','|C_1-C_2|');
    urplot=plot(ax1,ts,zeros(size(ts)),'DisplayName',sprintf('u_r*%d',plotting_scale(1)));
    udplot=plot(ax1,ts,zeros(size(ts)),'DisplayName',sprintf('u_d*%d',plotting_scale(2)));
    ukplot=plot(ax1,ts,zeros(size(ts)),'DisplayName',sprintf('u_k*%d',plotting_scale(3)));
    hold off
    xlabel('t');
    legend();
    xlim([0,T]);
    ylim([0,2600]);
    xtitle=title('Forward');
    %set(ax1,'FontSize', 20);
    %set(findall(ax1, 'Type', 'Line'),'LineWidth',4);
    ax2=nexttile;
    hold on
    l1plot=plot(ax2,ts,zeros(size(ts)),'DisplayName','\lambda_1');
    l2plot=plot(ax2,ts,zeros(size(ts)),'DisplayName','\lambda_1');
    hold off
    xlabel('t');
    legend();
    xlim([0,T]);
    %ylim([0,3]);
    ltitle=title('Backward');
    ax3=nexttile;
    hold on;
    urnewplot=plot(ax3,ts,zeros(size(ts)),'DisplayName',sprintf('u_rnew*%d',plotting_scale(1)));
    udnewplot=plot(ax3,ts,zeros(size(ts)),'DisplayName',sprintf('u_dnew*%d',plotting_scale(2)));
    uknewplot=plot(ax3,ts,zeros(size(ts)),'DisplayName',sprintf('u_knew*%d',plotting_scale(3)));
    hold off;
    xlabel('t');
    legend();
    xlim([0,T]);
    ylim([0,1500]);
    title('u update');
    %set(ax2,'FontSize', 20);
    %set(findall(ax2, 'Type', 'Line'),'LineWidth',4);
    figtitle=sgtitle('title');
    tiles.Padding="tight";
    tiles.TileSpacing="tight";
    drawnow;
end

%% forward-backward sweep
for iter=1:maxiter
    [Js(iter),Jcontrols(iter),Jmodels(iter),C,Lambda]=J(C0,T,ts,unum,fgen,dfdCgen,r1,d1,gamma1,K1,r2,d2,gamma2,K2,alpha);

    if iter==1
        Jgain = nan;
    else
        Jgain = -(Js(iter)-Js(iter-1));
        if Jgain<0
            % adaptive step size
            omega=omega/2;
            fprintf('reduced omega to %f\n',omega);
        end
    end
    fprintf('Iteration %d: Jcontrol=%.5f, Jmodel=%.5f, J=%.5f, gain = %.5f\n',iter,Jcontrols(iter),Jmodels(iter),Js(iter),Jgain);

    % update control
    unumnew=zeros(size(unum));
    for i=1:upts
        objective=@(u) -H(C(i,1),C(i,2),Lambda(i,1),Lambda(i,2),u);
        prob = createOptimProblem('fmincon','x0',default_u(active_u),'objective',objective,'lb',lb(active_u),'ub',ub(active_u));
        gs = GlobalSearch('Display','off');
        sol=run(gs,prob);
        unumnew(active_u,i)=sol;
    end

    if makeplot
        c1plot.YData=C(:,1);
        c2plot.YData=C(:,2);
        cdiffplot.YData=abs(C(:,1)-C(:,2));
        urplot.YData=unum(1,:)*plotting_scale(1);
        udplot.YData=unum(2,:)*plotting_scale(2);
        ukplot.YData=unum(3,:)*plotting_scale(3);
        l1plot.YData=Lambda(:,1);
        l2plot.YData=Lambda(:,2);
        urnewplot.YData=unumnew(1,:)*plotting_scale(1);
        udnewplot.YData=unumnew(2,:)*plotting_scale(2);
        uknewplot.YData=unumnew(3,:)*plotting_scale(3);
        figtitle.String=['Iteration=',num2str(iter),', Jcontrol=',num2str(Jcontrols(iter),'%.02f'),', Jmodel=',num2str(Jmodels(iter),'%.02f'),', Jtotal=',num2str(Js(iter),'%.02f'),];
        drawnow;
        frame = getframe(fig);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        if iter == 1
            imwrite(imind,cm,giffile,'gif','DelayTime',0.5, 'Loopcount',inf);
        else
            imwrite(imind,cm,giffile,'gif','DelayTime',0.5,'WriteMode','append');
        end
    end

    if abs(Jgain)<0.01
        fprintf('Converged.\n');
        break;
    end

    unum = unum*(1-omega) +unumnew*omega;
end

%% history of J
figJ = figure;
hold on;
plot(Js(1:iter));
%plot(Jcontrols(1:iter));
%plot(Jmodels(1:iter));
%legend('J total','J control','J model');
xlabel('iter');
ylabel('J');

%% save
fprintf('finish run on: %s\n',string(datetime,'yyyyMMdd_HHmmss'));
if makeplot
    save(matfile,'-mat');
    saveas(fig,[filename,'.png']);
    saveas(figJ,[filename,'_Jhistory.png']);
    diary off;
end


%% helper functions
function uall = combine_u(u,active_u)
uall=[0,0,0];
uall(active_u)=u;
end

function [J,Jcontrol,Jmodel,C,Lambda] = J(C0,T,ts,unum,fgen,dfdCgen,r1,d1,gamma1,K1,r2,d2,gamma2,K2,alpha)
odeopts = odeset('RelTol',1e-4,'AbsTol',1e-4,'MaxStep',T/100);
Lambinit=[0;0];
uall = @(t) [interp1(ts,unum(1,:),t),...
             interp1(ts,unum(2,:),t),...
             interp1(ts,unum(3,:),t)];
%forward
odefunC=@(t,C) [fgen(C(1),r1,d1,gamma1,K1,uall(t));
                fgen(C(2),r2,d2,gamma2,K2,uall(t))];
[t,X]=ode45(odefunC,[0,T],[C0;C0],odeopts);

%backward
C1fun=@(tt)interp1(t,X(:,1),tt)';
C2fun=@(tt)interp1(t,X(:,2),tt)';
odefunLamb=@(t,lambdas) [-2*(C1fun(t)-C2fun(t))-lambdas(1)*dfdCgen(C1fun(t),r1,d1,gamma1,K1,uall(t));
                         +2*(C1fun(t)-C2fun(t))-lambdas(2)*dfdCgen(C2fun(t),r2,d2,gamma2,K2,uall(t));];
[t2,Lamb]=ode45(odefunLamb,[T,0],Lambinit,odeopts);
%reverse the time
t2=flipud(t2);
Lamb=flipud(Lamb);

%calculate J (want to minimize J)
Jcontrol=alpha*trapz(ts,unum.^2,2);
Jmodel=trapz(t,-(X(:,1)-X(:,2)).^2);
J=Jmodel + Jcontrol;

nt=length(ts);
C=zeros(nt,2);
C(:,1)=interp1(t,X(:,1),ts);
C(:,2)=interp1(t,X(:,2),ts);
Lambda=zeros(nt,2);
Lambda(:,1)=interp1(t2,Lamb(:,1),ts);
Lambda(:,2)=interp1(t2,Lamb(:,2),ts);
end