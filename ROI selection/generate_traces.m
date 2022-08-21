function [traces] = generate_traces(movie,contours)
%-------------------------------------------------------------------------
%GENERATE TRACE VECTORS FROM A MOVIE AND CONTOURS
%Grace Paquelet, August 2017
%
%   INPUTS: Requires a movie from which to calculate traces, and contours
%   file to specify region over which to average pixel values for each
%   timebin. 
%
%   OUTPUTS: Returns an array of traces, one per contour
%
%-------------------------------------------------------------------------

    %% for each contour, generate logical mask covering all enclosed pixels
    for i = 1:size(contours,2)
        xv = contours{1,i}(:,1);
        yv = contours{1,i}(:,2);
        xq = linspace(1,size(movie,2),size(movie,2)); xq = repmat(xq,[size(movie,1),1]);
        yq = linspace(1,size(movie,1),size(movie,1))'; yq = repmat(yq,[1,size(movie,2)]); 
        in = inpolygon(xq,yq,xv,yv);
        mask.(['mask' num2str(i)]) = in;
    end
    
    %% collect trace data
    traces = zeros(size(movie,3),size(contours,2));
    for i = 1:size(contours,2)
        loop_track('Number of Cells Processed...',i,1);
        msk = mask.(['mask' num2str(i)]);
        for j = 1:size(movie,3)
            temp = movie(:,:,j);
            v = temp(msk == true);
            traces(j,i) = mean(v);
        end
    end
    fprintf('\n\n');

end

