load('/scratch/liuy1/wound_data/04-05-22 exp1/Circle/Density_CellcycleFraction/xy1_data.mat');
[nx,ny,nt]=size(density);
Cmax=max(density,[],'all');
animate_2d(density,[0,nx*29.2],[0,ny*29.2],[0,Cmax],1/3,'C','/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_20220405_raw',1);

density=density(:,:,1:3:end);
density=density./Cmax;
density(isnan(density))=0;
animate_2d(density,[0,nx*29.2],[0,ny*29.2],[0,1],1,'C','/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_20220405_scaled',1);

[nx,ny,nt]=size(density);
noisy_data=zeros(nt,nx,ny);
for i=1:nt
    noisy_data(i,:,:)=density(:,:,i);
end
close all;
save('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_20220405_scaled.mat');

%%
% load('/scratch/liuy1/wound_data/04-05-22 exp1/Triangle/Density_CellCycleFraction/xy3_data.mat');
% [nx,ny,nt]=size(density);
% Cmax=max(density,[],'all');
% animate_2d(density,[0,nx*29.2],[0,ny*29.2],[0,Cmax],1/3,'C','/home/liuy1/Documents/woundhealing/simulations/kevindata_triangle_20220405_raw',1);
% 
% density=density(:,:,1:3:end);
% density=density./Cmax;
% density(isnan(density))=0;
% animate_2d(density,[0,nx*29.2],[0,ny*29.2],[0,1],1,'C','/home/liuy1/Documents/woundhealing/simulations/kevindata_triangle_20220405_scaled',1);
% 
% [nx,ny,nt]=size(density);
% noisy_data=zeros(nt,nx,ny);
% for i=1:nt
%     noisy_data(i,:,:)=density(:,:,i);
% end
% close all;
% save('/home/liuy1/Documents/woundhealing/simulations/kevindata_triangle_20220405_scaled.mat');

%%
fig=figure('Position',[10 100 600 500],'color','w');
figtitle=title('t=0');
C=squeeze(noisy_data(1,:,:));
hold on
cfig=imagesc(C,[0,1]);
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

prefix='/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_20220405_scaled_withcircle';
giffile=[prefix,'.gif'];
frame = getframe(fig);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,giffile,'gif', 'Loopcount',inf);

for i=2:nt
    C=squeeze(noisy_data(i,:,:));
    cfig.CData=C;
    figtitle.String=['t=',num2str(i-1,'%.0f')];
    
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

%%

C=squeeze(noisy_data(1,:,:));
distance_to_center=zeros(nx,ny);

for i=1:nx
    for j=1:ny
        distance_to_center(i,j)=sqrt((i-centery)^2 + (j-centerx)^2) *29.2;
        dist_list((i-1)*nx+j,1)=distance_to_center(i,j);
    end
end


for i=1:nx
    for j=1:ny
        dist_list((i-1)*nx+j,2)=C(i,j);
    end
end

fig=figure;
plot(dist_list(:,1),dist_list(:,2),'.');

edges=(0:30:5000)'; % only take the first 100 at the end
bins=discretize(dist_list(:,1),edges);
bin_avg=accumarray(bins,dist_list(:,2),size(edges))./accumarray(bins,1,size(edges));
figure;
plot(edges,bin_avg);