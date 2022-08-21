function [regressions,fitted,residuals] = regress_and_subtract(x,regressors)
%Grace Paquelet, July 2019
%inputs may be vectors or arrays where each column is a vector
%each column of the first input is regressed against all columns of the
%second input

%convert inputs to table
tbl = table;
for i = 1:size(regressors,2)
    tbl.(['reg' num2str(i)]) = regressors(:,i);
end

%generate regression models and save residual and fitted for each comparison
residuals = NaN(size(x));
fitted = NaN(size(x));
for i = 1:size(x,2)
    tbl.x = x(:,i);
    regressions.(['cell' num2str(i)]) = fitlm(tbl,'interactions');
    residuals(:,i) = regressions.(['cell' num2str(i)]).Residuals.Raw;
    fitted(:,i) = regressions.(['cell' num2str(i)]).Fitted;
end


end