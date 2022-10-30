function [ ] = plot_contours_GP(Cn,display_numbers,Coor,ln_wd,cmap)
%PLOT CONTOURS OVER BACKGROUND IMAGE
%Grace Paquelet, 2017
%
    %Plot the contour traces of spatial components against specified 
    %background image. 
    %
    %INPUTS: Requires an image (Cn), a logical to indicate whether to
    %display numbers over cells, a cell array of contours (in the format
    %from CalTracer), and the line width with which to draw the contours.
    %
%
%Based on the function plot_contours by Pengcheng Zhou in CNMF-E.
%Colormap of the image is bone, and colormap of the contours is prism.
%Either can be changed within the script. 

if ~exist('ln_wd', 'var') || isempty(ln_wd)
    ln_wd = 1; % linewidth;
end

if ~exist('cmap','var') || isempty(cmap)
    cmap = lines(3*size(Coor,2));
end

if size(cmap,1) < size(Coor,1)
    cmap = lines(3*size(Coor,1));
end

fontname = 'helvetica';

imagesc(Cn)
axis equal tight off

posA = get(gca,'position');
set(gca,'position',posA);

hold on;

%Coor1 = cal2cnmfe(Coor);

for i = 1:size(Coor,1)
    cont = medfilt1(Coor{i}')';
    plot(cont(1,:),cont(2,:),'Color',cmap(i,:), 'linewidth', ln_wd); hold on;
    if display_numbers
        [x,y] = findcenter(cont(1,:),cont(2,:));
        x = x - size(Cn,1)/100;
        lbl = num2str(i);
        text(x,y,lbl,'color',cmap(i,:),'fontsize',12,'fontname',fontname,'fontweight','bold'); hold on
    end
end

end