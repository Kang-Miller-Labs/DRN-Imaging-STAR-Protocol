function [trace_rolled] = timeroll(trace)
%random time roll of a time series

%% select random amount of bins to roll trace
start = randi([1 size(trace,1)-1]);

%% initialize new trace
trace_rolled = NaN(size(trace));

%% generate rolled trace
trace_rolled(start:end) = trace(1:end-start + 1);
trace_rolled(1:start-1) = trace(end-start+2:end);

end

