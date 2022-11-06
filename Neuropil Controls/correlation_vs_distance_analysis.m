%% Correlation vs. Distance Analysis
% Written by Grace Paquelet, July 2022, for DRN Imaging STAR Protocol
% Compares the pairwise correlation between cells' activity with the pairwise
% distance between them

%% Calculate pairwise distances between cells using ROIs from CalTracer
%load traces and contours
load('traces_sorted')
load('contours_sorted')
%get rid of bad cells' contours

%repeat for each movie in this analysis
pixel_size = 2; %approximate pixel size in micrometers
%calculate pairwise distances and activity
pairwise_distance_corr = pairwise_distance(contours_sorted,traces_sorted,pixel_size);


