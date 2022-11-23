function handles = dilate_contours(handles)
% Adjusts the countours towards pi

% maskidx is the mask that is currently being processed.
maskidx = handles.app.data.currentMaskIdx;

% Ridx is the region currently being processed.
ridx = handles.app.data.currentRegionIdx;

% nhandlr is the number of handles for the contours within a region.
nhandlr = length(handles.guiOptions.face.handl{ridx}{maskidx});

% handlr is the handles for the contours within a region
handlr = handles.guiOptions.face.handl{ridx}{maskidx};

%contours is the contours in the current region.
contour = handles.app.experiment.regions.contours{ridx}{maskidx};

% Original and filtered image.
image = handles.app.experiment.Image(maskidx).image;
filtered_image = handles.app.experiment.Image(maskidx).filteredImage;

% clr is the color for each region.
clr = handles.app.experiment.regions.cl(ridx,:);

% Initialize the line width.
linewidth = zeros(1,length(handlr));

% Detecting which contours to adjust is based on the line width.
for counter = 1:nhandlr
    linewidth(counter)= get(handlr(counter),'linewidth');
end

response = inputdlg({'Enter Amount of Dilate (neg is shrink, pos is grow)'},'Dilation Size',1,{'-1'});
size_of_dilation = str2num(response{1});
% structuring_element = strel('square',abs(size_of_dilation));

tempcn = cell(size(contour));
spl = [];

boundary = cell(length(contour),1);
for counter = 1:length(contour)

    crd = contour{counter};

    x = 1:size(image,2); y = 1:size(image,1);
    [xs, ys] = meshgrid(x,y);
    in = inpolygon(xs,ys,crd(:,1),crd(:,2));

%     if size_of_dilation < 0
%         new_in = imerode(in,structuring_element);
%     else
%         new_in = imdilate(in,structuring_element);
%     end
    new_in = in;
    for iters = 1:abs(size_of_dilation)
        if size_of_dilation < 0
            boundary_image = bwperim(new_in);
            new_in = new_in - boundary_image;
            new_in(new_in < 0) = 0;
        else
            boundary_image = bwperim(abs(new_in - 1));
            boundary_image(1,:) = 0; boundary_image(end,:) = 0;
            boundary_image(:,1) = 0; boundary_image(:,end) = 0;
            new_in = new_in + boundary_image;
            new_in(new_in > 1) = 1;
        end
    end
    

%     [x_in, y_in] = find(new_in)

%     if length(x_in) < 3
%         tempcn{counter} = [x_in y_in];
%     else
%         length(tempcn)
        boundary{counter} = bwboundaries(new_in);
        if isempty(boundary{counter})
            tempcn{counter} = crd;
        else
            tempcn{counter} = fliplr(boundary{counter}{1});
%             length(boundary{counter})
            for b = 2:length(boundary{counter})
%                 'in'
%                 length(tempcn)
                tempcn{end+1} = fliplr(boundary{counter}{b});
%                 length(tempcn)
%                 handlr(end+1) = 0;
            end
%             tempcn{temp_counter} = fliplr(boundary{counter}{1});
%             temp_counter = temp_counter + 1;
        end
%     end
%         vls = vls.*in;
%         
%         mx = zeros(size(vls));
%         for xf = -1:1
%             for yf = -1:1
%                 mx(2:end-1,2:end-1) = max(cat(3,mx(2:end-1,2:end-1),vls((2:end-1)+yf,(2:end-1)+xf)),[],3);
%             end
%         end
%         
%         [j i] = find(vls>=mx & vls~=0);
%         i = x(1)+i-1;
%         j = y(1)+j-1;
%         
%         dst = [];
%         for d = 1:length(i)
%             dst(:,d) = sum((crd-repmat([i(d) j(d)],size(crd,1),1)).^2,2);
%         end
%         [mn bestcell] = min(dst,[],2);
%         set(handlr(counter),'visible','off');
%         for d = 1:length(i)
%             newcn{d} = crd(find(bestcell==d),:);
%             if ~isempty(newcn{d})
%                 v1 = newcn{d}([2:end 1],:)-newcn{d};
%                 v2 = newcn{d}([end 1:end-1],:)-newcn{d};
%                 angl = sum(v1.*v2,2)./(sum(v1.^2,2).*sum(v2.^2,2)+eps);
%                 newcn{d} = newcn{d}(find(angl<0),:);
%                 if ~isempty(newcn{d})
%                     spl = [spl plot(newcn{d}([1:end 1],1),newcn{d}([1:end 1],2),'linewidth',2,'Color',1-clr)];
%                 end
%             end
%             tempcn{length(tempcn)+1} = newcn{d};
%         end
%         drawnow;
%         refresh;
    
end

assignin('base','tempcn',tempcn)
assignin('base','boundary',boundary)
assignin('base','new_in',new_in)
assignin('base','in',in)
assignin('base','crd',crd)
assignin('base','handlr',handlr)
% Check to make sure that the new contours are still greater than
% the min area. -DCS:2005/03/30
% min_area = handles.guiOptions.face.minArea;
% for counter = 1:length(tempcn)
%     if (polyarea(tempcn{counter}(:,1),tempcn{counter}(:,2))*(handles.app.experiment.mpp^2) >= min_area)
%         contour{counter} = tempcn{counter};
%     end
% end

handles.guiOptions.face.handl{ridx}{maskidx} = handlr;
handles.app.experiment.regions.contours{ridx}{maskidx} = tempcn;
handles.guiOptions.face.isAdjusted(ridx) = 1;

delete(spl);

