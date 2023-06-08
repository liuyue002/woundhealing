%% set up
f = @(C,t,r,d,gamma,K,uk) r*C.*(1-(C./(K-uk(t))).^gamma)-d*C;
ff = @(C,r,d,gamma,K,u) r*C.*(1-(C./(K-u)).^gamma)-d*C;
dfdC= @(C,t,r,d,gamma,K,uk) r*(1-(1+gamma)*(C./(K-uk(t))).^gamma)-d;
dfduk= @(C,t,r,d,gamma,K,uk) -r*gamma*(C./(K-uk)).^(gamma+1);

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
opts = odeset('RelTol',1e-4,'AbsTol',1e-4);
alpha=0.01; % weight of control cost
omega=0.95; % control update rate

H = @(C1,C2,lambda1,lambda2,t,u) (C1-C2).^2-alpha*u.^2 + lambda1*ff(C1,r1,d1,gamma1,K1,u) + lambda2*ff(C2,r2,d2,gamma2,K2,u);
fminconopts=optimoptions('fmincon');
fminconopts.Display='none';
%% forward-backward sweep
% initial guess
%uk=@(t) ((t>5)&(t<(10)))*800;
%uk=@(t) ((t>5)&(t<(15)))*1200;
%uk=@(t) -10*t.*(t-T);
uk=@(t) 1000;
tfine=linspace(0,T,500);
uknum=uk(tfine);
Lambinit=[0;0];

makeplot=true;
Jold=nan;

if makeplot
    fig=figure('visible','on','Position',[0,0,2000,800]);
    ax1=subplot(1,2,1);
    hold on
    c1plot=plot(ax1,[0],[0]);
    c2plot=plot(ax1,[0],[0]);
    cdiffplot=plot(ax1,[0],[0]);
    uplot=plot(ax1,[0],[0]);
    hold off
    legend('C_1','C_2','|C_1-C_2|','u');
    xlim([0,T]);
    ylim([0,3000]);
    xtitle=title('Forward');
    %set(ax1,'FontSize', 20);
    %set(findall(ax1, 'Type', 'Line'),'LineWidth',4);
    ax2=subplot(1,2,2);
    hold on
    l1plot=plot(ax2,[0],[0]);
    l2plot=plot(ax2,[0],[0]);
    hold off
    legend('\lambda_1','\lambda_2');
    xlim([0,T]);
    %ylim([0,3]);
    ltitle=title('Backward');
    %set(ax2,'FontSize', 20);
    %set(findall(ax2, 'Type', 'Line'),'LineWidth',4);
    figtitle=sgtitle('title');
    filename='twomodel_control_2.gif';

    fig2=figure;
    uknewplot=plot([0],[0]);
    xlabel('t');
    ylabel('uknew');
end

for iter=1:1000
    %forward
    odefunC=@(t,C) [f(C(1),t,r1,d1,gamma1,K1,uk);
                 f(C(2),t,r2,d2,gamma2,K2,uk)];
    [t,X]=ode45(odefunC,[0,T],[C0;C0],opts);
    
    %backward
    C1fun=@(tt)interp1q(t,X(:,1),tt)';
    C2fun=@(tt)interp1q(t,X(:,2),tt)';
    odefunLamb=@(t,lambdas) [-2*(C1fun(t)-C2fun(t))-lambdas(1)*dfdC(C1fun(t),t,r1,d1,gamma1,K1,uk);
                              2*(C1fun(t)-C2fun(t))-lambdas(2)*dfdC(C2fun(t),t,r2,d2,gamma2,K2,uk);];
    [t2,Lamb]=ode45(odefunLamb,[T,0],Lambinit,opts);
    %reverse the time
    t2=flipud(t2);
    Lamb=flipud(Lamb);
    Lambda1fun=@(tt)interp1q(t2,Lamb(:,1),tt)';
    Lambda2fun=@(tt)interp1q(t2,Lamb(:,2),tt)';
    
    %calculate J
    ts=linspace(0,T,200); %uniform spacing for trapezoid rule u
    Jcontrol=alpha*trapz(ts,arrayfun(uk,ts).^2);
    Jmodel=trapz(t,-(X(:,1)-X(:,2)).^2);
    Jnew=Jmodel + Jcontrol;
    Jgain=Jold-Jnew;
    fprintf('Iteration %d: Jcontrol=%.5f, Jmodel=%.5f, J=%.5f, gain = %.5f\n',iter,Jcontrol,Jmodel,Jnew,Jgain);
    Jold=Jnew;
    
    if makeplot
        figure(fig);
        %cla(ax1);
        c1plot.XData=t;
        c1plot.YData=X(:,1);
        c2plot.XData=t;
        c2plot.YData=X(:,2);
        cdiffplot.XData=t;
        cdiffplot.YData=abs(X(:,1)-X(:,2));
        uplot.XData=t;
        uplot.YData=arrayfun(uk,t);
        %xtitle.String=['Forward, iter=',num2str(iter)];
        l1plot.XData=t2;
        l1plot.YData=Lamb(:,1);
        l2plot.XData=t2;
        l2plot.YData=Lamb(:,2);
        figtitle.String=['Iteration=',num2str(iter),', Jcontrol=',num2str(Jcontrol,'%.02f'),', Jmodel=',num2str(Jmodel,'%.02f'),', Jtotal=',num2str(Jnew,'%.02f'),];
        drawnow;
        % saveas(fig,['alm_iter_',num2str(iter,'%03d'),'.png']);
        frame = getframe(fig);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        if iter == 1
            imwrite(imind,cm,filename,'gif','DelayTime',0.5, 'Loopcount',inf);
        else
            imwrite(imind,cm,filename,'gif','DelayTime',0.5,'WriteMode','append');
        end
    end
    
    
    if abs(Jgain)<0.0001
        fprintf('Converged.\n');
        break;
    end
    
    % update control
    Lambdafun=@(tt)interp1q(t2,Lamb,tt)';
    %uknew=@(t) min((Lambda1fun(t).*dfduk(C1fun(t),t,r1,d1,gamma1,K1,uk) + Lambda2fun(t).*dfduk(C2fun(t),t,r2,d2,gamma2,K2,uk))/(2*alpha),1200);
    uknew=@(t) fmincon(@(u) -H(C1fun(t),C2fun(t),Lambda1fun(t),Lambda2fun(t),t,u), 400, [],[],[],[],0,1200,[],fminconopts);
    uk=@(t) uk(t)*omega + uknew(t)*(1-omega);
    uknum=arrayfun(uk,tfine);
    uk=@(tt) interp1(tfine,uknum,tt)';

    if makeplot
        figure(fig2);
        uknewplot.XData=t;
        uknewplot.YData=arrayfun(uknew,t);
    end
    
end