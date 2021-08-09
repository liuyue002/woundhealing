%% options
makegif=0;
drawperframe=10;
L=100; % half-domain size, the domain is [-L,L]
T=80;
nx=100;
dx=2*L/nx;
dt=0.05;
nt=T/dt+1;

%% parameters and reaction terms
Dc=1;
n=0; % assume this is always the case for now
r=1;
alpha=1;
beta=1;
k=1;
D = @(c) c.^n; % currently not used
f = @(c) r*c.^alpha .* (1-c./k).^beta;
noisestrength = 0.0; % default 0.01
fisherspeed = 2*sqrt(r*Dc);
fprintf('Fisher speed: %.3f\n', fisherspeed);

%% FDM setup
x=linspace(-L,L,nx)';
y=linspace(-L,L,nx)';
[X,Y] = meshgrid(x,y);
xmeshvec = reshape(X,[nx^2,1]);
ymeshvec = reshape(Y,[nx^2,1]);
c=zeros(nx,nx);

I=speye(nx);
e=ones(nx,1);
T1 = spdiags([e -4*e e],[-1 0 1],nx,nx);
T1(1,1)=-3;
T1(end,end)=-3;
S = spdiags([e e],[-1 1],nx,nx);
A = (kron(I,T1) + kron(S,I));
T2=spdiags([e,-3*e,e],[-1 0 1],nx,nx);
T2(1,1)=-2;
T2(nx,nx)=-2;
A(1:nx,1:nx)=T2;
A(end-nx+1:end,end-nx+1:end)=T2;
A = A/(dx^2);

%% initial condition
% central dot
% c(:)=0;
% c(nx/2,nx/2)=k;

% annulus
c = sqrt(X.^2 + Y.^2) > 100;

if ispc % is windows
    folder='D:\liuyueFolderOxford1\woundhealing\simulations\';
else % is linux
    folder='/home/liuy1/Documents/woundhealing/simulations/';
end
ictext = 'annulus_'; % 'centraldot_' or something else
prefix = strcat('woundhealing_2d_',datestr(datetime('now'), 'yyyymmdd_HHMMSS'),ictext,'_n=',num2str(n), '_alpha=', num2str(alpha), '_beta=', num2str(beta));
prefix = strcat(folder, prefix);
if makegif
    cinit=c;
    save([prefix,'.mat'],'-mat');
end

%% Set up figure
giffile = [prefix,'.gif'];
crange=[0,1.2];

fig_pos = [100 100 800 500];
fig=figure('Position',fig_pos,'color','w');
numticks=10;
hold on
cfig=imagesc(c,crange);
xlabel('x');
ylabel('y');
set(gca,'YDir','normal');
colormap('hot');
colorbar;
axis image;
set(gca,'XTick',0:(nx/numticks):nx);
set(gca,'YTick',0:(nx/numticks):nx);
set(gca,'XTickLabel',num2str((-L:2*L/numticks:L)'));
set(gca,'YTickLabel',num2str((-L:2*L/numticks:L)'));
xlim([1,nx]);
ylim([1,nx]);
ctitle=title('c, t=0');
hold off
pbaspect([1 1 1]);
timereachcenter = NaN;

%% simulation iteration
th=0.5; % 0: fw euler, 0.5: Crank-Nicosen, 1: bw euler
Tc=speye(nx^2)-th*dt*Dc*A;

for ti=1:1:nt
    t=dt*(ti-1);
    if (mod(ti, drawperframe) == 1)
        cfig.CData=c;
        ctitle.String=['c, t=',num2str(t)];
        drawnow;
        iFrame=(ti-1)/drawperframe+1;
        if makegif
            frame = getframe(fig);
            im = frame2im(frame);
            [imind,cm] = rgb2ind(im,256);
            if iFrame==1
                imwrite(imind,cm,giffile,'gif', 'Loopcount',inf);
            else
                imwrite(imind,cm,giffile,'gif','WriteMode','append','DelayTime',0);
            end
        end
    end
    
    cvec=reshape(c,[nx^2,1]);
    fvec=f(cvec);
    
    crhs = cvec + dt*(fvec + (1-th)*Dc*A*cvec);
    cnew = Tc\crhs;
    c = reshape(cnew,[nx,nx]);
    c = c + normrnd(0,noisestrength,size(c));
    
    if isnan(timereachcenter) && c(nx/2,nx/2)>0.9*k
        timereachcenter = t;
    end
end
fprintf('Time to reach center: %.5f\n',timereachcenter);