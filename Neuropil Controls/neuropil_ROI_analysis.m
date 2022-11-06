%% Neuropil ROI Analysis
% Written by Grace Paquelet, July 2022, for DRN Imaging STAR Protocol

%% Calculate pairwise correlations
%For each movie used for this analysis, calculate the pairwise correlation
%between traces. The same code can be used for neurpil ROIs and real cell
%traces.

load('traces_sorted') %load traces
c = corrcoef(traces_sorted); %calculate pairwise correlation, array
%convert correlation array to a vector with one value per cell pair
c_vec = triu(c,1); 
c_vec = nonzeros(c_vec(:));
save('traces_pairwise_correlation','c','c_vec')

%% Concatenate c_vec vectors for real cells
%if analyzing multiple movies...
%using the first dataset, initialize the concatenated variable
c_cat_cells = c_vec;
%then iteratively add each other dataset to that vector
c_cat_cells = cat(1,c_cat_cells,c_vec);
%then save the results
save('real_cells_corr_cat','c_cat_cells')

%% Concatenate c_vec vectors for neuropil ROIs
%if analyzing multiple movies...
%using the first dataset, initialize the concatenated variable
c_cat_neuropil = c_vec;
%then iteratively add each other dataset to that vector
c_cat_neuropil = cat(1,c_cat_neuropil,c_vec);
%then save the results
save('neuropil_ROI_corr_cat','c_cat_neuropil')

%% Generate a null distribution of pairwise correlation values
%You can use either a single representative movie, or multiple movies with
%their null correlation values concatenated as in the previous sections.
%This section is written for using a single movie. 
load('traces_sorted')
load('c_vec')
c_null = NaN(numel(c_vec),10000);
for i = 1:10000 %10000 iterations
    shuffled_traces = NaN(size(traces_sorted));
    for j = 1:size(traces_sorted,2) %shuffle each trace
        shuffled_traces(:,j) = timeroll(traces_sorted(:,j));
    end
    c = corrcoef(shuffled_traces); %calculate pairwise correlations
    %linearize correlation values
    c = triu(c,1);
    c = nonzeros(c(:));
    c_null(:,i) = c;
end
save('chance_corr','c_null')

%% Compare the three distributions
%make sure they're all loaded
load('real_cells_corr_cat')
load('neuropil_ROI_corr_cat')
load('chance_corr')

%plot distributions
figure
histfit(c_cat_cells,[],'kernel'); hold on
histfit(c_cat_neuropil,[],'kernel'); hold on
histfit(c_null(:,1),[],'kernel'); %depending on the number of cells in the other datasets,
%you may have to use a subset of c_null to see comparable plots
savefig(gcf,'pairwise_correlation_cells_v_neuropil_v_chance')

%K-S tests
%compare cells to neuropil
[h_cells_v_pil,p_cells_v_pil,d_cells_v_pil] = kstest2(c_cat_cells,c_cat_neuropil);
[h_pil_v_null,p_pil_v_null,d_pil_v_null] = kstest2(c_cat_neuropil,c_null(:));
save('neuropil_ROI_analysis','h_cells_v_pil','p_cells_v_pil','d_cells_v_pil',...
    'h_pil_v_null','p_pil_v_null','d_pil_v_null')
