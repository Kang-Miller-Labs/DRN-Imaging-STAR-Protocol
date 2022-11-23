function x = ct_detrend2(x, options)
[nrecordings len] = size(x);
% Detrends both contours and halos using MATLAB's built-in detrend function.
% MD - Created on 4/9/2010

time=(1:1:len)';

for i = 1:nrecordings
    xnew(i,:)=msbackadj(time,x(i,:)')';
end
x = xnew;

