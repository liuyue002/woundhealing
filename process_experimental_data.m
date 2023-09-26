% This script loads the experimental data, re-format it to be in a more
% convenient format, and create animations from it.
% We can do a bit more processing with the experiments with circular initial
% conditions

for experiment = 1:8
    %% basic processing of data
    % where is the raw data
    load(sprintf('experimental_data/raw_data/xy%d_data.mat',experiment),'density');
    % where to output the processed data
    prefix=sprintf('experimental_data/processed_data/xy%d_data_processed',experiment);
    [nx,ny,nt]=size(density);
    Cmax=max(density,[],'all');
    dt=1/3;
    density(isnan(density))=0;
    noisy_data=zeros(nt,nx,ny);
    for i=1:nt
        noisy_data(i,:,:)=density(:,:,i);
    end
    animate_2d(noisy_data,[0,nx*29.2],[0,ny*29.2],[0,Cmax],dt,'C',prefix,1);
    close all;
    save([prefix,'.mat']);

    %% for circular datasets, draw a circle for better visualisation
    is_circle = ismember(experiment,[1,2,5,6]);
    if is_circle
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

        %% for circular datasets, compute a radially-averaged density

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
            for i=1:nx
                for j=1:ny
                    Cvec = reshape(C,[nx*ny,1]);
                    bin_avg=accumarray(bins,Cvec,size(edges))./num_pts_in_bins;
                    C_radial_avg(ti,:)=bin_avg;
                end
            end
        end
        C_radial_avg(isnan(C_radial_avg))=0;

        animate_1d(C_radial_avg,[0,3600],1/3,'C',[prefix,'_radialavg'],1);
        close all;
        save([prefix,'.mat'],'-append');

        %% for circular datasets, compute interior density
        interior_density=zeros(nt,1);
        for ti=1:nt
            r=radiuss(ti)*29.2/2;
            interior_pts=noisy_data(ti,distance_to_center<r);
            interior_density(ti)=mean(interior_pts);
        end
        ts=0:dt:(nt-1)*dt;
        int_density_fig=figure('Position',[10 100 600 500],'color','w');
        figtitle=title('t=0');
        plot(ts,interior_density);
        xlabel('t');
        ylabel('interior density');
        xlim([0,26]);
        saveas(int_density_fig,[prefix,'_interiordensity.png']);
        close all;
        save([prefix,'.mat'],'-append');
    end
end