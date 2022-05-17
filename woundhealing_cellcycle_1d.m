function [prefix,cc1,cc2,timereachend,frontwidth] = woundhealing_cellcycle_1d(params,numeric_params,makegif,ic,xs)
% params: [D1,D2,kt,km,alpha,beta,gamma,eta,n,k]
% numeric_params: [T, dt, drawperframe, L, nx, ispolar, sameD]
%params=[500,500,0.05,0.1,1,1,1,0,0,2000];numeric_params=[300,0.01,400,2000,600,0];makegif=1;ic=NaN;xs=NaN;
% ispolar: whether the laplacian is in polar form
% ic: nan for default IC, otherwise provide ic (with 2 columes, c1 in col 1 and c2 in col 2)
% xs: nan for default, otherwise is the gridpoints as a col vector (mostly for polar case)
% sameD: whether D1 and D2 should be the same. If set to 1, then given
% value for D2 is ignored and set to D1

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
sameD=numeric_params(7);

%% parameters and reaction terms
D1=params(1);
D2=params(2);
kt=params(3);
km=params(4);
alpha=params(5);
beta=params(6);
gamma=params(7);
eta=params(8);
n=params(9);
k=params(10);
if sameD
    D2=D1;
end
D = @(c,D0) D0*c.^n;
%f = @(c1,c2) r*c.^alpha .* (abs(1-(c./k).^gamma)).^beta .*sign(1-c./k);
%noisestrength = 0;

%% FDM setup
c1=zeros(nx,1);
cc1=zeros(nFrame,nx);
c2=zeros(nx,1);
cc2=zeros(nFrame,nx);

%% initial condition
c1(:)=0;
c2(:)=0;
c1(1:ceil(nx/10))=k;
%c1(1)=k;

if ~isnan(ic)
    c1=ic(:,1);
    c2=ic(:,2);
end

if ispc % is windows
    folder='D:\liuyueFolderOxford1\woundhealing\simulations\';
else % is linux
    folder='/home/liuy1/Documents/woundhealing/simulations/';
end
prefix = sprintf('woundhealing_cellcycle_1d_%s_D1=%g,D2=%g,kt=%g,km=%g,alpha=%g,beta=%g,gamma=%g,n=%g,k=%g,dt=%.3g',datestr(datetime('now'), 'yyyymmdd_HHMMSS'),params,dt);
prefix = strcat(folder, prefix);
if makegif
    c1init=c1;
    c2init=c2;
    save([prefix,'.mat'],'-mat');
end

%% Set up figure
timereachend = NaN;
frontwidth=NaN;
if makegif
    fig_pos = [10 100 1000 500];
    fig=figure('Position',fig_pos,'color','w');
    hold on
    xlabel('x');
    ylabel('c');
    axis([0,L,0,k*1.5]);
    cfig1=plot(x,c1);
    cfig2=plot(x,c2);
    figtitle=title('t=0');
    tightEdge(gca);
    hold off
    giffile = [prefix,'.gif'];
    legend('C_1', 'C_2');
end
framereachend=nFrame;

%% simulation iteration
th=0.5; % 0: fw euler, 0.5: Crank-Nicosen, 1: bw euler

for ti=1:1:nt
    t=dt*(ti-1);
    if (mod(ti, drawperframe) == 1)
        iFrame=(ti-1)/drawperframe+1;
        cc1(iFrame,:)=c1;
        cc2(iFrame,:)=c2;
        if makegif
            cfig1.YData=c1;
            cfig2.YData=c2;
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
            fprintf('ti=%d done, total stuff=%.2f\n',ti,sum(c1+c2));
        end
    end
    if ~ispolar
        D1vec=1/2 *([D(c1(1:nx),D1);0]+[0;D(c1(1:nx),D1)]);
        A1=spdiags([D1vec(2:end),-D1vec(1:end-1)-D1vec(2:end),D1vec(1:end-1)],[-1 0 1],nx,nx);
        A1(1,1)=-D1vec(2); % for no-flux BC
        A1(nx,nx)=-D1vec(end-1);
        A1=A1/(dx^2);
        Tc1=speye(nx)-th*dt*A1;
        
        D2vec=1/2 *([D(c2(1:nx),D2);0]+[0;D(c2(1:nx),D2)]);
        A2=spdiags([D2vec(2:end),-D2vec(1:end-1)-D2vec(2:end),D2vec(1:end-1)],[-1 0 1],nx,nx);
        A2(1,1)=-D2vec(2); % for no-flux BC
        A2(nx,nx)=-D2vec(end-1);
        A2=A2/(dx^2);
        Tc2=speye(nx)-th*dt*A2;
    else
        D1vec=1/2 *([x;0].*[D(c1(1:nx),D1);0]+[x;0].*[0;D(c1(1:nx),D1)]);
        A1=spdiags([D1vec(2:end),-D1vec(1:end-1)-D1vec(2:end),D1vec(1:end-1)],[-1 0 1],nx,nx);
        A1(1,1)=-D1vec(2); % for no-flux BC
        A1(nx,nx)=-D1vec(end-1);
        A1=A1/(dx^2);
        A1=A1./x;
        Tc1=speye(nx)-th*dt*A1;
        
        D2vec=1/2 *([x;0].*[D(c2(1:nx),D2);0]+[x;0].*[0;D(c2(1:nx),D2)]);
        A2=spdiags([D2vec(2:end),-D2vec(1:end-1)-D2vec(2:end),D2vec(1:end-1)],[-1 0 1],nx,nx);
        A2(1,1)=-D2vec(2); % for no-flux BC
        A2(nx,nx)=-D2vec(end-1);
        A2=A2/(dx^2);
        A2=A2./x;
        Tc2=speye(nx)-th*dt*A2;
    end
    
    
    %fvec=f(c);
    powsign=@(c,p) abs(1-c).^p.*sign(1-c);
    fvec=-kt*c1.^alpha.*powsign((c1+c2)/k,eta) + 2*km*c2.*powsign(((c1+c2)/k).^gamma,beta);
    gvec= kt*c1.^alpha.*powsign((c1+c2)/k,eta) -   km*c2.*powsign(((c1+c2)/k).^gamma,beta);
    c1rhs = c1 + dt*(fvec + (1-th)*A1*c1);
    c1new = Tc1\c1rhs;
    c2rhs = c2 + dt*(gvec + (1-th)*A2*c2);
    c2new = Tc2\c2rhs;
    
    c1=c1new;c2=c2new;

    c1 = max(c1,0);
    c2 = max(c2,0);
    if any(c1<0) || ~isreal(c1) || any(c2<0) || ~isreal(c2)
        fprintf('Negative or complex value detected! something wrong\n');
        break;
    end
    if isnan(frontwidth) && c1(round(nx*0.8))>0.5
        % compute the width of the front when the wave reach the middle
        % define width as between c>0.9 and c<0.1
        wavetailloc=sum(c1>0.9)/nx*L;
        waveheadloc=sum(c1>0.1)/nx*L;
        frontwidth=waveheadloc-wavetailloc;
        %break; %%%%%%%
        %fprintf('front width: %.5f\n',frontwidth);
    end
    if isnan(timereachend) && c1(end)>0.9*k
        timereachend = t;
        %T = timereachend + 20;
        %nt=T/dt+1;
        %framereachend=ceil((ti-1)/drawperframe+1);
        break;
    end
end
%fprintf(['params=',repmat('%.3f,',size(params)),', Time to reach end: %.5f\n'],params,timereachend);

%% save
if makegif
    kymograph_pos = [100,100,650,500];
    c1_kymograph = plot_kymograph(cc1(1:framereachend,:), kymograph_pos,T,[0,L],[0,k*1.5],'C_1',0);
    c2_kymograph = plot_kymograph(cc2(1:framereachend,:), kymograph_pos,T,[0,L],[0,k*1.5],'C_2',0);
    saveas(c1_kymograph,[prefix,'_c1kymograph.png']);
    saveas(c2_kymograph,[prefix,'_c2kymograph.png']);
    save([prefix,'.mat'],'timereachend','frontwidth','cc1','cc2','-mat','-append');
end

end