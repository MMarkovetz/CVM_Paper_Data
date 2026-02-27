function [all_vels,all_clv, vnames] = batch_sperm_vels(filenames,p2m)

if nargin==1 || isempty(p2m)
    p2m = 1.09;
end

fnames = dir(filenames);
fn = numel(fnames);
all_vels = cell(fn,1);
all_clv = all_vels;
vnames = all_clv;

for fi=1:fn
    load(fnames(fi).name);
    vnames{fi} = fnames(fi).name;
    bead_num = max(tracking.spot3DSecUsecIndexFramenumXYZRPY(:,3))+1;
    n_frames = max(tracking.spot3DSecUsecIndexFramenumXYZRPY(:,4))+1;

    frames = tracking.spot3DSecUsecIndexFramenumXYZRPY(:,4);
    beads = tracking.spot3DSecUsecIndexFramenumXYZRPY(:,3);
    xs = tracking.spot3DSecUsecIndexFramenumXYZRPY(:,5);
    ys = tracking.spot3DSecUsecIndexFramenumXYZRPY(:,6);

    bead_v = zeros(bead_num,1);
    CLV = bead_v;
    j=1;
    figure;
    hold on
    for i=0:bead_num-1
        x = xs(beads==i)*p2m; % Convert x values from pixels to microns
        y = ys(beads==i)*p2m; % Convert y values from pixels to microns
        plot(x,y)
        f = frames(beads==i);
        x = x(~isnan(x));
        y = y(~isnan(y));
        f = f(~isnan(x));
        td=0;

        if numel(f)>30
            t = (max(f)-min(f))/10; % time in seconds at 10 fps
            bxd = x(find(f==max(f))) - x(min(find(f==min(f)))); % bead x linear distance
            byd = y(find(f==max(f))) - y(min(find(f==min(f)))); % bead y linear distance
            bv = sqrt(bxd^2+byd^2)/t; % bead velocity in um/s
            bead_v(j) = bv*60/1000; % bead velocity in mm/min
            j=j+1;
            for m = 2:numel(f)
               td = td + sqrt((x(m)-x(m-1))^2+(y(m)-y(m-1))^2)/(f(m)-f(m-1));
            end
            CLV(j) = td/10;
        end
    end
    hold off
    title(fnames(fi).name)
    box('on')
    if p2m==0.061
        xlim([0 1440]*p2m)
        ylim([0 1024]*p2m)
    end
%     xlim([0 251])
%     ylim([0 162])
    bolder(18)
    bead_v(bead_v==0) = [];
    CLV(CLV==0) = [];

    figure;
    histogram(bead_v)
    ylabel('Number of Tracks')
    xlabel('Linear Velocity (mm/min)')
    bolder(18)
    
    all_vels{fi} = bead_v;
    all_clv{fi} = CLV;
end