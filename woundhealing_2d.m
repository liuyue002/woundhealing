function [prefix,cc,timereachcenter] = woundhealing_2d(params,numeric_params,makegif,ic)
% params: [D0,r,alpha,beta,gamma,n,k]
% numeric_params: [T, dt, drawperframe, Lx, Ly, nx, ny]
% the domain is [0,Lx] x [0,Ly]
%params=[500,0.05,1,1,1,0,1];numeric_params=[50,0.1,10,2000,2000,100,100];makegif=1;ic=nan;
%% options
T=numeric_params(1);
dt=numeric_params(2);
drawperframe=numeric_params(3);
nt=T/dt+1;
nFrame=floor((T/dt)/drawperframe)+1;

Lx=numeric_params(4);
Ly=numeric_params(5);
nx=numeric_params(6);
ny=numeric_params(7);
dx=Lx/nx;
dy=Ly/ny;

%% parameters and reaction terms
D0=params(1);
r=params(2);
alpha=params(3);
beta=params(4);
gamma=params(5);
n=params(6);
k=params(7);
D = @(c) D0*(c./k).^n;
if gamma ~= Inf
    f = @(c) r*c.^alpha .* (abs(1-(c./k).^gamma)).^beta .*sign(1-c./k);
else
    f = @(c) r*c.^alpha;
end
%noisestrength = 0; % default 0 - 0.01
%fisherspeed = 2*sqrt(r*D0);
%fprintf('Fisher speed: %.3f\n', fisherspeed);

%% FDM setup
x=linspace(0,Lx,nx)';
y=linspace(0,Ly,ny)';
[X,Y] = meshgrid(x,y);
xmeshvec = reshape(X,[nx*ny,1]);
ymeshvec = reshape(Y,[nx*ny,1]);
c=zeros(ny,nx);
cc = zeros(nFrame,ny,nx); % history of c

%% initial condition
% central dot
% c(:)=0;
% c(nx/2,nx/2)=k;
% ictext='dot';

% circle
c = sqrt((X-Lx/2).^2 + (Y-Ly/2).^2) < 0.1*Lx;
ictext='circle';

% ellipse
%c = sqrt(X.^2./4 + Y.^2) < 50;
%ictext='ellipse';

% star
%c = sqrt(X.^2 + Y.^2) < 10*cos(5*atan2(X,Y))+20;
%ictext='star';

if ~isnan(ic)
    c=ic;
    ictext='kevinic';
end

if ispc % is windows
    folder='D:\liuyueFolderOxford1\woundhealing\simulations\';
else % is linux
    folder='/home/liuy1/Documents/woundhealing/simulations/';
end
prefix = sprintf('woundhealing_2d_%s_%s_D0=%g,r=%g,alpha=%g,beta=%g,gamma=%g,n=%g,k=%.1f,dt=%.3f',datestr(datetime('now'), 'yyyymmdd_HHMMSS'),ictext,params,dt);
prefix = strcat(folder, prefix);
if makegif
    cinit=c;
    save([prefix,'.mat'],'-mat');
end

%% Set up figure
if makegif
    giffile = [prefix,'.gif'];
    crange=[0,1.5*k];
    
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
    set(gca,'XTickLabel',num2str((0:Lx/numticks:Lx)'));
    set(gca,'YTickLabel',num2str((0:Ly/numticks:Ly)'));
    xlim([1,nx]);
    ylim([1,nx]);
    ctitle=title('c, t=0');
    hold off
    pbaspect([1 1 1]);
end
timereachcenter = NaN;

%% simulation iteration
th=0.5; % 0: fw euler, 0.5: Crank-Nicosen, 1: bw euler

for ti=1:1:nt
    t=dt*(ti-1);
    if (mod(ti, drawperframe) == 1)
        iFrame=(ti-1)/drawperframe+1;
        cc(iFrame,:,:) = c;
        if makegif
            cfig.CData=c;
            ctitle.String=['c, t=',num2str(t,'%.1f')];
            drawnow;
            frame = getframe(fig);
            im = frame2im(frame);
            [imind,cm] = rgb2ind(im,256);
            if iFrame==1
                imwrite(imind,cm,giffile,'gif', 'Loopcount',inf);
            else
                imwrite(imind,cm,giffile,'gif','WriteMode','append','DelayTime',0);
            end
            ctotal=sum(sum(c));
            fprintf('ti=%d done, total stuff=%.2f\n',ti,ctotal);
        end
    end
    
    Dxmat=1/2 * (D([c,c(:,nx)]) + D([c(:,1),c]));
    Dxvec=reshape(Dxmat(:,1:end-1),[nx*ny,1]);
    Axx=spdiags([[Dxvec(1+ny:end);zeros(ny,1)], ...
        -[Dxvec(1+ny:end);zeros(ny,1)]-[zeros(ny,1);Dxvec(1+ny:end)], ...
        [zeros(ny,1);Dxvec(1+ny:end)]],[-ny,0,ny],nx*ny,nx*ny);
    Axx=Axx/(dx^2);
    
    Dymat=1/2 * (D([c;c(ny,:)]) + D([c(1,:);c]));
    Dymat(1,:)=0;
    Dyvec=reshape(Dymat(1:end-1,:),[nx*ny,1]);
    Ayy=spdiags([[Dyvec(2:end);0],...
        -[Dyvec(2:end);0]-Dyvec,...
        Dyvec],[-1,0,1],nx*ny,nx*ny);
    Ayy=Ayy/(dy^2);
    A=Axx+Ayy;
    Tc=speye(nx^2)-th*dt*A;
    
    cvec=reshape(c,[nx^2,1]);
    fvec=f(cvec);
    
    crhs = cvec + dt*(fvec + (1-th)*A*cvec);
    cnew = Tc\crhs;
    c = reshape(cnew,[nx,nx]);
    if gamma == Inf
        c = min(c,k);
    end
    %c = c + normrnd(0,noisestrength,size(c));
    
    c = max(c,0);
    if any(c<0,'all') || ~isreal(c)
        fprintf('Negative or complex value detected! something wrong\n');
        error('Negative or complex value detected! something wrong');
    end
    
    if isnan(timereachcenter) && c(nx/2,nx/2)>0.9*k
        timereachcenter = t;
    end
end
if makegif
    fprintf('Time to reach center: %.5f\n',timereachcenter);
end

%% save
if makegif
    save([prefix,'.mat'],'timereachcenter','cc','-mat','-append');
end

end