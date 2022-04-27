%% explore effect of n on wavespeed
npt=30;
ns=linspace(0,10,npt)';
D=500;
r=0.05;
speeds=zeros(30,1);
T=5000;
L=2000;
for i=1:npt
    params=[D,r,1,1,1,ns(i)];
    [~,~,timereachend] = woundhealing_1d(params,T,0);
    speeds(i)=L/timereachend;
end

%%
fig=figure;
plot(ns,speeds);
xlabel('n');
ylabel('wave speed');
%%
fig=figure;
plot(ns,speeds,'b.','MarkerSize',10);
xlabel('n');
ylabel('wave speed');
% fo = fitoptions('Method','NonlinearLeastSquares',...
%                'Lower',[0,-100,-10,0],...
%                'Upper',[100,100,10,10],...
%                'StartPoint',[0,2,1,-1],...
%                'Exclude',[1]);
% ft = fittype('a/((x+b)^d)+c','independent','x','options',fo);

% fo = fitoptions('Method','NonlinearLeastSquares',...
%                'Lower',[0,-100,-10],...
%                'Upper',[100,100,10],...
%                'StartPoint',[0,2,1],...
%                'Exclude',[1]);
% ft = fittype('a/((x+b)^d)','independent','x','options',fo);

% fo = fitoptions('Method','NonlinearLeastSquares',...
%                'Lower',[-10,0,-3],...
%                'Upper',[10,10,3],...
%                'StartPoint',[0,0.5,0],...
%                'Exclude',[1]);
% ft = fittype('-a/(log(1-exp(-b/(x+c))))','independent','x','options',fo);

fo = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,0,-100],...
               'Upper',[100,100,100],...
               'StartPoint',[1,1,3],...
               'Exclude',[1]);
ft = fittype('-a/(b-log(x+c))','independent','x','options',fo);

fitobject=fit(ns,speeds,ft);
hold on
plot(fitobject);
xlabel('n');
ylabel('wave speed');
%legend('empirical c',sprintf('fit -%.3f/(log(1-exp(-%.3f/(x+%.3f))))',fitobject.a,fitobject.b,fitobject.c));
%legend('empirical c',sprintf('fit %.3f/((x+%.3f)^{%.3f})',fitobject.a,fitobject.b,fitobject.d));
legend('empirical c',sprintf('fit -%.3f/(%.3f-log(x+%.3f))',fitobject.a,fitobject.b,fitobject.c));
ylim([0,8]);

%%
saveas(fig,'wavespeed_vs_n_2.png');
save('wavespeed_vs_n_2.mat','-mat');
