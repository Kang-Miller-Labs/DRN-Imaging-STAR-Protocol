%% Z-motion Modeling Analysis
% Written by Grace Paquelet, July 2022, for DRN Imaging STAR Protocol
% Model z-motion using x-y motion and compare to activity from bandpassed
% movies. Before beginning, load zscored traces, contours, and offsets. 

%% Regress traces against x- and y-motion
[regressions,fitted,residuals] = regress_and_subtract(traces,offsets);
save('motion_fitted','fitted')
save('models','regressions')
save('residuals','residuals')

%% Visualize traces against motion
cell_number = 30;
figure; plot(traces(:,cell_number)); hold on
plot(fitted(:,cell_number));
