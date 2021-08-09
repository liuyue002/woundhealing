function [timereachend] = woundhealing_1d(alpha,beta,n,makegif)

%% options
makegif=1;
drawperframe=100;
L=100; % domain size
nx=600;
dx=L/nx;
T=80;
dt=0.01;
nt=T/dt+1;
nFrame=ceil((T/dt)/drawperframe);

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
x=linspace(0,L,nx)';
c=zeros(nx,1);

o=ones(nx,1);
%central difference gradient
grad = spdiags([-1*o 0*o o],[-1 0 1],nx,nx);
grad(1,1)=-1;
grad(nx,nx)=1;
grad=grad/(2*dx);

% laplacian
A=spdiags([o -2*o o],[-1 0 1],nx,nx);
A(1,1)=-1; % for no-flux BC
A(nx,nx)=-1;
A=A/(dx^2);

%% initial condition
c(:)=0;
c(1)=k;

if ispc % is windows
    folder='D:\liuyueFolderOxford1\woundhealing\simulations\';
else % is linux
    folder='/home/liuy1/Documents/woundhealing/simulations/';
end
prefix = strcat('woundhealing_1d_',datestr(datetime('now'), 'yyyymmdd_HHMMSS'),'_n=',num2str(n), '_alpha=', num2str(alpha), '_beta=', num2str(beta));
prefix = strcat(folder, prefix);
if makegif
    cinit=c;
    save([prefix,'.mat'],'-mat');
end

%% Set up figure
fig_pos = [10 100 1000 500];
fig=figure('Position',fig_pos,'color','w');
hold on
xlabel('x');
ylabel('c');
axis([0,L,0,1.5]);
cfig=plot(x,c);
figtitle=title('t=0');
tightEdge(gca);
hold off

timereachend = NaN;
if makegif
    giffile = [prefix,'.gif'];
    cc=zeros(nFrame,nx);
end


%% simulation iteration
th=0.5; % 0: fw euler, 0.5: Crank-Nicosen, 1: bw euler
Tc=speye(nx)-th*dt*Dc*A;

for ti=1:1:nt
    t=dt*(ti-1);
    if (mod(ti, drawperframe) == 1)
        cfig.YData=c;
        figtitle.String=['t=',num2str(t,'%.1f')];
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
            cc(iFrame,:)=c;
        end
    end
    
    fvec=f(c);
    
    crhs = c + dt*(fvec + (1-th)*Dc*A*c);
    cnew = Tc\crhs;
    cnew = cnew + normrnd(0,noisestrength,size(c));
    
    c=cnew;
    
    if isnan(timereachend) && c(end)>0.9*k
        timereachend = t;
    end
    if (mod(ti, drawperframe) == 0)
        ctotal=sum(sum(c))*dx;
        fprintf('ti=%d done, total stuff=%.2f\n',ti,ctotal);
    end
end
fprintf('Time to reach end: %.5f\n',timereachend);
%% save
if makegif
    kymograph_pos = [100,100,650,500];
    c_kymograph = plot_kymograph(cc, kymograph_pos,T,[-L,L],NaN,'u',0);
    saveas(c_kymograph,[prefix,'_ckymograph.png']);
end

end