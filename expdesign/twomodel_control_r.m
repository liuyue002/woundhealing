%% set up
f = @(C,r,d,gamma,K,ur) (r+ur)*C.*(1-(C./K).^gamma)-d*C;
dfdC= @(C,r,d,gamma,K,ur) (r+ur)*(1-(1+gamma)*(C./K).^gamma)-d;

r1=0.45;
d1=0.15;
gamma1=1;
K1=3900;

r2=0.3;
d2=0;
gamma2=1;
K2=2600;

C0=100;
T=25;
upts=100;
odeopts = odeset('RelTol',1e-4,'AbsTol',1e-4,'MaxStep',T/upts);
alpha=5e5; % weight of control cost
omega=0.1; % control update rate
urlim = 1; %upper bound for ur
bangbang=false;

if bangbang
    H = @(C1,C2,lambda1,lambda2,u) (C1-C2).^2-alpha*u + lambda1*f(C1,r1,d1,gamma1,K1,u) + lambda2*f(C2,r2,d2,gamma2,K2,u);
else
    H = @(C1,C2,lambda1,lambda2,u) (C1-C2).^2-alpha*u.^2 + lambda1*f(C1,r1,d1,gamma1,K1,u) + lambda2*f(C2,r2,d2,gamma2,K2,u);
end
%fminconopts=optimoptions('fmincon');
%fminconopts.Display='none';
fminconopts=optimoptions(@fmincon,'Algorithm','interior-point','Display','none');
% optiminits=[0,urlim/3,urlim*2/3,urlim];
% urvar=optimvar("ur",LowerBound=0,UpperBound=urlim);
% ms=MultiStart("Display","off");
filename=sprintf('simulations/twomodel_control_r_%s_alpha=%.2f,omega=%.2f',string(datetime,'yyyyMMdd_HHmmss'),alpha,omega);
makeplot=true;
giffile=[filename,'.gif'];
logfile=[filename,'.txt'];
matfile=[filename,'.mat'];
if makeplot
    diary(logfile);
end
fprintf('start run on: %s\n',string(datetime,'yyyyMMdd_HHmmss'));
%% figure and initializations
% initial guess
ur=@(t) ((t>0)&(t<(15)))*0.1;
%ur=@(t) ((t>15)&(t<(20)))*urlim;
%ur=@(t) -10*t.*(t-T);
%ur=@(t) 0.1;
%ur=@(t) urlim;
tfine=linspace(0,T,upts);
urnum=arrayfun(ur,tfine);
Lambinit=[0;0];
Jold=nan;

if makeplot
    fig=figure('visible','on','Position',[50,200,1700,600]);
    tiles=tiledlayout(1,3);
    ax1=nexttile;
    hold on
    c1plot=plot(ax1,[0],[0]);
    c2plot=plot(ax1,[0],[0]);
    cdiffplot=plot(ax1,[0],[0]);
    uplot=plot(ax1,[0],[0]);
    hold off
    xlabel('t');
    legend('C_1','C_2','|C_1-C_2|','u');
    xlim([0,T]);
    ylim([0,6000]);
    xtitle=title('Forward');
    %set(ax1,'FontSize', 20);
    %set(findall(ax1, 'Type', 'Line'),'LineWidth',4);
    ax2=nexttile;
    hold on
    l1plot=plot(ax2,[0],[0]);
    l2plot=plot(ax2,[0],[0]);
    hold off
    xlabel('t');
    legend('\lambda_1','\lambda_2');
    xlim([0,T]);
    %ylim([0,3]);
    ltitle=title('Backward');
    ax3=nexttile;
    urnewplot=plot(ax3,[0],[0]);
    xlabel('t');
    ylabel('urnew');
    xlim([0,T]);
    ylim([0,urlim*1.1]);
    title('u update');
    %set(ax2,'FontSize', 20);
    %set(findall(ax2, 'Type', 'Line'),'LineWidth',4);
    figtitle=sgtitle('title');
    tiles.Padding="tight";
    tiles.TileSpacing="tight";
end

%% forward-backward sweep

for iter=1:1000
    %forward
    odefunC=@(t,C) [f(C(1),r1,d1,gamma1,K1,ur(t));
                    f(C(2),r2,d2,gamma2,K2,ur(t))];
    [t,X]=ode45(odefunC,[0,T],[C0;C0],odeopts);
    
    %backward
    C1fun=@(tt)interp1q(t,X(:,1),tt)';
    C2fun=@(tt)interp1q(t,X(:,2),tt)';
    odefunLamb=@(t,lambdas) [-2*(C1fun(t)-C2fun(t))-lambdas(1)*dfdC(C1fun(t),r1,d1,gamma1,K1,ur(t));
                             +2*(C1fun(t)-C2fun(t))-lambdas(2)*dfdC(C2fun(t),r2,d2,gamma2,K2,ur(t));];
    [t2,Lamb]=ode45(odefunLamb,[T,0],Lambinit,odeopts);
    %reverse the time
    t2=flipud(t2);
    Lamb=flipud(Lamb);
    Lambda1fun=@(tt)interp1q(t2,Lamb(:,1),tt)';
    Lambda2fun=@(tt)interp1q(t2,Lamb(:,2),tt)';
    
    %calculate J
    if bangbang
        Jcontrol=alpha*trapz(tfine,abs(urnum));
    else
        Jcontrol=alpha*trapz(tfine,urnum.^2);
    end
    Jmodel=trapz(t,-(X(:,1)-X(:,2)).^2);
    Jnew=Jmodel + Jcontrol;
    Jgain=Jold-Jnew;
    fprintf('Iteration %d: Jcontrol=%.5f, Jmodel=%.5f, J=%.5f, gain = %.5f\n',iter,Jcontrol,Jmodel,Jnew,Jgain);
    Jold=Jnew;
    
    if makeplot
        %figure(fig);
        %cla(ax1);
        c1plot.XData=t;
        c1plot.YData=X(:,1);
        c2plot.XData=t;
        c2plot.YData=X(:,2);
        cdiffplot.XData=t;
        cdiffplot.YData=abs(X(:,1)-X(:,2));
        uplot.XData=t;
        uplot.YData=arrayfun(ur,t)*1000;
        %xtitle.String=['Forward, iter=',num2str(iter)];
        l1plot.XData=t2;
        l1plot.YData=Lamb(:,1);
        l2plot.XData=t2;
        l2plot.YData=Lamb(:,2);
        figtitle.String=['Iteration=',num2str(iter),', Jcontrol=',num2str(Jcontrol,'%.02f'),', Jmodel=',num2str(Jmodel,'%.02f'),', Jtotal=',num2str(Jnew,'%.02f'),];
        
    end
    
    
    if abs(Jgain)<0.01
        fprintf('Converged.\n');
        break;
    end
    
    % update control
    Lambdafun=@(tt)interp1q(t2,Lamb,tt)';
    urnumnew=zeros(size(urnum));
    for i=1:upts
        tt=tfine(i);
        if bangbang
            objective=@(u) H(C1fun(tt),C2fun(tt),Lambda1fun(tt),Lambda2fun(tt),u);
            if objective(urlim)>objective(0)
                urnumnew(i)=urlim;
            else
                urnumnew(i)=0;
            end
        else
            objective=@(u) -H(C1fun(tt),C2fun(tt),Lambda1fun(tt),Lambda2fun(tt),u);
            % prob = optimproblem(Objective=objective(urvar), ObjectiveSense='maximize');
            % optiminits2 = optimvalues(prob,ur=optiminits);
            % sol = solve(prob,optiminits2,ms,Options=fminconopts);
            % urnumnew(i)=sol.ur;
            urnumnew(i)=fmincon(objective, 0.1, [],[],[],[],0,urlim,[],fminconopts);
        end
    end
    % tt=24;fff=@(u) -H(C1fun(tt),C2fun(tt),Lambda1fun(tt),Lambda2fun(tt),u);
    % us=linspace(0,1200);
    % Hs=arrayfun(fff,us);
    % figure;plot(us,Hs);title(tt);
    urnum= urnum*(1-omega) +urnumnew*omega;
    ur=@(tt) interp1(tfine,urnum,tt)';

    if makeplot
        urnewplot.XData=tfine;
        urnewplot.YData=urnumnew;
        drawnow;
        % saveas(fig,['alm_iter_',num2str(iter,'%03d'),'.png']);
        frame = getframe(fig);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        if iter == 1
            imwrite(imind,cm,giffile,'gif','DelayTime',0.5, 'Loopcount',inf);
        else
            imwrite(imind,cm,giffile,'gif','DelayTime',0.5,'WriteMode','append');
        end
    end
    
end

%% check sufficient condition

sufficient=true;
bad_ind=nan;
du=0.1;
for i=1:upts
    urnum2 = urnum;
    urnum2(i) = urnum2(i)+du;
    ur2=@(tt) interp1(tfine,urnum2,tt)';

    %forward
    odefunC=@(t,C) [f(C(1),r1,d1,gamma1,K1,ur2(t));
                    f(C(2),r2,d2,gamma2,K2,ur2(t))];
    [t,X]=ode45(odefunC,[0,T],[C0;C0],odeopts);
    
    %backward
    C1fun=@(tt)interp1q(t,X(:,1),tt)';
    C2fun=@(tt)interp1q(t,X(:,2),tt)';
    odefunLamb=@(t,lambdas) [-2*(C1fun(t)-C2fun(t))-lambdas(1)*dfdC(C1fun(t),r1,d1,gamma1,K1,ur2(t));
                             +2*(C1fun(t)-C2fun(t))-lambdas(2)*dfdC(C2fun(t),r2,d2,gamma2,K2,ur2(t));];
    [t2,Lamb]=ode45(odefunLamb,[T,0],Lambinit,odeopts);
    %reverse the time
    t2=flipud(t2);
    Lamb=flipud(Lamb);
    Lambda1fun=@(tt)interp1q(t2,Lamb(:,1),tt)';
    Lambda2fun=@(tt)interp1q(t2,Lamb(:,2),tt)';

    %calculate J
    if bangbang
        Jcontrol=alpha*trapz(tfine,abs(urnum));
    else
        Jcontrol=alpha*trapz(tfine,urnum.^2);
    end
    Jmodel=trapz(t,-(X(:,1)-X(:,2)).^2);
    J2=Jmodel + Jcontrol;

    dJdu=(J2-Jold)/du;
    fprintf('u(%d)=%.2f, J(u(%d)+=du)=%.2f, dJ/du(%d)=%.2f\n',i,urnum(i),i,J2,i,dJdu);
    if abs(dJdu)>1.00 && urnum(i)<urlim-0.05
        sufficient=false;
        bad_ind=i;
    end
end
if sufficient
    fprintf('sufficient condition for local optima passed\n');
else
    fprintf('sufficient condition for local optima failed by i=%d\n',bad_ind);
end


%% save
fprintf('finish run on: %s\n',string(datetime,'yyyyMMdd_HHmmss'));
if makeplot
    save(matfile,'-mat');
    diary off;
end

