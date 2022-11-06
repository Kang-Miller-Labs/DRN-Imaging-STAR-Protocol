function [pairwise_distance_corr] = pairwise_distance(contours,traces,pixel_size)

%% compute centroids
x = NaN(numel(contours),1);
y = NaN(size(x));
for i = 1:size(contours,2)
    conts = contours{1,i};
    polyin = polyshape(conts(:,1),conts(:,2));
    [x(i),y(i)] = centroid(polyin);
end

%% calculate pairwise distance
centroids = [x y];

d = zeros(size(centroids,1));
for i = 1:size(centroids,1)
    d(:,i) = DistanceBetweenXYs(centroids,centroids(i,:));
end

%% convert distance from pixels to micrometers
d = d.*pixel_size;

%% pairwise correlation in activity
c = corr(traces);

%zero out relevant datapoints
d = triu(d);
c = triu(c);
c(eye(size(c,1)) == 1) = 0;

%reshape for plotting
d = nonzeros(d);
c = nonzeros(c);

%% plot
figure
scatter(d,c,30,'b','filled','markerfacealpha',0.3)
xlabel('pairwise distance (\mum)')
ylabel('correlation coefficient')

%% linear regression
reg = table;
reg.d = d;
reg.c = c;
mdl = fitlm(reg);

%% save data
pairwise_distance_corr = v2struct(c,d,mdl);
save('pairwise_distance_corr.mat','pairwise_distance_corr')
savefig(gcf,'pairwise_dist_corr_fig.fig')

end