%% basic processing of data

load('/scratch/liuy1/wound_data/04-05-22 exp1/Circle/Density_CellcycleFraction/xy6_data.mat');
prefix='/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy6_20220405_raw';
[nx,ny,nt]=size(density);
Cmax=max(density,[],'all');
dt=1/3;
density(isnan(density))=0;
noisy_data=zeros(nt,nx,ny);
C1=zeros(nt,nx,ny);
C2=zeros(nt,nx,ny);
for i=1:nt
    noisy_data(i,:,:)=density(:,:,i);
    C2(i,:,:)=G2fraction(:,:,i).*density(:,:,i);
    C1(i,:,:)=(1-G2fraction(:,:,i)).*density(:,:,i);
end
animate_2d(noisy_data,[0,nx*29.2],[0,ny*29.2],[0,Cmax],dt,'C',prefix,1);
close all;
save([prefix,'.mat']);

%% draw equivalent circle
fig=figure('Position',[10 100 600 500],'color','w');
figtitle=title('t=0');
C=squeeze(noisy_data(1,:,:));
hold on
cfig=imagesc(C,[0,Cmax]);
xlabel('x');
ylabel('y');
set(gca,'YDir','normal');
colormap('hot');
colorbar;
axis image;
hold off
pbaspect([1 1 1]);

%this turns out to be too crude
% col_extend=any(ic>0,1);
% leftmost=find(col_extend,1);
% rightmost=find(col_extend,1,'last');
% row_extend=any(ic>0,2);
% topmost=find(row_extend,1);
% bottommost=find(row_extend,1,'last');
% centerx=(leftmost+rightmost)/2;
% centery=(topmost+bottommost)/2;
% 
% draw_circle(centerx,centery,(3000/2)/29.2);

radiuss=zeros(nt,1);

[row,col]=find(C>0);
num_nonzero=size(row,1);
centerx=sum(col)/num_nonzero;
centery=sum(row)/num_nonzero;
radiuss(1)=sqrt(num_nonzero/pi);
circ=draw_circle(centerx,centery,radiuss(1));

giffile=[prefix,'_withcircle.gif'];
frame = getframe(fig);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,giffile,'gif', 'Loopcount',inf);

for i=2:nt
    C=squeeze(noisy_data(i,:,:));
    cfig.CData=C;
    figtitle.String=['t=',num2str((i-1)*dt,'%.1f')];
    
    [row,col]=find(C>0);
    num_nonzero=size(row,1);
    radiuss(i)=sqrt(num_nonzero/pi);
    update_circle(circ,centerx,centery,radiuss(i));
    drawnow;
    
    frame = getframe(fig);
    im = frame2im(frame);
    imind = rgb2ind(im,cm);
    imwrite(imind,cm,giffile,'gif', 'WriteMode','append','DelayTime',0);
end

%% radial averaging


distance_to_center=zeros(nx,ny);
edges=(0:30:3600)'; % 5000 radius is large enough to cover the whole domain
rs=(edges(2:end)+edges(1:end-1))/2;
edges=edges(1:end-1);
C_radial_avg=zeros(nt,size(edges,1));
C1_radial_avg=zeros(nt,size(edges,1));
%C2_radial_avg=zeros(nt,size(edges,1));
for i=1:nx
    for j=1:ny
        distance_to_center(i,j)=sqrt((i-centery)^2 + (j-centerx)^2) *29.2;
    end
end
bins=discretize(reshape(distance_to_center,[nx*ny,1]),edges);
num_pts_in_bins=accumarray(bins,1,size(edges));

for ti=1:nt
    disp(ti);
    C=squeeze(noisy_data(ti,:,:));
    C1t=squeeze(C1(ti,:,:));
    for i=1:nx
        for j=1:ny
            Cvec = reshape(C,[nx*ny,1]);
            bin_avg=accumarray(bins,Cvec,size(edges))./num_pts_in_bins;
            C_radial_avg(ti,:)=bin_avg;
            
            C1vec = reshape(C1t,[nx*ny,1]);
            bin_avg=accumarray(bins,C1vec,size(edges))./num_pts_in_bins;
            C1_radial_avg(ti,:)=bin_avg;
            
        end
    end
end
C_radial_avg(isnan(C_radial_avg))=0;
C1_radial_avg(isnan(C1_radial_avg))=0;
C2_radial_avg = C_radial_avg - C1_radial_avg;

%fig=figure;
%plot(dist_list(:,1),dist_list(:,2),'.');

%plot(edges,bin_avg);

animate_1d(C_radial_avg,[0,3600],1/3,'C',[prefix,'_radialavg'],1);
animate_2var_1d(C1_radial_avg,C2_radial_avg,[0,3600],1/3,'C_1','C_2',[prefix,'_cellcycle_radialavg'],1);
close all;
save([prefix,'.mat'],'-append');


%% triangles
% load('/scratch/liuy1/wound_data/04-05-22 exp1/Triangle/Density_CellCycleFraction/xy3_data.mat');
% prefix='/home/liuy1/Documents/woundhealing/simulations/kevindata_triangle_xy3_20220405_raw';
% 
% [nx,ny,nt]=size(density);
% Cmax=max(density,[],'all');
% dt=1/3;
% density(isnan(density))=0;
% noisy_data=zeros(nt,nx,ny);
% for i=1:nt
%     noisy_data(i,:,:)=density(:,:,i);
% end
% animate_2d(noisy_data,[0,nx*29.2],[0,ny*29.2],[0,Cmax],dt,'C',prefix,1);
% close all;
% save([prefix,'.mat']);