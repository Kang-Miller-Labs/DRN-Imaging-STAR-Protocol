function [] = loop_track(msg,var,increment)
%-------------------------------------------------------------------------
%DISPLAY PROGRESS DURING FOR OR WHILE LOOP
%Grace Paquelet, July 2017
%
    %INPUTS: Requires the identity of the indexing variable, a message to 
    %display before tracking, and the increments in which to report progress.
%    
    %OUTPUTS: Displays loop progress on screen in increments defined by the 
    %input.
%    
%-------------------------------------------------------------------------
    
    if var == increment
        fprintf([msg '\n\n'])
    end
    if ~rem(var,increment)
        fprintf('\t %u',var);
        if ~rem(var,10*increment)
            fprintf('\n')
        end
    end

end

