function options  = ct_matlab_detrend_bp_options
options.startTime.value = -1;		% use all data.
options.stopTime.value = -1;		% use all data.
options.startTime.prompt = 'Enter the start time for the baseline period.';
options.stopTime.prompt = 'Enter the stop time for the baseline period.';