function [ ] = roi2footprint(Y,contours)
%CONVERT ROIS AND A MOVIE TO SPATIAL FOOTPRINTS COMPATIBLE WITH CELLREG
%Grace Paquelet, 2018
%
%   INPUT: Opens a dialog box for the user to select the movie from which
%   to generate the footprints (suggested Ysignal, Yac, or other
%   background-subtracted movie), then a dialog box to select contours file
%   (in the format output by CalTracer). 
%
%   OUTPUT: Spatial footprints matrix is automatically saved to file.
%   Spatial footprints are calculated using the standard deviation
%   projection of the movie uploaded. 
%
%-------------------------------------------------------------------------

%     load movie
if isempty(Y)
     Y = loadmovie;
end
% 
%     %% load contours
if isempty(contours)
    [filename,pathname] = uigetfile('*.mat','Choose ROI contours file');
    filepath = [pathname filename];
    cd(pathname)
    S = load(filepath);
    names = fieldnames(S);
    contours = S.(names{1});
end

    %% for each contour, generate logical mask covering all enclosed pixels
    for i = 1:size(contours,2)
        xv = contours{1,i}(:,1);
        yv = contours{1,i}(:,2);
        xq = linspace(1,size(Y,2),size(Y,2)); xq = repmat(xq,[size(Y,1),1]);
        yq = linspace(1,size(Y,1),size(Y,1))'; yq = repmat(yq,[1,size(Y,2)]); 
        in = inpolygon(xq,yq,xv,yv);
        mask.(['mask' num2str(i)]) = in;
    end
    
    %% generate footprints using stdev of pixel values from movie to fill in contours
    footprints = zeros(size(contours,2),size(Y,1),size(Y,2));
    temp = reshape(Y,size(Y,1)*size(Y,2),size(Y,3));
    meas = NaN(size(temp,1),1);
    for i = 1:size(temp,1)
        meas(i) = std(single(temp(i,:)));
    end
    meas = reshape(meas,size(Y,1),size(Y,2));
    
    for i = 1:size(footprints,1)
        temp = mask.(['mask' num2str(i)]);
        footprints(i,:,:) = double(temp).*meas;
    end
    
    %% autosave
    save('spatial_footprints','footprints')
    disp('Done!')

end

