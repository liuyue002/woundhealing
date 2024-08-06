
%% exploration, take the "lean" param set from Picchini et al
% params=[tau, Tghmax, lambda, Txg,   Kxgl,    Vg,   Tig,   Vi,  Kxi];
params=  [3.0, 0.069,  8.9e-3, 0.085, 9.94e-6, 0.49, 0.096, 0.4, 0.039];
% ic = [Gb,   Ib];
ic =   [3.67, 17.91];

Ugx=@(t) 0.01*sin(2*pi*t/100)+0.03;
Uix=@(t) (t<10)*10+5;
%Uix=@(t) 0;
opt=odeset('MaxStep',0.5);
ode = @(t,X) [(Ugx(t-params(1))+params(2)*exp(-params(3)*X(1)*X(2)))/params(6) - params(4)*X(1)/(0.1+X(1)) - params(5)*X(1)*X(2);
              (params(7)*X(1)+Uix(t))/params(8)-params(9)*X(2)];

[tt,X] = ode45(ode,[0,300],ic,opt);

t=0:5:300;
sol = interp1(tt,X,t);

figure;
hold on;
plot(t,Ugx(t)*100,DisplayName="Ugx*100");
plot(t,sol(:,1),DisplayName="G");
plot(t,sol(:,2)./300,DisplayName="I/300");
legend();
