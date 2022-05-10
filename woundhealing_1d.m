function [prefix,cc,timereachend,frontwidth] = woundhealing_1d(params,numeric_params,makegif,ic,xs)
% params: [D0,r,alpha,beta,gamma,n,k]
% numeric_params: [T, dt, drawperframe, L, nx, ispolar]
% D0=500;r=0.07;alpha=1.5;beta=1.4;T=600;n=1;scale_r=0;makegif=1;
%params=[500,0.05,1,1,1,0,1];numeric_params=[200,0.01,400,2000,600,0];makegif=1;ic=nan;xs=nan;
%params=[1000,0.3,1,1,1,0,2600];numeric_params=[25,0.01/3,100,5000,166,0];makegif=1;ic=nan;xs=nan;
% ispolar: whether the laplacian is in polar form
% ic: nan for default IC, otherwise provide ic (as col vector)
% xs: nan for default, otherwise is the gridpoints as a col vector
%% options
T=numeric_params(1);
dt=numeric_params(2);
drawperframe=numeric_params(3);
nt=T/dt+1;
nFrame=floor((T/dt)/drawperframe)+1;
if isnan(xs)
    L=numeric_params(4); % domain size
    nx=numeric_params(5);
    dx=L/nx;
    x=linspace(0,L,nx)';
else
    x=xs;
    L=x(end);
    nx=size(x,1);
    dx=x(2)-x(1); % assume given grid is equaly-sized
end
ispolar=numeric_params(6);

%% parameters and reaction terms
D0=params(1);
r=params(2);
alpha=params(3);
beta=params(4);
gamma=params(5);
n=params(6);
k=params(7);
D = @(c) D0*c.^n;
f = @(c) r*c.^alpha .* (abs(1-(c./k).^gamma)).^beta .*sign(1-c./k);
noisestrength = 0; % default 0 - 0.01

% if scale_r
%     maxgrowthc = alpha*k/(alpha+beta);
%     fmax = f(maxgrowthc);
%     r = r/fmax;
% end

%fisherspeed = 2*sqrt(r*D0);
%fprintf('Fisher speed: %.3f\n', fisherspeed);

%% FDM setup
c=zeros(nx,1);
cc=zeros(nFrame,nx);

%% initial condition
c(:)=0;
c(1:ceil(nx/10))=k;
%c(1)=k;

if ~isnan(ic)
    c=ic;
end

if ispc % is windows
    folder='D:\liuyueFolderOxford1\woundhealing\simulations\';
else % is linux
    folder='/home/liuy1/Documents/woundhealing/simulations/';
end
prefix = sprintf('woundhealing_1d_%s_D0=%g,r=%g,alpha=%g,beta=%g,gamma=%g,n=%g,k=%.1f,dt=%.3g',datestr(datetime('now'), 'yyyymmdd_HHMMSS'),params,dt);
prefix = strcat(folder, prefix);
if makegif
    cinit=c;
    save([prefix,'.mat'],'-mat');
end

%% Set up figure
timereachend = NaN;
frontwidth=NaN;
if alpha < 1
    frontwidth=0;
end
if makegif
    fig_pos = [10 100 1000 500];
    fig=figure('Position',fig_pos,'color','w');
    hold on
    xlabel('x');
    ylabel('c');
    axis([0,L,0,k*1.5]);
    cfig=plot(x,c);
    figtitle=title('t=0');
    tightEdge(gca);
    hold off
    giffile = [prefix,'.gif'];
end
framereachend=nFrame;

%% simulation iteration
th=0.5; % 0: fw euler, 0.5: Crank-Nicosen, 1: bw euler

for ti=1:1:nt
    t=dt*(ti-1);
    if (mod(ti, drawperframe) == 1)
        iFrame=(ti-1)/drawperframe+1;
        cc(iFrame,:)=c;
        if makegif
            cfig.YData=c;
            figtitle.String=['t=',num2str(t,'%.1f')];
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
    if ~ispolar
        Dvec=1/2 *([D(c(1:nx));0]+[0;D(c(1:nx))]);
        A=spdiags([Dvec(2:end),-Dvec(1:end-1)-Dvec(2:end),Dvec(1:end-1)],[-1 0 1],nx,nx);
        A(1,1)=-Dvec(2); % for no-flux BC
        A(nx,nx)=-Dvec(end-1);
        A=A/(dx^2);
        Tc=speye(nx)-th*dt*A;
    else
        Dvec=1/2 *([x;0].*[D(c(1:nx));0]+[0;x].*[0;D(c(1:nx))]);
        A=spdiags([Dvec(2:end),-Dvec(1:end-1)-Dvec(2:end),Dvec(1:end-1)],[-1 0 1],nx,nx);
        A(1,1)=-Dvec(2); % for no-flux BC
        A(nx,nx)=-Dvec(end-1);
        A=A/(dx^2);
        A=A./x;
        Tc=speye(nx)-th*dt*A;
    end
    
    
    fvec=f(c);
    
    crhs = c + dt*(fvec + (1-th)*A*c);
    cnew = Tc\crhs;
    cnew = cnew + normrnd(0,noisestrength,size(c)).*fvec;
    c=cnew;

    c = max(c,0);
    if any(c<0) || ~isreal(c)
        fprintf('Negative or complex value detected! something wrong\n');
        break;
    end
    if isnan(frontwidth) && c(round(nx*0.8))>0.5
        % compute the width of the front when the wave reach the middle
        % define width as between c>0.9 and c<0.1
        wavetailloc=sum(c>0.9)/nx*L;
        waveheadloc=sum(c>0.1)/nx*L;
        frontwidth=waveheadloc-wavetailloc;
        %break; %%%%%%%
        %fprintf('front width: %.5f\n',frontwidth);
    end
    if isnan(timereachend) && c(end)>0.9*k
        timereachend = t;
        %T = timereachend + 20;
        %nt=T/dt+1;
        framereachend=ceil((ti-1)/drawperframe+1);
        break;
    end
end
%fprintf(['params=',repmat('%.3f,',size(params)),', Time to reach end: %.5f\n'],params,timereachend);

%% save
if makegif
    kymograph_pos = [100,100,650,500];
    c_kymograph = plot_kymograph(cc(1:framereachend,:), kymograph_pos,T,[0,L],NaN,'u',0);
    saveas(c_kymograph,[prefix,'_ckymograph.png']);
    save([prefix,'.mat'],'timereachend','T','nt','nFrame','cc','-mat','-append');
end

end