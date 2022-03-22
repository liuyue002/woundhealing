%% explore effect of r,D on width

npt=50;
rD=25; %defaulty si 500*0.05
Ds=linspace(50,5000,npt)';
%rs=rD./Ds;
widths=zeros(30,1);
T=1500;
L=2000;
for i=1:npt
    params=[Ds(i),0.05,1,1,1,0];
    [~,~,~,frontwidth] = woundhealing_1d(params,T,0);
    widths(i)=frontwidth;
end

%%
plot(Ds,widths);

%%
fig=figure;
plot(Ds,widths);
xlabel('D');
ylabel('width');
fo = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,0],...
               'Upper',[100,3],...
               'StartPoint',[30,0.05],...
               'Exclude',31:50);
ft = fittype('a*x^b','independent','x','options',fo);
fitobject=fit(Ds,widths,ft);
hold on
plot(fitobject);

xlabel('D');
ylabel('width');
title('wave width vs D (r=0.05)');

%%
fig2=figure;
plot(Ds,widths);
xlabel('D');
ylabel('width');
fo = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0],...
               'Upper',[100],...
               'StartPoint',[30],...
               'Exclude',31:50);
ft = fittype('a*x^0.5','independent','x','options',fo);
fitobject=fit(Ds,widths,ft);
hold on
plot(fitobject);

xlabel('D');
ylabel('width');
title('wave width vs D (r=0.05)');
%%
saveas(fig,'width_vs_D_fixed_r_3.png');
save('width_vs_D_fixed_r_3.mat','-mat');