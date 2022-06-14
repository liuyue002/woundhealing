function [fig] = animate_2var_2d(uu,vv,xlimit,ylimit,crange,Dt,fname,prefix,makegif)
%Animate a function u(x,t) of time and 1D space
% uu(i,j,k) = u(t_i,x_j,y_k), same for vv
% xlimit, ylimit: the 2D domain, i.e. [0,L], [0,L]
% crange: color range
% Dt: time step between each frame
% fname: name of the function (i.e. 'u')
% prefix: prefix for saving any file
% whether to save gif

[nFrame,nx,ny]=size(uu);
%[nx,ny,nFrame]=size(uu);
xs=linspace(xlimit(1),xlimit(2),nx);
ys=linspace(ylimit(1),ylimit(2),ny);
ts=(0:1:nFrame)*Dt;
T=nFrame*Dt;
fig=figure('Position',[10 100 600 500],'color','w');
figtitle=title('t=0');
%crange=[0,1.2];
numticks=10;
hold on
cfig=imagesc(squeeze(uu(1,:,:)),crange);
%cfig=imagesc(squeeze(uu(:,:,1)),crange);
xlabel('x');
ylabel(fname);
set(gca,'YDir','normal');
colormap('hot');
colorbar;
axis image;
set(gca,'XTick',0:(nx/numticks):nx);
set(gca,'YTick',0:(nx/numticks):nx);
set(gca,'XTickLabel',num2str((xlimit(1):(xlimit(2)-xlimit(1))/numticks:xlimit(2))','%.0f'));
set(gca,'YTickLabel',num2str((ylimit(1):(xlimit(2)-xlimit(1))/numticks:ylimit(2))','%.0f'));
xlim([1,nx]);
ylim([1,nx]);
hold off
pbaspect([1 1 1]);

if makegif
    giffile=[prefix,'.gif'];
    frame = getframe(fig);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    imwrite(imind,cm,giffile,'gif', 'Loopcount',inf);
end
for iframe=1:nFrame
    cfig.CData=squeeze(uu(iframe,:,:));
    %cfig.CData=squeeze(uu(:,:,iframe));
    figtitle.String=['t=',num2str(ts(iframe),'%.1f')];
    drawnow;
    if makegif
        frame = getframe(fig);
        im = frame2im(frame);
        imind = rgb2ind(im,cm);
        imwrite(imind,cm,giffile,'gif', 'WriteMode','append','DelayTime',0);
    end
end
hold off;

end

