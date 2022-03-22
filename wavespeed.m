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
plot(ns,speeds);
xlabel('n');
ylabel('wave speed');
% fo = fitoptions('Method','NonlinearLeastSquares',...
%                'Lower',[0,-100,0],...
%                'Upper',[100,100,5],...
%                'StartPoint',[0,2,1],...
%                'Exclude',[1]);
% ft = fittype('1/((x+a)^n)+b','independent','x','options',fo);
fo = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[-10,0,-3],...
               'Upper',[10,10,3],...
               'StartPoint',[0,0.5,0],...
               'Exclude',[1]);
%ft = fittype('-a*log(x)+b','independent','x','options',fo);
ft = fittype('-a/(log(1-exp(-b/(x+c))))','independent','x','options',fo);
fitobject=fit(ns,speeds,ft);
hold on
plot(fitobject);
xlabel('n');
ylabel('wave speed');
ylim([0,8]);

%%
saveas(fig,'wavespeed_vs_n_2.png');
save('wavespeed_vs_n_2.mat','-mat');
