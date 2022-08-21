function [STD] = std_projection(movie)
%-------------------------------------------------------------------------
%GENERATE A STANDARD DEVIATION PROJECTION OF A MOVIE
%Grace Paquelet, 2018
%
%   INPUT: Requires a movie (l x w x t).
%
%   OUTPUT: Outputs a 2-D image in which each pixel value equals the
%   standard deviation of the values over time for that pixel from the
%   movie.
%
%-------------------------------------------------------------------------

    movie = double(movie);
    temp = reshape(movie,size(movie,1)*size(movie,2),size(movie,3));
    STD = NaN(size(temp,1),1);
    %display_progress_bar('Generating standard deviation projection:    ',false)
    for i = 1:size(temp,1)
        %display_progress_bar(100*i/size(temp,1),false)
        %loop_track('Working on pixel # ...',i,1000);
        STD(i) = std(temp(i,:));
    end
    %display_progress_bar('terminate',true)
    STD = reshape(STD,size(movie,1),size(movie,2));
    disp('Done')
    fprintf('\n\n');
    
end

