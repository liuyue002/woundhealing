% params = [p1, p2, p3, p4, p5, p6, Ib, Gb]
params = [0.0343, 0.1012, 2.2e-5, 1.6, 5.23, 8,  48.64, 6.6];
% ic = [G0, 0, I0];
ic = [30, 0, 651];

opt=odeset('MaxStep',0.5);
ode = @(t,X) [-(params(1)+X(2))*X(1)+params(1)*params(8);
              -params(2)*X(2)+params(3)*(X(3)-params(7));
              params(4)*t*max(X(1)-params(5),0)-params(6)*(X(3)-params(7))];
[tt,X] = ode45(ode,[0,240],ic,opt);

t=0:1:240;
sol = interp1(tt,X,t);

figure;
hold on;
plot(t,sol(:,1)*10,DisplayName="G*10");
plot(t,sol(:,2)*10000,DisplayName="X*10000");
plot(t,sol(:,3),DisplayName="I");
legend();

figure;
semilogy(t,sol(:,1));
title('G');

figure;
semilogy(t,sol(:,3));
title('I');