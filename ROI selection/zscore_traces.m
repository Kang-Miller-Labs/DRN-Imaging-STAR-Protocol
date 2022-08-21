function [traces_zscored] = zscore_traces(traces)
%-------------------------------------------------------------------------
%COMPUTE Z-SCORE FOR MULTIPLE TRACES
%
%   Pulled from Jess Jimenez's 'detect_ca_transients.m'
%   Grace Paquelet, August 2017
%
%   INPUTS: Requires an array of traces.
%    
%   OUTPUTS: Returns an array of z-scored traces.
%    
%-------------------------------------------------------------------------

    pophist = reshape(traces,[],1); % generate single vector with all cell fluorescence values
   
    pop_offset = quantile(pophist,0.50); %find the 50% quantile value (for "silent" time points)
    
    silent = pophist < pop_offset; %find timepoints without ca transients based on threshold above
    
    mu = nanmean(pophist(silent == 1)); % specify mu from the silent timepoints
    
    [~, ~, sigma] = zscore(traces,1); %specify sigma from the entire time series
    
    traces_zscored = bsxfun(@rdivide, bsxfun(@minus, traces, mu), sigma); %convert transients into zscores using mu from silent timepoints and sigma from all timepoints

end

