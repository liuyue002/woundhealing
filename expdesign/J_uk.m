function [J,Jcontrol,Jmodel,C,Lambda] = J_uk(C0,T,tfine,uknum,r1,d1,gamma1,K1,r2,d2,gamma2,K2,alpha,bangbang)
f = @(C,r,d,gamma,K,uk) r*C.*(1-(C./(K-uk)).^gamma)-d*C;
dfdC= @(C,r,d,gamma,K,uk) r*(1-(1+gamma)*(C./(K-uk)).^gamma)-d;
uk=@(tt) interp1(tfine,uknum,tt)';
odeopts = odeset('RelTol',1e-4,'AbsTol',1e-4,'MaxStep',T/100);
Lambinit=[0;0];
%forward
odefunC=@(t,C) [f(C(1),r1,d1,gamma1,K1,uk(t));
    f(C(2),r2,d2,gamma2,K2,uk(t))];
[t,X]=ode45(odefunC,[0,T],[C0;C0],odeopts);

%backward
C1fun=@(tt)interp1(t,X(:,1),tt)';
C2fun=@(tt)interp1(t,X(:,2),tt)';
odefunLamb=@(t,lambdas) [-2*(C1fun(t)-C2fun(t))-lambdas(1)*dfdC(C1fun(t),r1,d1,gamma1,K1,uk(t));
    +2*(C1fun(t)-C2fun(t))-lambdas(2)*dfdC(C2fun(t),r2,d2,gamma2,K2,uk(t));];
[t2,Lamb]=ode45(odefunLamb,[T,0],Lambinit,odeopts);
%reverse the time
t2=flipud(t2);
Lamb=flipud(Lamb);

%calculate J
if bangbang
    Jcontrol=alpha*trapz(tfine,abs(uknum));
else
    Jcontrol=alpha*trapz(tfine,uknum.^2);
end
Jmodel=trapz(t,-(X(:,1)-X(:,2)).^2);
J=Jmodel + Jcontrol;

nt=length(tfine);
C=zeros(nt,2);
C(:,1)=interp1(t,X(:,1),tfine);
C(:,2)=interp1(t,X(:,2),tfine);
Lambda=zeros(nt,2);
Lambda(:,1)=interp1(t2,Lamb(:,1),tfine);
Lambda(:,2)=interp1(t2,Lamb(:,2),tfine);
end