function [var] = loadmovie()
%-------------------------------------------------------------------------
%LOAD A TIF OR TIF STACK FROM FILE
%Grace Paquelet, 2017
%
%   %INPUTS: Opens a dialog to choose movie/tif file
%
%   %OUTPUTS: Returns an array of the tif or movie
%
%-------------------------------------------------------------------------
    
    [filename,pathname] = uigetfile({'*.tif'});
    filepath = [pathname filename];
    cd(pathname)
    var = read_file(filepath);

end

