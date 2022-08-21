function [mcmovie,mcfiltered,offsets] = mctophat(proc_method)
%-------------------------------------------------------------------------
%MOTION CORRECT TIFF STACK USING TOP HAT FILTER AND 2D CROSS-CORRELATION
%Grace Paquelet, June 2017; based on script from Clay Lacefield, 2017
%
    %INPUTS: Requires a choice of parallel or nonparallel processing. For
    %parallel processing, input is the string 'par'; for nonparallel
    %processing, the string is 'nonpar'. Movie file (.tif, .avi, or .hdf5) 
    %is chosen by user using a dialog box.
%    
    %OUTPUTS: Returns a motion-corrected TIFF file (without metadata), 
    %automatically saved to the source file. Also generates a plot of x and 
    %y displacements. If movie is going to be loaded into CNMF-E, or
    %another program, errors may occur due to the lack of metadata. To deal
    %with this, open and save the movie in another application, e.g. FIJI. 
%    
    %Note: calls read_file.m (Eftychios A. Pnevmatikakis, Simons
    %Foundation), available on github in his NoRMCorre package. 
%
%-------------------------------------------------------------------------

%% Read TIFF stack
[filename,pathname] = uigetfile({'*.tif';'*.hdf5';'*.avi'},'Select movie');
disp('Reading file..');
tifstack = read_file([pathname filename]);
cd(pathname)

%% Define original movie dimensions
height = size(tifstack,1);
width = size(tifstack,2);
numtif = size(tifstack,3);

%% Generate tophat-filtered movie
disp('Tophat filtering...'); tic
imopenstack = imopen(tifstack,strel('disk',16));
tophatstack = tifstack - imopenstack; toc
clear imopenstack

%% restrict calculations to inner field to avoid conflict with lens edge
% orig = tophatstack;
% tophatstack = tophatstack(50:200,50:200,:);
% height = size(tophatstack,1);
% width = size(tophatstack,2);

%% Calculate x/y motion of each frame
disp('Calculating motion...'); tic
offsets = zeros(numtif,2); %initialize
template = tophatstack(:,:,1);

if strcmp(proc_method,'par')
    parfor i = 2:numtif
        corr = normxcorr2(tophatstack(:,:,i),template);
        [ypeak,xpeak] = find(corr == max(corr(:)));
        yoffset = ypeak - height;
        xoffset = xpeak - width;
        offsets(i,:) = [xoffset yoffset];
    end
else
    for i = 2:numtif
        loop_track('Finished with frame...',i,100)
        corr = normxcorr2(template,tophatstack(:,:,i));
        [ypeak,xpeak] = find(corr == max(corr(:)));
        yoffset = ypeak - height;
        xoffset = xpeak - width;
        offsets(i,:) = [xoffset yoffset];
    end
end
fprintf('\n');
toc

%% Account for extreme motion
% for i = 1:size(offsets,1)
%     if abs(offsets(i,1)) > 25
%         offsets(i,1) = round(mean([offsets(i-1,1) offsets(i,1)]));
%         disp(['Extreme x-motion detected at frame ' num2str(i)]);
%     end
%     if abs(offsets(i,2)) > 25
%         offsets(i,2) = round(mean([offsets(i-1,2) offsets(i,2)]));
%         disp(['Extreme y-motion detected at frame ' num2str(i)]);
%     end
% end

%% reset to full tophat movie
% tophatstack = orig;
% height = size(tophatstack,1);
% width = size(tophatstack,2);

%% Calculate cropping parameters for each frame
disp('Calculating cropping parameters...'); tic

xOffmin = min(offsets(:,1));
xOffmax = max(offsets(:,1));
yOffmin = min(offsets(:,2));
yOffmax = max(offsets(:,2));

newheight = height - (yOffmax - yOffmin);
newwidth = width - (xOffmax - xOffmin);

x1 = zeros(numtif,1); x2 = zeros(numtif,1);
y1 = zeros(numtif,1); y2 = zeros(numtif,1);
if strcmp(proc_method,'par')
    parfor i = 1:numtif
        x1(i) = 1 + xOffmax - offsets(i,1);
        x2(i) = xOffmax - offsets(i,1) + newwidth;
        y1(i) = 1 + yOffmax - offsets(i,2);
        y2(i) = yOffmax - offsets(i,2) + newheight;
    end
else
    for i = 1:numtif
        loop_track('Finished with frame...',i,100);
        x1(i) = 1 + abs(xOffmin) + offsets(i,1);
        x2(i) = abs(xOffmin) + offsets(i,1) + newwidth;
        y1(i) = 1 + abs(yOffmin) + offsets(i,2);
        y2(i) = abs(yOffmin) + offsets(i,2) + newheight;
    end
end
fprintf('\n');
toc

%% Compile motion-corrected movies
disp('Compiling motion-corrected movies...'); tic

mcfiltered = zeros(newheight,newwidth,numtif);
mcmovie = zeros(newheight,newwidth,numtif);

if strcmp(proc_method,'par')
    parfor i = 1:numtif
        mcfiltered(:,:,i) = tophatstack(y1(i):y2(i),x1(i):x2(i),i);
        mcmovie(:,:,i) = tifstack(y1(i):y2(i),x1(i):x2(i),i);
    end
else
    for i = 1:numtif
        loop_track('Added frame...',i,100);
        mcfiltered(:,:,i) = tophatstack(y1(i):y2(i),x1(i):x2(i),i);
        mcmovie(:,:,i) = tifstack(y1(i):y2(i),x1(i):x2(i),i);
    end
end
fprintf('\n');
toc;
clear tophatstack

%% Plot graphs of x and y movement
f = figure;

subplot(1,2,1) % x movement
plot(offsets(:,1),'b-')
xlabel('Frame Number')
ylabel('X Translation (pix)')
title([filename(1:end-4) ' X and Y Translation'])

subplot(1,2,2) % y movement
plot(offsets(:,2),'b-')
xlabel('Frame Number')
ylabel('Y Translation (pix)')

saveas(f,['XY_Translation_' filename(1:end-4) '.fig']) %save to current folder 

%% Save offsets file
outFilename = ['offsets_' filename(1:end-5) '.mat'];
save(outFilename,'offsets')

%% Save motion-corrected movies as TIFFs
disp('Saving motion corrected movies...'); tic

outFilename1 = ['mcmovie_' filename];
outFilename2 = ['mctophat_' filename];

mcmovie = uint16(mcmovie);
mcfiltered = uint16(mcfiltered);

imwrite(mcmovie(:,:,1), outFilename1);
imwrite(mcfiltered(:,:,1),outFilename2);
for i = 2:numtif
    loop_track('Writing frame number...',i,100);
    imwrite(mcmovie(:,:,i),outFilename1,'writemode','append');
    imwrite(mcfiltered(:,:,i),outFilename2,'writemode','append');
end
fprintf('\n');
toc;
disp('Done!');

end

