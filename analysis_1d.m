%timereachend = woundhealing_1d(1,1,0,0);

numalpha = 50;
numbeta = 50;
alphas = linspace(0.1,2,numalpha);
betas = linspace(0.1,2,numbeta);
times = zeros(numalpha,numbeta);
for i = 1:numalpha
    for j = 1:numbeta
        times(i,j) = woundhealing_1d(alphas(i),betas(j),0,1,0);
    end
end
[A,B]=meshgrid(alphas,betas);
surf(A,B,times);
xlabel('\alpha');
ylabel('\beta');
zlabel('time');

save('results1d_50.mat','-mat');