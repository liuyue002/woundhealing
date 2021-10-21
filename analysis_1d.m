%timereachend = woundhealing_1d(1,1,0,0);

numalpha = 10;
numbeta = 10;
alphas = linspace(0.1,2,numalpha);
betas = linspace(0.1,2,numbeta);
times = zeros(numalpha,numbeta);
widths = zeros(numalpha,numbeta);
for i = 1:numalpha
    for j = 1:numbeta
        [times(i,j),widths(i,j)] = woundhealing_1d(alphas(i),betas(j),0,1,0);
    end
end
[A,B]=meshgrid(alphas,betas);
figure;
surf(A,B,times);
xlabel('\beta');
ylabel('\alpha');
zlabel('time');

figure;
surf(A,B,widths);
xlabel('\beta');
ylabel('\alpha');
zlabel('width');

save('results1d_10.mat','-mat');

%%
numD = 10;
numr = 10;

Ds = linspace(0.1,2,numD);
rs = linspace(0.1,2,numr);
times = zeros(numD,numr);
widths = zeros(numD,numr);
for i = 1:numD
    for j = 1:numr
        [times(i,j),widths(i,j)] = woundhealing_1d(Ds(i),rs(j),1,1,0,0,0);
    end
end
[A,B]=meshgrid(Ds,rs);
figure;
surf(A,B,times);
xlabel('r');
ylabel('D');
zlabel('time');

figure;
surf(A,B,widths);
xlabel('r');
ylabel('D');
zlabel('width');