%% set up
f = @(C,r,d,gamma,K,uk) r*C.*(1-(C./(K-uk)).^gamma)-d*C;
dfdC= @(C,r,d,gamma,K,uk) r*(1-(1+gamma)*(C./(K-uk)).^gamma)-d;
%dfduk= @(C,r,d,gamma,K,uk) -r*gamma*(C./(K-uk)).^(gamma+1);

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
alpha=0.03; % weight of control cost
omega=0.1; % control update rate
uklim = 1200; %upper bound for uk
bangbang=false;

if bangbang
    H = @(C1,C2,lambda1,lambda2,u) (C1-C2).^2-alpha*u + lambda1*f(C1,r1,d1,gamma1,K1,u) + lambda2*f(C2,r2,d2,gamma2,K2,u);
else
    H = @(C1,C2,lambda1,lambda2,u) (C1-C2).^2-alpha*u.^2 + lambda1*f(C1,r1,d1,gamma1,K1,u) + lambda2*f(C2,r2,d2,gamma2,K2,u);
end
%fminconopts=optimoptions('fmincon');
%fminconopts.Display='none';
fminconopts=optimoptions(@fmincon,'Algorithm','interior-point','Display','none');
optiminits=[0,uklim/3,uklim*2/3,uklim];
ukvar=optimvar("uk",LowerBound=0,UpperBound=uklim);
ms=MultiStart("Display","off");
filename=sprintf('simulations/twomodel_control_%s_alpha=%.2f,omega=%.2f',string(datetime,'yyyyMMdd_HHmmss'),alpha,omega);
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
%uk=@(t) ((t>5)&(t<(10)))*800;
%uk=@(t) ((t>15)&(t<(20)))*uklim;
%uk=@(t) -10*t.*(t-T);
%uk=@(t) 100;
%uk=@(t) uklim;
%uk=@(t) ((t>9.5)&(t<(23.25)))*uklim;
uk=@(t) (t<9.5)*(1200/9.5)*t + ((t>9.5)&(t<(23.5)))*uklim + (t>23.5)*(-1200/1.5)*(t-25);
tfine=linspace(0,T,upts);
uknum=arrayfun(uk,tfine);
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
    c1plot=plot(ax1,tfine,zeros(size(tfine)));
    c2plot=plot(ax1,tfine,zeros(size(tfine)));
    cdiffplot=plot(ax1,tfine,zeros(size(tfine)));
    uplot=plot(ax1,tfine,zeros(size(tfine)));
    hold off
    xlabel('t');
    legend('C_1','C_2','|C_1-C_2|','u');
    xlim([0,T]);
    ylim([0,2600]);
    xtitle=title('Forward');
    %set(ax1,'FontSize', 20);
    %set(findall(ax1, 'Type', 'Line'),'LineWidth',4);
    ax2=nexttile;
    hold on
    l1plot=plot(ax2,tfine,zeros(size(tfine)));
    l2plot=plot(ax2,tfine,zeros(size(tfine)));
    hold off
    xlabel('t');
    legend('\lambda_1','\lambda_2');
    xlim([0,T]);
    %ylim([0,3]);
    ltitle=title('Backward');
    ax3=nexttile;
    uknewplot=plot(ax3,tfine,zeros(size(tfine)));
    xlabel('t');
    ylabel('uknew');
    xlim([0,T]);
    ylim([0,uklim+100]);
    title('u update');
    %set(ax2,'FontSize', 20);
    %set(findall(ax2, 'Type', 'Line'),'LineWidth',4);
    figtitle=sgtitle('title');
    tiles.Padding="tight";
    tiles.TileSpacing="tight";
end

%% forward-backward sweep


for iter=1:maxiter
    [Js(iter),Jcontrols(iter),Jmodels(iter),C,Lambda]=J_uk(C0,T,tfine,uknum,r1,d1,gamma1,K1,r2,d2,gamma2,K2,alpha,bangbang);

    if iter==1
        Jgain = nan;
    else
        Jgain = -(Js(iter)-Js(iter-1));
    end
    fprintf('Iteration %d: Jcontrol=%.5f, Jmodel=%.5f, J=%.5f, gain = %.5f\n',iter,Jcontrols(iter),Jmodels(iter),Js(iter),Jgain);

    if Jgain<0
        omega=omega/2;
        fprintf('reduced omega to %f\n',omega);
    end

    % update control
    uknumnew=zeros(size(uknum));
    for i=1:upts
        objective=@(u) H(C(i,1),C(i,2),Lambda(i,1),Lambda(i,2),u);
        if bangbang
            if objective(uklim)>objective(0)
                uknumnew(i)=uklim;
            else
                uknumnew(i)=0;
            end
        else
            prob = optimproblem(Objective=objective(ukvar), ObjectiveSense='maximize');
            sol = solve(prob, optimvalues(prob,uk=optiminits), ms,Options=fminconopts);
            uknumnew(i)=sol.uk;
        end
    end

    if makeplot
        c1plot.YData=C(:,1);
        c2plot.YData=C(:,2);
        cdiffplot.YData=abs(C(:,1)-C(:,2));
        uplot.YData=uknum;
        l1plot.YData=Lambda(:,1);
        l2plot.YData=Lambda(:,2);
        uknewplot.YData=uknumnew;
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

    % tt=24;fff=@(u) -H(C1fun(tt),C2fun(tt),Lambda1fun(tt),Lambda2fun(tt),u);
    % us=linspace(0,1200);
    % Hs=arrayfun(fff,us);
    % figure;plot(us,Hs);title(tt);
    uknum= uknum*(1-omega) +uknumnew*omega;
    uk=@(tt) interp1(tfine,uknum,tt)';
end

%% check sufficient condition

% sufficient=true;
% bad_ind=nan;
% du=0.1;
% for i=1:upts
%     uknum2 = uknum;
%     uknum2(i) = uknum2(i)+du;
%     uk2=@(tt) interp1(tfine,uknum2,tt)';
% 
%     %forward
%     odefunC=@(t,C) [f(C(1),r1,d1,gamma1,K1,uk2(t));
%         f(C(2),r2,d2,gamma2,K2,uk2(t))];
%     [t,X]=ode45(odefunC,[0,T],[C0;C0],odeopts);
% 
%     %backward
%     C1fun=@(tt)interp1q(t,X(:,1),tt)';
%     C2fun=@(tt)interp1q(t,X(:,2),tt)';
%     odefunLamb=@(t,lambdas) [-2*(C1fun(t)-C2fun(t))-lambdas(1)*dfdC(C1fun(t),r1,d1,gamma1,K1,uk2(t));
%         +2*(C1fun(t)-C2fun(t))-lambdas(2)*dfdC(C2fun(t),r2,d2,gamma2,K2,uk2(t));];
%     [t2,Lamb]=ode45(odefunLamb,[T,0],Lambinit,odeopts);
%     %reverse the time
%     t2=flipud(t2);
%     Lamb=flipud(Lamb);
%     Lambda1fun=@(tt)interp1q(t2,Lamb(:,1),tt)';
%     Lambda2fun=@(tt)interp1q(t2,Lamb(:,2),tt)';
% 
%     %calculate J
%     if bangbang
%         Jcontrol=alpha*trapz(tfine,abs(uknum));
%     else
%         Jcontrol=alpha*trapz(tfine,uknum.^2);
%     end
%     Jmodel=trapz(t,-(X(:,1)-X(:,2)).^2);
%     J2=Jmodel + Jcontrol;
% 
%     dJdu=(J2-Jold)/du;
%     fprintf('u(%d)=%.2f, J(u(%d)+=du)=%.2f, dJ/du(%d)=%.2f\n',i,uknum(i),i,J2,i,dJdu);
%     if abs(dJdu)>1.00 && uknum(i)<uklim-1.00
%         sufficient=false;
%         bad_ind=i;
%     end
% end
% if sufficient
%     fprintf('sufficient condition for local optima passed\n');
% else
%     fprintf('sufficient condition for local optima failed by i=%d\n',bad_ind);
% end


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
    diary off;
end

